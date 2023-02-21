CREATE OR REPLACE TRIGGER INDIRIZZI_TELEMATICI_TIU
/******************************************************************************
 NOME:        INDIRIZZI_TELEMATICI_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table INDIRIZZI_TELEMATICI
******************************************************************************/
   before INSERT or UPDATE or DELETE ON INDIRIZZI_TELEMATICI
for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      --  Column "ID_INDIRIZZO" uses sequence INDIRIZZI_TELEMATICI_SQ
      if :NEW.ID_INDIRIZZO IS NULL and not DELETING then
         select INDIRIZZI_TELEMATICI_SQ.NEXTVAL
           into :new.ID_INDIRIZZO
           from dual;
      end if;
      if :NEW.utente_aggiornamento is null and not DELETING then
         :NEW.utente_aggiornamento := user;
      end if;
      if :NEW.data_aggiornamento is null and not DELETING then
         :NEW.data_aggiornamento := trunc(sysdate);
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "INDIRIZZI_TELEMATICI"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_indirizzi_telematici(var_ID_INDIRIZZO number) is
               select 1
                 from   INDIRIZZI_TELEMATICI
                where  ID_INDIRIZZO = var_ID_INDIRIZZO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin
               if :new.ID_INDIRIZZO is not null then
                  open  cpk_indirizzi_telematici(:new.ID_INDIRIZZO);
                  fetch cpk_indirizzi_telematici into dummy;
                  found := cpk_indirizzi_telematici%FOUND;
                  close cpk_indirizzi_telematici;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_INDIRIZZO||
                               '" gia'' presente in Indirizzi telematici. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      declare
         a_istruzione           varchar2(2000);
         d_inserting number := AFC.to_number( inserting );
         d_updating  number := AFC.to_number( updating );
         d_deleting  number := AFC.to_number( deleting );
      begin
         a_istruzione := 'begin indirizzo_telematico.chk_RI( ''' || :new.tipo_entita ||''''
                      ||                     ', ''' || :new.tipo_indirizzo ||''''
                      ||                     ', ''' || :new.id_indirizzo ||''''
                      ||                     ', ''' || :new.id_amministrazione ||''''
                      ||                     ', ''' || :new.id_aoo ||''''
                      ||                     ', ''' || :new.id_unita_organizzativa ||''''
                      ||                     ', ''' || to_char( d_inserting ) || ''''
                      ||                     ', ''' || to_char( d_updating ) || ''''
                      ||                     ');'
                      ||                     'end;'
                      ;
             IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
      end;
   end;
   begin  -- Set FUNCTIONAL Integrity
      if functionalNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
       declare
                d_statement varchar2(32000);
            begiN
                  if nvl(so4_pkg.get_integrazione_as4new,'NO') = 'SI' then
                        if (inserting or updating)  THEN
                            begin
                            
                                d_statement := 'begin  so4as4_PKG.ALLINEA_INDIRIZZO_TELEMATICO(:p_tipo_entita,:p_tipo_indirizzo,:p_id_amministrazione,:p_id_aoo,:P_ID_UNITA_ORGANIZZATIVA, :p_indirizzo,:p_old_indirizzo,:p_utente_agg); end;';
                                        execute immediate d_statement
                                            using in :new.tipo_entita,  :new.tipo_indirizzo, :new.id_amministrazione, :new.id_aoo, :new.id_unita_organizzativa, :NEW.INDIRIZZO, :OLD.INDIRIZZO, :new.utente_aggiornamento;                                           
                            exception when others then
                              key_error_log_tpk.ins(p_error_id       => ''
                                                     ,p_error_session  => userenv('sessionid')
                                                     ,p_error_date     => trunc(sysdate)
                                                     ,p_error_text     => 'Errore in allineamento indirizzo telematico '||:new.indirizzo||' su anagrafica centralizzata '
                                                     ,p_error_user     => :new.utente_aggiornamento
                                                     ,p_error_usertext => sqlerrm
                                                     ,p_error_type     => 'E');
                            end;
                        else -- deleting
                            begin
                                d_statement := 'begin  so4as4_PKG.ALLINEA_INDIRIZZO_TELEMATICO(:p_tipo_entita,:p_tipo_indirizzo,:p_id_amministrazione,:p_id_aoo,:P_ID_UNITA_ORGANIZZATIVA, :p_indirizzo,:p_old_indirizzo,:p_utente_agg); end;';
                                    execute immediate d_statement
                                        using in :old.tipo_entita,  :old.tipo_indirizzo, :old.id_amministrazione, :old.id_aoo, :old.id_unita_organizzativa, '', :OLD.INDIRIZZO, nvl(si4.utente,:old.utente_aggiornamento);
                            exception when others then
                              key_error_log_tpk.ins(p_error_id       => ''
                                                     ,p_error_session  => userenv('sessionid')
                                                     ,p_error_date     => trunc(sysdate)
                                                     ,p_error_text     => 'Errore in chiusura validita'' indirizzo telematico '||:OLD.indirizzo||' su anagrafica centralizzata '
                                                     ,p_error_user     => :new.utente_aggiornamento
                                                     ,p_error_usertext => sqlerrm
                                                     ,p_error_type     => 'E');
                            end;
                        end if;
                  END IF;
            end;
         end;
        IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/



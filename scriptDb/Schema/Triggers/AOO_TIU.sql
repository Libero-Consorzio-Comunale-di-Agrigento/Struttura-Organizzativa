CREATE OR REPLACE TRIGGER AOO_TIU
/******************************************************************************
 NOME:        AOO_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table AOO
******************************************************************************/
   before INSERT or UPDATE or DELETE ON AOO for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   d_codice_aoo     AOO.CODICE_AOO%type;
begin
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __
    1   21/03/2019 SN  verifica su amministrazione con upper e trim
    2   21/03/2019 SN controllo se ente con valore old in caso di cancellazione
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      if inserting or updating then   -- ipotizzo che da scarico IPA mi venga passato il codice così come è
        d_codice_aoo := :new.codice_aoo;
        :new.codice_aoo := upper(:new.codice_aoo);
        if upper(:new.fax) = 'NULL' then -- per evitare eventuali dati da scarico ipa sporchi
            :new.fax := '';
        end if;
        if upper(:new.telefono) = 'NULL' then -- per evitare eventuali dati da scarico ipa sporchi
            :new.telefono := '';
        end if;  
        if upper(:new.indirizzo) = 'NULL' then -- per evitare eventuali dati da scarico ipa sporchi
            :new.indirizzo := '';
        end if;              
      end if;  
      -- Column "PROGR_AOO" uses GET_ID_AREA function
      if :NEW.progr_aoo IS NULL and not DELETING then
         select AOO_pkg.get_id_area
           into :NEW.progr_aoo
           from dual;
      end if;
      if :NEW.utente_aggiornamento is null and not DELETING then
         :NEW.utente_aggiornamento := user;
      end if;
      if :NEW.data_aggiornamento is null and not DELETING then
         :NEW.data_aggiornamento := trunc(sysdate);
      end if;
   end;
   --#28708
   -- rev. 2  inizio modificato controllo su ente
   if  ((inserting or updating ) and amministrazione.get_ente(:new.codice_amministrazione) = 'SI')
     or 
     ((deleting ) and amministrazione.get_ente(:old.codice_amministrazione) = 'SI')
     -- rev. 2  fine
        then
      if inserting or updating then
         begin
            select 1
              into dummy
              from codici_ipa
             where tipo_entita = 'AO'
               and progressivo = :new.progr_aoo;
            raise too_many_rows;
         exception
            when no_data_found then
               insert into codici_ipa
                  (tipo_entita
                  ,progressivo
                  ,codice_originale)
               values
                  ('AO'
                  ,:new.progr_aoo
                  ,d_codice_aoo);
            when too_many_rows then
               update codici_ipa
                  set codice_originale = d_codice_aoo
                where tipo_entita = 'AO'
                  and progressivo = :new.progr_aoo;
         end;
      end if;
   end if;
   if NOT deleting then
      begin
        AOO_pkg.chk_di( :new.codice_aoo
                      , :new.dal
                      , :new.al
                      ) ;
      end;
   end if;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "AOO"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_aoo(var_PROGR_AOO number,
                            var_DAL date) is
               select 1
                 from   AOO
                where  PROGR_AOO = var_PROGR_AOO and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin
               if :new.PROGR_AOO is not null and
                  :new.DAL is not null then
                  open  cpk_aoo(:new.PROGR_AOO,
                                 :new.DAL);
                  fetch cpk_aoo into dummy;
                  found := cpk_aoo%FOUND;
                  close cpk_aoo;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.PROGR_AOO||' '||
                               :new.DAL||
                               '" gia'' presente in AOO. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
      declare
         a_istruzione           varchar2(2000);
         d_inserting number := AFC.to_number( inserting );
         d_updating  number := AFC.to_number( updating );
         d_deleting  number := AFC.to_number( deleting );
      begin
         a_istruzione := 'begin AOO_pkg.chk_RI( ''' || nvl(:new.progr_aoo,:old.progr_aoo) ||''''
                      ||                     ', ' || AFC.quote(:new.codice_aoo)
                      ||                     ', ' || AFC.quote(:new.descrizione)
                      ||                     ', ' || AFC.quote(:new.codice_amministrazione)
                      ||                     ', to_date( ''' || to_char( :old.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                      ||                     ', to_date( ''' || to_char( :new.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                      ||                     ', to_date( ''' || to_char( :old.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                      ||                     ', to_date( ''' || to_char( :new.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                      ||                     ', ''' || :new.rowid || ''''
                      ||                     ', ''' || to_char( d_inserting ) || ''''
                      ||                     ', ''' || to_char( d_updating ) || ''''
                      ||                     ', ''' || to_char( d_deleting ) || ''''
                      ||                     ');'
                      ||                     'end;'
                      ;
             IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
      end;
   end;
   begin  -- Set FUNCTIONAL Integrity
      begin
         if Integritypackage.functional
         then  -- Switched functional Integrity
            declare
               a_istruzione           varchar2(2000);
               d_inserting number := AFC.to_number( inserting );
               d_updating  number := AFC.to_number( updating );
               d_deleting  number := AFC.to_number( deleting );
            begin
               a_istruzione := 'begin AOO_pkg.set_FI( ''' || :new.progr_aoo ||''''
                            ||                     ', ''' || :old.progr_aoo || ''''
                            ||                     ', to_date( ''' || to_char( :new.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                            ||                     ', to_date( ''' || to_char( :old.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                            ||                     ', to_date( ''' || to_char( :new.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                            ||                     ', to_date( ''' || to_char( :old.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                            ||                     ', ''' || to_char( d_inserting ) || ''''
                            ||                     ', ''' || to_char( d_updating ) || ''''
                            ||                     ', ''' || to_char( d_deleting ) || ''''
                            ||                     ');'
                            ||                     'end;'
                            ;
               IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
            end;
         end if;
      end;
      DECLARE
        d_statement varchar2(32000);
        D_NI_AS4    NUMBER := null;
        d_descrizione   varchar2(2000);
        d_indirizzo     varchar2(2000);
        d_dett_nome     varchar2(100);
      begiN
          if nvl(so4_pkg.get_integrazione_as4new,'NO') = 'SI' then
          BEGIN-- rev. 1
            begin
                select ' ('||codice_originale||':'||d_CODICE_aoo||')'
                  into d_dett_nome
                  from codici_ipa, amministrazioni
                 where progressivo = ni
                   and tipo_entita = 'AM'
                   and codice_amministrazione =UPPER (TRIM (:new.codice_amministrazione)) ; -- rev. 1 considero la maiuscola
            exception when no_data_found then -- piuttosto che dare errore ci metto il codice amministrazione
                d_dett_nome := ' ('||TRIM (:new.codice_amministrazione)||':'||d_CODICE_aoo||')';
            when others then raise;
            end;                   
            d_descrizione   := substr(rtrim(:new.descrizione),1,240-length(d_dett_nome))||d_dett_nome;
            d_indirizzo     := :new.indirizzo;
             exception
                 when others then
                    raise_application_error (-20999,' Errore in ricerca codice originale amministrazione (' || UPPER (TRIM (:new.codice_amministrazione))||')' , true); 
              END;
                 -- rev. 1 fine
            BEGIN
                SELECT NI
                  INTO D_NI_AS4
                  FROM SOGGETTI_AOO
                 WHERE PROGR_AOO = :NEW.PROGR_AOO;
            EXCEPTION WHEN OTHERS THEN
                D_NI_AS4 := NULL;
            END;
            if inserting then
                d_statement := 'begin so4as4_pkg.allinea_aoo(:p_ni_as4,:p_progr_aoo,:p_dal, :p_old_dal, :p_descrizione , :p_indirizzo, :p_provincia , :p_comune, :p_cap , :p_telefono, :p_fax, :p_utente_agg); end; ';
                  execute immediate d_statement using in d_ni_as4,:new.progr_aoo,:new.dal,:old.dal,d_descrizione,d_indirizzo,:new.provincia,:new.comune,:new.cap,:new.telefono,:new.fax,:new.utente_aggiornamento;
           elsif UPDATING then
              if (:new.dal != :old.dal) or
                 (:new.descrizione != :old.descrizione) or
                 (nvl(:new.INDIRIZZO,'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') !=
                  nvl(:old.INDIRIZZO,'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')) or
                 (nvl(:new.provincia,-1) != nvl(:old.provincia,-1)) or
                 (nvl(:new.comune,-1) != nvl(:old.comune,-1)) or
                 (nvl(:new.cap,'XXXXXX') != nvl(:old.cap,'XXXXXX')) or
                 (nvl(:new.telefono,'XXXXXXXXXXXXXXX') != nvl(:old.telefono,'XXXXXXXXXXXXXXX')) or
                 (nvl(:new.fax,'XXXXXXXXXXXXXXX') != nvl(:old.fax,'XXXXXXXXXXXXXXX')) then
                    d_statement := 'begin so4as4_pkg.allinea_aoo(:p_ni_as4,:p_progr_aoo,:p_dal, :p_old_dal, :p_descrizione , :p_indirizzo, :p_provincia , :p_comune, :p_cap , :p_telefono, :p_fax, :p_utente_agg); end; ';
                    execute immediate d_statement using in d_ni_as4,:new.progr_aoo,:new.dal,:old.dal,d_descrizione,d_indirizzo,:new.provincia,:new.comune,:new.cap,:new.telefono,:new.fax,:new.utente_aggiornamento;
              end if;
            end if;
          end if;
      exception
          when others then                                                    
              key_error_log_tpk.ins(p_error_id       => ''
                                     ,p_error_session  => userenv('sessionid')
                                     ,p_error_date     => trunc(sysdate)
                                     ,p_error_text     => 'Errore in allineamento su anagrafica centralizzata per AOO '||:new.progr_aoo||', decorrenza '||to_char(:new.dal,'DD/MM/YYYY')
                                     ,p_error_user     => :new.utente_aggiornamento
                                     ,p_error_usertext => sqlerrm
                                     ,p_error_type     => 'E');
      end;
      if functionalNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
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



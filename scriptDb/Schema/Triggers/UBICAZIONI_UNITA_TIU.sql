CREATE OR REPLACE TRIGGER UBICAZIONI_UNITA_TIU
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table UBICAZIONI_UNITA
******************************************************************************/
   before INSERT or UPDATE or DELETE on UBICAZIONI_UNITA
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
      --  Column "ID_UBICAZIONE" uses sequence UBICAZIONI_UNITA_SQ
      if :NEW.ID_UBICAZIONE IS NULL and not DELETING then
         select UBICAZIONI_UNITA_SQ.NEXTVAL
           into :new.ID_UBICAZIONE
           from dual;
      end if;
      if :new.utente_aggiornamento is null and not DELETING then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not DELETING then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
   end;
      
   if NOT deleting then
      begin
        ubicazione_unita.chk_di( :new.dal
                               , :new.al
                               );
      end;
   end if;

   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "UBICAZIONI_UNITA" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_ubicazioni_unita(var_ID_UBICAZIONE number) is
               select 1
                 from   UBICAZIONI_UNITA
                where  ID_UBICAZIONE = var_ID_UBICAZIONE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_UBICAZIONE is not null then
                  open  cpk_ubicazioni_unita(:new.ID_UBICAZIONE);
                  fetch cpk_ubicazioni_unita into dummy;
                  found := cpk_ubicazioni_unita%FOUND;
                  close cpk_ubicazioni_unita;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_UBICAZIONE||
                               '" gia'' presente in Ubicazioni unita. La registrazione  non puo'' essere inserita.';
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
      begin
         a_istruzione := 'begin ubicazione_unita.chk_RI( ''' || nvl(:new.id_ubicazione,:old.id_ubicazione) || ''''
                                                    ||', ''' || nvl(:new.progr_unita_organizzativa,:old.progr_unita_organizzativa) ||''''
                                                    ||', ''' || nvl(:new.progr_unita_fisica,:old.progr_unita_fisica) || ''''
                                                    ||', to_date( ''' || to_char( :new.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                                                    ||', to_date( ''' || to_char( :new.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                                                    ||', ''' || to_char( d_inserting ) || ''''
                                                    ||', ''' || to_char( d_updating ) || ''''
                                                    ||');'
                                                    ||'end;'
                                                    ;
             IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
      end;
   end;
   begin  -- Set FUNCTIONAL Integrity
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



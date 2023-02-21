CREATE OR REPLACE TRIGGER ISCRIZIONI_PUBBLICAZIONE_TIU
/******************************************************************************
 NOME:        ISCRIZIONI_PUBBLICAZIONE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table ISCRIZIONI_PUBBLICAZIONE
******************************************************************************/
   before INSERT or UPDATE or DELETE on ISCRIZIONI_PUBBLICAZIONE
for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   d_oggi                 date := trunc(sysdate);
begin
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __     
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      --  Column "ID_ISCRIZIONE" uses sequence MODIFICHE_SQ
      if :NEW.ID_ISCRIZIONE IS NULL and not DELETING then
         select MODIFICHE_SQ.NEXTVAL
           into :new.ID_ISCRIZIONE
           from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := d_oggi;
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "ISCRIZIONI_PUBBLICAZIONE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_iscrizioni_pubblicazione(var_ID_ISCRIZIONE number) is
               select 1
                 from   ISCRIZIONI_PUBBLICAZIONE
                where  ID_ISCRIZIONE = var_ID_ISCRIZIONE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_ISCRIZIONE is not null then
                  open  cpk_iscrizioni_pubblicazione(:new.ID_ISCRIZIONE);
                  fetch cpk_iscrizioni_pubblicazione into dummy;
                  found := cpk_iscrizioni_pubblicazione%FOUND;
                  close cpk_iscrizioni_pubblicazione;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_ISCRIZIONE||
                               '" gia'' presente in Iscrizioni pubblicazione. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
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



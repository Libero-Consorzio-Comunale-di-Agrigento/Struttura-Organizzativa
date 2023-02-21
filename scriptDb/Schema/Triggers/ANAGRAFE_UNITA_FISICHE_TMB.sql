CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_FISICHE_TMB
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ANAGRAFE_UNITA_FISICHE
 ANNOTAZIONI: Richiama Procedure ANAGRAFE_UNITA_FISICHE_PI e ANAGRAFE_UNITA_FISICHE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on ANAGRAFE_UNITA_FISICHE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         ANAGRAFE_UNITA_FISICHE_PI( :NEW.PROGR_UNITA_FISICA
                        , :NEW.DAL
                        , :NEW.ID_SUDDIVISIONE );
         null;
      end if;
      if UPDATING then
         ANAGRAFE_UNITA_FISICHE_PU( :OLD.PROGR_UNITA_FISICA
                        , :OLD.DAL
                        , :OLD.ID_SUDDIVISIONE
                        , :NEW.PROGR_UNITA_FISICA
                        , :NEW.DAL
                        , :NEW.ID_SUDDIVISIONE );
         null;
      end if;
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



CREATE OR REPLACE TRIGGER RUOLI_PROFILO_TMB
/******************************************************************************
 NOME:        RUOLI_PROFILO_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RUOLI_PROFILO
 ANNOTAZIONI: Richiama Procedure RUOLI_PROFILO_PI e RUOLI_PROFILO_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on RUOLI_PROFILO
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
         RUOLI_PROFILO_PI( :NEW.ID_RUOLO_PROFILO
                        , :NEW.RUOLO_PROFILO
                        , :NEW.RUOLO );
         null;
      end if;
      if UPDATING then
         RUOLI_PROFILO_PU( :OLD.ID_RUOLO_PROFILO
                        , :OLD.RUOLO_PROFILO
                        , :OLD.RUOLO
                        , :NEW.ID_RUOLO_PROFILO
                        , :NEW.RUOLO_PROFILO
                        , :NEW.RUOLO );
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



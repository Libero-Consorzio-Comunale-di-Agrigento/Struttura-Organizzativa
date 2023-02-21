CREATE OR REPLACE TRIGGER RUOLI_COMPONENTE_TMB
/******************************************************************************
 NOME:        RUOLI_COMPONENTE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RUOLI_COMPONENTE
 ANNOTAZIONI: Richiama Procedure RUOLI_COMPONENTE_PI e RUOLI_COMPONENTE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on RUOLI_COMPONENTE
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
         RUOLI_COMPONENTE_PI( :NEW.ID_RUOLO_COMPONENTE
                        , :NEW.ID_COMPONENTE
                        , :NEW.RUOLO );
         null;
      end if;
      if UPDATING then
         RUOLI_COMPONENTE_PU( :OLD.ID_RUOLO_COMPONENTE
                        , :OLD.ID_COMPONENTE
                        , :OLD.RUOLO
                        , :NEW.ID_RUOLO_COMPONENTE
                        , :NEW.ID_COMPONENTE
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



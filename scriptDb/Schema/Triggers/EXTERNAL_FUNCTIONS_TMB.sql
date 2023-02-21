CREATE OR REPLACE TRIGGER EXTERNAL_FUNCTIONS_TMB
/******************************************************************************
 NOME:        EXTERNAL_FUNCTIONS_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table EXTERNAL_FUNCTIONS
 ANNOTAZIONI: Richiama Procedure EXTERNAL_FUNCTIONS_PI e EXTERNAL_FUNCTIONS_PU
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on EXTERNAL_FUNCTIONS
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      :new.TABLE_NAME := UPPER(:new.TABLE_NAME);
      :new.FUNCTION_OWNER := UPPER(:new.FUNCTION_OWNER);
      :new.FIRING_FUNCTION := UPPER(:new.FIRING_FUNCTION);
      :new.FIRING_EVENT := UPPER(:new.FIRING_EVENT);
      if INSERTING then
         EXTERNAL_FUNCTIONS_PI( :NEW.FUNCTION_ID
                        , :NEW.TABLE_NAME
                        , :NEW.FUNCTION_OWNER 
                        , :NEW.FIRING_FUNCTION );
      end if;
      if UPDATING then
         EXTERNAL_FUNCTIONS_PU( :OLD.FUNCTION_ID
                        , :OLD.TABLE_NAME
                        , :OLD.FUNCTION_OWNER
                        , :NEW.FUNCTION_ID
                        , :NEW.TABLE_NAME
                        , :NEW.FUNCTION_OWNER
                        , :NEW.FIRING_FUNCTION );
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



CREATE OR REPLACE TRIGGER RUOLI_DERIVATI_TMB
/******************************************************************************
 NOME:        RUOLI_DERIVATI_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RUOLI_DERIVATI
 ANNOTAZIONI: Richiama Procedure RUOLI_DERIVATI_PI e RUOLI_DERIVATI_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on RUOLI_DERIVATI
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
         RUOLI_DERIVATI_PI( :NEW.ID_RUOLO_DERIVATO
                        , :NEW.ID_RUOLO_COMPONENTE
                        , :NEW.ID_PROFILO );
         null;
      end if;
      if UPDATING then
         RUOLI_DERIVATI_PU( :OLD.ID_RUOLO_DERIVATO
                        , :OLD.ID_RUOLO_COMPONENTE
                        , :OLD.ID_PROFILO
                        , :NEW.ID_RUOLO_DERIVATO
                        , :NEW.ID_RUOLO_COMPONENTE
                        , :NEW.ID_PROFILO );
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



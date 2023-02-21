CREATE OR REPLACE TRIGGER IMPUTAZIONI_BILANCIO_TMB
/******************************************************************************
 NOME:        IMPUTAZIONI_BILANCIO_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table IMPUTAZIONI_BILANCIO
 ANNOTAZIONI: Richiama Procedure IMPUTAZIONI_BILANCIO_PI e IMPUTAZIONI_BILANCIO_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on IMPUTAZIONI_BILANCIO
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
         IMPUTAZIONI_BILANCIO_PI( :NEW.ID_IMPUTAZIONE
                        , :NEW.ID_COMPONENTE );
         null;
      end if;
      if UPDATING then
         IMPUTAZIONI_BILANCIO_PU( :OLD.ID_IMPUTAZIONE
                        , :OLD.ID_COMPONENTE
                        , :NEW.ID_IMPUTAZIONE
                        , :NEW.ID_COMPONENTE );
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



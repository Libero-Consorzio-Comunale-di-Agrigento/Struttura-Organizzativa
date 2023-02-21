CREATE OR REPLACE TRIGGER SOGGETTI_RUBRICA_TMB
/******************************************************************************
 NOME:        SOGGETTI_RUBRICA_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table SOGGETTI_RUBRICA
 ANNOTAZIONI: Richiama Procedure SOGGETTI_RUBRICA_PI e SOGGETTI_RUBRICA_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on SOGGETTI_RUBRICA
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
         SOGGETTI_RUBRICA_PI( :NEW.NI
                        , :NEW.TIPO_CONTATTO
                        , :NEW.PROGRESSIVO
                        , :NEW.RIFERIMENTO_TIPO
                        , :NEW.RIFERIMENTO );
         null;
      end if;
      if UPDATING then
         SOGGETTI_RUBRICA_PU( :OLD.NI
                        , :OLD.TIPO_CONTATTO
                        , :OLD.PROGRESSIVO
                        , :OLD.RIFERIMENTO_TIPO
                        , :OLD.RIFERIMENTO
                        , :NEW.NI
                        , :NEW.TIPO_CONTATTO
                        , :NEW.PROGRESSIVO
                        , :NEW.RIFERIMENTO_TIPO
                        , :NEW.RIFERIMENTO );
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



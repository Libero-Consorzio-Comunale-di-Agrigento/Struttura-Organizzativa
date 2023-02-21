CREATE OR REPLACE TRIGGER UNITA_ORGANIZZATIVE_TMB
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table UNITA_ORGANIZZATIVE
 ANNOTAZIONI: Richiama Procedure UNITA_ORGANIZZATIVE_PI e UNITA_ORGANIZZATIVE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on UNITA_ORGANIZZATIVE
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
         UNITA_ORGANIZZATIVE_PI( :NEW.ID_ELEMENTO
                        , :NEW.OTTICA
                        , :NEW.REVISIONE
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.ID_UNITA_PADRE
                        , :NEW.REVISIONE_CESSAZIONE );
         null;
      end if;
      if UPDATING then
         UNITA_ORGANIZZATIVE_PU( :OLD.ID_ELEMENTO
                        , :OLD.OTTICA
                        , :OLD.REVISIONE
                        , :OLD.PROGR_UNITA_ORGANIZZATIVA
                        , :OLD.ID_UNITA_PADRE
                        , :OLD.REVISIONE_CESSAZIONE
                        , :NEW.ID_ELEMENTO
                        , :NEW.OTTICA
                        , :NEW.REVISIONE
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.ID_UNITA_PADRE
                        , :NEW.REVISIONE_CESSAZIONE );
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



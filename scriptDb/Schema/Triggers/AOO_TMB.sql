CREATE OR REPLACE TRIGGER AOO_TMB
/******************************************************************************
 NOME:        AOO_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table AOO
 ANNOTAZIONI: Richiama Procedure AOO_PI e AOO_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on AOO
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
         AOO_PI( :NEW.PROGR_AOO
                        , :NEW.DAL
                        , :NEW.CODICE_AMMINISTRAZIONE );
         null;
      end if;
      if UPDATING then
         AOO_PU( :OLD.PROGR_AOO
                        , :OLD.DAL
                        , :OLD.CODICE_AMMINISTRAZIONE
                        , :NEW.PROGR_AOO
                        , :NEW.DAL
                        , :NEW.CODICE_AMMINISTRAZIONE );
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



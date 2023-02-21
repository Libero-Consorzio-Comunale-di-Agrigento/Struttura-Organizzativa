CREATE OR REPLACE TRIGGER UNITA_FISICHE_TMB
/******************************************************************************
 NOME:        UNITA_FISICHE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table UNITA_FISICHE
 ANNOTAZIONI: Richiama Procedure UNITA_FISICHE_PI e UNITA_FISICHE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on UNITA_FISICHE
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
         UNITA_FISICHE_PI( :NEW.ID_ELEMENTO_FISICO
                        , :NEW.AMMINISTRAZIONE
                        , :NEW.PROGR_UNITA_FISICA
                        , :NEW.ID_UNITA_FISICA_PADRE );
         null;
      end if;
      if UPDATING then
         UNITA_FISICHE_PU( :OLD.ID_ELEMENTO_FISICO
                        , :OLD.AMMINISTRAZIONE
                        , :OLD.PROGR_UNITA_FISICA
                        , :OLD.ID_UNITA_FISICA_PADRE
                        , :NEW.ID_ELEMENTO_FISICO
                        , :NEW.AMMINISTRAZIONE
                        , :NEW.PROGR_UNITA_FISICA
                        , :NEW.ID_UNITA_FISICA_PADRE );
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



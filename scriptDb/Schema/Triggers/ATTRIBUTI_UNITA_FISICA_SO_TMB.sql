CREATE OR REPLACE TRIGGER ATTRIBUTI_UNITA_FISICA_SO_TMB
/******************************************************************************
 NOME:        ATTRIBUTI_UNITA_FISICA_SO_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ATTRIBUTI_UNITA_FISICA_SO
 ANNOTAZIONI: Richiama Procedure ATTRIBUTI_UNITA_FISICA_SO_PI e ATTRIBUTI_UNITA_FISICA_SO_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on ATTRIBUTI_UNITA_FISICA_SO
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
         ATTRIBUTI_UNITA_FISICA_SO_PI( :NEW.PROGR_UNITA_FISICA
                        , :NEW.ATTRIBUTO
                        , :NEW.DAL );
         null;
      end if;
      if UPDATING then
         ATTRIBUTI_UNITA_FISICA_SO_PU( :OLD.PROGR_UNITA_FISICA
                        , :OLD.ATTRIBUTO
                        , :OLD.DAL
                        , :NEW.PROGR_UNITA_FISICA
                        , :NEW.ATTRIBUTO
                        , :NEW.DAL );
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



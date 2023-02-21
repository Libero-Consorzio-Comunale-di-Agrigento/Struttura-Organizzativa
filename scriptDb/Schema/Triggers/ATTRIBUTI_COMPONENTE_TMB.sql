CREATE OR REPLACE TRIGGER ATTRIBUTI_COMPONENTE_TMB
/******************************************************************************
 NOME:        ATTRIBUTI_COMPONENTE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ATTRIBUTI_COMPONENTE
 ANNOTAZIONI: Richiama Procedure ATTRIBUTI_COMPONENTE_PI e ATTRIBUTI_COMPONENTE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on ATTRIBUTI_COMPONENTE
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
         ATTRIBUTI_COMPONENTE_PI( :NEW.ID_ATTR_COMPONENTE
                        , :NEW.ID_COMPONENTE
                        , :NEW.INCARICO );
         null;
      end if;
      if UPDATING then
         ATTRIBUTI_COMPONENTE_PU( :OLD.ID_ATTR_COMPONENTE
                        , :OLD.ID_COMPONENTE
                        , :OLD.INCARICO
                        , :NEW.ID_ATTR_COMPONENTE
                        , :NEW.ID_COMPONENTE
                        , :NEW.INCARICO );
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



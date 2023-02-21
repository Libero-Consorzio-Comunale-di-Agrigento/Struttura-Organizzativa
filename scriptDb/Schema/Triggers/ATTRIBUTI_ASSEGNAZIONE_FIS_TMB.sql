CREATE OR REPLACE TRIGGER ATTRIBUTI_ASSEGNAZIONE_FIS_TMB
/******************************************************************************
 NOME:        ATTRIBUTI_ASSEGNAZIONE_FIS_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ATTRIBUTI_ASSEGNAZIONE_FISICA
 ANNOTAZIONI: Richiama Procedure ATTRIBUTI_ASSEGNAZIONE_FISICA_PI e ATTRIBUTI_ASSEGNAZIONE_FISICA_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on ATTRIBUTI_ASSEGNAZIONE_FISICA
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
         ATTRIBUTI_ASSEGNAZIONE_FISI_PI( :NEW.ID_ASFI
                        , :NEW.ATTRIBUTO
                        , :NEW.DAL );
         null;
      end if;
      if UPDATING then
         ATTRIBUTI_ASSEGNAZIONE_FISI_PU( :OLD.ID_ASFI
                        , :OLD.ATTRIBUTO
                        , :OLD.DAL
                        , :NEW.ID_ASFI
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



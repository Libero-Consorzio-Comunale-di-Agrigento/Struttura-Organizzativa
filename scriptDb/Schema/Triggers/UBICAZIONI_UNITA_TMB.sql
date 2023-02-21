CREATE OR REPLACE TRIGGER UBICAZIONI_UNITA_TMB
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table UBICAZIONI_UNITA
 ANNOTAZIONI: Richiama Procedure UBICAZIONI_UNITA_PI e UBICAZIONI_UNITA_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on UBICAZIONI_UNITA
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
         UBICAZIONI_UNITA_PI( :NEW.ID_UBICAZIONE
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.PROGR_UNITA_FISICA );
         null;
      end if;
      if UPDATING then
         UBICAZIONI_UNITA_PU( :OLD.ID_UBICAZIONE
                        , :OLD.PROGR_UNITA_ORGANIZZATIVA
                        , :OLD.PROGR_UNITA_FISICA
                        , :NEW.ID_UBICAZIONE
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.PROGR_UNITA_FISICA );
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



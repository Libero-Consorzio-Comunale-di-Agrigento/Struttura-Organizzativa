CREATE OR REPLACE TRIGGER ASSEGNAZIONI_FISICHE_TMB
/******************************************************************************
 NOME:        ASSEGNAZIONI_FISICHE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ASSEGNAZIONI_FISICHE
 ANNOTAZIONI: Richiama Procedure ASSEGNAZIONI_FISICHE_PI e ASSEGNAZIONI_FISICHE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on ASSEGNAZIONI_FISICHE
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
         ASSEGNAZIONI_FISICHE_PI( :NEW.ID_ASFI
                        , :NEW.ID_UBICAZIONE_COMPONENTE
                        , :NEW.NI
                        , :NEW.PROGR_UNITA_FISICA
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA );
         null;
      end if;
      if UPDATING then
         ASSEGNAZIONI_FISICHE_PU( :OLD.ID_ASFI
                        , :OLD.ID_UBICAZIONE_COMPONENTE
                        , :OLD.NI
                        , :OLD.PROGR_UNITA_FISICA
                        , :OLD.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.ID_ASFI
                        , :NEW.ID_UBICAZIONE_COMPONENTE
                        , :NEW.NI
                        , :NEW.PROGR_UNITA_FISICA
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA );
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



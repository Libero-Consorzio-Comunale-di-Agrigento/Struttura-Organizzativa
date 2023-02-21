CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_ORGANIZZATI_TMB
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_ORGANIZZATI_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ANAGRAFE_UNITA_ORGANIZZATIVE
 ANNOTAZIONI: Richiama Procedure ANAGRAFE_UNITA_ORGANIZZATIVE_PI e ANAGRAFE_UNITA_ORGANIZZATIVE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on ANAGRAFE_UNITA_ORGANIZZATIVE
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
         ANAGRAFE_UNITA_ORGANIZZATIV_PI( :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.DAL
                        , :NEW.ID_SUDDIVISIONE
                        , :NEW.OTTICA
                        , :NEW.REVISIONE_ISTITUZIONE
                        , :NEW.REVISIONE_CESSAZIONE
                        , :NEW.AMMINISTRAZIONE
                        , :NEW.PROGR_AOO
                        , :NEW.CENTRO );
         null;
      end if;
      if UPDATING then
         ANAGRAFE_UNITA_ORGANIZZATIV_PU( :OLD.PROGR_UNITA_ORGANIZZATIVA
                        , :OLD.DAL
                        , :OLD.ID_SUDDIVISIONE
                        , :OLD.OTTICA
                        , :OLD.REVISIONE_ISTITUZIONE
                        , :OLD.REVISIONE_CESSAZIONE
                        , :OLD.AMMINISTRAZIONE
                        , :OLD.PROGR_AOO
                        , :OLD.CENTRO
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.DAL
                        , :NEW.ID_SUDDIVISIONE
                        , :NEW.OTTICA
                        , :NEW.REVISIONE_ISTITUZIONE
                        , :NEW.REVISIONE_CESSAZIONE
                        , :NEW.AMMINISTRAZIONE
                        , :NEW.PROGR_AOO
                        , :NEW.CENTRO );
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



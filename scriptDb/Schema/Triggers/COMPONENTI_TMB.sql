CREATE OR REPLACE TRIGGER COMPONENTI_TMB
/******************************************************************************
 NOME:        COMPONENTI_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table COMPONENTI
 ANNOTAZIONI: Richiama Procedure COMPONENTI_PI e COMPONENTI_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on COMPONENTI
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
         COMPONENTI_PI( :NEW.ID_COMPONENTE
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.NI
                        , :NEW.OTTICA
                        , :NEW.REVISIONE_ASSEGNAZIONE
                        , :NEW.REVISIONE_CESSAZIONE );
         null;
      end if;
      if UPDATING then
         COMPONENTI_PU( :OLD.ID_COMPONENTE
                        , :OLD.PROGR_UNITA_ORGANIZZATIVA
                        , :OLD.NI
                        , :OLD.OTTICA
                        , :OLD.REVISIONE_ASSEGNAZIONE
                        , :OLD.REVISIONE_CESSAZIONE
                        , :NEW.ID_COMPONENTE
                        , :NEW.PROGR_UNITA_ORGANIZZATIVA
                        , :NEW.NI
                        , :NEW.OTTICA
                        , :NEW.REVISIONE_ASSEGNAZIONE
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



CREATE OR REPLACE TRIGGER INDIRIZZI_TELEMATICI_TMB
/******************************************************************************
 NOME:        INDIRIZZI_TELEMATICI_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table INDIRIZZI_TELEMATICI
 ANNOTAZIONI: Richiama Procedure INDIRIZZI_TELEMATICI_PI e INDIRIZZI_TELEMATICI_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on INDIRIZZI_TELEMATICI
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
         INDIRIZZI_TELEMATICI_PI( :NEW.TIPO_ENTITA
                        , :NEW.ID_INDIRIZZO
                        , :NEW.ID_AMMINISTRAZIONE
                        , :NEW.ID_AOO
                        , :NEW.ID_UNITA_ORGANIZZATIVA );
         null;
      end if;
      if UPDATING then
         INDIRIZZI_TELEMATICI_PU( :OLD.TIPO_ENTITA
                        , :OLD.ID_INDIRIZZO
                        , :OLD.ID_AMMINISTRAZIONE
                        , :OLD.ID_AOO
                        , :OLD.ID_UNITA_ORGANIZZATIVA
                        , :NEW.TIPO_ENTITA
                        , :NEW.ID_INDIRIZZO
                        , :NEW.ID_AMMINISTRAZIONE
                        , :NEW.ID_AOO
                        , :NEW.ID_UNITA_ORGANIZZATIVA );
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



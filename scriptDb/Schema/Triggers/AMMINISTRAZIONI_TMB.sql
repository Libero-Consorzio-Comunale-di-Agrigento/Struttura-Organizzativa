CREATE OR REPLACE TRIGGER AMMINISTRAZIONI_TMB
/******************************************************************************
 NOME:        AMMINISTRAZIONI_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table AMMINISTRAZIONI
 ANNOTAZIONI: Richiama Procedure AMMINISTRAZIONI_PI e AMMINISTRAZIONI_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on AMMINISTRAZIONI
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
         AMMINISTRAZIONI_PI( :NEW.CODICE_AMMINISTRAZIONE
                        , :NEW.NI );
         null;
      end if;
      if UPDATING then
         AMMINISTRAZIONI_PU( :OLD.CODICE_AMMINISTRAZIONE
                        , :OLD.NI
                        , :NEW.CODICE_AMMINISTRAZIONE
                        , :NEW.NI );
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



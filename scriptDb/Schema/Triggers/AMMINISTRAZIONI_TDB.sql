CREATE OR REPLACE TRIGGER AMMINISTRAZIONI_TDB
/******************************************************************************
 NOME:        AMMINISTRAZIONI_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table AMMINISTRAZIONI
 ANNOTAZIONI: Richiama Procedure AMMINISTRAZIONI_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on AMMINISTRAZIONI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      AMMINISTRAZIONI_PD( :OLD.CODICE_AMMINISTRAZIONE
                     , :OLD.NI );
      null;
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



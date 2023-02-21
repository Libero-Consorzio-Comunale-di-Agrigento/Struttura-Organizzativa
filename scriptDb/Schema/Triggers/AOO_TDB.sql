CREATE OR REPLACE TRIGGER AOO_TDB
/******************************************************************************
 NOME:        AOO_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table AOO
 ANNOTAZIONI: Richiama Procedure AOO_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on AOO
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      AOO_PD( :OLD.PROGR_AOO
                     , :OLD.DAL
                     , :OLD.CODICE_AMMINISTRAZIONE );
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



CREATE OR REPLACE TRIGGER OTTICHE_TDB
/******************************************************************************
 NOME:        OTTICHE_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table OTTICHE
 ANNOTAZIONI: Richiama Procedure OTTICHE_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on OTTICHE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      OTTICHE_PD( :OLD.OTTICA
                     , :OLD.AMMINISTRAZIONE
                     , :OLD.OTTICA_ORIGINE );
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



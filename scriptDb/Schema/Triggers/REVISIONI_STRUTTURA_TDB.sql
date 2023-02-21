CREATE OR REPLACE TRIGGER REVISIONI_STRUTTURA_TDB
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table REVISIONI_STRUTTURA
 ANNOTAZIONI: Richiama Procedure REVISIONI_STRUTTURA_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on REVISIONI_STRUTTURA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      REVISIONI_STRUTTURA_PD( :OLD.OTTICA
                     , :OLD.REVISIONE );
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



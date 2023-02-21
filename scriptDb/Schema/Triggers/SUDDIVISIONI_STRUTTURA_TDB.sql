CREATE OR REPLACE TRIGGER SUDDIVISIONI_STRUTTURA_TDB
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table SUDDIVISIONI_STRUTTURA
 ANNOTAZIONI: Richiama Procedure SUDDIVISIONI_STRUTTURA_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on SUDDIVISIONI_STRUTTURA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      SUDDIVISIONI_STRUTTURA_PD( :OLD.ID_SUDDIVISIONE
                     , :OLD.OTTICA );
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



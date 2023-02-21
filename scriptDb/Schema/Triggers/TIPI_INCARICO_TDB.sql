CREATE OR REPLACE TRIGGER TIPI_INCARICO_TDB
/******************************************************************************
 NOME:        TIPI_INCARICO_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table TIPI_INCARICO
 ANNOTAZIONI: Richiama Procedure TIPI_INCARICO_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on TIPI_INCARICO
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      TIPI_INCARICO_PD( :OLD.INCARICO
                     , :OLD.TIPO_INCARICO );
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



CREATE OR REPLACE TRIGGER SUDDIVISIONI_FISICHE_TDB
/******************************************************************************
 NOME:        SUDDIVISIONI_FISICHE_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table SUDDIVISIONI_FISICHE
 ANNOTAZIONI: Richiama Procedure SUDDIVISIONI_FISICHE_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on SUDDIVISIONI_FISICHE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      SUDDIVISIONI_FISICHE_PD( :OLD.ID_SUDDIVISIONE
                     , :OLD.AMMINISTRAZIONE );
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



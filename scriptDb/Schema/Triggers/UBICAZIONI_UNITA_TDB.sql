CREATE OR REPLACE TRIGGER UBICAZIONI_UNITA_TDB
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table UBICAZIONI_UNITA
 ANNOTAZIONI: Richiama Procedure UBICAZIONI_UNITA_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on UBICAZIONI_UNITA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      UBICAZIONI_UNITA_PD( :OLD.ID_UBICAZIONE
                     , :OLD.PROGR_UNITA_ORGANIZZATIVA
                     , :OLD.PROGR_UNITA_FISICA );
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



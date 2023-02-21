CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_FISICHE_TDB
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table ANAGRAFE_UNITA_FISICHE
 ANNOTAZIONI: Richiama Procedure ANAGRAFE_UNITA_FISICHE_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on ANAGRAFE_UNITA_FISICHE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      ANAGRAFE_UNITA_FISICHE_PD( :OLD.PROGR_UNITA_FISICA
                     , :OLD.DAL
                     , :OLD.ID_SUDDIVISIONE );
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



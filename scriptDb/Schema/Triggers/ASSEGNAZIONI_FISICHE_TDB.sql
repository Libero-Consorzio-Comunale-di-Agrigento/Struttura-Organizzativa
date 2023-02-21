CREATE OR REPLACE TRIGGER ASSEGNAZIONI_FISICHE_TDB
/******************************************************************************
 NOME:        ASSEGNAZIONI_FISICHE_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table ASSEGNAZIONI_FISICHE
 ANNOTAZIONI: Richiama Procedure ASSEGNAZIONI_FISICHE_TD  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before DELETE on ASSEGNAZIONI_FISICHE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on DELETE
      ASSEGNAZIONI_FISICHE_PD( :OLD.ID_ASFI
                     , :OLD.ID_UBICAZIONE_COMPONENTE
                     , :OLD.NI
                     , :OLD.PROGR_UNITA_FISICA
                     , :OLD.PROGR_UNITA_ORGANIZZATIVA );
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



CREATE OR REPLACE TRIGGER COMPONENTI_TMA
/******************************************************************************
 NOME:        COMPONENTI_TMA
 DESCRIZIONE: Trigger for Set REFERENTIAL Integrity
                       at INSERT or UPDATE on Table COMPONENTI
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   after INSERT or UPDATE on COMPONENTI
for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
   begin  -- Set REFERENTIAL Integrity on UPDATE
      if UPDATING then
         IntegrityPackage.NextNestLevel;
         --  Modify parent code of "COMPONENTI" for all children in "RUOLI_COMPONENTE"
         if (:OLD.ID_COMPONENTE != :NEW.ID_COMPONENTE) then
            update RUOLI_COMPONENTE
             set   ID_COMPONENTE = :NEW.ID_COMPONENTE
            where  ID_COMPONENTE = :OLD.ID_COMPONENTE;
         end if;
         --  Modify parent code of "COMPONENTI" for all children in "ATTRIBUTI_COMPONENTE"
         if (:OLD.ID_COMPONENTE != :NEW.ID_COMPONENTE) then
            update ATTRIBUTI_COMPONENTE
             set   ID_COMPONENTE = :NEW.ID_COMPONENTE
            where  ID_COMPONENTE = :OLD.ID_COMPONENTE;
         end if;
         --  Modify parent code of "COMPONENTI" for all children in "UBICAZIONI_COMPONENTE"
         if (:OLD.ID_COMPONENTE != :NEW.ID_COMPONENTE) then
            update UBICAZIONI_COMPONENTE
             set   ID_COMPONENTE = :NEW.ID_COMPONENTE
            where  ID_COMPONENTE = :OLD.ID_COMPONENTE;
         end if;
         --  Modify parent code of "COMPONENTI" for all children in "IMPUTAZIONI_BILANCIO"
         if (:OLD.ID_COMPONENTE != :NEW.ID_COMPONENTE) then
            update IMPUTAZIONI_BILANCIO
             set   ID_COMPONENTE = :NEW.ID_COMPONENTE
            where  ID_COMPONENTE = :OLD.ID_COMPONENTE;
         end if;
         IntegrityPackage.PreviousNestLevel;
      end if;
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



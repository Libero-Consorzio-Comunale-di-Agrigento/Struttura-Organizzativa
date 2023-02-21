CREATE OR REPLACE TRIGGER SLAVES_TB
/******************************************************************************
 NOME:        SLAVES_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table SLAVES
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   before INSERT or UPDATE or DELETE on SLAVES
declare
   functionalNestLevel integer;
begin
   /* RESET PostEvent for Custom Functional Check */
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   if functionalNestLevel = 0 then
      IntegrityPackage.InitNestLevel;
   end if;
end;
/



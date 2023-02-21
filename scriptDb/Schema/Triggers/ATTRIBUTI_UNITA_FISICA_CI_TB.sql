CREATE OR REPLACE TRIGGER ATTRIBUTI_UNITA_FISICA_CI_TB
/******************************************************************************
 NOME:        ATTRIBUTI_UNITA_FISICA_CI_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table ATTRIBUTI_UNITA_FISICA_CI
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   before INSERT or UPDATE or DELETE on ATTRIBUTI_UNITA_FISICA_CI
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



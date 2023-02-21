CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_ORGANIZZATIV_TB
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_ORGANIZZATIV_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table ANAGRAFE_UNITA_ORGANIZZATIVE
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   before INSERT or UPDATE or DELETE on ANAGRAFE_UNITA_ORGANIZZATIVE
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



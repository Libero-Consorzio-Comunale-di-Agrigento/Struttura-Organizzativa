CREATE OR REPLACE TRIGGER TEMP_CF4_UNITA_AGG_TB
/******************************************************************************
 NOME:        TEMP_CF4_UNITA_AGG_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table TEMP_CF4_UNITA_AGG
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   before INSERT or UPDATE or DELETE on TEMP_CF4_UNITA_AGG
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



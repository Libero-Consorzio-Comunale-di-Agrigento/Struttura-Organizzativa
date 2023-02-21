CREATE OR REPLACE TRIGGER ATTRIBUTI_ASSEGNAZIONE_FISI_TB
/******************************************************************************
 NOME:        ATTRIBUTI_ASSEGNAZIONE_FISI_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table ATTRIBUTI_ASSEGNAZIONE_FISICA
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   before INSERT or UPDATE or DELETE on ATTRIBUTI_ASSEGNAZIONE_FISICA
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



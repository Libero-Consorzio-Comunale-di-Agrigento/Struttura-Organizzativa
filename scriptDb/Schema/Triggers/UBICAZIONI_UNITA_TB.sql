CREATE OR REPLACE TRIGGER UBICAZIONI_UNITA_TB
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table UBICAZIONI_UNITA
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   before INSERT or UPDATE or DELETE on UBICAZIONI_UNITA
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



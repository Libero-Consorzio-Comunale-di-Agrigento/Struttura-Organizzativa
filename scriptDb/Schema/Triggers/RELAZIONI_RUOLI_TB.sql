CREATE OR REPLACE TRIGGER relazioni_ruoli_tb
/******************************************************************************
    NOME:        relazioni_ruoli_TB
    DESCRIZIONE: Trigger for Custom Functional Check
                          at INSERT or UPDATE or DELETE on Table relazioni_ruoli
   
    ANNOTAZIONI: Esegue inizializzazione tabella di POST Event.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generata in automatico.
   ******************************************************************************/
   before insert or update or delete on relazioni_ruoli
declare
   functionalnestlevel integer;
begin
   /* RESET PostEvent for Custom Functional Check */
   functionalnestlevel := integritypackage.getnestlevel;
   if functionalnestlevel = 0 then
      integritypackage.initnestlevel;
   end if;
end;
/



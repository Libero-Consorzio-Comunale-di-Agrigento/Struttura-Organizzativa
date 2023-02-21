CREATE OR REPLACE TRIGGER competenze_delega_tb
/******************************************************************************
    NOME:        competenze_delega_tb
    DESCRIZIONE: Trigger for Custom Functional Check
                          at INSERT or UPDATE or DELETE on Table competenze_deleghe_1
   
    ANNOTAZIONI: Esegue inizializzazione tabella di POST Event.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generata in automatico.
   ******************************************************************************/
   before insert or update or delete on competenze_delega
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



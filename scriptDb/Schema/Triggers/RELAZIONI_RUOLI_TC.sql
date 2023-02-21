CREATE OR REPLACE TRIGGER relazioni_ruoli_tc
/******************************************************************************
    NOME:        relazioni_ruoli_TC
    DESCRIZIONE: Trigger for Custom Functional Check
                       after INSERT or UPDATE or DELETE on Table relazioni_ruoli
   
    ANNOTAZIONI: Esegue operazioni di POST Event prenotate.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generata in automatico.
   ******************************************************************************/
   after insert or update or delete on relazioni_ruoli
begin
   /* Esempio di prenotazione PostEvent con macro SetFunctionalPostEvent
      IntegrityPackage.Set_PostEvent( 'select 1 from tab'
                                    ||'where c1 = '''||%new%c1||''''
                                    , 'Non esiste riferimento su tabella.');
   */
   /* EXEC PostEvent for Custom Functional Check */
   integritypackage.exec_postevent;
end;
/



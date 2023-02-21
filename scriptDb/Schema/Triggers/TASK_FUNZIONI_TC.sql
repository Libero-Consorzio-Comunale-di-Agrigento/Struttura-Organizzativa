CREATE OR REPLACE TRIGGER task_funzioni_tc
/******************************************************************************
    NOME:        task_funzioni_TC
    DESCRIZIONE: Trigger for Custom Functional Check
                       after INSERT or UPDATE or DELETE on Table task_funzioni
   
    ANNOTAZIONI: Esegue operazioni di POST Event prenotate.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generata in automatico.
   ******************************************************************************/
   after insert or update or delete ON TASK_FUNZIONI
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



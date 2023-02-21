CREATE OR REPLACE TRIGGER SLAVES_TC
/******************************************************************************
 NOME:        SLAVES_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table SLAVES
 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   after INSERT or UPDATE or DELETE on SLAVES
begin
   /* Esempio di prenotazione PostEvent con macro SetFunctionalPostEvent
      IntegrityPackage.Set_PostEvent( 'select 1 from tab'
                                    ||'where c1 = '''||%new%c1||''''
                                    , 'Non esiste riferimento su tabella.');
   */
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
end;
/



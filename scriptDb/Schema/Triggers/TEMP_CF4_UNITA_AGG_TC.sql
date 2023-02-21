CREATE OR REPLACE TRIGGER TEMP_CF4_UNITA_AGG_TC
/******************************************************************************
 NOME:        TEMP_CF4_UNITA_AGG_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table TEMP_CF4_UNITA_AGG

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   after INSERT or UPDATE or DELETE on TEMP_CF4_UNITA_AGG
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



CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_FISICHE_TC
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table ANAGRAFE_UNITA_FISICHE

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
   after INSERT or UPDATE or DELETE on ANAGRAFE_UNITA_FISICHE
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



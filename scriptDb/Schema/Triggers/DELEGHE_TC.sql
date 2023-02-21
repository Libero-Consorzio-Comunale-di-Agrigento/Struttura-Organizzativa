CREATE OR REPLACE TRIGGER deleghe_tc
/******************************************************************************
    NOME:        deleghe_TC
    DESCRIZIONE: Trigger for Custom Functional Check
                       after INSERT or UPDATE or DELETE on Table deleghe
   
    ANNOTAZIONI: Esegue operazioni di POST Event prenotate.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generata in automatico.
   ******************************************************************************/
   after insert or update or delete on deleghe
begin
   /* EXEC PostEvent for Custom Functional Check */
   integritypackage.exec_postevent;
end;
/



CREATE OR REPLACE PACKAGE BODY Job_Utility IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 29/11/2006';
END VERSIONE;
FUNCTION crea
( p_what varchar2
, p_next_date date
, p_interval varchar2
, p_broken number
)
RETURN NUMBER
IS
  d_job        number;
BEGIN
  dbms_job.submit
      ( job       => d_job
      , what      => p_what
      , next_date => p_next_date
      , interval  => p_interval
      , no_parse  => TRUE
      );
   if p_broken = 1
   then
      dbms_job.broken(d_job,TRUE);
   end if;
   return d_job;
END crea;
FUNCTION crea_commit
( p_what varchar2
, p_next_date date
, p_interval varchar2
, p_broken number
)
RETURN NUMBER
IS
  pragma autonomous_transaction;
  d_job        number;
BEGIN
   d_job := crea(p_what, p_next_date, p_interval, p_broken);
   commit;
   return d_job;
END crea_commit;
PROCEDURE modifica
( p_job  NUMBER
, p_what VARCHAR2
, p_next_date VARCHAR2
, p_interval VARCHAR2)
IS
  d_next_date DATE := TO_DATE(p_next_date,'dd/mm/yyyy hh24:mi:ss');
BEGIN
   DBMS_JOB.CHANGE ( job       => p_job
                   , what      => p_what
                   , next_date => d_next_date
                   , INTERVAL  => p_interval
                   );
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END modifica;
PROCEDURE modifica_commit
( p_job  NUMBER
, p_what VARCHAR2
, p_next_date VARCHAR2
, p_interval VARCHAR2)
IS
   pragma autonomous_transaction;
BEGIN
   modifica ( p_job, p_what, p_next_date, p_interval);
   commit;
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END modifica_commit;
PROCEDURE blocca
/************************************************************************************
   FUNZIONE:      JOB_BROKEN
   DESCRIZIONE:   Modifica il flag 'broken' del job ( i job 'broken' non vengono
                  eseguiti) con la funzione SYS.DBMS_JOB.BROKEN e modifica la data in
                  cui il job sarà eseguito la volta successiva con la funzione
                  SYS.DBMS_JOB.NEXT_DATE.
                  Esegue COMMIT (o ROLLBACK) delle modifiche sul DB.
   ARGOMENTI:      Nome            Descrizione
                  ----            -----------
                  p_job            Numero identificativo del job da bloccare / sbloccare
                  p_broken         Indica se il job deve essere bloccato (TRUE) o
                                 sbloccato (FALSE)
                  p_next_date      Data in cui il job sarà eseguito la volta   successiva
   MODIFICHE:      Data          Sigla      Commento
                  ----         -----      --------
                  10/01/2002   MM         Creazione.
************************************************************************************/
( p_job  NUMBER
, p_broken VARCHAR2
, p_next_date VARCHAR2)
IS
  d_next_date DATE := TO_DATE(p_next_date,'dd/mm/yyyy hh24:mi:ss');
  d_broken BOOLEAN := p_broken <> 'Y';
BEGIN
    DBMS_JOB.BROKEN(p_job, d_broken);
   DBMS_JOB.NEXT_DATE(p_job, d_next_date);
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
     RAISE;
END blocca;
PROCEDURE blocca_commit
( p_job  NUMBER
, p_broken VARCHAR2
, p_next_date VARCHAR2)
IS
   pragma autonomous_transaction;
BEGIN
   blocca ( p_job, p_broken, p_next_date);
   commit;
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END blocca_commit;
END Job_Utility;
/


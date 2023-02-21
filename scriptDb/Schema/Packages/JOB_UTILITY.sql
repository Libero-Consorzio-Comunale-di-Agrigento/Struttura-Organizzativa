CREATE OR REPLACE PACKAGE Job_Utility IS
/******************************************************************************
 NOME:        JOB_UTILITY.
 DESCRIZIONE: .
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/11/2006 MM     Creazione.
******************************************************************************/
FUNCTION VERSIONE RETURN VARCHAR2;
FUNCTION crea
( p_what varchar2
, p_next_date date default sysdate + 1/86400
, p_interval varchar2 default ''
, p_broken number default 0
)
RETURN NUMBER;
FUNCTION crea_commit
( p_what varchar2
, p_next_date date default sysdate + 1/86400
, p_interval varchar2 default ''
, p_broken number default 0
)
RETURN NUMBER;
PROCEDURE modifica
( p_job  NUMBER
, p_what VARCHAR2
, p_next_date VARCHAR2
, p_interval VARCHAR2);
PROCEDURE modifica_commit
( p_job  NUMBER
, p_what VARCHAR2
, p_next_date VARCHAR2
, p_interval VARCHAR2);
PROCEDURE blocca
( p_job  NUMBER
, p_broken VARCHAR2
, p_next_date VARCHAR2);
PROCEDURE blocca_commit
( p_job  NUMBER
, p_broken VARCHAR2
, p_next_date VARCHAR2);
END JOB_UTILITY;
/


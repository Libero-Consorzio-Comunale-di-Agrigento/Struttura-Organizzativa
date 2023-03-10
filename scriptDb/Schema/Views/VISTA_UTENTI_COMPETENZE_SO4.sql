CREATE OR REPLACE FORCE VIEW VISTA_UTENTI_COMPETENZE_SO4
(UTENTE, ID_UTENTE, NOMINATIVO, PASSWORD, DATA_PASSWORD, 
 RINNOVO_PASSWORD, PWD_DA_MODIFICARE, ULTIMO_TENTATIVO, NUMERO_TENTATIVI, TIPO_UTENTE, 
 STATO, LINGUA, GRUPPO_LAVORO, IMPORTANZA, NOTE, 
 DATA_INSERIMENTO, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO)
BEQUEATH DEFINER
AS 
SELECT UTENTE,
          ID_UTENTE,
          NOMINATIVO,
          PASSWORD,
          DATA_PASSWORD,
          RINNOVO_PASSWORD,
          PWD_DA_MODIFICARE,
          ULTIMO_TENTATIVO,
          NUMERO_TENTATIVI,
          TIPO_UTENTE,
          STATO,
          LINGUA,
          GRUPPO_LAVORO,
          IMPORTANZA,
          NOTE,
          DATA_INSERIMENTO,
          UTENTE_AGGIORNAMENTO,
          DATA_AGGIORNAMENTO
     FROM ad4_utenti uten
    WHERE EXISTS
             (SELECT 1
                FROM ad4_diritti_accesso diac
               WHERE     UTEN.UTENTE = DIAC.UTENTE
                     AND diac.modulo = 'SI4SO'
                     AND stato = 'U'
                     AND tipo_utente IN ('G', 'U'));



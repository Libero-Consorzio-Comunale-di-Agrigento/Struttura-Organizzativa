CREATE OR REPLACE FORCE VIEW VISTA_PROFILI
(PROFILO, DESCRIZIONE, PROGETTO, MODULO, UTENTI, 
 UTENTI_OGGI)
BEQUEATH DEFINER
AS 
SELECT DISTINCT
          r.ruolo profilo,
          r.descrizione,
          r.progetto,
          r.modulo,
          (SELECT COUNT (DISTINCT ni)
             FROM vista_ruoli_profili
            WHERE profilo = r.ruolo)
             utenti,
          (SELECT COUNT (DISTINCT ni)
             FROM vista_ruoli_profili
            WHERE     profilo = r.ruolo
                  AND SYSDATE BETWEEN dal_ruolo
                                  AND NVL (al_ruolo, TO_DATE (3333333, 'j')))
             utenti_oggi
     FROM ad4_ruoli r, ruoli_profilo p
    WHERE p.ruolo_profilo = r.ruolo;



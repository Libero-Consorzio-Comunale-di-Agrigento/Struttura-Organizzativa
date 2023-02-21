CREATE OR REPLACE FORCE VIEW VISTA_VALORI_COMPETENZE_SO4
(VALORE, DESCRIZIONE, CODICE_COMPETENZA)
BEQUEATH DEFINER
AS 
SELECT codice_amministrazione valore,
          ad4_soggetto.get_denominazione (ni) descrizione,
          'SO4AMM' codice_competenza
     FROM amministrazioni
    where ente = 'SI'
   UNION
   SELECT OTTICA VALORE, DESCRIZIONE, 'SO4OTT' CODICE_COMPETENZA FROM OTTICHE
   UNION
   SELECT TO_CHAR (progr_unita_fisica) valore,
          denominazione descrizione,
          'SO4STRF' codice_competenza
     FROM vista_unita_fisiche
    WHERE     SYSDATE BETWEEN dal AND NVL (al, TO_DATE (3333333, 'J'))
          AND id_unita_fisica_padre IS NULL
   UNION
   SELECT '%' valore,
          'Tutte le unita'' fisiche' descrizione,
          'SO4STRF' codice_competenza
     FROM DUAL;



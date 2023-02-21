CREATE OR REPLACE FORCE VIEW VISTA_TIPI_OGGETTO_SO4
(TIPO_OGGETTO, DESCRIZIONE)
BEQUEATH DEFINER
AS 
SELECT 'SO4AMM' tipo_oggetto, 'Competenza su Amministrazione' descrizione
     FROM DUAL
   UNION
   SELECT 'SO4OTT' tipo_oggetto, 'Competenza su Ottica' descrizione FROM DUAL

   UNION
   SELECT 'SO4STRF' tipo_oggetto,
          'Competenza su Struttura Fisica' descrizione
     FROM DUAL;



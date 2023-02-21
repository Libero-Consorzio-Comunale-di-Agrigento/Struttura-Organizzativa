CREATE OR REPLACE FORCE VIEW SOGGETTI_STRUTTURA
(NI, PROGR_ENTITA, TIPO_ENTITA)
BEQUEATH DEFINER
AS 
SELECT ni, progr_unita_organizzativa progr_entita, 'UO' tipo_entita
     FROM soggetti_unita
   UNION
   SELECT ni, progr_aoo progr_entita, 'AO' tipo_entita FROM soggetti_aoo
   UNION
   SELECT ni, ni progr_entita, 'AM' tipo_entita FROM amministrazioni;



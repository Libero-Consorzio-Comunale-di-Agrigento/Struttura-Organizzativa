CREATE OR REPLACE FORCE VIEW VISTA_TIPI_ABILITAZIONE_SO4
(TIPO_OGGETTO, TIPO_ABILITAZIONE, DESCRIZIONE)
BEQUEATH DEFINER
AS 
SELECT vcso.tipo_oggetto, 'LE' tipo_abilitazione, 'Lettura' descrizione
     FROM DUAL, vista_tipi_oggetto_so4 vcso;



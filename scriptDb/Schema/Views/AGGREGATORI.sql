CREATE OR REPLACE FORCE VIEW AGGREGATORI
(AGGREGATORE, DESCRIZIONE, DATA_INIZIO_VALIDITA, DATA_FINE_VALIDITA)
BEQUEATH DEFINER
AS 
SELECT aggregatore,
       descrizione,
       data_inizio_validita,
       data_fine_validita
  FROM so4_aggregatori aggr1
 WHERE data_inizio_validita =
      (SELECT MAX (data_inizio_validita)
         FROM so4_aggregatori aggr2
        WHERE aggr2.aggregatore = aggr1.aggregatore);



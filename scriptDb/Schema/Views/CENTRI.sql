CREATE OR REPLACE FORCE VIEW CENTRI
(CENTRO, DESCRIZIONE, DESCRIZIONE_ABB, TIPO_CENTRO, DATA_VALIDITA)
BEQUEATH DEFINER
AS 
select centro
     , descrizione
     , descrizione_abb
     , tipo_centro
     , data_validita
  from SO4_CENTRI;



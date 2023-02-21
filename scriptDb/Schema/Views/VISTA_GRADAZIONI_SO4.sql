CREATE OR REPLACE FORCE VIEW VISTA_GRADAZIONI_SO4
(TIPOLOGIA_UNITA)
BEQUEATH DEFINER
AS 
select distinct tipologia_unita
  from anagrafe_unita_organizzative
union
select distinct gradazione 
  from attributi_componente;



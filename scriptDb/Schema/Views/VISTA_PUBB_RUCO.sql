CREATE OR REPLACE FORCE VIEW VISTA_PUBB_RUCO
(ID_RUOLO_COMPONENTE, ID_COMPONENTE, RUOLO, DAL, AL, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO)
BEQUEATH DEFINER
AS 
select id_ruolo_componente
     , id_componente
     , ruolo
     , dal_pubb dal
     , al_pubb al
     , utente_aggiornamento
     , data_aggiornamento
  from ruoli_componente
 where dal_pubb <= nvl(al_pubb,to_date(3333333,'j'));



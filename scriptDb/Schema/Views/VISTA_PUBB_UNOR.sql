CREATE OR REPLACE FORCE VIEW VISTA_PUBB_UNOR
(ID_ELEMENTO, OTTICA, REVISIONE, SEQUENZA, PROGR_UNITA_ORGANIZZATIVA, 
 ID_UNITA_PADRE, REVISIONE_CESSAZIONE, DAL, AL, UTENTE_AGGIORNAMENTO, 
 DATA_AGGIORNAMENTO)
BEQUEATH DEFINER
AS 
select id_elemento
      ,u.ottica
      ,revisione
      ,sequenza
      ,progr_unita_organizzativa
      ,id_unita_padre
      ,revisione_cessazione
      ,dal_pubb                  dal
      ,al_pubb                   al
      ,utente_aggiornamento
      ,data_aggiornamento
  from revisioni_modifica  r
      ,unita_organizzative u
 where nvl(revisione, -2) <> r.revisione_modifica
   and r.ottica = u.ottica
   and dal_pubb <= nvl(al_pubb, to_date(3333333, 'j'));



CREATE OR REPLACE FORCE VIEW RELAZIONI_STRUTTURA
(REVISIONE, AMMINISTRAZIONE, PROGR_PADRE, COD_PADRE, SUDD_PADRE, 
 PROGR_FIGLIO, COD_FIGLIO, SUDD_FIGLIO, SEQUENZA_FIGLIO, SEQUENZA_PADRE, 
 DESCR_FIGLIO, DESCR_PADRE, LIV_FIGLIO, LIV_PADRE, OTTICA, 
 DAL_PADRE, AL_PADRE, DAL_FIGLIO, AL_FIGLIO, ORDINAMENTO, 
 DESCR_AMMINISTRAZIONE, COD_AOO, DESCR_AOO, DESCR_OTTICA, ID_RELAZIONI_STRUTTURA, 
 PROGR_PADRE_EFFETTIVO)
BEQUEATH DEFINER
AS 
select rest.revisione
      ,reuo.amministrazione
      ,reuo.progr_padre
      ,reuo.cod_padre
      ,reuo.sudd_padre
      ,reuo.progr_figlio
      ,reuo.cod_figlio
      ,reuo.sudd_figlio
      ,reuo.sequenza_figlio
      ,reuo.sequenza_padre
      ,reuo.descr_figlio
      ,reuo.descr_padre
      ,reuo.liv_figlio
      ,reuo.liv_padre
      ,reuo.ottica
      ,reuo.dal_padre
      ,reuo.al_padre
      ,reuo.dal_figlio
      ,reuo.al_figlio
      ,reuo.ordinamento
      ,reuo.descr_amministrazione
      ,reuo.cod_aoo
      ,reuo.descr_aoo
      ,reuo.descr_ottica
      ,reuo.id_relazioni_struttura
      ,reuo.progr_padre_effettivo
  from relazioni_unita_organizzative reuo
      ,revisioni_struttura           rest
 where rest.ottica = reuo.ottica;



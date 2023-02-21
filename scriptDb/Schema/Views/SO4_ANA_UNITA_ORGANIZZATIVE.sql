CREATE OR REPLACE FORCE VIEW SO4_ANA_UNITA_ORGANIZZATIVE
(OTTICA, COD_SUDDIVISIONE, DES_SUDDIVISIONE, PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, 
 DES_UNITA_ORGANIZZATIVA, DAL, AL, ID_SUDDIVISIONE, CENTRO, 
 CENTRO_RESPONSABILITA)
BEQUEATH DEFINER
AS 
select a.ottica ottica
      ,s.suddivisione cod_suddivisione
      ,s.descrizione des_suddivisione
      ,a.progr_unita_organizzativa
      ,a.codice_uo
      ,a.descrizione des_unita_organizzativa
      ,a.dal
      ,decode(a.revisione_cessazione
             ,r.revisione_modifica --#558
             ,a.al_prec --#547
             ,a.al)
      ,a.id_suddivisione
      ,a.centro
      ,a.centro_responsabilita
  from suddivisioni_struttura       s
      ,revisioni_modifica           r --#558
      ,anagrafe_unita_organizzative a
 where a.id_suddivisione = s.id_suddivisione(+)
   and r.ottica = a.ottica
   and nvl(a.revisione_istituzione, -2) != r.revisione_modifica --#558
;



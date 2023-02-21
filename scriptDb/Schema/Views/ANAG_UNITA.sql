CREATE OR REPLACE FORCE VIEW ANAG_UNITA
(AMMINISTRAZIONE, CODICE_UO, DES_UNITA_ORGANIZZATIVA, DES_ABB, UTENTE_AD4, 
 CODICE_AOO, PROGR_AOO, PROGR_UNITA_ORGANIZZATIVA)
BEQUEATH DEFINER
AS 
select a.amministrazione
      ,a.codice_uo
      ,a.descrizione des_unita_organizzativa
      ,a.des_abb
      ,a.utente_ad4
      ,aoo_pkg.get_codice_aoo(a.progr_aoo, trunc(sysdate)) codice_aoo
      ,a.progr_aoo
      ,a.progr_unita_organizzativa
  from anagrafe_unita_organizzative a
      ,revisioni_modifica           r --#558
      ,ottiche                      o
 where nvl(a.revisione_istituzione, -2) != r.revisione_modifica
   and trunc(sysdate) between a.dal and
       nvl(decode(nvl(revisione_cessazione, -2), r.revisione_modifica, a.al_prec, a.al) --#547,#558
          ,trunc(sysdate))
   and a.ottica = o.ottica
   and r.ottica = a.ottica
   and o.ottica_istituzionale = 'SI';



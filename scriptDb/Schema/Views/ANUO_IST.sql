CREATE OR REPLACE FORCE VIEW ANUO_IST
(PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, DESCRIZIONE, CATEGORIA, DES_CATEGORIA, 
 AMMINISTRAZIONE, DES_AMMINISTRAZIONE, COD_AOO, DES_AOO, OTTICA, 
 DES_OTTICA)
BEQUEATH DEFINER
AS 
select progr_unita_organizzativa
      ,codice_uo
      ,descrizione
      ,suddivisione_struttura.get_suddivisione(id_suddivisione) categoria
      ,suddivisione_struttura.get_descrizione(id_suddivisione) des_categoria
      ,amministrazione
      ,soggetti_get_descr(amministrazione.get_ni(amministrazione), dal, 'DESCRIZIONE') des_amministrazione
      ,aoo_pkg.get_codice_aoo(progr_aoo, dal) cod_aoo
      ,aoo_pkg.get_descrizione(progr_aoo, dal) des_aoo
      ,a.ottica
      ,ottica.get_descrizione(a.ottica) des_ottica
  from anagrafe_unita_organizzative a
      ,revisioni_modifica r --#558
 where a.ottica in (select ottica from ottiche where ottica_istituzionale = 'SI')
   and r.ottica=a.ottica
   and nvl(revisione_istituzione,-2) != r.revisione_modifica
   and sysdate between dal and nvl(decode(nvl(revisione_cessazione,-2)
                                         ,r.revisione_modifica --#558
                                         ,al_prec --#547
                                         ,al)
                                  ,to_date(3333333, 'j'));



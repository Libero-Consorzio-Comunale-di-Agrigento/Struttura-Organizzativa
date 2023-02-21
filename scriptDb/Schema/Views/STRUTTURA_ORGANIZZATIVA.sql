CREATE OR REPLACE FORCE VIEW STRUTTURA_ORGANIZZATIVA
(OTTICA, AMMINISTRAZIONE, ORDINAMENTO, PROGR_UNITA_ORGANIZZATIVA, CODICE_PADRE, 
 DESCR_PADRE, CODICE_FIGLIO, DESCR_FIGLIO, ID_SUDDIVISIONE, ICONA_STANDARD, 
 RESPONSABILE)
BEQUEATH DEFINER
AS 
select s.ottica
      ,o.amministrazione
      ,so4_util.get_ordinamento(s.progr_unita_organizzativa
                               ,trunc(sysdate)
                               ,s.ottica
                               ,o.amministrazione) ordinamento
      ,s.progr_unita_organizzativa
      ,anagrafe_unita_organizzativa.get_codice_uo(s.id_unita_padre, trunc(sysdate)) codice_padre
      ,anagrafe_unita_organizzativa.get_descrizione(s.id_unita_padre, trunc(sysdate)) descr_padre
      ,anagrafe_unita_organizzativa.get_codice_uo(s.progr_unita_organizzativa
                                                 ,trunc(sysdate)) codice_figlio
      ,anagrafe_unita_organizzativa.get_descrizione(s.progr_unita_organizzativa
                                                   ,trunc(sysdate)) descr_figlio
      ,anagrafe_unita_organizzativa.get_id_suddivisione(s.progr_unita_organizzativa
                                                       ,trunc(sysdate)) id_suddivisione
      ,suddivisione_struttura.get_icona_standard(anagrafe_unita_organizzativa.get_id_suddivisione(s.progr_unita_organizzativa
                                                                                                 ,trunc(sysdate))) icona_standard
      ,so4_util.unita_get_resp_unico(s.progr_unita_organizzativa
                                    ,null
                                    ,s.ottica
                                    ,trunc(sysdate)
                                    ,o.amministrazione) responsabile
  from unita_organizzative s
      ,revisioni_modifica  r --#558
      ,ottiche             o
 where s.ottica = o.ottica
   and r.ottica = s.ottica
   and s.revisione != r.revisione_modifica
   and trunc(sysdate) between s.dal and
       nvl(decode(nvl(revisione_cessazione,-2)
                 ,r.revisione_modifica
                 ,s.al_prec --#547
                 ,al)
          ,to_date('3333333', 'j'));



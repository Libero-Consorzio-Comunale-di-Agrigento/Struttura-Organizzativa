CREATE OR REPLACE FORCE VIEW STRUTTURA_COMPONENTI
(OTTICA, AMMINISTRAZIONE, ORDINAMENTO, CODICE_PADRE, DESCR_PADRE, 
 CODICE_FIGLIO, DESCR_FIGLIO, NI, NOMINATIVO, INCARICO, 
 DESCR_INCARICO, SE_RESP)
BEQUEATH DEFINER
AS 
select s.ottica
      ,o.amministrazione
      ,so4_util.get_ordinamento(s.progr_unita_organizzativa
                               ,trunc(sysdate)
                               ,s.ottica
                               ,o.amministrazione) ordinamento
      ,anagrafe_unita_organizzativa.get_codice_uo(unita_organizzativa.get_progr_unita_padre(s.id_elemento)
                                                 ,trunc(sysdate)) codice_padre
      ,anagrafe_unita_organizzativa.get_descrizione(unita_organizzativa.get_progr_unita_padre(s.id_elemento)
                                                   ,trunc(sysdate)) descr_padre
      ,anagrafe_unita_organizzativa.get_codice_uo(s.progr_unita_organizzativa
                                                 ,trunc(sysdate)) codice_figlio
      ,anagrafe_unita_organizzativa.get_descrizione(s.progr_unita_organizzativa
                                                   ,trunc(sysdate)) descr_figlio
      ,c.ni
      ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME E NOME') nominativo
      ,attributo_componente.get_incarico_valido(c.id_componente
                                               ,trunc(sysdate)
                                               ,c.ottica) incarico
      ,tipo_incarico.get_descrizione(attributo_componente.get_incarico_valido(c.id_componente
                                                                             ,trunc(sysdate)
                                                                             ,c.ottica)) descr_incarico
      ,nvl(tipo_incarico.get_responsabile(attributo_componente.get_incarico_valido(c.id_componente
                                                                                  ,trunc(sysdate)
                                                                                  ,c.ottica))
          ,'NO') se_resp
  from unita_organizzative s
      ,ottiche             o
      ,revisioni_modifica  r --#558
      ,componenti          c
 where s.ottica = o.ottica
   and r.ottica = s.ottica
   and s.revisione != r.revisione_modifica
   and trunc(sysdate) between s.dal and
       nvl(decode(s.revisione_cessazione
                 ,r.revisione_modifica
                 ,s.al_prec --#547
                 ,s.al)
          ,to_date('3333333', 'j'))
   and c.ottica = o.ottica
   and s.progr_unita_organizzativa = c.progr_unita_organizzativa
   and nvl(c.revisione_assegnazione,-2) != r.revisione_modifica
   and trunc(sysdate) between c.dal and
       nvl(decode(c.revisione_cessazione
                 ,r.revisione_modifica
                 ,c.al_prec --#547
                 ,c.al)
          ,to_date('3333333', 'j'));



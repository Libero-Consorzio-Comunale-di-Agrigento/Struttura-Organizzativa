CREATE OR REPLACE FORCE VIEW VISTA_BROWSER_ASSEGNAZIONI
(OTTICA, ENTE, ENTE_NI, ENTE_DENOMINAZIONE, NI, 
 NOMINATIVO, CI, DAL, AL, PROGR_UNITA_ORGANIZZATIVA, 
 CODICE_UO, DESCRIZIONE, SUDDIVISIONE, DESCR_SUDDIVISIONE, TIPOLOGIA_UNITA, 
 SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, CENTRO, CENTRO_RESPONSABILITA, TIPO_UNITA, 
 UTENTE_AD4, RESPONSABILE, ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, ID_COMPONENTE, 
 NUM_MOD_UO)
BEQUEATH DEFINER
AS 
select c.ottica
      ,u.amministrazione ente
      ,amministrazione.get_ni(u.amministrazione) ente_ni
      ,substr(soggetti_get_descr(amministrazione.get_ni(u.amministrazione)
                                ,trunc(sysdate)
                                ,'DESCRIZIONE')
             ,1
             ,240) ente_denominazione
      ,c.ni
      ,nvl((select cognome || '  ' || nome
             from as4_anagrafe_soggetti
            where ni = c.ni
              and al is null)
          ,c.denominazione) nominativo
      ,c.ci
      ,c.dal
      ,c.al
      ,u.progr_unita_organizzativa
      ,u.codice_uo
      ,u.descrizione
      ,suddivisione_struttura.get_suddivisione(u.id_suddivisione) suddivisione
      ,suddivisione_struttura.get_descrizione(u.id_suddivisione) descr_suddivisione
      ,u.tipologia_unita
      ,u.se_giuridico
      ,u.assegnazione_componenti
      ,u.centro
      ,u.centro_responsabilita
      ,u.tipo_unita
      ,u.utente_ad4
      ,tipo_incarico.get_responsabile(attributo_componente.get_incarico_valido(c.id_componente
                                                                              ,nvl(decode(nvl(c.revisione_cessazione
                                                                                             ,-2)
                                                                                         ,rc.revisione_modifica
                                                                                         ,c.al_prec --#547
                                                                                         ,c.al)
                                                                                  ,to_date(3333333
                                                                                          ,'j'))
                                                                              ,c.ottica)) responsabile
      ,attributo_componente.get_assegnazione_valida(c.id_componente
                                                   ,nvl(decode(nvl(c.revisione_cessazione
                                                                  ,-2)
                                                              ,rc.revisione_modifica
                                                              ,c.al_prec --#547
                                                              ,c.al)
                                                       ,to_date(3333333, 'j'))
                                                   ,c.ottica) assegnazione_prevalente
      ,nvl(attributo_componente.get_tipo_ass_valido(c.id_componente
                                                   ,nvl(decode(nvl(c.revisione_cessazione
                                                                  ,-2)
                                                              ,rc.revisione_modifica
                                                              ,c.al_prec --#547
                                                              ,c.al)
                                                       ,to_date(3333333, 'j'))
                                                   ,c.ottica)
          ,'I') tipo_assegnazione
      ,c.id_componente
      ,anagrafe_unita_organizzativa.get_num_modifiche_uo(u.progr_unita_organizzativa
                                                        ,c.ottica
                                                        ,c.revisione_cessazione
                                                        ,rc.revisione_modifica
                                                        ,c.dal
                                                        ,c.al) num_mod_uo
  from anagrafe_unita_organizzative u
      ,revisioni_modifica           ru --#558
      ,revisioni_modifica           rc
      ,componenti                   c
 where u.revisione_istituzione != ru.revisione_modifica
   and nvl(c.revisione_assegnazione, -2) != rc.revisione_modifica
   and c.dal <= nvl(c.al, to_date(3333333, 'j'))
   and nvl(decode(nvl(c.revisione_cessazione, -2)
                 ,rc.revisione_modifica
                 ,c.al_prec --#547
                 ,c.al)
          ,to_date(3333333, 'j')) between u.dal and
       nvl(decode(nvl(u.revisione_cessazione, -2)
                 ,ru.revisione_modifica
                 ,u.al_prec --#547
                 ,u.al)
          ,to_date(3333333, 'j'))
   and u.progr_unita_organizzativa = c.progr_unita_organizzativa
   and nvl(c.al, to_date(3333333, 'j')) between u.dal and --#705
       nvl(decode(nvl(u.revisione_cessazione, -2)
                 ,ru.revisione_modifica
                 ,u.al_prec 
                 ,u.al)
          ,to_date(3333333, 'j'))
   and ru.ottica = u.ottica
   and rc.ottica = c.ottica;



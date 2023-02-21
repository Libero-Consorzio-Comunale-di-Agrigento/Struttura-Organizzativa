CREATE OR REPLACE FORCE VIEW VISTA_STRUTTURA
(OTTICA, AMMINISTRAZIONE, ORDINAMENTO, PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, 
 DESCRIZIONE, DAL, AL, PROGR_UNITA_PADRE, CODICE_PADRE, 
 DESCR_PADRE, ID_ELEMENTO, ID_UNITA_PADRE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, 
 REVISIONE, REVISIONE_CESSAZIONE, SEQUENZA, ID_SUDDIVISIONE, ICONA_STANDARD, 
 REV_IST_ANAG, REV_CESS_ANAG, TIPOLOGIA_UNITA, SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, 
 CENTRO, CENTRO_RESPONSABILITA, UTENTE_AD4, UTENTE_AGG_ANAG, DATA_AGG_ANAG)
BEQUEATH DEFINER
AS 
select u.ottica
      ,a.amministrazione
      ,so4_util.get_ordinamento(u.progr_unita_organizzativa
                               ,greatest(u.dal, a.dal)
                               ,u.ottica
                               ,a.amministrazione) ordinamento
      ,u.progr_unita_organizzativa
      ,a.codice_uo
      ,a.descrizione
      ,greatest(u.dal, a.dal) dal
      ,decode(least(nvl(decode(nvl(u.revisione_cessazione,-2)
                              ,ru.revisione_modifica
                              ,u.al_prec --#547
                              ,u.al)
                       ,to_date(3333333, 'j'))
                   ,nvl(decode(a.revisione_cessazione
                              ,ra.revisione_modifica
                              ,a.al_prec --#547
                              ,a.al)
                       ,to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(decode(u.revisione_cessazione
                              ,ru.revisione_modifica
                              ,u.al_prec --#547
                              ,u.al)
                       ,to_date(3333333, 'j'))
                   ,nvl(decode(a.revisione_cessazione
                              ,ra.revisione_modifica
                              ,a.al_prec --#547
                              ,a.al)
                       ,to_date(3333333, 'j')))) al
      ,u.id_unita_padre progr_unita_padre
      ,anagrafe_unita_organizzativa.get_codice_uo(u.id_unita_padre, a.dal) codice_padre
      ,anagrafe_unita_organizzativa.get_descrizione(u.id_unita_padre, a.dal) descr_padre
      ,u.id_elemento
      ,unita_organizzativa.get_id_progr_unita(u.id_unita_padre, u.ottica, u.dal) id_unita_padre
      ,u.utente_aggiornamento
      ,u.data_aggiornamento
      ,u.revisione
      ,u.revisione_cessazione
      ,u.sequenza
      ,a.id_suddivisione
      ,suddivisione_struttura.get_icona_standard(a.id_suddivisione) icona_standard
      ,a.revisione_istituzione rev_ist_anag
      ,a.revisione_cessazione rev_cess_anag
      ,a.tipologia_unita
      ,a.se_giuridico
      ,a.assegnazione_componenti
      ,a.centro
      ,a.centro_responsabilita
      ,a.utente_ad4
      ,a.utente_aggiornamento utente_agg_anag
      ,a.data_aggiornamento data_agg_anag
  from unita_organizzative          u
      ,revisioni_modifica           ru --#558
      ,revisioni_modifica           ra --#558
      ,anagrafe_unita_organizzative a
 where u.dal <= nvl(a.al, to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= a.dal
   and u.progr_unita_organizzativa = a.progr_unita_organizzativa
   and u.revisione != ru.revisione_modifica
   and a.revisione_istituzione != ra.revisione_modifica
   and u.dal < nvl(u.al, to_date(3333333, 'j'))
   and a.dal < nvl(a.al, to_date(3333333, 'j'))
   and ra.ottica = a.ottica
   and ru.ottica = u.ottica;



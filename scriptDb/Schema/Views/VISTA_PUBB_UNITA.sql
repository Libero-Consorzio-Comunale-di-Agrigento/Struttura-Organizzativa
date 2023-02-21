CREATE OR REPLACE FORCE VIEW VISTA_PUBB_UNITA
(ID_ELEMENTO, OTTICA, REVISIONE, REVISIONE_CESSAZIONE, SEQUENZA, 
 PROGR_UNITA_ORGANIZZATIVA, DAL, AL, ID_UNITA_PADRE, PROGR_UNITA_PADRE, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, CODICE_UO, DESCRIZIONE, ID_SUDDIVISIONE, 
 SUDDIVISIONE, DESCR_SUDDIVISIONE, REV_IST_ANAG, REV_CESS_ANAG, TIPOLOGIA_UNITA, 
 SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, AMMINISTRAZIONE, AOO, CENTRO, 
 CENTRO_RESPONSABILITA, UTENTE_AD4, UTENTE_AGG_ANAG, DATA_AGG_ANAG, NOTE, 
 TIPO_UNITA, ETICHETTA, TAG_MAIL, INDIRIZZO, FAX, 
 MAILFAX)
BEQUEATH DEFINER
AS 
select u.id_elemento
      ,u.ottica
      ,u.revisione
      ,u.revisione_cessazione
      ,u.sequenza
      ,u.progr_unita_organizzativa
      ,greatest(u.dal_pubb, a.dal_pubb) dal
      ,decode(least(nvl(decode(u.revisione_cessazione
                              ,ru.revisione_modifica
                              ,u.al_prec --#547
                              ,u.al_pubb)
                       ,to_date(3333333, 'j'))
                   ,nvl(decode(a.revisione_cessazione
                              ,ra.revisione_modifica
                              ,a.al_prec --#547
                              ,a.al_pubb)
                       ,to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(decode(u.revisione_cessazione
                              ,ru.revisione_modifica
                              ,u.al_prec --#547
                              ,u.al_pubb)
                       ,to_date(3333333, 'j'))
                   ,nvl(decode(a.revisione_cessazione
                              ,ra.revisione_modifica
                              ,a.al_prec --#547
                              ,a.al_pubb)
                       ,to_date(3333333, 'j'))))
      ,unita_organizzativa.get_id_progr_unita(u.id_unita_padre, u.ottica, u.dal) id_unita_padre
      ,u.id_unita_padre progr_unita_padre
      ,u.utente_aggiornamento
      ,u.data_aggiornamento
      ,a.codice_uo
      ,a.descrizione
      ,a.id_suddivisione
      ,suddivisione_struttura.get_suddivisione(a.id_suddivisione) suddivisione
      ,suddivisione_struttura.get_descrizione(a.id_suddivisione) descr_suddivisione
      ,a.revisione_istituzione rev_ist_anag
      ,a.revisione_cessazione rev_cess_anag
      ,a.tipologia_unita
      ,a.se_giuridico
      ,a.assegnazione_componenti
      ,a.amministrazione
      ,aoo_pkg.get_codice_aoo(a.progr_aoo, a.dal) aoo
      ,a.centro
      ,a.centro_responsabilita
      ,a.utente_ad4
      ,a.utente_aggiornamento utente_agg_anag
      ,a.data_aggiornamento data_agg_anag
      ,a.note
      ,a.tipo_unita
      ,a.etichetta
      ,indirizzo_telematico.get_tag_mail('UO'
                                        ,'I'
                                        ,null
                                        ,null
                                        ,a.progr_unita_organizzativa) tag_mail
      ,indirizzo_telematico.get_indirizzo('UO'
                                         ,'I'
                                         ,null
                                         ,null
                                         ,a.progr_unita_organizzativa) indirizzo
      ,a.fax
      ,indirizzo_telematico.get_indirizzo('UO'
                                         ,'F'
                                         ,null
                                         ,null
                                         ,a.progr_unita_organizzativa) mailfax
  from anagrafe_unita_organizzative a
      ,revisioni_modifica           ra --#558
      ,revisioni_modifica           ru
      ,unita_organizzative          u
 where nvl(u.revisione, -2) != ru.revisione_modifica
   and ru.ottica = u.ottica
   and ra.ottica = a.ottica
   and nvl(a.revisione_istituzione, -2) != ra.revisione_modifica
   and u.dal_pubb <= nvl(decode(nvl(a.revisione_cessazione, -2)
                               ,ra.revisione_modifica
                               ,a.al_prec --#547
                               ,a.al_pubb)
                        ,to_date(3333333, 'j'))
   and nvl(decode(nvl(u.revisione_cessazione, -2)
                 ,ru.revisione_modifica
                 ,u.al_prec --#547
                 ,u.al_pubb)
          ,to_date(3333333, 'j')) >= a.dal_pubb
   and u.progr_unita_organizzativa = a.progr_unita_organizzativa
   and u.ottica > ' '
   and a.dal_pubb <= nvl(a.al_pubb, to_date(3333333, 'j')) --#712
   and u.dal_pubb <= nvl(u.al_pubb, to_date(3333333, 'j')) --#712
;



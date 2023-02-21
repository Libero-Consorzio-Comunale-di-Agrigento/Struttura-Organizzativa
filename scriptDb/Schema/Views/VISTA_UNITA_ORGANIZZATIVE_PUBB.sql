CREATE OR REPLACE FORCE VIEW VISTA_UNITA_ORGANIZZATIVE_PUBB
(ID_ELEMENTO, OTTICA, REVISIONE, REVISIONE_CESSAZIONE, SEQUENZA, 
 PROGR_UNITA_ORGANIZZATIVA, DAL, AL, ID_UNITA_PADRE, PROGR_UNITA_PADRE, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, CODICE_UO, CODICE_IPA, DESCRIZIONE, 
 ID_SUDDIVISIONE, SUDDIVISIONE, DESCR_SUDDIVISIONE, REV_IST_ANAG, REV_CESS_ANAG, 
 TIPOLOGIA_UNITA, SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, AMMINISTRAZIONE, AOO, 
 CENTRO, CENTRO_RESPONSABILITA, AGGREGATORE, UTENTE_AD4, UTENTE_AGG_ANAG, 
 DATA_AGG_ANAG, NOTE, TIPO_UNITA, ETICHETTA, TAG_MAIL)
BEQUEATH DEFINER
AS 
select u.id_elemento
      ,u.ottica
      ,u.revisione
      ,u.revisione_cessazione
      ,u.sequenza
      ,u.progr_unita_organizzativa
      ,greatest(u.dal_pubb, a.dal_pubb) dal
      ,decode(least(nvl(u.al_pubb, to_date(3333333, 'j'))
                   ,nvl(a.al_pubb, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(u.al_pubb, to_date(3333333, 'j'))
                   ,nvl(a.al_pubb, to_date(3333333, 'j')))) al
      ,unita_organizzativa.get_id_progr_unita(u.id_unita_padre, u.ottica, u.dal_pubb) id_unita_padre
      ,u.id_unita_padre progr_unita_padre
      ,u.utente_aggiornamento
      ,u.data_aggiornamento
      ,a.codice_uo
      ,a.codice_ipa --#52548
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
      ,aoo_pkg.get_codice_aoo(a.progr_aoo, a.dal_pubb) aoo
      ,a.centro
      ,a.centro_responsabilita
      ,a.aggregatore
      ,a.utente_ad4
      ,a.utente_aggiornamento utente_agg_anag
      ,a.data_aggiornamento data_agg_anag
      ,a.note
      ,a.tipo_unita
      ,a.etichetta
      ,indirizzo_telematico.get_tag_mail('UO','I',null,null,a.progr_unita_organizzativa) tag_mail
  from unita_organizzative          u
      ,revisioni_modifica           ru --#558
      ,revisioni_modifica           ra --#558
      ,anagrafe_unita_organizzative a
 where u.revisione != ru.revisione_modifica
   and a.revisione_istituzione != ra.revisione_modifica
   and ra.ottica = a.ottica
   and ru.ottica = u.ottica
   and u.dal_pubb <= nvl(a.al_pubb, to_date(3333333, 'j'))
   and nvl(u.al_pubb, to_date(3333333, 'j')) >= a.dal_pubb
   and u.progr_unita_organizzativa = a.progr_unita_organizzativa
   and u.dal_pubb <= nvl(u.al_pubb,to_date(3333333,'j'))
   and a.dal_pubb <= nvl(a.al_pubb,to_date(3333333,'j'));



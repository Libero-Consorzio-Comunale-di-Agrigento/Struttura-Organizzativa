CREATE OR REPLACE FORCE VIEW VISTA_ASSEGNAZIONI
(OTTICA, ENTE, ENTE_NI, ENTE_DENOMINAZIONE, NI, 
 NOMINATIVO, CI, DAL, AL, PROGR_UNITA_ORGANIZZATIVA, 
 CODICE_UO, DESCRIZIONE, ID_SUDDIVISIONE, SUDDIVISIONE, DESCR_SUDDIVISIONE, 
 ID_UNITA_PADRE, PROGR_UNITA_PADRE, REV_IST_ANAG, REV_CESS_ANAG, TIPOLOGIA_UNITA, 
 SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, SEQUENZA, CENTRO, CENTRO_RESPONSABILITA, 
 TIPO_UNITA, UTENTE_AD4, STATO, INCARICO, DES_INCARICO, 
 RESPONSABILE, ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, GRADAZIONE, PERCENTUALE_IMPIEGO, 
 TELEFONO, E_MAIL, FAX, REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, 
 ID_COMPONENTE, ID_ATTR_COMPONENTE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, UTENTE_AGG_ATTR, 
 DATA_AGG_ATTR)
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
      ,c.nominativo
      ,c.ci
      ,greatest(u.dal, c.dal) dal
      ,decode(least(nvl(u.al, to_date(3333333, 'j')), nvl(c.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(u.al, to_date(3333333, 'j')), nvl(c.al, to_date(3333333, 'j')))) al
      ,u.progr_unita_organizzativa
      ,u.codice_uo
      ,u.descrizione
      ,u.id_suddivisione
      ,u.suddivisione
      ,u.descr_suddivisione
      ,u.id_unita_padre
      ,u.progr_unita_padre
      ,u.rev_ist_anag
      ,u.rev_cess_anag
      ,u.tipologia_unita
      ,u.se_giuridico
      ,u.assegnazione_componenti
      ,u.sequenza
      ,u.centro
      ,u.centro_responsabilita
      ,u.tipo_unita
      ,u.utente_ad4
      ,c.stato
      ,c.incarico
      ,c.des_incarico
      ,c.responsabile
      ,c.assegnazione_prevalente
      ,nvl(c.tipo_assegnazione, 'I') tipo_assegnazione
      ,c.gradazione
      ,c.percentuale_impiego
      ,c.telefono
      ,c.e_mail
      ,c.fax     
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.id_componente
      ,c.id_attr_componente
      ,c.utente_aggiornamento utente_aggiornamento
      ,c.data_aggiornamento data_aggiornamento
      ,c.utente_agg_attr utente_agg_attr
      ,c.data_agg_attr data_agg_attr
  from vista_unita_organizzative u
      ,vista_componenti          c
 where u.dal <= nvl(c.al, to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= c.dal
   and u.progr_unita_organizzativa = c.progr_unita_organizzativa
   and u.ottica = c.ottica;



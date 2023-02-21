CREATE OR REPLACE FORCE VIEW VISTA_RUOLI
(OTTICA, ENTE, ENTE_NI, ENTE_DENOMINAZIONE, NI, 
 NOMINATIVO, CI, DAL, AL, PROGR_UNITA_ORGANIZZATIVA, 
 CODICE_UO, DESCRIZIONE, ID_SUDDIVISIONE, SUDDIVISIONE, DESCR_SUDDIVISIONE, 
 ID_UNITA_PADRE, PROGR_UNITA_PADRE, REV_IST_ANAG, REV_CESS_ANAG, TIPOLOGIA_UNITA, 
 SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, SEQUENZA, CENTRO, CENTRO_RESPONSABILITA, 
 TIPO_UNITA, UTENTE_AD4, STATO, RUOLO, DES_RUOLO, 
 REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, ID_COMPONENTE, ID_RUOLO_COMPONENTE, COMP_UTENTE_AGG, 
 COMP_DATA_AGG, RUCO_UTENTE_AGG, RUCO_DATA_AGG)
BEQUEATH DEFINER
AS 
select r.ottica
     , u.amministrazione ente
     , amministrazione.get_ni(u.amministrazione) ente_ni
     , substr(soggetti_get_descr(amministrazione.get_ni(u.amministrazione)
                                ,trunc(sysdate)
                                ,'DESCRIZIONE')
              ,1,240) ente_denominazione
     , r.ni
     , r.nominativo
     , r.ci
     , greatest(u.dal, r.dal) dal
     , decode(least(nvl(u.al, to_date(3333333, 'j')), nvl(r.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(u.al, to_date(3333333, 'j')), nvl(r.al, to_date(3333333, 'j')))) al
     , u.progr_unita_organizzativa
     , u.codice_uo
     , u.descrizione
     , u.id_suddivisione
     , u.suddivisione
     , u.descr_suddivisione
     , u.id_unita_padre
     , u.progr_unita_padre
     , u.rev_ist_anag
     , u.rev_cess_anag
     , u.tipologia_unita
     , u.se_giuridico
     , u.assegnazione_componenti
     , u.sequenza
     , u.centro
     , u.centro_responsabilita
     , u.tipo_unita
     , u.utente_ad4
     , r.stato
     , r.ruolo
     , r.des_ruolo
     , r.revisione_assegnazione
     , r.revisione_cessazione
     , r.id_componente
     , r.id_ruolo_componente
     , r.comp_utente_agg
     , r.comp_data_agg
     , r.ruco_utente_agg
     , r.ruco_data_agg
  from vista_unita_organizzative u
     , vista_ruoli_componente r
 where u.dal <= nvl(r.al, to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= r.dal
   and u.progr_unita_organizzativa = r.progr_unita_organizzativa
   and u.ottica = r.ottica;



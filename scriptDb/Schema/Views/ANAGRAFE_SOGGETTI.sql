CREATE OR REPLACE FORCE VIEW ANAGRAFE_SOGGETTI
(NI, DAL, COGNOME, NOME, SESSO, 
 DATA_NAS, PROVINCIA_NAS, COMUNE_NAS, LUOGO_NAS, CODICE_FISCALE, 
 CODICE_FISCALE_ESTERO, PARTITA_IVA, CITTADINANZA, GRUPPO_LING, INDIRIZZO_RES, 
 PROVINCIA_RES, COMUNE_RES, CAP_RES, TEL_RES, FAX_RES, 
 PRESSO, INDIRIZZO_DOM, PROVINCIA_DOM, COMUNE_DOM, CAP_DOM, 
 TEL_DOM, FAX_DOM, UTENTE, DATA_AGG, COMPETENZA, 
 COMPETENZA_ESCLUSIVA, TIPO_SOGGETTO, FLAG_TRG, STATO_CEE, PARTITA_IVA_CEE, 
 FINE_VALIDITA, AL, DENOMINAZIONE, INDIRIZZO_WEB, NOTE, 
 CI, NUM_CI)
BEQUEATH DEFINER
AS 
select ni
      ,dal
      ,cognome
      ,nome
      ,sesso
      ,data_nas
      ,provincia_nas
      ,comune_nas
      ,luogo_nas
      ,codice_fiscale
      ,codice_fiscale_estero
      ,partita_iva
      ,cittadinanza
      ,gruppo_ling
      ,indirizzo_res
      ,provincia_res
      ,comune_res
      ,cap_res
      ,tel_res
      ,fax_res
      ,presso
      ,indirizzo_dom
      ,provincia_dom
      ,comune_dom
      ,cap_dom
      ,tel_dom
      ,fax_dom
      ,utente
      ,data_agg
      ,competenza
      ,competenza_esclusiva
      ,tipo_soggetto
      ,flag_trg
      ,stato_cee
      ,partita_iva_cee
      ,fine_validita
      ,al
      ,denominazione
      ,indirizzo_web
      ,note
      ,so4gp_pkg.get_ci(ni)  ci  --#45269
      ,so4gp_pkg.get_numero_ci(s.ni) num_ci
  from as4_anagrafe_soggetti s
 where al is null;



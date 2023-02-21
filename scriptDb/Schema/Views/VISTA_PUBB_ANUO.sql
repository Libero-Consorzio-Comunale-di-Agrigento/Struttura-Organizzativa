CREATE OR REPLACE FORCE VIEW VISTA_PUBB_ANUO
(PROGR_UNITA_ORGANIZZATIVA, DAL, CODICE_UO, DESCRIZIONE, DESCRIZIONE_AL1, 
 DESCRIZIONE_AL2, DES_ABB, DES_ABB_AL1, DES_ABB_AL2, ID_SUDDIVISIONE, 
 OTTICA, REVISIONE_ISTITUZIONE, REVISIONE_CESSAZIONE, TIPOLOGIA_UNITA, SE_GIURIDICO, 
 ASSEGNAZIONE_COMPONENTI, AMMINISTRAZIONE, PROGR_AOO, INDIRIZZO, CAP, 
 PROVINCIA, COMUNE, TELEFONO, FAX, CENTRO, 
 CENTRO_RESPONSABILITA, AL, UTENTE_AD4, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, 
 NOTE, TIPO_UNITA, INCARICO_RESP)
BEQUEATH DEFINER
AS 
select progr_unita_organizzativa
     , dal_pubb dal
     , codice_uo
     , descrizione
     , descrizione_al1
     , descrizione_al2
     , des_abb
     , des_abb_al1
     , des_abb_al2
     , id_suddivisione
     , a.ottica
     , revisione_istituzione
     , revisione_cessazione
     , tipologia_unita
     , se_giuridico
     , assegnazione_componenti
     , amministrazione
     , progr_aoo
     , indirizzo
     , cap
     , provincia
     , comune
     , telefono
     , fax
     , centro
     , centro_responsabilita
     , al_pubb al
     , utente_ad4
     , utente_aggiornamento
     , data_aggiornamento
     , note
     , tipo_unita
     , incarico_resp
  from revisioni_modifica r
      ,anagrafe_unita_organizzative a
 where r.ottica=a.ottica
   and a.revisione_istituzione <> r.revisione_modifica;



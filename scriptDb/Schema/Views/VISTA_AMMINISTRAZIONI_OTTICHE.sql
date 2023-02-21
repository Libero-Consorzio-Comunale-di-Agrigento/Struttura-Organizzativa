CREATE OR REPLACE FORCE VIEW VISTA_AMMINISTRAZIONI_OTTICHE
(CODICE_AMMINISTRAZIONE, DENOMINAZIONE, NI, DAL, AL, 
 INDIRIZZO_RES, CAP_RES, DEN_COMUNE_RES, SIGLA_RES, SITO_ISTITUZIONALE, 
 INDIRIZZO_ISTITUZIONALE, OTTICA, DESCR_OTTICA, NOTA, OTTICA_ISTITUZIONALE)
BEQUEATH DEFINER
AS 
select codice_amministrazione
     , cognome denominazione
     , as4_anagrafe_soggetti.ni ni
     , as4_anagrafe_soggetti.dal dal
     , as4_anagrafe_soggetti.al al
     , indirizzo_res indirizzo_res
     , cap_res cap_res
     , ad4_comuni.denominazione den_comune_res
     , ad4_provincie.sigla sigla_res
     , as4_anagrafe_soggetti.indirizzo_web sito_istituzionale
     , inte.indirizzo indirizzo_istituzionale
     , otti.ottica
     , otti.descrizione descr_ottica
     , otti.nota
     , otti.ottica_istituzionale
  from as4_anagrafe_soggetti,
       ad4_comuni,
       ad4_provincie,
       amministrazioni ammi,
       ottiche otti,
       indirizzi_telematici inte
where ad4_provincie.provincia (+) = as4_anagrafe_soggetti.provincia_res
  and ad4_comuni.provincia_stato (+) = as4_anagrafe_soggetti.provincia_res
  and ad4_comuni.comune (+)= as4_anagrafe_soggetti.comune_res
  and ammi.ni = as4_anagrafe_soggetti.ni
  and as4_anagrafe_soggetti.al is null
  and ammi.ente = 'SI'
  and ammi.ni = inte.id_amministrazione (+)
  and inte.tipo_entita (+) = 'AM'
  and inte.tipo_indirizzo (+) = 'I'
  and otti.amministrazione = ammi.codice_amministrazione;



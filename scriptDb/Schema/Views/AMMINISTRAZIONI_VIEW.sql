CREATE OR REPLACE FORCE VIEW AMMINISTRAZIONI_VIEW
(DENOMINAZIONE, NI, DAL, AL, CODICE, 
 INDIRIZZO_RES, CAP_RES, DEN_COMUNE_RES, SIGLA_RES, SITO_ISTITUZIONALE, 
 INDIRIZZO_ISTITUZIONALE)
BEQUEATH DEFINER
AS 
select cognome
     , as4_anagrafe_soggetti.ni
     , as4_anagrafe_soggetti.dal
     , as4_anagrafe_soggetti.al
     , codice_amministrazione
     , indirizzo_res
     , cap_res
     , ad4_comuni.denominazione
     , ad4_provincie.sigla
     , as4_anagrafe_soggetti.indirizzo_web
     , inte.indirizzo
  from as4_anagrafe_soggetti,
       ad4_comuni,
       ad4_provincie,
       amministrazioni ammi,
       indirizzi_telematici inte
where ad4_provincie.provincia (+) = as4_anagrafe_soggetti.provincia_res
  and ad4_comuni.provincia_stato (+) = as4_anagrafe_soggetti.provincia_res
  and ad4_comuni.comune (+)= as4_anagrafe_soggetti.comune_res
  and ammi.ni = as4_anagrafe_soggetti.ni
  and as4_anagrafe_soggetti.al is null
  and ammi.ni = inte.id_amministrazione (+)
  and inte.tipo_entita (+) = 'AM' 
  and inte.tipo_indirizzo (+) = 'I';



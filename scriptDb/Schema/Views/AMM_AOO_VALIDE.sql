CREATE OR REPLACE FORCE VIEW AMM_AOO_VALIDE
(DESCRIZIONE_AMM, DESCRIZIONE_AOO, CODICE_AMMINISTRAZIONE, CODICE_AOO, CODICE_IPA, 
 NI, DAL, TIPO, INDIRIZZO_AMM, CAP_AMM, 
 COMUNE_AMM, SIGLA_AMM, MAIL_AMM, INDIRIZZO_AOO, CAP_AOO, 
 COMUNE_AOO, SIGLA_AOO, MAIL_AOO)
BEQUEATH DEFINER
AS 
select as4_anagrafe_soggetti.denominazione descrizione_amm
      ,null descrizione_aoo
      ,ammi.codice_amministrazione codice_amministrazione
      ,null codice_aoo
      ,null codice_ipa  --#52548
      ,ammi.ni ni
      ,as4_anagrafe_soggetti.dal dal
      ,'AMM' tipo
      ,as4_anagrafe_soggetti.indirizzo_res indirizzo_amm
      ,as4_anagrafe_soggetti.cap_res cap_amm
      ,ad4_comuni.denominazione comune_amm
      ,ad4_provincie.sigla sigla_amm
      ,inte.indirizzo mail_amm
      ,null indirizzo_aoo
      ,null cap_aoo
      ,null comune_aoo
      ,null sigla_aoo
      ,null mail_aoo
  from amministrazioni       ammi
      ,as4_anagrafe_soggetti
      ,ad4_comuni
      ,ad4_provincie
      ,indirizzi_telematici  inte
 where ammi.ni = as4_anagrafe_soggetti.ni
   and as4_anagrafe_soggetti.al is null
   and as4_anagrafe_soggetti.comune_res = ad4_comuni.comune(+)
   and as4_anagrafe_soggetti.provincia_res = ad4_comuni.provincia_stato(+)
   and ad4_comuni.provincia_stato = ad4_provincie.provincia(+)
   and ammi.ni = inte.id_amministrazione(+)
   and inte.tipo_entita(+) = 'AM'
   and inte.tipo_indirizzo(+) = 'I'
   and not exists
 (select 1
          from aoo
         where aoo.al is null
           and aoo.codice_amministrazione = ammi.codice_amministrazione)
union
select as4_anagrafe_soggetti.denominazione descrizione_amm
      ,aoo.descrizione descrizione_aoo
      ,aoo.codice_amministrazione codice_amministrazione
      ,aoo.codice_aoo codice_aoo
      ,aoo.codice_ipa --#52548
      ,aoo.progr_aoo ni
      ,aoo.dal dal
      ,'AOO' tipo
      ,as4_anagrafe_soggetti.indirizzo_res indirizzo_amm
      ,as4_anagrafe_soggetti.cap_res cap_amm
      ,comuni_amm.denominazione comune_amm
      ,prov_amm.sigla sigla_amm
      ,null mail_amm
      ,aoo.indirizzo indirizzo_aoo
      ,aoo.cap cap_aoo
      ,comuni_aoo.denominazione comune_aoo
      ,prov_aoo.sigla sigla_aoo
      ,inte.indirizzo mail_aoo
  from aoo
      ,amministrazioni       ammi
      ,as4_anagrafe_soggetti
      ,ad4_comuni            comuni_amm
      ,ad4_provincie         prov_amm
      ,ad4_comuni            comuni_aoo
      ,ad4_provincie         prov_aoo
      ,indirizzi_telematici  inte
 where aoo.al is null
   and aoo.codice_amministrazione = ammi.codice_amministrazione
   and ammi.ni = as4_anagrafe_soggetti.ni
   and as4_anagrafe_soggetti.al is null
   and as4_anagrafe_soggetti.comune_res = comuni_amm.comune(+)
   and as4_anagrafe_soggetti.provincia_res = comuni_amm.provincia_stato(+)
   and comuni_amm.provincia_stato = prov_amm.provincia(+)
   and aoo.comune = comuni_aoo.comune(+)
   and aoo.provincia = comuni_aoo.provincia_stato(+)
   and comuni_aoo.provincia_stato = prov_aoo.provincia(+)
   and aoo.progr_aoo = inte.id_aoo(+)
   and inte.tipo_entita(+) = 'AO'
   and inte.tipo_indirizzo(+) = 'I';



CREATE OR REPLACE FORCE VIEW SO_AMM_ESTERNE
(CODICE_AMMINISTRAZIONE, DESCRIZIONE_AMM, INDIRIZZO_AMM, CAP_AMM, COMUNE_AMM, 
 SIGLA_AMM, MAIL_AMM)
BEQUEATH DEFINER
AS 
select ammi.codice_amministrazione
     , anso.denominazione descrizione_amm
     , anso.indirizzo_res indirizzo_amm
     , anso.cap_res cap_amm
     , ad4_comuni.denominazione comune_amm
     , ad4_provincie.sigla sigla_amm
     , inte_amm.indirizzo mail_amm
  from amministrazioni ammi
     , as4_anagrafe_soggetti anso
     , ad4_comuni
     , ad4_provincie
     , indirizzi_telematici inte_amm
 where ammi.ni = anso.ni
   and nvl(ammi.ente,'NO') = 'NO'
   and anso.dal = (select max(x.dal) from as4_anagrafe_soggetti x
                    where x.ni = ammi.ni)
   and anso.comune_res = ad4_comuni.comune(+)
   and anso.provincia_res = ad4_comuni.provincia_stato(+)
   and anso.provincia_res = ad4_provincie.provincia(+)
   and inte_amm.tipo_entita(+) = 'AM'
   and inte_amm.tipo_indirizzo(+) = 'I'
   and ammi.ni = inte_amm.id_amministrazione(+);



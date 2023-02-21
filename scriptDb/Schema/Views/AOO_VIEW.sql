CREATE OR REPLACE FORCE VIEW AOO_VIEW
(DENOMINAZIONE, NI, DAL, AL, CODICE_AMMINISTRAZIONE, 
 CODICE_AOO, CODICE_IPA, INDIRIZZO_RES, CAP_RES, DEN_COMUNE_RES, 
 SIGLA_RES, SITO_ISTITUZIONALE, INDIRIZZO_ISTITUZIONALE, DEN_AMMINISTRAZIONE, DAL_AMMINISTRAZIONE, 
 AL_AMMINISTRAZIONE, INDIRIZZO_RES_AMMINISTRAZIONE, CAP_AMMINISTRAZIONE, DEN_COMUNE_AMMINISTRAZIONE, SIGLA_AMMINISTRAZIONE, 
 INDIRIZZO_IST_AMMINISTRAZIONE, FAX_ISTITUZIONALE, MAILFAX_ISTITUZIONALE)
BEQUEATH DEFINER
AS 
select aoo.DESCRIZIONE denominazione
     , aoo.PROGR_AOO ni
     , aoo.dal dal
     , aoo.al al
     , aoo.codice_amministrazione codice_amministrazione
     , aoo.codice_aoo codice_aoo
     , aoo.codice_ipa codice_ipa --#52548
     , aoo.INDIRIZZO indirizzo_res
     , aoo.CAP cap_res
     , ad4_comuni.denominazione den_comune_res
     , ad4_provincie.sigla sigla_res
     , null sito_istituzionale
     , inte.INDIRIZZO indirizzo_istituzionale
     , ammi.denominazione den_amministrazione
     , ammi.DAL dal_amministrazione
     , ammi.AL al_amministrazione
     , ammi.INDIRIZZO_RES indirizzo_res_amministrazione
     , ammi.CAP_RES cap_amministrazione
     , ammi.DEN_COMUNE_RES den_comune_amministrazione
     , ammi.SIGLA_RES sigla_amministrazione
     , ammi.INDIRIZZO_ISTITUZIONALE indirizzo_ist_amministrazione
     , aoo.fax fax_istituzionale
     , fax.indirizzo mailfax_istituzionale
  FROM ad4_comuni,
       ad4_provincie,
       amministrazioni_view ammi,
       aoo,
       indirizzi_telematici inte,
       indirizzi_telematici fax
 WHERE ad4_provincie.provincia(+) = aoo.provincia
   AND ad4_comuni.provincia_stato(+) = aoo.provincia
   AND ad4_comuni.comune(+) = aoo.comune
   AND aoo.codice_amministrazione = ammi.codice
   AND inte.id_aoo(+) = aoo.progr_aoo
   AND inte.tipo_entita(+) = 'AO'
   AND inte.tipo_indirizzo(+) = 'I'
   AND fax.id_aoo(+) = aoo.progr_aoo
   AND fax.tipo_entita(+) = 'AO'
   AND fax.tipo_indirizzo(+) = 'F';



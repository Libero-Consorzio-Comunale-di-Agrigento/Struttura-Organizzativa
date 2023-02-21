CREATE OR REPLACE FORCE VIEW SO_UNITA_ORG_ESTERNE
(PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, DESCRIZIONE_UO, INDIRIZZO_UO, CAP_UO, 
 COMUNE_UO, SIGLA_UO, MAIL_UO, TELEFONO, FAX, 
 AL, SE_FATTURA_ELETTRONICA, CODICE_AMM)
BEQUEATH DEFINER
AS 
select auor.progr_unita_organizzativa
     , auor.codice_uo codice_uo
     , auor.descrizione descrizione_uo
     , auor.indirizzo indirizzo_uo
     , auor.cap cap_uo
     , auor.comune comune_uo
     , prov_uo.sigla sigla_uo
     , inte_uo.indirizzo mail_uo
     , auor.telefono
     , auor.fax
     , auor.al
     , auor.se_fattura_elettronica
     , amministrazione codice_amm
  from amministrazioni ammi
     , anagrafe_unita_organizzative auor
     , ad4_comuni comuni_uo
     , ad4_provincie prov_uo
     , indirizzi_telematici inte_uo
 where ammi.codice_amministrazione = auor.amministrazione
   and nvl(ammi.ente,'NO') = 'NO' 
   and auor.dal = (select max(x.dal) from anagrafe_unita_organizzative x
                    where x.progr_unita_organizzativa = auor.progr_unita_organizzativa)
   and auor.comune = comuni_uo.comune(+)
   and auor.provincia = comuni_uo.provincia_stato(+)
   and auor.provincia = prov_uo.provincia(+)
   and auor.progr_unita_organizzativa = inte_uo.id_unita_organizzativa(+)
   and inte_uo.tipo_entita(+) = 'UO'
   and inte_uo.tipo_indirizzo(+) = 'I';



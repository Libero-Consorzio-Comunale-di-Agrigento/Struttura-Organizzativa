CREATE OR REPLACE FORCE VIEW VISTA_INDIRIZZI_TELEMATICI
(CODICE_AMMINISTRAZIONE, CODICE_AOO, DESCRIZIONE_AMMINISTRAZIONE, DESCRIZIONE_AOO, CODICE_UO, 
 DESCRIZIONE_UO, PROVENIENZA, TIPO_INDIRIZZO, DES_TIPO_INDIRIZZO, INDIRIZZO, 
 REGIONE, PROVINCIA, COMUNE, SIGLA_PROVINCIA, SIGLA_COMUNE)
BEQUEATH DEFINER
AS 
select amm.codice_amministrazione codice_amministrazione
      ,'' codice_aoo
      ,ana.denominazione descrizione_amministrazione
      ,'' descrizione_aoo
      ,'' codice_uo
      ,'' descrizione_uo
      ,ind.tipo_entita provenienza
      ,ind.tipo_indirizzo
      ,decode(ind.tipo_indirizzo
             ,'I'
             ,'Indirizzo Istituzionale'
             ,'R'
             ,'Risposta automatica'
             ,'M'
             ,'Protocollo manuale'
             ,'G'
             ,'Generico'
             ,'C'
             ,'Contatto'
             ,'P'
             ,'Contatto PEC'
             ,'Altro') des_tipo_indirizzo
      ,ind.indirizzo
      ,reg.denominazione regione
      ,pro.denominazione provincia
      ,com.denominazione comune
      ,pro.sigla sigla_provincia
      ,com.sigla_cfis sigla_comune
  from indirizzi_telematici ind
      ,anagrafe_soggetti    ana
      ,ad4_regioni          reg
      ,ad4_province         pro
      ,ad4_comuni           com
      ,amministrazioni      amm
 where ind.id_amministrazione = amm.ni
   and ana.ni = amm.ni
   and com.provincia_stato(+) = ana.provincia_res
   and com.comune(+) = ana.comune_res
   and pro.provincia(+) = ana.provincia_res
   and reg.regione(+) = pro.regione
union all
-- indirizzi AOO
select amm.codice_amministrazione codice_amministrazione
      ,aoo.codice_aoo codice_aoo
      ,ana.denominazione descrizione_amministrazione
      ,aoo.descrizione descrizione_aoo
      ,'' codice_uo
      ,'' descrizione_uo
      ,ind.tipo_entita provenienza
      ,ind.tipo_indirizzo
      ,decode(ind.tipo_indirizzo
             ,'I'
             ,'Indirizzo Istituzionale'
             ,'R'
             ,'Risposta automatica'
             ,'M'
             ,'Protocollo manuale'
             ,'G'
             ,'Generico'
             ,'C'
             ,'Contatto'
             ,'P'
             ,'Contatto PEC'
             ,'Altro') des_tipo_indirizzo
      ,ind.indirizzo
      ,reg.denominazione regione
      ,pro.denominazione provincia
      ,com.denominazione comune
      ,pro.sigla sigla_provincia
      ,com.sigla_cfis sigla_comune
  from indirizzi_telematici ind
      ,anagrafe_soggetti    ana
      ,ad4_regioni          reg
      ,ad4_province         pro
      ,ad4_comuni           com
      ,amministrazioni      amm
      ,aoo
 where ind.id_aoo = aoo.progr_aoo
   and amm.codice_amministrazione = aoo.codice_amministrazione
   and trunc(sysdate) between aoo.dal and nvl(aoo.al, to_date(3333333, 'j'))
   and ana.ni = amm.ni
   and com.provincia_stato(+) = ana.provincia_res
   and com.comune(+) = ana.comune_res
   and pro.provincia(+) = ana.provincia_res
   and reg.regione(+) = pro.regione
union all
-- indirizzi UO non collegate ad una AOO
select amm.codice_amministrazione codice_amministrazione
      ,'' codice_aoo
      ,ana.denominazione descrizione_amministrazione
      ,'' descrizione_aoo
      ,auo.codice_uo codice_uo
      ,auo.descrizione descrizione_uo
      ,ind.tipo_entita provenienza
      ,ind.tipo_indirizzo
      ,decode(ind.tipo_indirizzo
             ,'I'
             ,'Indirizzo Istituzionale'
             ,'R'
             ,'Risposta automatica'
             ,'M'
             ,'Protocollo manuale'
             ,'G'
             ,'Generico'
             ,'C'
             ,'Contatto'
             ,'P'
             ,'Contatto PEC'
             ,'Altro') des_tipo_indirizzo
      ,ind.indirizzo
      ,reg.denominazione regione
      ,pro.denominazione provincia
      ,com.denominazione comune
      ,pro.sigla sigla_provincia
      ,com.sigla_cfis sigla_comune
  from indirizzi_telematici         ind
      ,anagrafe_soggetti            ana
      ,ad4_regioni                  reg
      ,ad4_province                 pro
      ,ad4_comuni                   com
      ,amministrazioni              amm
      ,anagrafe_unita_organizzative auo
 where ind.id_unita_organizzativa = auo.progr_unita_organizzativa
   and trunc(sysdate) between auo.dal and nvl(auo.al, to_date(3333333, 'j'))
   and ana.ni = amm.ni
   and com.provincia_stato(+) = ana.provincia_res
   and com.comune(+) = ana.comune_res
   and pro.provincia(+) = ana.provincia_res
   and reg.regione(+) = pro.regione
   and auo.progr_aoo is null
   and auo.amministrazione = amm.codice_amministrazione
union
-- indirizzi UO collegate ad una AOO
select amm.codice_amministrazione codice_amministrazione
      ,aoo.codice_aoo codice_aoo
      ,ana.denominazione descrizione_amministrazione
      ,aoo.descrizione descrizione_aoo
      ,auo.codice_uo codice_uo
      ,auo.descrizione descrizione_uo
      ,ind.tipo_entita provenienza
      ,ind.tipo_indirizzo
      ,decode(ind.tipo_indirizzo
             ,'I'
             ,'Indirizzo Istituzionale'
             ,'R'
             ,'Risposta automatica'
             ,'M'
             ,'Protocollo manuale'
             ,'G'
             ,'Generico'
             ,'C'
             ,'Contatto'
             ,'P'
             ,'Contatto PEC'
             ,'Altro') des_tipo_indirizzo
      ,ind.indirizzo
      ,reg.denominazione regione
      ,pro.denominazione provincia
      ,com.denominazione comune
      ,pro.sigla sigla_provincia
      ,com.sigla_cfis sigla_comune
  from indirizzi_telematici         ind
      ,anagrafe_soggetti            ana
      ,ad4_regioni                  reg
      ,ad4_province                 pro
      ,ad4_comuni                   com
      ,amministrazioni              amm
      ,aoo
      ,anagrafe_unita_organizzative auo
 where ind.id_unita_organizzativa = auo.progr_unita_organizzativa
   and amm.codice_amministrazione = aoo.codice_amministrazione
   and trunc(sysdate) between aoo.dal and nvl(aoo.al, to_date(3333333, 'j'))
   and trunc(sysdate) between auo.dal and nvl(auo.al, to_date(3333333, 'j'))
   and ana.ni = amm.ni
   and com.provincia_stato(+) = ana.provincia_res
   and com.comune(+) = ana.comune_res
   and pro.provincia(+) = ana.provincia_res
   and reg.regione(+) = pro.regione
   and auo.progr_aoo = aoo.progr_aoo
   and auo.amministrazione = amm.codice_amministrazione;



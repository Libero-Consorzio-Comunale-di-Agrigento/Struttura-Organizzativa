CREATE OR REPLACE FORCE VIEW SO_ANA_UNITA_FISICHE
(PROGR_UNITA_FISICA, CODICE_UF, DENOMINAZIONE, INDIRIZZO, CAP, 
 PROVINCIA, COMUNE, DENOMINAZIONE_COMUNE, SIGLA_PROVINCIA, AMMINISTRAZIONE, 
 DENOMINAZIONE_COMPLETA_1, DENOMINAZIONE_COMPLETA_2)
BEQUEATH DEFINER
AS 
select progr_unita_fisica
     , codice_uf
     , denominazione
     , indirizzo
     , cap
     , provincia
     , comune
     , ad4_comune.get_denominazione(provincia,comune) denominazione_comune
     , ad4_provincia.get_sigla(provincia) sigla_provincia
     , amministrazione
     , nvl(so4_util_fis.get_stringa_ascendenti(progr_unita_fisica,trunc(sysdate),amministrazione,1),denominazione) denominazione_completa_1
     , nvl(so4_util_fis.get_stringa_ascendenti(progr_unita_fisica,trunc(sysdate),amministrazione,2),denominazione) denominazione_completa_2
  from anagrafe_unita_fisiche a
 where a.dal = (select max(b.dal) 
                  from anagrafe_unita_fisiche b
                 where b.progr_unita_fisica = a.progr_unita_fisica);



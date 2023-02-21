CREATE OR REPLACE FORCE VIEW ANAGRAFICA_COMPONENTI
(NI, COGNOME, NOME, CODICE_FISCALE, DATA_NASCITA, 
 LUOGO_NASCITA)
BEQUEATH DEFINER
AS 
select distinct a.ni
      ,a.cognome
      ,a.nome
      ,a.codice_fiscale
      ,a.data_nas data_nascita
      ,ad4_comune.get_denominazione(provincia_nas, comune_nas) luogo_nascita
  from anagrafe_soggetti a
      ,componenti        c
 where a.al is null
   and c.ni = a.ni;



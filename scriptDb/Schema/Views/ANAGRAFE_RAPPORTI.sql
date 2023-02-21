CREATE OR REPLACE FORCE VIEW ANAGRAFE_RAPPORTI
(NI, COGNOME, NOME, CODICE_FISCALE, CI, 
 RAPPORTO, DAL, AL)
BEQUEATH DEFINER
AS 
select a.ni
      ,a.cognome
      ,a.nome
      ,a.codice_fiscale
      ,r.ci
      ,r.rapporto
      ,r.dal
      ,r.al
  from as4_anagrafe_soggetti        a
      ,p00_dipendenti_soggetti  d
      ,p00_rapporti_individuali r
 where a.ni = d.ni_as4
   and r.ni = d.ni_gp4
   and p00_classi_rapporto_tpk.get_componente(r.rapporto) = 'SI'
   and a.al is null
 order by a.ni
         ,r.ci;



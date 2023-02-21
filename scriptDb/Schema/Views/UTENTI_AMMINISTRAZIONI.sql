CREATE OR REPLACE FORCE VIEW UTENTI_AMMINISTRAZIONI
(UTENTE, NOMINATIVO, NI, CODICE_AMMINISTRAZIONE, DESCR_AMMINISTRAZIONE)
BEQUEATH DEFINER
AS 
select distinct uten.utente
               ,uten.nominativo
               ,utso.soggetto ni_soggetto
               ,ammi.codice_amministrazione
               ,(select denominazione from anagrafe_soggetti where ni = ammi.ni) denominazione
  from amministrazioni              ammi
      ,anagrafe_unita_organizzative anuo
      ,ad4_utenti                   uten
      ,componenti                   comp
      ,ad4_utenti_soggetti          utso
 where uten.utente = utso.utente
   and comp.ni = utso.soggetto
   and sysdate between comp.dal and nvl(comp.al, to_date(3333333, 'j'))
   and anuo.progr_unita_organizzativa = comp.progr_unita_organizzativa
   and ammi.codice_amministrazione = anuo.amministrazione
   and ammi.ente = 'SI';



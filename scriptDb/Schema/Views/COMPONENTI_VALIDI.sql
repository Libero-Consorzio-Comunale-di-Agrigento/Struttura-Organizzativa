CREATE OR REPLACE FORCE VIEW COMPONENTI_VALIDI
(OTTICA, ENTE, ENTE_NI, ENTE_DENOMINAZIONE, NI, 
 CI, COGNOME, NOME, DAL, AL, 
 PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, DESCR_UO, INCARICO, DESCR_INCARICO, 
 ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, GRADAZIONE, CODICE_UF, DESCR_UF, 
 ID_COMPONENTE, UTENTE_AGG, DATA_AGG)
BEQUEATH DEFINER
AS 
select c.ottica
     , substr(ottica.get_amministrazione (c.ottica),1,16) ente
     , amministrazione.get_ni(ottica.get_amministrazione (c.ottica)) ente_ni
     , substr(soggetti_get_descr(amministrazione.get_ni(ottica.get_amministrazione (c.ottica)), trunc(sysdate), 'DESCRIZIONE'),1,240) ente_denominazione
     , c.ni
     , c.ci
     , substr(soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME'),1,240) cognome
     , substr(soggetti_get_descr(c.ni, trunc(sysdate), 'NOME'),1,40) nome
     , greatest(u.dal, c.dal) dal
     , decode(least(nvl(u.al, to_date(3333333, 'j')), nvl(c.al, to_date(3333333, 'j'))), to_date(3333333,'j'),to_date(null),
              least(nvl(u.al, to_date(3333333, 'j')), nvl(c.al, to_date(3333333, 'j')))) al
     , c.progr_unita_organizzativa
     , u.codice_uo
     , u.descrizione descr_uo
     , c.incarico
     , tipo_incarico.get_descrizione(c.incarico) descr_incarico
     , c.assegnazione_prevalente
     , nvl(c.tipo_assegnazione,'I') tipo_assegnazione
     , c.gradazione
     , substr(anagrafe_unita_fisica.get_codice_uf(ubicazione_componente.get_ubicazione_corrente(c.id_componente,trunc(sysdate)), trunc(sysdate)),1,8) codice_uf
     , substr(anagrafe_unita_fisica.get_denominazione(ubicazione_componente.get_ubicazione_corrente(c.id_componente,trunc(sysdate)), trunc(sysdate)),1,60) descr_uf
     , c.id_componente
     , c.utente_agg_attr utente_agg
     , c.data_agg_attr data_agg
  from vista_unita_organizzative u
      ,vista_componenti          c
 where u.dal <= nvl(c.al, to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= c.dal
   and trunc(sysdate) between u.dal and nvl(u.al,to_date(3333333,'j'))
   and trunc(sysdate) between c.dal and nvl(c.al,to_date(3333333,'j'))
   and u.progr_unita_organizzativa = c.progr_unita_organizzativa
   and u.ottica = c.ottica;



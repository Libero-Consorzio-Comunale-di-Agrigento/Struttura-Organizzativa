CREATE OR REPLACE FORCE VIEW STORICO_COMPONENTI
(OTTICA, ENTE, ENTE_NI, ENTE_DENOMINAZIONE, NI, 
 CI, DAL, AL, PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, 
 DESCR_UO, INCARICO, DESCR_INCARICO, ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, 
 GRADAZIONE, UTENTE_AGG, DATA_AGG)
BEQUEATH DEFINER
AS 
select u.ottica
     , substr(ottica.get_amministrazione (c.ottica),1,16) ente
     , amministrazione.get_ni(ottica.get_amministrazione (c.ottica)) ente_ni
     , substr(soggetti_get_descr(amministrazione.get_ni(ottica.get_amministrazione (c.ottica)), trunc(sysdate), 'DESCRIZIONE'),1,240) ente_denominazione
     , c.ni
     , c.ci
     , greatest(u.dal, c.dal) dal
     , decode(least(nvl(u.al, to_date(3333333, 'j')), nvl(c.al, to_date(3333333, 'j'))), to_date(3333333,'j'),to_date(null),
              least(nvl(u.al, to_date(3333333, 'j')), nvl(c.al, to_date(3333333, 'j')))) al
     , u.progr_unita_organizzativa
     , u.codice_uo
     , u.descrizione descr_uo
     , c.incarico
     , tipo_incarico.get_descrizione(c.incarico) descr_incarico
     , c.assegnazione_prevalente
     , nvl(c.tipo_assegnazione,'I') tipo_assegnazione
     , c.gradazione
     , c.utente_agg_attr utente_agg
     , c.data_agg_attr data_agg
  from vista_unita_organizzative u
      ,vista_componenti          c
 where u.dal <= nvl(c.al, to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= c.dal
   and u.progr_unita_organizzativa = c.progr_unita_organizzativa
   and u.ottica = c.ottica;



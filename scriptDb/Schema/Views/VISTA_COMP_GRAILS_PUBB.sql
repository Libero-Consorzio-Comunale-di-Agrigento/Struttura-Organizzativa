CREATE OR REPLACE FORCE VIEW VISTA_COMP_GRAILS_PUBB
(ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, NI, 
 NOMINATIVO, CI, STATO, OTTICA, REVISIONE_ASSEGNAZIONE, 
 REVISIONE_CESSAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO)
BEQUEATH DEFINER
AS 
select c.id_componente
      ,c.progr_unita_organizzativa
      ,c.dal_pubb dal
      ,c.al_pubb al
      ,c.ni
      ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME E NOME') nominativo
      ,c.ci
      ,c.stato
      ,c.ottica
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.utente_aggiornamento
      ,c.data_aggiornamento
  from revisioni_modifica r --#558
      ,componenti         c
 where nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and r.ottica           = c.ottica;



CREATE OR REPLACE FORCE VIEW VISTA_COMP_GRAILS
(ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, NI, 
 NOMINATIVO, CI, STATO, OTTICA, REVISIONE_ASSEGNAZIONE, 
 REVISIONE_CESSAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO)
BEQUEATH DEFINER
AS 
select c.id_componente
      ,c.progr_unita_organizzativa
      ,c.dal
      ,decode(nvl(c.revisione_cessazione, -2)
             ,r.revisione_modifica
             ,c.al_prec
             ,c.al) al
      ,c.ni
      ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME E NOME') nominativo
      ,c.ci
      ,c.stato
      ,c.ottica
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.utente_aggiornamento
      ,c.data_aggiornamento
  from componenti         c
      ,revisioni_modifica r --#558
 where nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and c.dal <= nvl(c.al, to_date(3333333, 'j'))
   and r.ottica = c.ottica;



CREATE OR REPLACE FORCE VIEW VISTA_UBIC_COMPONENTI
(ID_ASFI, ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, 
 NI, CI, STATO, OTTICA, REVISIONE_ASSEGNAZIONE, 
 REVISIONE_CESSAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ID_UBICAZIONE_COMPONENTE, ID_UBICAZIONE_UNITA, 
 UTENTE_AGG_UBIC, DATA_AGG_UBIC)
BEQUEATH DEFINER
AS 
select a.id_asfi
      ,c.id_componente
      ,c.progr_unita_organizzativa
      ,greatest(c.dal, u.dal) dal
      ,decode(least(nvl(decode(nvl(c.revisione_cessazione, -2)
                              ,r.revisione_modifica
                              ,c.al_prec
                              ,c.al) --#547
                       ,to_date(3333333, 'j'))
                   ,nvl(u.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(decode(nvl(c.revisione_cessazione, -2)
                              ,r.revisione_modifica
                              ,c.al_prec
                              ,c.al) --#547
                       ,to_date(3333333, 'j'))
                   ,nvl(u.al, to_date(3333333, 'j')))) al
      ,c.ni
      ,c.ci
      ,c.stato
      ,c.ottica
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.utente_aggiornamento
      ,c.data_aggiornamento
      ,u.id_ubicazione_componente
      ,u.id_ubicazione_unita
      ,u.utente_aggiornamento utente_agg_ubic
      ,u.data_aggiornamento data_agg_ubic
  from componenti            c
      ,revisioni_modifica    r --#558
      ,assegnazioni_fisiche  a
      ,ubicazioni_componente u
 where nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and r.ottica = c.ottica
   and u.dal <= nvl(decode(c.revisione_cessazione
                          ,r.revisione_modifica
                          ,c.al_prec
                          ,c.al) --#547
                   ,to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= c.dal
   and c.id_componente = u.id_componente
   and a.id_ubicazione_componente = u.id_ubicazione_componente
union
select to_number(null) id_asfi
      ,c.id_componente
      ,c.progr_unita_organizzativa
      ,c.dal dal
      ,decode(nvl(c.revisione_cessazione, -2)
             ,r.revisione_modifica
             ,c.al_prec
             ,c.al) --#547
      ,c.ni
      ,c.ci
      ,c.stato
      ,c.ottica
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.utente_aggiornamento
      ,c.data_aggiornamento
      ,to_number(null)
      ,to_number(null)
      ,c.utente_aggiornamento utente_agg_ubic
      ,c.data_aggiornamento data_agg_ubic
  from componenti c
      ,revisioni_modifica r
      ,ottiche    o
 where c.ottica = o.ottica
   and r.ottica = c.ottica
   and o.ottica_istituzionale = 'SI'
   and nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and not exists
 (select 'x' from ubicazioni_componente where id_componente = c.id_componente);



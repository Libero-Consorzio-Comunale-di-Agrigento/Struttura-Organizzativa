CREATE OR REPLACE FORCE VIEW VISTA_RUOLI_COMPONENTE
(ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, NI, 
 NOMINATIVO, CI, STATO, OTTICA, REVISIONE_ASSEGNAZIONE, 
 REVISIONE_CESSAZIONE, COMP_UTENTE_AGG, COMP_DATA_AGG, ID_RUOLO_COMPONENTE, RUOLO, 
 DES_RUOLO, PROFILO, RELAZIONE, RUCO_UTENTE_AGG, RUCO_DATA_AGG)
BEQUEATH DEFINER
AS 
select c.id_componente
      ,c.progr_unita_organizzativa
      ,greatest(c.dal, r.dal) dal
      ,decode(least(nvl(decode(nvl(c.revisione_cessazione, -2)
                              ,rm.revisione_modifica
                              ,c.al_prec
                              ,c.al)
                       ,to_date(3333333, 'j'))
                   ,nvl(r.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(decode(nvl(c.revisione_cessazione, -2)
                              ,rm.revisione_modifica
                              ,c.al_prec
                              ,c.al)
                       ,to_date(3333333, 'j'))
                   ,nvl(r.al, to_date(3333333, 'j')))) al
      ,c.ni
      ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME E NOME') nominativo
      ,c.ci
      ,c.stato
      ,c.ottica
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.utente_aggiornamento comp_utente_agg
      ,c.data_aggiornamento comp_data_agg
      ,r.id_ruolo_componente
      ,r.ruolo
      ,ad4_ruoli_tpk.get_descrizione(r.ruolo) des_ruolo
      ,ruolo_componente.get_id_profilo_origine(r.id_ruolo_componente) profilo
      ,ruolo_componente.get_id_relazione_origine(r.id_ruolo_componente) relazione
      ,r.utente_aggiornamento ruco_utente_agg
      ,r.data_aggiornamento ruco_data_agg
  from componenti         c
      ,revisioni_modifica rm
      ,ruoli_componente   r
 where nvl(c.revisione_assegnazione, -2) != rm.revisione_modifica
   and rm.ottica = c.ottica
   and r.dal <=
       nvl(decode(nvl(c.revisione_cessazione, -2), rm.revisione_modifica, c.al_prec, c.al)
          ,to_date(3333333, 'j'))
   and nvl(r.al, to_date(3333333, 'j')) >= c.dal
   and c.id_componente = r.id_componente
   and c.dal <= nvl(c.al, to_date(3333333, 'j'))
   and r.dal <= nvl(r.al, to_date(3333333, 'j'));



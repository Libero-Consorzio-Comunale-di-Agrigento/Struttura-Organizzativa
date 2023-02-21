CREATE OR REPLACE FORCE VIEW VISTA_COMPONENTI
(ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, NI, 
 NOMINATIVO, CI, STATO, OTTICA, REVISIONE_ASSEGNAZIONE, 
 REVISIONE_CESSAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ID_ATTR_COMPONENTE, INCARICO, 
 DES_INCARICO, RESPONSABILE, ORDINAMENTO, TELEFONO, E_MAIL, 
 FAX, ASSEGNAZIONE_PREVALENTE, PERCENTUALE_IMPIEGO, REV_ASSE_ATTR, REV_CESS_ATTR, 
 UTENTE_AGG_ATTR, DATA_AGG_ATTR, GRADAZIONE, TIPO_ASSEGNAZIONE)
BEQUEATH DEFINER
AS 
select c.id_componente
      ,c.progr_unita_organizzativa
      ,greatest(c.dal, a.dal) dal
      ,decode(least(nvl(decode(nvl(c.revisione_cessazione, -2)
                              ,r.revisione_modifica
                              ,c.al_prec --to_date(null) #547
                              ,c.al)
                       ,to_date(3333333, 'j'))
                   ,nvl(decode(nvl(a.revisione_cessazione, -2)
                              ,r.revisione_modifica
                              ,a.al_prec --to_date(null) #547
                              ,a.al)
                       ,to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(decode(nvl(c.revisione_cessazione, -2)
                              ,r.revisione_modifica
                              ,c.al_prec --to_date(null) #547
                              ,c.al)
                       ,to_date(3333333, 'j'))
                   ,nvl(decode(nvl(a.revisione_cessazione, -2)
                              ,r.revisione_modifica
                              ,a.al_prec --to_date(null) #547
                              ,a.al)
                       ,to_date(3333333, 'j')))) al
      ,c.ni
      ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME E NOME') nominativo
      ,c.ci
      ,c.stato
      ,c.ottica
      ,c.revisione_assegnazione
      ,c.revisione_cessazione
      ,c.utente_aggiornamento
      ,c.data_aggiornamento
      ,a.id_attr_componente
      ,a.incarico
      ,tipo_incarico.get_descrizione(a.incarico) des_incarico
      ,tipo_incarico.get_responsabile(a.incarico) responsabile
      ,tipo_incarico.get_ordinamento(a.incarico) ordinamento
      ,a.telefono
      ,a.e_mail
      ,a.fax
      ,a.assegnazione_prevalente
      ,a.percentuale_impiego
      ,a.revisione_assegnazione rev_asse_attr
      ,a.revisione_cessazione rev_cess_attr
      ,a.utente_aggiornamento utente_agg_attr
      ,a.data_aggiornamento data_agg_attr
      ,a.gradazione
      ,a.tipo_assegnazione
  from componenti           c
      ,revisioni_modifica   r --#558
      ,attributi_componente a
 where nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and nvl(a.revisione_assegnazione, -2) != r.revisione_modifica
   and a.dal <= nvl(decode(nvl(c.revisione_cessazione,-2)
                          ,r.revisione_modifica
                          ,c.al_prec --to_date(null) #547
                          ,c.al)
                   ,to_date(3333333, 'j'))
   and nvl(decode(nvl(a.revisione_cessazione,-2)
                 ,r.revisione_modifica
                 ,a.al_prec --to_date(null) #547
                 ,a.al)
          ,to_date(3333333, 'j')) >= c.dal
   and c.id_componente = a.id_componente
   and r.ottica = c.ottica
   and c.dal <= nvl(c.al, to_date(3333333, 'j'))
   and a.dal <= nvl(a.al, to_date(3333333, 'j'));



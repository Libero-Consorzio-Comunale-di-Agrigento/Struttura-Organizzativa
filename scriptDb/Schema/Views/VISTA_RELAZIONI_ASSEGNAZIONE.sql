CREATE OR REPLACE FORCE VIEW VISTA_RELAZIONI_ASSEGNAZIONE
(OTTICA, NOMINATIVO, CI, NI, DAL, 
 AL, PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, DESCR_UO, ID_UNITA_PADRE, 
 DES_INCARICO, RESPONSABILE, ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, RUOLO)
BEQUEATH DEFINER
AS 
select c.ottica
      ,c.nominativo
      ,c.ci
      ,c.ni
      ,greatest(u.dal_figlio, c.dal) dal
      ,decode(least(u.al_figlio, nvl(c.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(u.al_figlio, nvl(c.al, to_date(3333333, 'j')))) al
      ,u.progr_figlio progr_unita_organizzativa
      ,u.cod_figlio codice_uo
      ,u.descr_figlio descr_uo
      ,u.progr_padre id_unita_padre
      ,c.des_incarico
      ,c.responsabile
      ,c.assegnazione_prevalente
      ,nvl(c.tipo_assegnazione, 'I') tipo_assegnazione
      ,r.ruolo
  from relazioni_unita_organizzative u
      ,ruoli_componente              r
      ,vista_componenti              c
 where u.dal_figlio <= nvl(c.al, to_date(3333333, 'j'))
   and u.al_figlio >= c.dal
   and u.progr_padre = c.progr_unita_organizzativa
   and u.ottica = c.ottica
   and r.id_componente = c.id_componente;



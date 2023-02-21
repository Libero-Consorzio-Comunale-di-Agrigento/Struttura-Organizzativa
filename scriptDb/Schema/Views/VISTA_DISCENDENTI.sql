CREATE OR REPLACE FORCE VIEW VISTA_DISCENDENTI
(OTTICA, NOMINATIVO_PADRE, NI_PADRE, RUOLO_PADRE, NOMINATIVO, 
 CI, NI, DAL, AL, PROGR_UNITA_ORGANIZZATIVA, 
 CODICE_UO, DESCR_UO, ID_UNITA_PADRE, DES_INCARICO, RESPONSABILE, 
 ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE)
BEQUEATH DEFINER
AS 
select c.ottica
      ,u.nominativo nominativo_padre
      ,u.ni         ni_padre
      ,u.ruolo      ruolo_padre
      ,c.nominativo
      ,c.ci
      ,c.ni
      ,greatest(u.dal, c.dal) dal
      ,decode(least(nvl(u.al,to_date(3333333,'j')) , nvl(c.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(u.al,to_date(3333333,'j')) , nvl(c.al, to_date(3333333, 'j')))) al
      ,u.progr_unita_organizzativa  progr_unita_organizzativa
      ,u.codice_uo
      ,u.descr_uo
      ,u.id_unita_padre
      ,c.des_incarico
      ,c.responsabile
      ,c.assegnazione_prevalente
      ,nvl(c.tipo_assegnazione, 'I') tipo_assegnazione
  from vista_relazioni_assegnazione u
      ,vista_componenti             c
 where u.dal <= nvl(c.al, to_date(3333333, 'j'))
   and nvl(u.al,to_date(3333333,'j'))  >= c.dal
   and u.progr_unita_organizzativa  = c.progr_unita_organizzativa
   and u.ottica = c.ottica;



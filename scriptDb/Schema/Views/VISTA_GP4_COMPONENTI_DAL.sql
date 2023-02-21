CREATE OR REPLACE FORCE VIEW VISTA_GP4_COMPONENTI_DAL
(OTTICA, AMMINISTRAZIONE, PROGR_UNITA_ORGANIZZATIVA, ID_COMPONENTE, NI, 
 CI, DAL)
BEQUEATH DEFINER
AS 
select c.ottica
     , u.amministrazione
     , c.progr_unita_organizzativa
     , a.id_componente
     , c.ni
     , c.ci
     , greatest(u.dal,c.dal) dal
  from componenti c
     , anagrafe_unita_organizzative u
     , attributi_componente a
 where c.progr_unita_organizzativa = u.progr_unita_organizzativa
   and nvl(u.revisione_istituzione,-2) != revisione_struttura.get_revisione_mod(u.ottica)
   and nvl(c.revisione_assegnazione,-2) != revisione_struttura.get_revisione_mod(c.ottica)
   and u.dal <= nvl(decode(c.revisione_cessazione,revisione_struttura.get_revisione_mod(c.ottica),to_date(null),c.al),to_date(3333333,'j')) 
   and nvl(decode(u.revisione_cessazione,revisione_struttura.get_revisione_mod(u.ottica),to_date(null),u.al),to_date(3333333,'j')) >= c.dal
   and c.id_componente = a.id_componente
   and nvl(a.tipo_assegnazione,'I') = 'I'
   and nvl(a.assegnazione_prevalente,0) = 1
   and c.dal <= nvl (c.al, to_date (3333333, 'j'))
   and a.dal <= nvl (a.al, to_date (3333333, 'j'))
 union
select c.ottica
     , substr(ottica.get_amministrazione (c.ottica),1,16) amministrazione
     , c.progr_unita_organizzativa
     , a.id_componente
     , c.ni
     , c.ci
     , a.dal
  from componenti c
     , imputazioni_bilancio a
 where c.id_componente = a.id_componente
   and nvl(c.revisione_assegnazione,-2) != revisione_struttura.get_revisione_mod(c.ottica)
   and c.dal <= nvl (c.al, to_date (3333333, 'j'))
   and a.dal <= nvl (a.al, to_date (3333333, 'j'));



CREATE OR REPLACE FORCE VIEW VISTA_UNOR_DAL
(OTTICA, PROGR_UNITA_ORGANIZZATIVA, DAL)
BEQUEATH DEFINER
AS 
select a.ottica
      ,progr_unita_organizzativa
      ,dal
  from revisioni_modifica           r
      ,anagrafe_unita_organizzative a
 where nvl(revisione_istituzione, -2) != r.revisione_modifica
   and r.ottica = a.ottica
union
select u.ottica
      ,progr_unita_organizzativa
      ,dal
  from revisioni_modifica           r
      ,unita_organizzative         u
 where nvl(revisione, -2) != r.revisione_modifica
   and r.ottica = u.ottica;



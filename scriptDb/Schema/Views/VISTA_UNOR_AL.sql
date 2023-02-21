CREATE OR REPLACE FORCE VIEW VISTA_UNOR_AL
(OTTICA, PROGR_UNITA_ORGANIZZATIVA, AL)
BEQUEATH DEFINER
AS 
select a.ottica
      ,progr_unita_organizzativa
      ,decode(nvl(revisione_cessazione, -2)
             ,r.revisione_modifica
             ,al_prec --#547
             ,al) al
  from revisioni_modifica           r --#558
      ,anagrafe_unita_organizzative a
 where a.ottica = r.ottica
union
select u.ottica
      ,progr_unita_organizzativa
      ,decode(nvl(revisione_cessazione, -2)
             ,r.revisione_modifica
             ,al_prec --#547
             ,al)
  from revisioni_modifica  r --#558
      ,unita_organizzative u
 where u.ottica = r.ottica;



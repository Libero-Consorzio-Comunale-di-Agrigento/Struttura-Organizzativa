CREATE OR REPLACE FORCE VIEW VISTA_RESPONSABILI
(CI, NOMINATIVO, DAL, AL, UNITA_ORGANIZZATIVA)
BEQUEATH DEFINER
AS 
select c.ci 
      ,c.nominativo
      ,c.dal
      ,c.al
      ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                 ,nvl(c.al, to_date(3333333, 'j'))) unita_organizzativa
  from vista_componenti c
 where responsabile = 'SI';



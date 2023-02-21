CREATE OR REPLACE FORCE VIEW VISTA_PROFILI_COMPONENTE
(NI, CI, DAL_COMPONENTE, AL_COMPONENTE, ID_COMPONENTE, 
 OTTICA, PROGR_UNITA_ORGANIZZATIVA, PROFILO, ID_RUOLO_PROFILO, DAL_PROFILO, 
 AL_PROFILO, DAL_PUBB_COMPONENTE, AL_PUBB_COMPONENTE, DAL_PUBB_PROFILO, AL_PUBB_PROFILO)
BEQUEATH DEFINER
AS 
select c.ni
      ,c.ci
      ,c.dal                       dal_componente
      ,c.al                        al_componente
      ,c.id_componente
      ,c.ottica
      ,c.progr_unita_organizzativa
      ,r.ruolo                     profilo
      ,r.id_ruolo_componente       id_ruolo_profilo
      ,r.dal                       dal_profilo
      ,r.al                        al_profilo
      ,c.dal_pubb                  dal_pubb_componente
      ,c.al_pubb                   al_pubb_componente
      ,r.dal_pubb                  dal_pubb_profilo
      ,r.al_pubb                   al_pubb_profilo
  from componenti       c
      ,ruoli_componente r
 where r.id_componente = c.id_componente
   and r.ruolo in (select distinct ruolo_profilo from ruoli_profilo);



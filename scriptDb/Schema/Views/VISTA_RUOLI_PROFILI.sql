CREATE OR REPLACE FORCE VIEW VISTA_RUOLI_PROFILI
(NI, CI, OTTICA, PROGR_UNITA_ORGANIZZATIVA, PROFILO, 
 RUOLO, ID_COMPONENTE, DAL_COMPONENTE, AL_COMPONENTE, ID_RUOLO_COMPONENTE, 
 DAL_RUOLO, AL_RUOLO, DAL_PUBB_COMPONENTE, AL_PUBB_COMPONENTE, DAL_PUBB_RUOLO, 
 AL_PUBB_RUOLO, ID_PROFILO, DAL_PROFILO, AL_PROFILO)
BEQUEATH DEFINER
AS 
select p.ni
         ,p.ci
         ,p.ottica
         ,p.progr_unita_organizzativa
         ,p.profilo
         ,r.ruolo
         ,p.id_componente
         ,p.dal_componente
         ,p.al_componente
         ,r.id_ruolo_componente
         ,r.dal                       dal_ruolo
         ,r.al                        al_ruolo
         ,p.dal_pubb_componente
         ,p.al_pubb_componente
         ,r.dal_pubb                  dal_pubb_ruolo
         ,r.al_pubb                   al_pubb_ruolo
         ,p.id_ruolo_profilo id_profilo
         ,p.dal_profilo
         ,p.al_profilo
     from ruoli_componente         r
         ,vista_profili_componente p
         ,ruoli_derivati           d
    where r.id_componente = p.id_componente
      and d.id_ruolo_componente = r.id_ruolo_componente
      and d.id_profilo = p.id_ruolo_profilo;



CREATE OR REPLACE FORCE VIEW UTENTI_APPARTENENZA_STRUTTURA
(RUOLO, SOGGETTO, TIPO)
BEQUEATH DEFINER
AS 
select '@@' || us.ottica || '@@' ruolo
     , us.ni soggetto
     , 'D'   tipo                                                   --derivata
  from utenti_relazioni_struttura us
union
select '@@' || us.ottica || '@@' || progr_padre ruolo
     , US.ni
     , 'D'                                                          --derivata
  from utenti_relazioni_struttura us
 where progr_figlio != progr_padre
union
select '@@' || us.ottica || '@@' || progr_padre ruolo
     , US.ni
     , 'S'                                                          --derivata
  from utenti_relazioni_struttura us
 where progr_figlio = progr_padre
union
select rc.ruolo || '@@' || us.ottica || '@@' || progr_padre ruolo
     , us.ni
     , 'S'                                        -- da posizione in struttura
  from utenti_relazioni_struttura us
     , ruoli_componente rc
 where rC.ID_COMPONENTE = us.ID_COMPONENTE
   and progr_figlio = progr_padre
   and trunc (sysdate) between rc.dal and nvl (rc.al, to_date (3333333, 'j'))
union
select rc.ruolo || '@@' || us.ottica || '@@' ruolo
     , us.ni
     , 'D'                               -- derivato da posizione in struttura
  from utenti_relazioni_struttura us
     , ruoli_componente rc
 where rC.ID_COMPONENTE = us.ID_COMPONENTE
   and trunc (sysdate) between rc.dal and nvl (rc.al, to_date (3333333, 'j'))
union
select rc.ruolo || '@@' || '@@' ruolo
     , us.ni
     , 'D'                               --struttura
  from utenti_relazioni_struttura us
     , ruoli_componente rc
 where rC.ID_COMPONENTE = us.ID_COMPONENTE
   and trunc (sysdate) between rc.dal and nvl (rc.al, to_date (3333333, 'j'))
union
select rc.ruolo || '@@' || us.ottica || '@@' ruolo
     , us.ni
     , 'D'                                        -- da posizione in struttura
  from utenti_relazioni_struttura us
     , ruoli_componente rc
 where rC.ID_COMPONENTE = us.ID_COMPONENTE
   and trunc (sysdate) between rc.dal and nvl (rc.al, to_date (3333333, 'j'));



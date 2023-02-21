CREATE OR REPLACE FORCE VIEW VISTA_INFO_SO4
(ISTANZA, DESCRIZIONE)
BEQUEATH DEFINER
AS 
select distinct istanza
     , descrizione
  from user_tab_privs
     , ad4_istanze ista
 where owner = user
   and grantor = user
   and user_oracle = grantee
   and ista.installazione is not null
 union
select 'CG4' istanza
     , 'Controllo di Gestione' descrizione
  from ad4_istanze ista
 where istanza = 'SO4' 
   and instr(installazione, 'CG4') != 0
 union
select 'GS4' istanza
     , 'Gestione Segreteria' descrizione
  from ad4_istanze ista
 where istanza = 'SO4' 
   and instr (installazione, 'GS4') != 0;



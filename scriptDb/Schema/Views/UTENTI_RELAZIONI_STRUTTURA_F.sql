CREATE OR REPLACE FORCE VIEW UTENTI_RELAZIONI_STRUTTURA_F
(NI, OTTICA, REVISIONE, PROGR_PADRE, COD_PADRE, 
 DESCR_PADRE, ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, PROGR_FIGLIO)
BEQUEATH DEFINER
AS 
select c.ni
      ,ruo.ottica
      ,ruo.revisione
      ,ruo.progr_padre
      ,cod_padre
      ,ruo.descr_padre
      ,c.id_componente
      ,c.progr_unita_organizzativa
      ,ruo.progr_figlio
  from relazioni_unita_organizzative ruo
      ,revisioni_modifica            r
      ,componenti                    c
 where ruo.progr_padre = c.progr_unita_organizzativa
   and ruo.ottica = c.ottica
   and c.dal <= nvl(c.al, to_date(3333333, 'j'))
   and r.ottica = c.ottica
   and trunc(sysdate) between c.dal and nvl(c.al, to_date(3333333, 'j'))
   and trunc(sysdate) between dal_figlio and al_figlio
   and trunc(sysdate) between dal_padre and al_padre
   and nvl(c.revisione_assegnazione, -2) != r.revisione_modifica;



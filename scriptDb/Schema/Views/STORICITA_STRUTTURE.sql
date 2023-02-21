CREATE OR REPLACE FORCE VIEW STORICITA_STRUTTURE
(AMMINISTRAZIONE, OTTICA, PROGR_UNITA_ORGANIZZATIVA, DAL, AL)
BEQUEATH DEFINER
AS 
select distinct rs.amministrazione
               ,rs.ottica
               ,progr_figlio progr_unita_organizzativa
               ,dal_figlio dal
               ,decode(nvl((select (min(dal_figlio) - 1)
                             from relazioni_unita_organizzative
                            where ottica = rs.ottica
                              and progr_figlio = rs.progr_figlio
                              and dal_figlio > rs.dal_figlio)
                          ,(select max(al_figlio)
                             from relazioni_unita_organizzative
                            where ottica = rs.ottica
                              and progr_figlio = rs.progr_figlio))
                      ,to_date(3333333, 'j')
                      ,to_date(null)
                      ,nvl((select (min(dal_figlio) - 1)
                             from relazioni_unita_organizzative
                            where ottica = rs.ottica
                              and progr_figlio = rs.progr_figlio
                              and dal_figlio > rs.dal_figlio)
                          ,(select max(al_figlio)
                             from relazioni_unita_organizzative
                            where ottica = rs.ottica
                              and progr_figlio = rs.progr_figlio))) al
  from relazioni_unita_organizzative rs;



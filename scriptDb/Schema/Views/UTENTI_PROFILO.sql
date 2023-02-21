CREATE OR REPLACE FORCE VIEW UTENTI_PROFILO
(AD4_UTENTE, CODICE_AMMINISTRAZIONE, AOO, RUOLO, GRUPPO, 
 ASSEGNAZIONE_PREVALENTE)
BEQUEATH DEFINER
AS 
select s.utente ad4_utente
      ,aoo.codice_amministrazione
      ,aoo.codice_aoo aoo
      ,r.ruolo
      ,anuo.utente_ad4 gruppo
      ,decode(substr(a.assegnazione_prevalente, 1, 1), '1', 1, a.assegnazione_prevalente)
  from componenti                   c
      ,ad4_utenti_soggetti          s
      ,anagrafe_unita_organizzative anuo
      ,revisioni_modifica           r --#558
      ,ruoli_componente             r
      ,attributi_componente         a
      ,aoo
 where aoo.progr_aoo = anuo.progr_aoo
   and aoo.al is null
   and anuo.ottica = (select min(ottica) from ottiche where ottica_istituzionale = 'SI')
   and a.id_componente = c.id_componente
   and trunc(sysdate) between a.dal and nvl(a.al, to_date('3333333', 'j'))
   and anuo.progr_unita_organizzativa = c.progr_unita_organizzativa
   and trunc(sysdate) between anuo.dal and nvl(anuo.al, trunc(sysdate))
   and r.ottica = c.ottica
   and nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and trunc(sysdate) between c.dal and
       nvl(decode(nvl(c.revisione_cessazione,-2)
                 ,r.revisione_modifica
                 ,c.al_prec --#547
                 ,c.al)
          ,to_date('3333333', 'j'))
   and c.ni = s.soggetto
   and r.id_componente = c.id_componente
   and trunc(sysdate) between r.dal and nvl(r.al, to_date('3333333', 'j'))
union
-- incarichi assegnati
select s.utente ad4_utente
      ,aoo.codice_amministrazione
      ,aoo.codice_aoo aoo
      ,a.incarico
      ,anuo.utente_ad4 gruppo
      ,decode(substr(a.assegnazione_prevalente, 1, 1), '1', 1, a.assegnazione_prevalente)
  from componenti                   c
      ,ad4_utenti_soggetti          s
      ,anagrafe_unita_organizzative anuo
      ,revisioni_modifica           r --#558
      ,attributi_componente         a
      ,aoo
 where aoo.progr_aoo = anuo.progr_aoo
   and aoo.al is null
   and anuo.ottica = (select min(ottica) from ottiche where ottica_istituzionale = 'SI')
   and a.id_componente = c.id_componente
   and trunc(sysdate) between a.dal and nvl(a.al, to_date('3333333', 'j'))
   and anuo.progr_unita_organizzativa = c.progr_unita_organizzativa
   and trunc(sysdate) between anuo.dal and nvl(anuo.al, trunc(sysdate))
   and r.ottica = c.ottica
   and nvl(c.revisione_assegnazione, -2) != r.revisione_modifica
   and trunc(sysdate) between c.dal and
       nvl(decode(nvl(c.revisione_cessazione,-2)
                 ,r.revisione_modifica
                 ,c.al_prec --#547
                 ,c.al)
          ,to_date('3333333', 'j'))
   and c.ni = s.soggetto;



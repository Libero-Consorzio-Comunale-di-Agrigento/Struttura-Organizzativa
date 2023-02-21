CREATE OR REPLACE FORCE VIEW VISTA_MODIFICHE_REVISIONI
(OTTICA, REVISIONE, TIPO_OGGETTO, OGGETTO, EVENTO, 
 NOTE)
BEQUEATH DEFINER
AS 
select a.ottica
      ,a.revisione_istituzione revisione
      ,'ANAGRAFE UO' tipo_oggetto
      ,a.codice_uo || ' : ' || a.descrizione ||
       (select ' (' || descrizione || ')'
          from suddivisioni_struttura s
         where id_suddivisione = a.id_suddivisione) oggetto
      ,'Creazione nuova UO' evento
      ,' ' note
  from revisioni_struttura           r
      ,anagrafe_unita_organizzative a
 where revisione_istituzione = r.revisione
   and r.ottica = a.ottica
   and not exists (select 'x'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = a.progr_unita_organizzativa
           and revisione_cessazione = r.revisione)
union
--eliminazione uo
select a.ottica
      ,a.revisione_cessazione revisione
      ,'ANAGRAFE UO' tipo_oggetto
      ,a.codice_uo || ' : ' || a.descrizione ||
       (select ' (' || descrizione || ')'
          from suddivisioni_struttura s
         where id_suddivisione = a.id_suddivisione) oggetto
      ,'Eliminazione UO' evento
      ,' ' note
  from revisioni_struttura           r
      ,anagrafe_unita_organizzative a
 where revisione_cessazione = r.revisione
   and r.ottica = a.ottica
   and not exists (select 'x'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = a.progr_unita_organizzativa
           and revisione_istituzione = r.revisione)
union
--modifiche uo
select a.ottica
      ,r.revisione revisione
      ,'ANAGRAFE UO' tipo_oggetto
      ,a.codice_uo || ' : ' || a.descrizione ||
       (select ' (' || descrizione || ')'
          from suddivisioni_struttura s
         where id_suddivisione = a.id_suddivisione) oggetto
      ,'Modifiche attributi UO' evento
      ,decode(revisione_istituzione, r.revisione, 'Dopo', 'Prima') note
  from revisioni_struttura           r
      ,anagrafe_unita_organizzative a -- UO Modificate
 where (revisione_istituzione = r.revisione or
       revisione_cessazione = r.revisione)
   and r.ottica = a.ottica
   and progr_unita_organizzativa in
       (select progr_unita_organizzativa
          from anagrafe_unita_organizzative a1
              ,revisioni_struttura           r1
         where revisione_cessazione = r1.revisione
           and r1.ottica = a1.ottica
           and r1.revisione=r.revisione
           and exists
         (select 'x'
                  from anagrafe_unita_organizzative
                 where progr_unita_organizzativa = a1.progr_unita_organizzativa
                   and revisione_istituzione = r1.revisione))
union
-- UO inserite in struttura in questa revisione
select u.ottica
      ,u.revisione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' inserita in struttura' evento
      ,'Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_struttura  r
      ,unita_organizzative u
 where u.revisione = r.revisione
   and r.ottica = u.ottica
   and not exists (select 'x'
          from unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and ottica = u.ottica
           and revisione_cessazione = r.revisione)
union
-- UO eliminate in struttura in questa revisione
select u.ottica
      ,u.revisione_cessazione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and (r.dal-1) between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' eliminata dalla struttura' evento
      ,'Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_struttura  r
      ,unita_organizzative u
 where revisione_cessazione = r.revisione
   and r.ottica = u.ottica
   and not exists (select 'x'
          from unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and revisione = r.revisione)
union
-- UOP spostate
select u.ottica
      ,u.revisione_cessazione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' spostata' evento
      ,'Prima' || ' : Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_struttura  r
      ,unita_organizzative u
 where revisione_cessazione = r.revisione
   and r.ottica = u.ottica
   and progr_unita_organizzativa in
       (select progr_unita_organizzativa
          from unita_organizzative
         where progr_unita_organizzativa in
               (select progr_unita_organizzativa
                  from unita_organizzative u1
                      ,revisioni_struttura  r1
                 where u1.revisione = r1.revisione
                   and r1.ottica = u1.ottica
                   and r1.revisione= r.revisione
                   and exists
                 (select 'x'
                          from unita_organizzative
                         where progr_unita_organizzativa = u1.progr_unita_organizzativa
                           and revisione_cessazione = r1.revisione)))
union
-- UOP spostate
select u.ottica
      ,u.revisione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' spostata' evento
      ,'Dopo' || ' : Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_struttura  r
      ,unita_organizzative u
 where u.revisione = r.revisione
   and r.ottica = u.ottica
   and progr_unita_organizzativa in
       (select progr_unita_organizzativa
          from unita_organizzative
         where progr_unita_organizzativa in
               (select progr_unita_organizzativa
                  from unita_organizzative u1
                      ,revisioni_struttura  r1
                 where u1.revisione = r1.revisione
                   and r1.ottica = u1.ottica
                   and exists
                 (select 'x'
                          from unita_organizzative
                         where progr_unita_organizzativa = u1.progr_unita_organizzativa
                           and revisione_cessazione = r1.revisione)))
union
--componenti spostati in revisione
select c.ottica
      ,c.revisione_cessazione revisione
      ,'COMPONENTE'
      ,(select cognome || ' ' || nome from anagrafe_soggetti where ni = c.ni) oggetto
      ,'Spostamento Componente' evento
      ,'Prima : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = c.progr_unita_organizzativa
           and (r.dal - 1) between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_struttura r
      ,componenti         c
 where revisione_cessazione = r.revisione
   and r.ottica = c.ottica
   and ni in
       (select ni
          from componenti
         where ni in (select ni
                        from componenti c1
                       where revisione_assegnazione = r.revisione
                         and ottica = c.ottica
                         and exists
                       (select 'x'
                                from componenti
                               where ni = c1.ni
                                 and ottica = c1.ottica
                                 and revisione_cessazione = r.revisione)))
union
--componenti spostati in revisione
select c.ottica
      ,c.revisione_assegnazione revisione
      ,'COMPONENTE'
      ,(select cognome || ' ' || nome from anagrafe_soggetti where ni = c.ni) oggetto
      ,'Spostamento Componente' evento
      ,'Dopo : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = c.progr_unita_organizzativa
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_struttura r
      ,componenti         c
 where revisione_assegnazione = r.revisione
   and r.ottica = c.ottica
   and ni in
       (select ni
          from componenti
         where ni in (select ni
                        from componenti c1
                       where revisione_assegnazione = r.revisione
                         and ottica = c.ottica
                         and exists
                       (select 'x'
                                from componenti
                               where ni = c1.ni
                                 and ottica = c1.ottica
                                 and revisione_cessazione = r.revisione)));



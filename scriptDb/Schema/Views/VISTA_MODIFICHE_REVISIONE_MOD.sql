CREATE OR REPLACE FORCE VIEW VISTA_MODIFICHE_REVISIONE_MOD
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
  from revisioni_modifica           r
      ,anagrafe_unita_organizzative a
 where revisione_istituzione = r.revisione_modifica
   and r.ottica = a.ottica
   and not exists (select 'x'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = a.progr_unita_organizzativa
           and revisione_cessazione = r.revisione_modifica)
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
  from revisioni_modifica           r
      ,anagrafe_unita_organizzative a
 where revisione_cessazione = r.revisione_modifica
   and r.ottica = a.ottica
   and not exists (select 'x'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = a.progr_unita_organizzativa
           and revisione_istituzione = r.revisione_modifica)
union
--modifiche uo
select a.ottica
      ,r.revisione_modifica revisione
      ,'ANAGRAFE UO' tipo_oggetto
      ,a.codice_uo || ' : ' || a.descrizione ||
       (select ' (' || descrizione || ')'
          from suddivisioni_struttura s
         where id_suddivisione = a.id_suddivisione) oggetto
      ,'Modifiche attributi UO' evento
      ,decode(revisione_istituzione, revisione_struttura.get_revisione_mod(a.ottica), 'Dopo', 'Prima') note
  from revisioni_modifica           r
      ,anagrafe_unita_organizzative a -- UO Modificate
 where (revisione_istituzione = r.revisione_modifica or
       revisione_cessazione = r.revisione_modifica)
   and r.ottica = a.ottica
   and progr_unita_organizzativa in
       (select progr_unita_organizzativa
          from anagrafe_unita_organizzative a1
              ,revisioni_modifica           r1
         where revisione_cessazione = r1.revisione_modifica
           and r1.ottica = a1.ottica
           and exists
         (select 'x'
                  from anagrafe_unita_organizzative
                 where progr_unita_organizzativa = a1.progr_unita_organizzativa
                   and revisione_istituzione = r1.revisione_modifica))
union
-- UO inserite in struttura in questa revisione
select u.ottica
      ,u.revisione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' inserita in struttura' evento
      ,'Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_modifica  r
      ,revisioni_struttura rs
      ,unita_organizzative u
 where u.revisione = r.revisione_modifica
   and r.ottica = u.ottica
   and rs.revisione = r.revisione_modifica
   and rs.ottica = r.ottica
   and not exists (select 'x'
          from unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and ottica = u.ottica
           and revisione_cessazione = r.revisione_modifica)
union
-- UO eliminate in struttura in questa revisione
select u.ottica
      ,u.revisione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' eliminata dalla struttura' evento
      ,'Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_modifica  r
      ,revisioni_struttura rs
      ,unita_organizzative u
 where revisione_cessazione = r.revisione_modifica
   and r.ottica = u.ottica
   and rs.revisione = r.revisione_modifica
   and rs.ottica = r.ottica
   and not exists (select 'x'
          from unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and revisione = r.revisione_modifica)
union
-- UOP spostate
select u.ottica
      ,u.revisione
      ,'RELAZIONE STRUTTURA' tipo_oggetto
      ,(select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) oggetto
      ,'Unita'' spostata' evento
      ,decode(u.revisione
             ,revisione_struttura.get_revisione_mod(u.ottica)
             ,'Dopo'
             ,'Prima') || ' : Unita'' padre : ' ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.id_unita_padre
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_modifica  r
      ,revisioni_struttura rs
      ,unita_organizzative u
 where (u.revisione = r.revisione_modifica or u.revisione_cessazione = r.revisione_modifica)
   and r.ottica = u.ottica
   and rs.revisione = r.revisione_modifica
   and rs.ottica = r.ottica
   and progr_unita_organizzativa in
       (select progr_unita_organizzativa
          from unita_organizzative
         where progr_unita_organizzativa in
               (select progr_unita_organizzativa
                  from unita_organizzative u1
                      ,revisioni_modifica  r1
                 where revisione = r1.revisione_modifica
                   and r1.ottica = u1.ottica
                   and exists
                 (select 'x'
                          from unita_organizzative
                         where progr_unita_organizzativa = u1.progr_unita_organizzativa
                           and revisione_cessazione = r1.revisione_modifica)))
union
--componenti spostati in revisione
select c.ottica
      ,c.revisione_assegnazione revisione
      ,'COMPONENTE'
      ,(select cognome || ' ' || nome from anagrafe_soggetti where ni = c.ni) oggetto
      ,'Spostamento Componente' evento
      ,decode(revisione_assegnazione
             ,revisione_struttura.get_revisione_mod(c.ottica)
             ,'Dopo : '
             ,'Prima : ') ||
       (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = c.progr_unita_organizzativa
           and nvl(rs.dal, trunc(sysdate)) between dal and nvl(al, to_date(3333333, 'j'))) note
  from revisioni_modifica  r
      ,revisioni_struttura rs
      ,componenti          c
 where (revisione_assegnazione = r.revisione_modifica or
       revisione_cessazione = r.revisione_modifica)
   and r.ottica = c.ottica
   and rs.revisione = r.revisione_modifica
   and rs.ottica = r.ottica
   and ni in
       (select ni
          from componenti
         where ni in (select ni
                        from componenti c1
                       where revisione_assegnazione = r.revisione_modifica
                         and ottica = c.ottica
                         and exists
                       (select 'x'
                                from componenti
                               where ni = c1.ni
                                 and ottica = c1.ottica
                                 and revisione_cessazione = r.revisione_modifica)))
 order by 1
         ,3
         ,5
         ,6 desc;



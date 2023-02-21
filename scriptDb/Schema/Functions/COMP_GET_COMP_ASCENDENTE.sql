CREATE OR REPLACE function comp_get_comp_ascendente
(
   p_ni     in componenti.ni%type
  ,p_ottica in componenti.ottica%type
  ,p_ruolo  in ruoli_componente.ruolo%type
) return number is
   d_result componenti.ni%type;
begin
   begin
      select min(c.ni)
        into d_result
        from componenti          c
            ,relazioni_struttura rs
       where c.progr_unita_organizzativa = rs.progr_padre
         and rs.progr_figlio =
             (select progr_unita_organizzativa
                from componenti c
               where ni = p_ni
                 and ottica = p_ottica
                 and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'))
                 and exists
               (select 'x'
                        from attributi_componente
                       where id_componente = c.id_componente
                         and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'))
                         and tipo_assegnazione = 'I'
                         and assegnazione_prevalente like '1%'))
         and rs.ottica = p_ottica
         and rs.revisione = (select max(revisione)
                               from revisioni_struttura
                              where ottica = p_ottica
                                and dal <= trunc(sysdate))
         and trunc(sysdate) between dal_figlio and nvl(al_figlio, to_date(3333333, 'j'))
         and trunc(sysdate) between dal_padre and nvl(al_padre, to_date(3333333, 'j'))
         and exists
       (select 'x'
                from ruoli_componente r
               where ruolo = p_ruolo
                 and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'))
                 and id_componente = c.id_componente)
         and rs.liv_padre =
             (select max(liv_padre)
                from relazioni_struttura rs
               where progr_figlio =
                     (select progr_unita_organizzativa
                        from componenti c
                       where ni = p_ni
                         and ottica = p_ottica
                         and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'))
                         and exists (select 'x'
                                from attributi_componente
                               where id_componente = c.id_componente
                                 and trunc(sysdate) between dal and
                                     nvl(al, to_date(3333333, 'j'))
                                 and tipo_assegnazione = 'I'
                                 and assegnazione_prevalente like '1%'))
                 and ottica = p_ottica
                 and revisione = (select max(revisione)
                                    from revisioni_struttura
                                   where ottica = p_ottica
                                     and dal <= trunc(sysdate))
                 and trunc(sysdate) between dal_figlio and
                     nvl(al_figlio, to_date(3333333, 'j'))
                 and trunc(sysdate) between dal_padre and
                     nvl(al_padre, to_date(3333333, 'j'))
                 and exists
               (select 'x'
                        from ruoli_componente r
                       where ruolo = p_ruolo
                         and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'))
                         and id_componente in
                             (select id_componente
                                from componenti c
                               where trunc(sysdate) between dal and
                                     nvl(al, to_date(3333333, 'j'))
                                 and progr_unita_organizzativa = rs.progr_padre)));
   exception
      when others then
         d_result := '';
   end;
   return(d_result);
end comp_get_comp_ascendente;
/


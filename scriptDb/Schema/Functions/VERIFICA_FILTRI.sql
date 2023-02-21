CREATE OR REPLACE function verifica_filtri
(
   p_ottica                ottiche.ottica%type
  ,p_progr_unor            anagrafe_unita_organizzative.progr_unita_organizzativa%type
  ,p_dal                   anagrafe_unita_organizzative.dal%type
  ,p_al                    anagrafe_unita_organizzative.al%type
  ,p_ni                    componenti.ni%type
  ,p_dipendente            varchar2
  ,p_revisione_in_modifica revisioni_struttura.revisione%type default -1
) return number as
   d_result        afc_error.t_error_number;
   d_revisione_mod revisioni_struttura.revisione%type := p_revisione_in_modifica; --#484
begin
   if p_ottica is null and p_progr_unor is null and p_dal is null and p_al is null and
      p_ni is null and p_dipendente is null then
      d_result := afc_error.ok;
   else
      if p_ottica is not null then
         begin
            if p_ni is not null then
               select afc_error.ok
                 into d_result
                 from componenti c
                where c.ottica = p_ottica
                  and c.progr_unita_organizzativa =
                      nvl(p_progr_unor, c.progr_unita_organizzativa)
                  and nvl(c.revisione_assegnazione, -2) != d_revisione_mod
                  and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                  and nvl(decode(c.revisione_cessazione
                                ,d_revisione_mod
                                ,c.al_prec --#533
                                ,c.al)
                         ,to_date(3333333, 'j')) >= nvl(p_dal, to_date(2222222, 'j'))
                  and c.ni = p_ni
                  and ((nvl(p_dipendente, 'N') = 'S' and c.ci is not null) or
                      nvl(p_dipendente, 'N') = 'N');
            else
               select afc_error.ok
                 into d_result
                 from componenti c
                where c.ottica = p_ottica
                  and c.progr_unita_organizzativa =
                      nvl(p_progr_unor, c.progr_unita_organizzativa)
                  and nvl(c.revisione_assegnazione, -2) != d_revisione_mod
                  and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                  and nvl(decode(c.revisione_cessazione
                                ,d_revisione_mod
                                ,c.al_prec --#533
                                ,c.al)
                         ,to_date(3333333, 'j')) >= nvl(p_dal, to_date(2222222, 'j'))
                  and ((nvl(p_dipendente, 'N') = 'S' and c.ci is not null) or
                      nvl(p_dipendente, 'N') = 'N');
            end if;
         exception
            when no_data_found then
               d_result := 0;
            when too_many_rows then
               d_result := afc_error.ok;
         end;
      else
         begin
            if p_ni is not null then
               select afc_error.ok
                 into d_result
                 from componenti c
                where c.progr_unita_organizzativa =
                      nvl(p_progr_unor, c.progr_unita_organizzativa)
                  and nvl(c.revisione_assegnazione, -2) != d_revisione_mod
                  and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                  and nvl(decode(c.revisione_cessazione
                                ,d_revisione_mod
                                ,c.al_prec --#533
                                ,c.al)
                         ,to_date(3333333, 'j')) >= nvl(p_dal, to_date(2222222, 'j'))
                  and c.ni = p_ni
                  and ((nvl(p_dipendente, 'N') = 'S' and c.ci is not null) or
                      nvl(p_dipendente, 'N') = 'N');
            else
               select afc_error.ok
                 into d_result
                 from componenti c
                where c.progr_unita_organizzativa =
                      nvl(p_progr_unor, c.progr_unita_organizzativa)
                  and nvl(c.revisione_assegnazione, -2) != d_revisione_mod
                  and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                  and nvl(decode(c.revisione_cessazione
                                ,d_revisione_mod
                                ,c.al_prec --#533
                                ,c.al)
                         ,to_date(3333333, 'j')) >= nvl(p_dal, to_date(2222222, 'j'))
                  and ((nvl(p_dipendente, 'N') = 'S' and c.ci is not null) or
                      nvl(p_dipendente, 'N') = 'N');
            end if;
         exception
            when no_data_found then
               d_result := 0;
            when too_many_rows then
               d_result := afc_error.ok;
         end;
      end if;
   end if;
   --
   return d_result;
   --
end;
/


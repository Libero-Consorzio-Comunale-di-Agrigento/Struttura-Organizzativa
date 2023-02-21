CREATE OR REPLACE function get_livello_rs
(
   p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
  ,p_ottica                    unita_organizzative.ottica%type
  ,p_data                      date
) return number as
   d_result number(3);
begin
   d_result := to_number(null);
   begin
      select max(nvl(level, 0))
        into d_result
        from unita_organizzative u
       where u.ottica = p_ottica
         and p_data between dal and nvl(al, to_date(3333333, 'j'))
       start with u.progr_unita_organizzativa = p_progr_unita_organizzativa
              and u.ottica = p_ottica
              and p_data between dal and nvl(al, to_date(3333333, 'j'))
      connect by prior u.id_unita_padre = u.progr_unita_organizzativa
             and u.ottica = p_ottica
             and p_data between dal and nvl(al, to_date(3333333, 'j'));
   exception
      when no_data_found or too_many_rows then
         begin
            d_result := to_number(null);
         end;
   end;
   return d_result;
end;
/


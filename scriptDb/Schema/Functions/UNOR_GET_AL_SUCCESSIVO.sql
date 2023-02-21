CREATE OR REPLACE function UNOR_GET_AL_SUCCESSIVO
( p_ottica                      unita_organizzative.ottica%type
, p_progr_unita_organizzativa   unita_organizzative.progr_unita_organizzativa%type
, p_dal                         unita_organizzative.dal%type
) return unita_organizzative.al%type is
  d_data1                       unita_organizzative.al%type;
  d_data2                       unita_organizzative.al%type;
  d_result                      unita_organizzative.al%type;
begin
  select min(al)
    into d_data1
    from vista_unor_al
   where ottica = p_ottica
     and progr_unita_organizzativa = p_progr_unita_organizzativa
     and al > p_dal;
  select min(dal) - 1
    into d_data2
    from vista_unor_dal
   where ottica = p_ottica
     and progr_unita_organizzativa = p_progr_unita_organizzativa
     and dal > p_dal;
--
  if d_data1 is null then
     d_result := d_data2;
  elsif d_data2 is null then
     d_result := d_data1;
  else
     d_result := least(d_data1,d_data2);
  end if;
--
  return d_result;
--
end;
/


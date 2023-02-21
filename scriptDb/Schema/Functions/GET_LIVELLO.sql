CREATE OR REPLACE function GET_LIVELLO
(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) 
return NUMBER as
  /******************************************************************************
   NOME:        get_livello
   DESCRIZIONE: Riporta il numero delle suddivisioni struttura di ordinamento inferiore
   PARAMETRI:
   RITORNA:
   NOTE:
   ******************************************************************************/
  d_result number(3);
  d_ottica suddivisioni_struttura.ottica%type := suddivisione_struttura.get_ottica(p_id_suddivisione);
begin
   d_result := to_number(null);
   begin
      select count(distinct ordinamento)
        into d_result
        from suddivisioni_struttura s
       where ottica = d_ottica
         and ordinamento < suddivisione_struttura.get_ordinamento(p_id_suddivisione);
   exception
      when no_data_found or too_many_rows then
         begin
            d_result := to_number(null);
         end;
   end;
   return d_result;
end;
/


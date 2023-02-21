CREATE OR REPLACE package body p00_dipendenti_soggetti_pkg is
   
   s_revisione_body constant afc.t_revision := '000 - 13/01/2012';
   
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   s_warning      afc.t_statement;
   
   function versione return varchar2 is
      
   begin
      return afc.version(s_revisione, s_revisione_body);
   end versione; 
   
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      
      d_result afc_error.t_error_msg;
      d_detail afc_error.t_error_msg;
   begin
      if s_error_detail.exists(p_error_number) then
         d_detail := s_error_detail(p_error_number);
      end if;
      if s_error_table.exists(p_error_number) then
         d_result := s_error_table(p_error_number) || d_detail;
         s_error_detail(p_error_number) := '';
      else
         raise_application_error(afc_error.exception_not_in_table_number
                                ,afc_error.exception_not_in_table_msg);
      end if;
      return d_result;
   end error_message; 
   
   function get_ci
   (
      p_ni  in p00_dipendenti_soggetti.ni_gp4%type
     ,p_dal in date default null
   ) return varchar2 is
      
      d_result varchar2(2000) := to_char(null);
   begin
      return d_result;
   end get_ci; 
   
   function get_ni_gp4(p_ni_as4 in p00_dipendenti_soggetti.ni_as4%type)
      return p00_dipendenti_soggetti.ni_gp4%type is
      
      d_result p00_dipendenti_soggetti.ni_gp4%type;
   begin
      d_result := to_number(null);
      return d_result;
   end get_ni_gp4; 
end p00_dipendenti_soggetti_pkg;
/


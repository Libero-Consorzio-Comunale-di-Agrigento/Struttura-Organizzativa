CREATE OR REPLACE package external_functions_pkg is
/******************************************************************************
 NOME:        external_functions_pkg
 DESCRIZIONE: Gestione tabella EXTERNAL_FUNCTIONS.
 ANNOTAZIONI: .
 REVISIONI:
 <CODE>
 Rev.  Data       Autore  Descrizione.
 00    31/05/2007  MMalferrari  Prima emissione.
 </CODE>
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   -- Versione e revisione
   function versione
   return varchar2;
   FUNCTION get_db_link
   ( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
   ) return varchar2;   
   FUNCTION get_function_name
   ( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
   ) return varchar2;
   FUNCTION get_package_name
   ( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
   ) return varchar2 ;
   FUNCTION get_function_parameters
   ( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
   ) return varchar2;
   -- Ritorna il tipo del valore di ritorno di 'p_firing_function' dello user
   -- 'p_function_owner'.
   function get_return_type
   ( p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
   , p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
   ) return varchar2;
   -- Controlla validita' della funzione data.
   function is_valid_function
   ( p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
   , p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
   ) return number;
   -- Crea trigger di AFTER DELETE OR INSERT OR UPDATE sulla tabella data.
   PROCEDURE crea_trigger_si4ef
   ( p_table_name in varchar2
   , p_check_esiste in number default 1);
   -- Elimina trigger di AFTER DELETE OR INSERT OR UPDATE sulla tabella data.
   PROCEDURE elimina_trigger_si4ef
   ( p_table_name in varchar2
   , p_function_id in number default 0
   , p_check_altri_record in number default 1);
end external_functions_pkg;
/


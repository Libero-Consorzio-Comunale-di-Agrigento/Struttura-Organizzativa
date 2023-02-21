CREATE OR REPLACE PACKAGE external_functions_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        external_functions_tpk
 DESCRIZIONE: Gestione tabella EXTERNAL_FUNCTIONS.
 ANNOTAZIONI: .
 REVISIONI:   Template Revision: 1.53.
 <CODE>
 Rev.  Data       Autore  Descrizione.
 00    11/05/2009  mmalferrari  Prima emissione.
 </CODE>
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'EXTERNAL_FUNCTIONS';
   subtype t_rowtype is EXTERNAL_FUNCTIONS%rowtype;
   -- Tipo del record primary key
   subtype t_function_id  is EXTERNAL_FUNCTIONS.function_id%type;
   type t_PK is record
   (
    function_id  t_function_id
   );
   -- Versione e revisione
   function versione /* SLAVE_COPY */
   return varchar2;
   pragma restrict_references( versione, WNDS );
   -- Costruttore di record chiave
   function PK /* SLAVE_COPY */
   (
    p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return t_PK;
   pragma restrict_references( PK, WNDS );
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (
    p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return number;
   pragma restrict_references( can_handle, WNDS );
   -- Controllo integrità chiave
   -- wrapper boolean
   function canHandle /* SLAVE_COPY */
   (
    p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return boolean;
   pragma restrict_references( canhandle, WNDS );
    -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
    p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return number;
   pragma restrict_references( exists_id, WNDS );
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsId /* SLAVE_COPY */
   (
    p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return boolean;
   pragma restrict_references( existsid, WNDS );
   -- Inserimento di una riga
   procedure ins  /*+ SOA  */
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type default null
   , p_table_name  in EXTERNAL_FUNCTIONS.table_name%type
   , p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
   , p_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type
   , p_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type
   );
   function ins  /*+ SOA  */
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type default null
   , p_table_name  in EXTERNAL_FUNCTIONS.table_name%type
   , p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
   , p_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type
   , p_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type
   ) return integer;
   -- Aggiornamento di una riga
   procedure upd  /*+ SOA  */
   (
     p_check_OLD  in integer default 0
   , p_NEW_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_OLD_function_id  in EXTERNAL_FUNCTIONS.function_id%type default null
   , p_NEW_table_name  in EXTERNAL_FUNCTIONS.table_name%type default null
   , p_OLD_table_name  in EXTERNAL_FUNCTIONS.table_name%type default null
   , p_NEW_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type default null
   , p_OLD_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type default null
   , p_NEW_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type default null
   , p_OLD_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type default null
   , p_NEW_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type default null
   , p_OLD_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_column         in varchar2
   , p_value          in varchar2 default null
   , p_literal_value  in number   default 1
   );
   -- Cancellazione di una riga
   procedure del  /*+ SOA  */
   (
     p_check_OLD  in integer default 0
   , p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_table_name  in EXTERNAL_FUNCTIONS.table_name%type default null
   , p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type default null
   , p_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type default null
   , p_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type default null
   );
   -- Getter per attributo table_name di riga identificata da chiave
   function get_table_name /* SLAVE_COPY */
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return EXTERNAL_FUNCTIONS.table_name%type;
   pragma restrict_references( get_table_name, WNDS );
   -- Getter per attributo function_owner di riga identificata da chiave
   function get_function_owner /* SLAVE_COPY */
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return EXTERNAL_FUNCTIONS.function_owner%type;
   pragma restrict_references( get_function_owner, WNDS );
   -- Getter per attributo firing_function di riga identificata da chiave
   function get_firing_function /* SLAVE_COPY */
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return EXTERNAL_FUNCTIONS.firing_function%type;
   pragma restrict_references( get_firing_function, WNDS );
   -- Getter per attributo firing_event di riga identificata da chiave
   function get_firing_event /* SLAVE_COPY */
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   ) return EXTERNAL_FUNCTIONS.firing_event%type;
   pragma restrict_references( get_firing_event, WNDS );
   -- Setter per attributo function_id di riga identificata da chiave
   procedure set_function_id
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_value  in EXTERNAL_FUNCTIONS.function_id%type default null
   );
   -- Setter per attributo table_name di riga identificata da chiave
   procedure set_table_name
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_value  in EXTERNAL_FUNCTIONS.table_name%type default null
   );
   -- Setter per attributo function_owner di riga identificata da chiave
   procedure set_function_owner
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_value  in EXTERNAL_FUNCTIONS.function_owner%type default null
   );
   -- Setter per attributo firing_function di riga identificata da chiave
   procedure set_firing_function
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_value  in EXTERNAL_FUNCTIONS.firing_function%type default null
   );
   -- Setter per attributo firing_event di riga identificata da chiave
   procedure set_firing_event
   (
     p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
   , p_value  in EXTERNAL_FUNCTIONS.firing_event%type default null
   );
   -- righe corrispondenti alla selezione indicata
   function get_rows  /*+ SOA  */ /* SLAVE_COPY */
   ( p_QBE  in number default 0
   , p_other_condition in varchar2 default null
   , p_order_by in varchar2 default null
   , p_extra_columns in varchar2 default null
   , p_extra_condition in varchar2 default null
   , p_function_id  in varchar2 default null
   , p_table_name  in varchar2 default null
   , p_function_owner  in varchar2 default null
   , p_firing_function  in varchar2 default null
   , p_firing_event  in varchar2 default null
   ) return AFC.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   ( p_QBE in number default 0
   , p_other_condition in varchar2 default null
   , p_function_id  in varchar2 default null
   , p_table_name  in varchar2 default null
   , p_function_owner  in varchar2 default null
   , p_firing_function  in varchar2 default null
   , p_firing_event  in varchar2 default null
   ) return integer;
end external_functions_tpk;
/


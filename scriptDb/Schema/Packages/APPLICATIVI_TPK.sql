CREATE OR REPLACE package applicativi_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        applicativi_tpk
 DESCRIZIONE: Gestione tabella APPLICATIVI.
 ANNOTAZIONI: .
 REVISIONI:   Table Revision: 07/03/2018 12:08:21
              SiaPKGen Revision: V1.05.014.
              SiaTPKDeclare Revision: V1.17.001.
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    04/05/2018  ADadamo  Generazione automatica. 
 </CODE>
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'APPLICATIVI';
   subtype t_rowtype is APPLICATIVI%rowtype;
   -- Tipo del record primary key
subtype t_id_applicativo  is APPLICATIVI.id_applicativo%type;
   type t_PK is record
   ( 
id_applicativo  t_id_applicativo
   );
   -- Versione e revisione
   function versione /* SLAVE_COPY */
   return varchar2;
   pragma restrict_references( versione, WNDS );
   -- Costruttore di record chiave
   function PK /* SLAVE_COPY */
   (
    p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return t_PK;
   pragma restrict_references( PK, WNDS );
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
    p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return number;
   pragma restrict_references( can_handle, WNDS );
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canHandle /* SLAVE_COPY */
   (
    p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return boolean;
   pragma restrict_references( canhandle, WNDS );
    -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
    p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return number;
   pragma restrict_references( exists_id, WNDS );
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsId /* SLAVE_COPY */
   (
    p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return boolean;
   pragma restrict_references( existsid, WNDS );
   -- Inserimento di una riga
   procedure ins
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type default null
   , p_descrizione  in APPLICATIVI.descrizione%type 
   , p_istanza  in APPLICATIVI.istanza%type default null
   , p_modulo  in APPLICATIVI.modulo%type default null
   , p_utente_aggiornamento  in APPLICATIVI.utente_aggiornamento%type default null
   , p_data_aggiornamento  in APPLICATIVI.data_aggiornamento%type default null
   );
   function ins  /*+ SOA  */
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type default null
   , p_descrizione  in APPLICATIVI.descrizione%type 
   , p_istanza  in APPLICATIVI.istanza%type default null
   , p_modulo  in APPLICATIVI.modulo%type default null
   , p_utente_aggiornamento  in APPLICATIVI.utente_aggiornamento%type default null
   , p_data_aggiornamento  in APPLICATIVI.data_aggiornamento%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd  /*+ SOA  */
   (
     p_check_OLD  in integer default 0
   , p_NEW_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_OLD_id_applicativo  in APPLICATIVI.id_applicativo%type default null
   , p_NEW_descrizione  in APPLICATIVI.descrizione%type default afc.default_null('APPLICATIVI.descrizione')
   , p_OLD_descrizione  in APPLICATIVI.descrizione%type default null
   , p_NEW_istanza  in APPLICATIVI.istanza%type default afc.default_null('APPLICATIVI.istanza')
   , p_OLD_istanza  in APPLICATIVI.istanza%type default null
   , p_NEW_modulo  in APPLICATIVI.modulo%type default afc.default_null('APPLICATIVI.modulo')
   , p_OLD_modulo  in APPLICATIVI.modulo%type default null
   , p_NEW_utente_aggiornamento  in APPLICATIVI.utente_aggiornamento%type default afc.default_null('APPLICATIVI.utente_aggiornamento')
   , p_OLD_utente_aggiornamento  in APPLICATIVI.utente_aggiornamento%type default null
   , p_NEW_data_aggiornamento  in APPLICATIVI.data_aggiornamento%type default afc.default_null('APPLICATIVI.data_aggiornamento')
   , p_OLD_data_aggiornamento  in APPLICATIVI.data_aggiornamento%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_column         in varchar2
   , p_value          in varchar2 default null
   , p_literal_value  in number   default 1
   );
   procedure upd_column
   (
p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_column in varchar2
   , p_value  in date
   );
   -- Cancellazione di una riga
   procedure del  /*+ SOA  */
   (
     p_check_OLD  in integer default 0
   , p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_descrizione  in APPLICATIVI.descrizione%type default null
   , p_istanza  in APPLICATIVI.istanza%type default null
   , p_modulo  in APPLICATIVI.modulo%type default null
   , p_utente_aggiornamento  in APPLICATIVI.utente_aggiornamento%type default null
   , p_data_aggiornamento  in APPLICATIVI.data_aggiornamento%type default null
   );
-- Getter per attributo descrizione di riga identificata da chiave
   function get_descrizione /* SLAVE_COPY */ 
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return APPLICATIVI.descrizione%type;
   pragma restrict_references( get_descrizione, WNDS );
-- Getter per attributo istanza di riga identificata da chiave
   function get_istanza /* SLAVE_COPY */ 
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return APPLICATIVI.istanza%type;
   pragma restrict_references( get_istanza, WNDS );
-- Getter per attributo modulo di riga identificata da chiave
   function get_modulo /* SLAVE_COPY */ 
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return APPLICATIVI.modulo%type;
   pragma restrict_references( get_modulo, WNDS );
-- Getter per attributo utente_aggiornamento di riga identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */ 
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return APPLICATIVI.utente_aggiornamento%type;
   pragma restrict_references( get_utente_aggiornamento, WNDS );
-- Getter per attributo data_aggiornamento di riga identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */ 
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   ) return APPLICATIVI.data_aggiornamento%type;
   pragma restrict_references( get_data_aggiornamento, WNDS );
-- Setter per attributo id_applicativo di riga identificata da chiave
   procedure set_id_applicativo
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_value  in APPLICATIVI.id_applicativo%type default null
   );
-- Setter per attributo descrizione di riga identificata da chiave
   procedure set_descrizione
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_value  in APPLICATIVI.descrizione%type default null
   );
-- Setter per attributo istanza di riga identificata da chiave
   procedure set_istanza
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_value  in APPLICATIVI.istanza%type default null
   );
-- Setter per attributo modulo di riga identificata da chiave
   procedure set_modulo
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_value  in APPLICATIVI.modulo%type default null
   );
-- Setter per attributo utente_aggiornamento di riga identificata da chiave
   procedure set_utente_aggiornamento
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_value  in APPLICATIVI.utente_aggiornamento%type default null
   );
-- Setter per attributo data_aggiornamento di riga identificata da chiave
   procedure set_data_aggiornamento
   (
     p_id_applicativo  in APPLICATIVI.id_applicativo%type
   , p_value  in APPLICATIVI.data_aggiornamento%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   ( p_QBE  in number default 0
   , p_other_condition in varchar2 default null
   , p_id_applicativo  in varchar2 default null
   , p_descrizione  in varchar2 default null
   , p_istanza  in varchar2 default null
   , p_modulo  in varchar2 default null
   , p_utente_aggiornamento  in varchar2 default null
   , p_data_aggiornamento  in varchar2 default null
   ) return AFC.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows  /*+ SOA  */ /* SLAVE_COPY */
   ( p_QBE  in number default 0
   , p_other_condition in varchar2 default null
   , p_order_by in varchar2 default null
   , p_extra_columns in varchar2 default null
   , p_extra_condition in varchar2 default null
   , p_id_applicativo  in varchar2 default null
   , p_descrizione  in varchar2 default null
   , p_istanza  in varchar2 default null
   , p_modulo  in varchar2 default null
   , p_utente_aggiornamento  in varchar2 default null
   , p_data_aggiornamento  in varchar2 default null
   ) return AFC.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   ( p_QBE in number default 0
   , p_other_condition in varchar2 default null
   , p_id_applicativo  in varchar2 default null
   , p_descrizione  in varchar2 default null
   , p_istanza  in varchar2 default null
   , p_modulo  in varchar2 default null
   , p_utente_aggiornamento  in varchar2 default null
   , p_data_aggiornamento  in varchar2 default null
   ) return integer;
end applicativi_tpk;
/


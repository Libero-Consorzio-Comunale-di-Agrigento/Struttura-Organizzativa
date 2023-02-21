CREATE OR REPLACE package P00_DIPENDENTI_SOGGETTI_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        P00_DIPENDENTI_SOGGETTI_tpk
 DESCRIZIONE: Gestione tabella P00_DIPENDENTI_SOGGETTI.
 ANNOTAZIONI: .
 REVISIONI:   Table Revision:
              SiaPKGen Revision: .
              SiaTPKDeclare Revision: .
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    30/10/2012  MSarti  Generazione automatica.
 </CODE>
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'P00_DIPENDENTI_SOGGETTI';
   subtype t_rowtype is P00_DIPENDENTI_SOGGETTI%rowtype;
   -- Tipo del record primary key
subtype t_ni_gp4  is P00_DIPENDENTI_SOGGETTI.ni_gp4%type;
   type t_PK is record
   (
ni_gp4  t_ni_gp4
   );
   -- Versione e revisione
   function versione /* SLAVE_COPY */
   return varchar2;
   pragma restrict_references( versione, WNDS );
   -- Costruttore di record chiave
   function PK /* SLAVE_COPY */
   (
    p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   ) return t_PK;
   pragma restrict_references( PK, WNDS );
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
    p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   ) return number;
   pragma restrict_references( can_handle, WNDS );
   -- Controllo integrita chiave
   -- wrapper boolean
   function canHandle /* SLAVE_COPY */
   (
    p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   ) return boolean;
   pragma restrict_references( canhandle, WNDS );
    -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
    p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   ) return number;
   pragma restrict_references( exists_id, WNDS );
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsId /* SLAVE_COPY */
   (
    p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   ) return boolean;
   pragma restrict_references( existsid, WNDS );
   -- Inserimento di una riga
   procedure ins
   (
     p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
   , p_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type
   );
   function ins  /*+ SOA  */
   (
     p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
   , p_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type
   ) return number;
   -- Aggiornamento di una riga
   procedure upd  /*+ SOA  */
   (
     p_check_OLD  in integer default 0
   , p_NEW_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   , p_OLD_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
   , p_NEW_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default afc.default_null('P00_DIPENDENTI_SOGGETTI.ni_as4')
   , p_OLD_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
     p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   , p_column         in varchar2
   , p_value          in varchar2 default null
   , p_literal_value  in number   default 1
   );
   -- Cancellazione di una riga
   procedure del  /*+ SOA  */
   (
     p_check_OLD  in integer default 0
   , p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   , p_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default null
   );
-- Getter per attributo ni_as4 di riga identificata da chiave
   function get_ni_as4 /* SLAVE_COPY */
   (
     p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   ) return P00_DIPENDENTI_SOGGETTI.ni_as4%type;
   pragma restrict_references( get_ni_as4, WNDS );
-- Setter per attributo ni_gp4 di riga identificata da chiave
   procedure set_ni_gp4
   (
     p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   , p_value  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
   );
-- Setter per attributo ni_as4 di riga identificata da chiave
   procedure set_ni_as4
   (
     p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
   , p_value  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   ( p_QBE  in number default 0
   , p_other_condition in varchar2 default null
   , p_ni_gp4  in varchar2 default null
   , p_ni_as4  in varchar2 default null
   ) return AFC.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows  /*+ SOA  */ /* SLAVE_COPY */
   ( p_QBE  in number default 0
   , p_other_condition in varchar2 default null
   , p_order_by in varchar2 default null
   , p_extra_columns in varchar2 default null
   , p_extra_condition in varchar2 default null
   , p_ni_gp4  in varchar2 default null
   , p_ni_as4  in varchar2 default null
   ) return AFC.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   ( p_QBE in number default 0
   , p_other_condition in varchar2 default null
   , p_ni_gp4  in varchar2 default null
   , p_ni_as4  in varchar2 default null
   ) return integer;
end P00_DIPENDENTI_SOGGETTI_tpk;
/


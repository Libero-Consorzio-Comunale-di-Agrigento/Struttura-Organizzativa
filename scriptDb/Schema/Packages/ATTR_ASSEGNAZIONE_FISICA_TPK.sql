CREATE OR REPLACE package attr_assegnazione_fisica_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        attr_assegnazione_fisica_tpk
    DESCRIZIONE: Gestione tabella ATTRIBUTI_ASSEGNAZIONE_FISICA.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    29/08/2012  mmonari  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'ATTRIBUTI_ASSEGNAZIONE_FISICA';
   subtype t_rowtype is attributi_assegnazione_fisica%rowtype;
   -- Tipo del record primary key
   subtype t_id_asfi is attributi_assegnazione_fisica.id_asfi%type;
   subtype t_attributo is attributi_assegnazione_fisica.attributo%type;
   subtype t_dal is attributi_assegnazione_fisica.dal%type;
   type t_pk is record(
       id_asfi   t_id_asfi
      ,attributo t_attributo
      ,dal       t_dal);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_asfi              in attributi_assegnazione_fisica.id_asfi%type default null
     ,p_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_asfi              in attributi_assegnazione_fisica.id_asfi%type default null
     ,p_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                in integer default 0
     ,p_new_id_asfi              in attributi_assegnazione_fisica.id_asfi%type
     ,p_old_id_asfi              in attributi_assegnazione_fisica.id_asfi%type default null
     ,p_new_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_old_attributo            in attributi_assegnazione_fisica.attributo%type default null
     ,p_new_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_old_dal                  in attributi_assegnazione_fisica.dal%type default null
     ,p_new_al                   in attributi_assegnazione_fisica.al%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.al')
     ,p_old_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_new_valore               in attributi_assegnazione_fisica.valore%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.valore')
     ,p_old_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_new_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.utente_aggiornamento')
     ,p_old_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.data_aggiornamento')
     ,p_old_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_asfi       in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo     in attributi_assegnazione_fisica.attributo%type
     ,p_dal           in attributi_assegnazione_fisica.dal%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_column    in varchar2
     ,p_value     in date
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old            in integer default 0
     ,p_id_asfi              in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
   );
   -- Getter per attributo al di riga identificata da chiave
   function get_al /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.al%type;
   pragma restrict_references(get_al, wnds);
   -- Getter per attributo valore di riga identificata da chiave
   function get_valore /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.valore%type;
   pragma restrict_references(get_valore, wnds);
   -- Getter per attributo utente_aggiornamento di riga identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Getter per attributo data_aggiornamento di riga identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Setter per attributo id_asfi di riga identificata da chiave
   procedure set_id_asfi
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.id_asfi%type default null
   );
   -- Setter per attributo attributo di riga identificata da chiave
   procedure set_attributo
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.attributo%type default null
   );
   -- Setter per attributo dal di riga identificata da chiave
   procedure set_dal
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.dal%type default null
   );
   -- Setter per attributo al di riga identificata da chiave
   procedure set_al
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.al%type default null
   );
   -- Setter per attributo valore di riga identificata da chiave
   procedure set_valore
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.valore%type default null
   );
   -- Setter per attributo utente_aggiornamento di riga identificata da chiave
   procedure set_utente_aggiornamento
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.utente_aggiornamento%type default null
   );
   -- Setter per attributo data_aggiornamento di riga identificata da chiave
   procedure set_data_aggiornamento
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.data_aggiornamento%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_asfi              in varchar2 default null
     ,p_attributo            in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_valore               in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_id_asfi              in varchar2 default null
     ,p_attributo            in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_valore               in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_asfi              in varchar2 default null
     ,p_attributo            in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_valore               in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return integer;
end attr_assegnazione_fisica_tpk;
/


CREATE OR REPLACE package ruoli_profilo_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        ruoli_profilo_tpk
    DESCRIZIONE: Gestione tabella RUOLI_PROFILO.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    07/07/2014  mmonari  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'RUOLI_PROFILO';
   subtype t_rowtype is ruoli_profilo%rowtype;
   -- Tipo del record primary key
   subtype t_id_ruolo_profilo is ruoli_profilo.id_ruolo_profilo%type;
   type t_pk is record(
       id_ruolo_profilo t_id_ruolo_profilo);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type default null
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_dal                  in ruoli_profilo.dal%type default null
     ,p_al                   in ruoli_profilo.al%type default null
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type default null
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_dal                  in ruoli_profilo.dal%type default null
     ,p_al                   in ruoli_profilo.al%type default null
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                in integer default 0
     ,p_new_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type
     ,p_old_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type default null
     ,p_new_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default afc.default_null('RUOLI_PROFILO.id_profilo')
     ,p_old_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_new_ruolo                in ruoli_profilo.ruolo%type default afc.default_null('RUOLI_PROFILO.ruolo')
     ,p_old_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_new_dal                  in ruoli_profilo.dal%type default afc.default_null('RUOLI_PROFILO.dal')
     ,p_old_dal                  in ruoli_profilo.dal%type default null
     ,p_new_al                   in ruoli_profilo.al%type default afc.default_null('RUOLI_PROFILO.al')
     ,p_old_al                   in ruoli_profilo.al%type default null
     ,p_new_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default afc.default_null('RUOLI_PROFILO.utente_aggiornamento')
     ,p_old_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default afc.default_null('RUOLI_PROFILO.data_aggiornamento')
     ,p_old_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_column           in varchar2
     ,p_value            in varchar2 default null
     ,p_literal_value    in number default 1
   );
   procedure upd_column
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_column           in varchar2
     ,p_value            in date
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old            in integer default 0
     ,p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_dal                  in ruoli_profilo.dal%type default null
     ,p_al                   in ruoli_profilo.al%type default null
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   );
   -- Getter per attributo id_profilo di riga identificata da chiave
   function get_ruolo_profilo /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.ruolo_profilo%type;
   pragma restrict_references(get_ruolo_profilo, wnds);
   -- Getter per attributo ruolo di riga identificata da chiave
   function get_ruolo /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.ruolo%type;
   pragma restrict_references(get_ruolo, wnds);
   -- Getter per attributo dal di riga identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return ruoli_profilo.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Getter per attributo al di riga identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return ruoli_profilo.al%type;
   pragma restrict_references(get_al, wnds);
   -- Getter per attributo utente_aggiornamento di riga identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Getter per attributo data_aggiornamento di riga identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Setter per attributo id_ruolo_profilo di riga identificata da chiave
   procedure set_id_ruolo_profilo
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.id_ruolo_profilo%type default null
   );
   -- Setter per attributo id_profilo di riga identificata da chiave
   procedure set_id_profilo
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.ruolo_profilo%type default null
   );
   -- Setter per attributo ruolo di riga identificata da chiave
   procedure set_ruolo
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.ruolo%type default null
   );
   -- Setter per attributo dal di riga identificata da chiave
   procedure set_dal
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.dal%type default null
   );
   -- Setter per attributo al di riga identificata da chiave
   procedure set_al
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.al%type default null
   );
   -- Setter per attributo utente_aggiornamento di riga identificata da chiave
   procedure set_utente_aggiornamento
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.utente_aggiornamento%type default null
   );
   -- Setter per attributo data_aggiornamento di riga identificata da chiave
   procedure set_data_aggiornamento
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.data_aggiornamento%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_ruolo_profilo     in varchar2 default null
     ,p_id_profilo           in varchar2 default null
     ,p_ruolo                in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
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
     ,p_id_ruolo_profilo     in varchar2 default null
     ,p_id_profilo           in varchar2 default null
     ,p_ruolo                in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_ruolo_profilo     in varchar2 default null
     ,p_id_profilo           in varchar2 default null
     ,p_ruolo                in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return integer;
end ruoli_profilo_tpk;
/


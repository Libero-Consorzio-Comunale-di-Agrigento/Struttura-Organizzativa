CREATE OR REPLACE package deleghe_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        deleghe_tpk
 DESCRIZIONE: Gestione tabella DELEGHE.
 ANNOTAZIONI: .
 REVISIONI:   Table Revision: 07/03/2018 15:12:25
              SiaPKGen Revision: V1.05.014.
              SiaTPKDeclare Revision: V1.17.001.
 <CODE>
 Rev.  Data        Autore      Descrizione.
    00    22/11/2017  MMonari  Generazione automatica.
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'DELEGHE';
   subtype t_rowtype is deleghe%rowtype;
   -- Tipo del record primary key
   subtype t_id_delega is deleghe.id_delega%type;
   type t_pk is record(
       id_delega t_id_delega);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_delega                 in deleghe.id_delega%type default null
     ,p_delegante                 in deleghe.delegante%type
     ,p_delegato                  in deleghe.delegato%type
     ,p_ottica                    in deleghe.ottica%type default null
     ,p_progr_unita_organizzativa in deleghe.progr_unita_organizzativa%type default null
     ,p_ruolo                     in deleghe.ruolo%type default null
     ,p_id_competenza_delega      in deleghe.id_competenza_delega%type default null
     ,p_dal                       in deleghe.dal%type
     ,p_al                        in deleghe.al%type default null
     ,p_utente_aggiornamento      in deleghe.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in deleghe.data_aggiornamento%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_delega                 in deleghe.id_delega%type default null
     ,p_delegante                 in deleghe.delegante%type
     ,p_delegato                  in deleghe.delegato%type
     ,p_ottica                    in deleghe.ottica%type default null
     ,p_progr_unita_organizzativa in deleghe.progr_unita_organizzativa%type default null
     ,p_ruolo                     in deleghe.ruolo%type default null
     ,p_id_competenza_delega      in deleghe.id_competenza_delega%type default null
     ,p_dal                       in deleghe.dal%type
     ,p_al                        in deleghe.al%type default null
     ,p_utente_aggiornamento      in deleghe.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in deleghe.data_aggiornamento%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                    in integer default 0
     ,p_new_id_delega                in deleghe.id_delega%type
     ,p_old_id_delega                in deleghe.id_delega%type default null
     ,p_new_delegante                in deleghe.delegante%type default afc.default_null('DELEGHE.delegante')
     ,p_old_delegante                in deleghe.delegante%type default null
     ,p_new_delegato                 in deleghe.delegato%type default afc.default_null('DELEGHE.delegato')
     ,p_old_delegato                 in deleghe.delegato%type default null
     ,p_new_ottica                   in deleghe.ottica%type default afc.default_null('DELEGHE.ottica')
     ,p_old_ottica                   in deleghe.ottica%type default null
     ,p_new_progr_unita_organizzativ in deleghe.progr_unita_organizzativa%type default afc.default_null('DELEGHE.progr_unita_organizzativa')
     ,p_old_progr_unita_organizzativ in deleghe.progr_unita_organizzativa%type default null
     ,p_new_ruolo                    in deleghe.ruolo%type default afc.default_null('DELEGHE.ruolo')
     ,p_old_ruolo                    in deleghe.ruolo%type default null
     ,p_new_id_competenza_delega     in deleghe.id_competenza_delega%type default afc.default_null('DELEGHE.id_competenza_delega')
     ,p_old_id_competenza_delega     in deleghe.id_competenza_delega%type default null
     ,p_new_dal                      in deleghe.dal%type default afc.default_null('DELEGHE.dal')
     ,p_old_dal                      in deleghe.dal%type default null
     ,p_new_al                       in deleghe.al%type default afc.default_null('DELEGHE.al')
     ,p_old_al                       in deleghe.al%type default null
     ,p_new_utente_aggiornamento     in deleghe.utente_aggiornamento%type default afc.default_null('DELEGHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento     in deleghe.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento       in deleghe.data_aggiornamento%type default afc.default_null('DELEGHE.data_aggiornamento')
     ,p_old_data_aggiornamento       in deleghe.data_aggiornamento%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_delega     in deleghe.id_delega%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_id_delega in deleghe.id_delega%type
     ,p_column    in varchar2
     ,p_value     in date
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old                 in integer default 0
     ,p_id_delega                 in deleghe.id_delega%type
     ,p_delegante                 in deleghe.delegante%type default null
     ,p_delegato                  in deleghe.delegato%type default null
     ,p_ottica                    in deleghe.ottica%type default null
     ,p_progr_unita_organizzativa in deleghe.progr_unita_organizzativa%type default null
     ,p_ruolo                     in deleghe.ruolo%type default null
     ,p_id_competenza_delega      in deleghe.id_competenza_delega%type default null
     ,p_dal                       in deleghe.dal%type default null
     ,p_al                        in deleghe.al%type default null
     ,p_utente_aggiornamento      in deleghe.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in deleghe.data_aggiornamento%type default null
   );
   -- Getter per attributo delegante di riga identificata da chiave
   function get_delegante /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.delegante%type;
   pragma restrict_references(get_delegante, wnds);
   -- Getter per attributo delegato di riga identificata da chiave
   function get_delegato /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.delegato%type;
   pragma restrict_references(get_delegato, wnds);
   -- Getter per attributo ottica di riga identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Getter per attributo progr_unita_organizzativa di riga identificata da chiave
   function get_progr_unita_organizzativa /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita_organizzativa, wnds);
   -- Getter per attributo ruolo di riga identificata da chiave
   function get_ruolo /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.ruolo%type;
   pragma restrict_references(get_ruolo, wnds);
   -- Getter per attributo id_competenza_delega di riga identificata da chiave
   function get_id_competenza_delega /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.id_competenza_delega%type;
   pragma restrict_references(get_id_competenza_delega, wnds);
   -- Getter per attributo dal di riga identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Getter per attributo al di riga identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.al%type;
   pragma restrict_references(get_al, wnds);
   -- Getter per attributo utente_aggiornamento di riga identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Getter per attributo data_aggiornamento di riga identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_delega in deleghe.id_delega%type) return deleghe.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Setter per attributo id_delega di riga identificata da chiave
   procedure set_id_delega
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.id_delega%type default null
   );
   -- Setter per attributo delegante di riga identificata da chiave
   procedure set_delegante
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.delegante%type default null
   );
   -- Setter per attributo delegato di riga identificata da chiave
   procedure set_delegato
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.delegato%type default null
   );
   -- Setter per attributo ottica di riga identificata da chiave
   procedure set_ottica
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.ottica%type default null
   );
   -- Setter per attributo progr_unita_organizzativa di riga identificata da chiave
   procedure set_progr_unita_organizzativa
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.progr_unita_organizzativa%type default null
   );
   -- Setter per attributo ruolo di riga identificata da chiave
   procedure set_ruolo
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.ruolo%type default null
   );
   -- Setter per attributo id_competenza_delega di riga identificata da chiave
   procedure set_id_competenza_delega
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.id_competenza_delega%type default null
   );
   -- Setter per attributo dal di riga identificata da chiave
   procedure set_dal
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.dal%type default null
   );
   -- Setter per attributo al di riga identificata da chiave
   procedure set_al
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.al%type default null
   );
   -- Setter per attributo utente_aggiornamento di riga identificata da chiave
   procedure set_utente_aggiornamento
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.utente_aggiornamento%type default null
   );
   -- Setter per attributo data_aggiornamento di riga identificata da chiave
   procedure set_data_aggiornamento
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.data_aggiornamento%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_delega                 in varchar2 default null
     ,p_delegante                 in varchar2 default null
     ,p_delegato                  in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_ruolo                     in varchar2 default null
     ,p_id_competenza_delega      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */
      /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_order_by                  in varchar2 default null
     ,p_extra_columns             in varchar2 default null
     ,p_extra_condition           in varchar2 default null
     ,p_id_delega                 in varchar2 default null
     ,p_delegante                 in varchar2 default null
     ,p_delegato                  in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_ruolo                     in varchar2 default null
     ,p_id_competenza_delega      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_delega                 in varchar2 default null
     ,p_delegante                 in varchar2 default null
     ,p_delegato                  in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_ruolo                     in varchar2 default null
     ,p_id_competenza_delega      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
   ) return integer;
end deleghe_tpk;
/


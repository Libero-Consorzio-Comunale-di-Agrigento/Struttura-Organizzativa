CREATE OR REPLACE package modifica_componente is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        modifica_componente
    DESCRIZIONE: Gestione tabella MODIFICHE_COMPONENTI.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision:
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    12/08/2011  mmonari  Generazione automatica.
    01    02/07/2012  mmonari  Consolidamento rel.1.4.1
    02    02/11/2012  Adadamo  Modifica alla aggiorna_ottica_derivata per gestione
                               commit
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.02';
   s_table_name constant afc.t_object_name := 'MODIFICHE_COMPONENTI';
   subtype t_rowtype is modifiche_componenti%rowtype;
   -- Tipo del record primary key
   subtype t_id_modifica is modifiche_componenti.id_modifica%type;
   type t_pk is record(
       id_modifica t_id_modifica);
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_number constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg    constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   modifica_non_applicabile exception;
   pragma exception_init(dal_al_errato, -20901);
   s_mod_non_applicabile_number constant afc_error.t_error_number := -20902;
   s_mod_non_applicabile_msg    constant afc_error.t_error_msg := 'Modifica non applicabile sull''ottica derivata';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_modifica             in modifiche_componenti.id_modifica%type default null
     ,p_ottica                  in modifiche_componenti.ottica%type
     ,p_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_operazione              in modifiche_componenti.operazione%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_modifica             in modifiche_componenti.id_modifica%type default null
     ,p_ottica                  in modifiche_componenti.ottica%type
     ,p_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_operazione              in modifiche_componenti.operazione%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                   in integer default 0
     ,p_new_id_modifica             in modifiche_componenti.id_modifica%type
     ,p_old_id_modifica             in modifiche_componenti.id_modifica%type default null
     ,p_new_ottica                  in modifiche_componenti.ottica%type default afc.default_null('MODIFICHE_COMPONENTI.ottica')
     ,p_old_ottica                  in modifiche_componenti.ottica%type default null
     ,p_new_id_componente           in modifiche_componenti.id_componente%type default afc.default_null('MODIFICHE_COMPONENTI.id_componente')
     ,p_old_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_new_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default afc.default_null('MODIFICHE_COMPONENTI.id_attributo_componente')
     ,p_old_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_new_operazione              in modifiche_componenti.operazione%type default afc.default_null('MODIFICHE_COMPONENTI.operazione')
     ,p_old_operazione              in modifiche_componenti.operazione%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_modifica   in modifiche_componenti.id_modifica%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old               in integer default 0
     ,p_id_modifica             in modifiche_componenti.id_modifica%type
     ,p_ottica                  in modifiche_componenti.ottica%type default null
     ,p_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_operazione              in modifiche_componenti.operazione%type default null
   );
   -- Getter per attributo ottica di riga identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Getter per attributo id_componente di riga identificata da chiave
   function get_id_componente /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.id_componente%type;
   pragma restrict_references(get_id_componente, wnds);
   -- Getter per attributo id_attributo_componente di riga identificata da chiave
   function get_id_attributo_componente /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.id_attributo_componente%type;
   pragma restrict_references(get_id_attributo_componente, wnds);
   -- Getter per attributo operazione di riga identificata da chiave
   function get_operazione /* SLAVE_COPY */
   (p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.operazione%type;
   pragma restrict_references(get_operazione, wnds);
   -- Setter per attributo id_modifica di riga identificata da chiave
   procedure set_id_modifica
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.id_modifica%type default null
   );
   -- Setter per attributo ottica di riga identificata da chiave
   procedure set_ottica
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.ottica%type default null
   );
   -- Setter per attributo id_componente di riga identificata da chiave
   procedure set_id_componente
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.id_componente%type default null
   );
   -- Setter per attributo id_attributo_componente di riga identificata da chiave
   procedure set_id_attributo_componente
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.id_attributo_componente%type default null
   );
   -- Setter per attributo operazione di riga identificata da chiave
   procedure set_operazione
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.operazione%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                     in number default 0
     ,p_other_condition         in varchar2 default null
     ,p_id_modifica             in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_id_attributo_componente in varchar2 default null
     ,p_operazione              in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe                     in number default 0
     ,p_other_condition         in varchar2 default null
     ,p_order_by                in varchar2 default null
     ,p_extra_columns           in varchar2 default null
     ,p_extra_condition         in varchar2 default null
     ,p_id_modifica             in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_id_attributo_componente in varchar2 default null
     ,p_operazione              in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                     in number default 0
     ,p_other_condition         in varchar2 default null
     ,p_id_modifica             in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_id_attributo_componente in varchar2 default null
     ,p_operazione              in varchar2 default null
   ) return integer;
   -- Determinazione del progressivo in inserimento di nuova
   -- modifica
   function get_id return modifiche_componenti.id_modifica%type;
   pragma restrict_references(get_id, wnds);
   procedure aggiorna_ottica_derivata
   (
      p_id_modifica            in modifiche_componenti.id_modifica%type
     ,p_ottica_derivata        in ottiche.ottica%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
     ,p_trigger                in number default 0
   );
end modifica_componente;
/


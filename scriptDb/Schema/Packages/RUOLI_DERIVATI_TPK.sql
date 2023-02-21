CREATE OR REPLACE package ruoli_derivati_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        ruoli_derivati_tpk
    DESCRIZIONE: Gestione tabella RUOLI_DERIVATI.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    07/07/2014  mmonari  Generazione automatica.  Feature #430
    01    07/08/2015  mmonari  #634
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.01';
   s_table_name constant afc.t_object_name := 'RUOLI_DERIVATI';
   subtype t_rowtype is ruoli_derivati%rowtype;
   -- Tipo del record primary key
   subtype t_id_ruolo_derivato is ruoli_derivati.id_ruolo_derivato%type;
   type t_pk is record(
       id_ruolo_derivato t_id_ruolo_derivato);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type default null
     ,p_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_id_profilo          in ruoli_derivati.id_profilo%type default null
     ,p_id_relazione        in ruoli_derivati.id_relazione%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type default null
     ,p_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_id_profilo          in ruoli_derivati.id_profilo%type default null
     ,p_id_relazione        in ruoli_derivati.id_relazione%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old               in integer default 0
     ,p_new_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type
     ,p_old_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type default null
     ,p_new_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default afc.default_null('RUOLI_DERIVATI.id_ruolo_componente')
     ,p_old_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_new_id_profilo          in ruoli_derivati.id_profilo%type default afc.default_null('RUOLI_DERIVATI.id_profilo')
     ,p_old_id_profilo          in ruoli_derivati.id_profilo%type default null
     ,p_new_id_relazione        in ruoli_derivati.id_relazione%type default afc.default_null('RUOLI_DERIVATI.id_relazione')
     ,p_old_id_relazione        in ruoli_derivati.id_relazione%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_column            in varchar2
     ,p_value             in varchar2 default null
     ,p_literal_value     in number default 1
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old           in integer default 0
     ,p_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type
     ,p_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_id_profilo          in ruoli_derivati.id_profilo%type default null
   );
   -- Getter per attributo id_ruolo_componente di riga identificata da chiave
   function get_id_ruolo_componente /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return ruoli_derivati.id_ruolo_componente%type;
   pragma restrict_references(get_id_ruolo_componente, wnds);
   -- Getter per attributo id_profilo di riga identificata da chiave
   function get_id_profilo /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return ruoli_derivati.id_profilo%type;
   pragma restrict_references(get_id_profilo, wnds);
   function get_id_relazione /* SLAVE_COPY */
   (p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return ruoli_derivati.id_relazione%type;
   pragma restrict_references(get_id_relazione, wnds);
   -- Setter per attributo id_ruolo_derivato di riga identificata da chiave
   procedure set_id_ruolo_derivato
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_value             in ruoli_derivati.id_ruolo_derivato%type default null
   );
   -- Setter per attributo id_ruolo_componente di riga identificata da chiave
   procedure set_id_ruolo_componente
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_value             in ruoli_derivati.id_ruolo_componente%type default null
   );
   -- Setter per attributo id_profilo di riga identificata da chiave
   procedure set_id_profilo
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_value             in ruoli_derivati.id_profilo%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                 in number default 0
     ,p_other_condition     in varchar2 default null
     ,p_id_ruolo_derivato   in varchar2 default null
     ,p_id_ruolo_componente in varchar2 default null
     ,p_id_profilo          in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe                 in number default 0
     ,p_other_condition     in varchar2 default null
     ,p_order_by            in varchar2 default null
     ,p_extra_columns       in varchar2 default null
     ,p_extra_condition     in varchar2 default null
     ,p_id_ruolo_derivato   in varchar2 default null
     ,p_id_ruolo_componente in varchar2 default null
     ,p_id_profilo          in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                 in number default 0
     ,p_other_condition     in varchar2 default null
     ,p_id_ruolo_derivato   in varchar2 default null
     ,p_id_ruolo_componente in varchar2 default null
     ,p_id_profilo          in varchar2 default null
   ) return integer;
end ruoli_derivati_tpk;
/


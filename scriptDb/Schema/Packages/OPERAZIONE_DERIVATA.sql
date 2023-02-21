CREATE OR REPLACE package operazione_derivata is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        operazioni_derivate_tpk
    DESCRIZIONE: Gestione tabella OPERAZIONI_DERIVATE.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision:
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    21/09/2011  mmonari  Generazione automatica.
    01    02/07/2012  mmonari  Consolidamento rel.1.4.1
    02    01/09/2014  mmonari  Bug #485
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V2.00';
   s_table_name constant afc.t_object_name := 'OPERAZIONI_DERIVATE';
   subtype t_rowtype is operazioni_derivate%rowtype;
   -- Tipo del record primary key
   subtype t_id_modifica is operazioni_derivate.id_modifica%type;
   type t_pk is record(
       id_modifica t_id_modifica);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type
     ,p_esecuzione  in operazioni_derivate.esecuzione%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type
     ,p_esecuzione  in operazioni_derivate.esecuzione%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old       in integer default 0
     ,p_new_id_modifica in operazioni_derivate.id_modifica%type
     ,p_old_id_modifica in operazioni_derivate.id_modifica%type default null
     ,p_new_ottica      in operazioni_derivate.ottica%type default afc.default_null('OPERAZIONI_DERIVATE.ottica')
     ,p_old_ottica      in operazioni_derivate.ottica%type default null
     ,p_new_esecuzione  in operazioni_derivate.esecuzione%type default afc.default_null('OPERAZIONI_DERIVATE.esecuzione')
     ,p_old_esecuzione  in operazioni_derivate.esecuzione%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_modifica   in operazioni_derivate.id_modifica%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old   in integer default 0
     ,p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type default null
     ,p_esecuzione  in operazioni_derivate.esecuzione%type default null
   );
   -- Getter per attributo ottica di riga identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type)
      return operazioni_derivate.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Getter per attributo esecuzione di riga identificata da chiave
   function get_esecuzione /* SLAVE_COPY */
   (p_id_modifica in operazioni_derivate.id_modifica%type)
      return operazioni_derivate.esecuzione%type;
   pragma restrict_references(get_esecuzione, wnds);
   -- Setter per attributo id_modifica di riga identificata da chiave
   procedure set_id_modifica
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_value       in operazioni_derivate.id_modifica%type default null
   );
   -- Setter per attributo ottica di riga identificata da chiave
   procedure set_ottica
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_value       in operazioni_derivate.ottica%type default null
   );
   -- Setter per attributo esecuzione di riga identificata da chiave
   procedure set_esecuzione
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type
     ,p_value       in operazioni_derivate.esecuzione%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_modifica     in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_esecuzione      in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_order_by        in varchar2 default null
     ,p_extra_columns   in varchar2 default null
     ,p_extra_condition in varchar2 default null
     ,p_id_modifica     in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_esecuzione      in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_modifica     in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_esecuzione      in varchar2 default null
   ) return integer;
end operazione_derivata;
/


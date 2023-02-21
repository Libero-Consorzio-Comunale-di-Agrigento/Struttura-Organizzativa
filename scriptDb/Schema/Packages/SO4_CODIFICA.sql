CREATE OR REPLACE package so4_codifica is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        so4_codifiche_tpk
    DESCRIZIONE: Gestione tabella SO4_CODIFICHE.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    08/06/2012  mmonari  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'SO4_CODIFICHE';
   subtype t_rowtype is so4_codifiche%rowtype;
   -- Tipo del record primary key
   subtype t_id_codifica is so4_codifiche.id_codifica%type;
   type t_pk is record(
       id_codifica t_id_codifica);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_codifica    in so4_codifiche.id_codifica%type default null
     ,p_dominio        in so4_codifiche.dominio%type
     ,p_valore         in so4_codifiche.valore%type
     ,p_descrizione    in so4_codifiche.descrizione%type
     ,p_valore_default in so4_codifiche.valore_default%type default 0
     ,p_sequenza       in so4_codifiche.sequenza%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_codifica    in so4_codifiche.id_codifica%type default null
     ,p_dominio        in so4_codifiche.dominio%type
     ,p_valore         in so4_codifiche.valore%type
     ,p_descrizione    in so4_codifiche.descrizione%type
     ,p_valore_default in so4_codifiche.valore_default%type default 0
     ,p_sequenza       in so4_codifiche.sequenza%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old          in integer default 0
     ,p_new_id_codifica    in so4_codifiche.id_codifica%type
     ,p_old_id_codifica    in so4_codifiche.id_codifica%type default null
     ,p_new_dominio        in so4_codifiche.dominio%type default afc.default_null('SO4_CODIFICHE.dominio')
     ,p_old_dominio        in so4_codifiche.dominio%type default null
     ,p_new_valore         in so4_codifiche.valore%type default afc.default_null('SO4_CODIFICHE.valore')
     ,p_old_valore         in so4_codifiche.valore%type default null
     ,p_new_descrizione    in so4_codifiche.descrizione%type default afc.default_null('SO4_CODIFICHE.descrizione')
     ,p_old_descrizione    in so4_codifiche.descrizione%type default null
     ,p_new_valore_default in so4_codifiche.valore_default%type default afc.default_null('SO4_CODIFICHE.valore_default')
     ,p_old_valore_default in so4_codifiche.valore_default%type default null
     ,p_new_sequenza       in so4_codifiche.sequenza%type default afc.default_null('SO4_CODIFICHE.sequenza')
     ,p_old_sequenza       in so4_codifiche.sequenza%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_codifica   in so4_codifiche.id_codifica%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old      in integer default 0
     ,p_id_codifica    in so4_codifiche.id_codifica%type
     ,p_dominio        in so4_codifiche.dominio%type default null
     ,p_valore         in so4_codifiche.valore%type default null
     ,p_descrizione    in so4_codifiche.descrizione%type default null
     ,p_valore_default in so4_codifiche.valore_default%type default null
     ,p_sequenza       in so4_codifiche.sequenza%type default null
   );
   -- Getter per attributo dominio di riga identificata da chiave
   function get_dominio /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return so4_codifiche.dominio%type;
   pragma restrict_references(get_dominio, wnds);
   -- Getter per attributo valore di riga identificata da chiave
   function get_valore /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return so4_codifiche.valore%type;
   pragma restrict_references(get_valore, wnds);
   -- Getter per attributo descrizione di riga identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return so4_codifiche.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);
   -- Getter per descrizione dato il valore e dominio
   function get_descrizione /* SLAVE_COPY */
   (
      p_dominio in so4_codifiche.dominio%type
     ,p_valore  in so4_codifiche.valore%type
   ) return so4_codifiche.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);
   -- Getter per attributo valore_default di riga identificata da chiave
   function get_valore_default /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type)
      return so4_codifiche.valore_default%type;
   pragma restrict_references(get_valore_default, wnds);
   -- Getter per attributo sequenza di riga identificata da chiave
   function get_sequenza /* SLAVE_COPY */
   (p_id_codifica in so4_codifiche.id_codifica%type) return so4_codifiche.sequenza%type;
   pragma restrict_references(get_sequenza, wnds);
   -- Setter per attributo id_codifica di riga identificata da chiave
   procedure set_id_codifica
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.id_codifica%type default null
   );
   -- Setter per attributo dominio di riga identificata da chiave
   procedure set_dominio
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.dominio%type default null
   );
   -- Setter per attributo valore di riga identificata da chiave
   procedure set_valore
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.valore%type default null
   );
   -- Setter per attributo descrizione di riga identificata da chiave
   procedure set_descrizione
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.descrizione%type default null
   );
   -- Setter per attributo valore_default di riga identificata da chiave
   procedure set_valore_default
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.valore_default%type default null
   );
   -- Setter per attributo sequenza di riga identificata da chiave
   procedure set_sequenza
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.sequenza%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_codifica     in varchar2 default null
     ,p_dominio         in varchar2 default null
     ,p_valore          in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_valore_default  in varchar2 default null
     ,p_sequenza        in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_order_by        in varchar2 default null
     ,p_extra_columns   in varchar2 default null
     ,p_extra_condition in varchar2 default null
     ,p_id_codifica     in varchar2 default null
     ,p_dominio         in varchar2 default null
     ,p_valore          in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_valore_default  in varchar2 default null
     ,p_sequenza        in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_codifica     in varchar2 default null
     ,p_dominio         in varchar2 default null
     ,p_valore          in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_valore_default  in varchar2 default null
     ,p_sequenza        in varchar2 default null
   ) return integer;
end so4_codifica;
/


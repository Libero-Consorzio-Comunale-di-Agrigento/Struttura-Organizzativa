CREATE OR REPLACE package codici_ipa_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        codici_ipa_tpk
    DESCRIZIONE: Gestione tabella CODICI_IPA.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    16/02/2017  SO4  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'CODICI_IPA';
   subtype t_rowtype is codici_ipa%rowtype;
   -- Tipo del record primary key
   subtype t_tipo_entita is codici_ipa.tipo_entita%type;
   subtype t_progressivo is codici_ipa.progressivo%type;
   type t_pk is record(
       tipo_entita t_tipo_entita
      ,progressivo t_progressivo);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_progressivo      in codici_ipa.progressivo%type default null
     ,p_codice_originale in codici_ipa.codice_originale%type
   );
   function ins /*+ SOA  */
   (
      p_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_progressivo      in codici_ipa.progressivo%type default null
     ,p_codice_originale in codici_ipa.codice_originale%type
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old            in integer default 0
     ,p_new_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_old_tipo_entita      in codici_ipa.tipo_entita%type default null
     ,p_new_progressivo      in codici_ipa.progressivo%type
     ,p_old_progressivo      in codici_ipa.progressivo%type default null
     ,p_new_codice_originale in codici_ipa.codice_originale%type default afc.default_null('CODICI_IPA.codice_originale')
     ,p_old_codice_originale in codici_ipa.codice_originale%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_tipo_entita   in codici_ipa.tipo_entita%type
     ,p_progressivo   in codici_ipa.progressivo%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old        in integer default 0
     ,p_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_progressivo      in codici_ipa.progressivo%type
     ,p_codice_originale in codici_ipa.codice_originale%type default null
   );
   -- Getter per attributo codice_originale di riga identificata da chiave
   function get_codice_originale /* SLAVE_COPY */
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return codici_ipa.codice_originale%type;
   pragma restrict_references(get_codice_originale, wnds);
   -- Setter per attributo tipo_entita di riga identificata da chiave
   procedure set_tipo_entita
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
     ,p_value       in codici_ipa.tipo_entita%type default null
   );
   -- Setter per attributo progressivo di riga identificata da chiave
   procedure set_progressivo
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
     ,p_value       in codici_ipa.progressivo%type default null
   );
   -- Setter per attributo codice_originale di riga identificata da chiave
   procedure set_codice_originale
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
     ,p_value       in codici_ipa.codice_originale%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe              in number default 0
     ,p_other_condition  in varchar2 default null
     ,p_tipo_entita      in varchar2 default null
     ,p_progressivo      in varchar2 default null
     ,p_codice_originale in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe              in number default 0
     ,p_other_condition  in varchar2 default null
     ,p_order_by         in varchar2 default null
     ,p_extra_columns    in varchar2 default null
     ,p_extra_condition  in varchar2 default null
     ,p_tipo_entita      in varchar2 default null
     ,p_progressivo      in varchar2 default null
     ,p_codice_originale in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe              in number default 0
     ,p_other_condition  in varchar2 default null
     ,p_tipo_entita      in varchar2 default null
     ,p_progressivo      in varchar2 default null
     ,p_codice_originale in varchar2 default null
   ) return integer;
end codici_ipa_tpk;
/


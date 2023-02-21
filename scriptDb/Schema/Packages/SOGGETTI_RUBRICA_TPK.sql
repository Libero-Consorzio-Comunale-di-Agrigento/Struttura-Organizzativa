CREATE OR REPLACE package soggetti_rubrica_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        soggetti_rubrica_tpk
    DESCRIZIONE: Gestione tabella SOGGETTI_RUBRICA.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 11/01/2012 11:49:24
                 SiaPKGen Revision: V1.05.014.
                 SiaTPKDeclare Revision: V1.17.001.
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    09/11/2009  VDAVALLI  Prima emissione.
    01    16/01/2012  vdavalli  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.01';
   s_table_name constant afc.t_object_name := 'SOGGETTI_RUBRICA';
   subtype t_rowtype is soggetti_rubrica%rowtype;
   -- Tipo del record primary key
   subtype t_ni is soggetti_rubrica.ni%type;
   subtype t_tipo_contatto is soggetti_rubrica.tipo_contatto%type;
   subtype t_progressivo is soggetti_rubrica.progressivo%type;
   type t_pk is record(
       ni            t_ni
      ,tipo_contatto t_tipo_contatto
      ,progressivo   t_progressivo);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_ni                   in soggetti_rubrica.ni%type default null
     ,p_tipo_contatto        in soggetti_rubrica.tipo_contatto%type default null
     ,p_progressivo          in soggetti_rubrica.progressivo%type default null
     ,p_contatto             in soggetti_rubrica.contatto%type
     ,p_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
   );
   function ins /*+ SOA  */
   (
      p_ni                   in soggetti_rubrica.ni%type default null
     ,p_tipo_contatto        in soggetti_rubrica.tipo_contatto%type default null
     ,p_progressivo          in soggetti_rubrica.progressivo%type default null
     ,p_contatto             in soggetti_rubrica.contatto%type
     ,p_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                in integer default 0
     ,p_new_ni                   in soggetti_rubrica.ni%type
     ,p_old_ni                   in soggetti_rubrica.ni%type default null
     ,p_new_tipo_contatto        in soggetti_rubrica.tipo_contatto%type
     ,p_old_tipo_contatto        in soggetti_rubrica.tipo_contatto%type default null
     ,p_new_progressivo          in soggetti_rubrica.progressivo%type
     ,p_old_progressivo          in soggetti_rubrica.progressivo%type default null
     ,p_new_contatto             in soggetti_rubrica.contatto%type default afc.default_null('SOGGETTI_RUBRICA.contatto')
     ,p_old_contatto             in soggetti_rubrica.contatto%type default null
     ,p_new_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default afc.default_null('SOGGETTI_RUBRICA.riferimento_tipo')
     ,p_old_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_new_riferimento          in soggetti_rubrica.riferimento%type default afc.default_null('SOGGETTI_RUBRICA.riferimento')
     ,p_old_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_new_pubblicabile         in soggetti_rubrica.pubblicabile%type default afc.default_null('SOGGETTI_RUBRICA.pubblicabile')
     ,p_old_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_new_utente_agg           in soggetti_rubrica.utente_agg%type default afc.default_null('SOGGETTI_RUBRICA.utente_agg')
     ,p_old_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_new_data_agg             in soggetti_rubrica.data_agg%type default afc.default_null('SOGGETTI_RUBRICA.data_agg')
     ,p_old_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_new_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default afc.default_null('SOGGETTI_RUBRICA.descrizione_contatto')
     ,p_old_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_column        in varchar2
     ,p_value         in date
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old            in integer default 0
     ,p_ni                   in soggetti_rubrica.ni%type
     ,p_tipo_contatto        in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo          in soggetti_rubrica.progressivo%type
     ,p_contatto             in soggetti_rubrica.contatto%type default null
     ,p_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
   );
   -- Getter per attributo contatto di riga identificata da chiave
   function get_contatto /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_contatto, wnds);
   -- Getter per attributo riferimento_tipo di riga identificata da chiave
   function get_riferimento_tipo /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.riferimento_tipo%type;
   pragma restrict_references(get_riferimento_tipo, wnds);
   -- Getter per attributo riferimento di riga identificata da chiave
   function get_riferimento /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.riferimento%type;
   pragma restrict_references(get_riferimento, wnds);
   -- Getter per attributo pubblicabile di riga identificata da chiave
   function get_pubblicabile /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.pubblicabile%type;
   pragma restrict_references(get_pubblicabile, wnds);
   -- Getter per attributo utente_agg di riga identificata da chiave
   function get_utente_agg /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.utente_agg%type;
   pragma restrict_references(get_utente_agg, wnds);
   -- Getter per attributo data_agg di riga identificata da chiave
   function get_data_agg /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.data_agg%type;
   pragma restrict_references(get_data_agg, wnds);
   -- Getter per attributo descrizione_contatto di riga identificata da chiave
   function get_descrizione_contatto /* SLAVE_COPY */
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.descrizione_contatto%type;
   pragma restrict_references(get_descrizione_contatto, wnds);
   -- Setter per attributo ni di riga identificata da chiave
   procedure set_ni
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.ni%type default null
   );
   -- Setter per attributo tipo_contatto di riga identificata da chiave
   procedure set_tipo_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.tipo_contatto%type default null
   );
   -- Setter per attributo progressivo di riga identificata da chiave
   procedure set_progressivo
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.progressivo%type default null
   );
   -- Setter per attributo contatto di riga identificata da chiave
   procedure set_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.contatto%type default null
   );
   -- Setter per attributo riferimento_tipo di riga identificata da chiave
   procedure set_riferimento_tipo
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.riferimento_tipo%type default null
   );
   -- Setter per attributo riferimento di riga identificata da chiave
   procedure set_riferimento
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.riferimento%type default null
   );
   -- Setter per attributo pubblicabile di riga identificata da chiave
   procedure set_pubblicabile
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.pubblicabile%type default null
   );
   -- Setter per attributo utente_agg di riga identificata da chiave
   procedure set_utente_agg
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.utente_agg%type default null
   );
   -- Setter per attributo data_agg di riga identificata da chiave
   procedure set_data_agg
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.data_agg%type default null
   );
   -- Setter per attributo descrizione_contatto di riga identificata da chiave
   procedure set_descrizione_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.descrizione_contatto%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_ni                   in varchar2 default null
     ,p_tipo_contatto        in varchar2 default null
     ,p_progressivo          in varchar2 default null
     ,p_contatto             in varchar2 default null
     ,p_riferimento_tipo     in varchar2 default null
     ,p_riferimento          in varchar2 default null
     ,p_pubblicabile         in varchar2 default null
     ,p_utente_agg           in varchar2 default null
     ,p_data_agg             in varchar2 default null
     ,p_descrizione_contatto in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_ni                   in varchar2 default null
     ,p_tipo_contatto        in varchar2 default null
     ,p_progressivo          in varchar2 default null
     ,p_contatto             in varchar2 default null
     ,p_riferimento_tipo     in varchar2 default null
     ,p_riferimento          in varchar2 default null
     ,p_pubblicabile         in varchar2 default null
     ,p_utente_agg           in varchar2 default null
     ,p_data_agg             in varchar2 default null
     ,p_descrizione_contatto in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_ni                   in varchar2 default null
     ,p_tipo_contatto        in varchar2 default null
     ,p_progressivo          in varchar2 default null
     ,p_contatto             in varchar2 default null
     ,p_riferimento_tipo     in varchar2 default null
     ,p_riferimento          in varchar2 default null
     ,p_pubblicabile         in varchar2 default null
     ,p_utente_agg           in varchar2 default null
     ,p_data_agg             in varchar2 default null
     ,p_descrizione_contatto in varchar2 default null
   ) return integer;
end soggetti_rubrica_tpk;
/


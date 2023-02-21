CREATE OR REPLACE package indirizzo_telematico is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        indirizzo_telematico
    DESCRIZIONE: Gestione tabella indirizzi_telematici.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    29/01/2007  VDAVALLI  Prima emissione.
    01    03/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    14/03/2016  MMONARI   #689 Modifiche per gestione Contatti
    03    04/03/2022  MMONARI   #54239 Modifiche per Scarico IPA
    04    25/01/2023  MMONARI   #60713
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.04';
   s_table_name constant afc.t_object_name := 'indirizzi_telematici';
   subtype t_rowtype is indirizzi_telematici%rowtype;
   -- Tipo del record primary key
   type t_pk is record(
       id_indirizzo indirizzi_telematici.id_indirizzo%type);
   s_scarico_ipa number(1) := 0; --#54239
   -- Exceptions
   /*   <exception_name> exception;
   pragma exception_init( <exception_name>, <error_code> );
   s_<exception_name>_number constant AFC_Error.t_error_number := <error_code>;
   s_<exception_name>_msg    constant AFC_Error.t_error_msg := <error_message>;*/
   id_errati exception;
   pragma exception_init(id_errati, -20901);
   s_id_errati_number constant afc_error.t_error_number := -20901;
   s_id_errati_msg    constant afc_error.t_error_msg := 'Occorre assegnare un solo identificativo';
   indirizzo_presente exception;
   pragma exception_init(indirizzo_presente, -20901);
   s_indirizzo_presente_number constant afc_error.t_error_number := -20901;
   s_indirizzo_presente_msg    constant afc_error.t_error_msg := 'Tipo indirizzo gia'' inserito per l''entita''';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_indirizzo           in indirizzi_telematici.id_indirizzo%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_note                   in indirizzi_telematici.note%type default null
     ,p_protocol               in indirizzi_telematici.protocol%type default null
     ,p_server                 in indirizzi_telematici.server%type default null
     ,p_port                   in indirizzi_telematici.port%type default null
     ,p_utente                 in indirizzi_telematici.utente%type default null
     ,p_password               in indirizzi_telematici.password%type default null
     ,p_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_authentication         in indirizzi_telematici.authentication%type default null
     ,p_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_tag_mail               in indirizzi_telematici.tag_mail%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_indirizzo           in indirizzi_telematici.id_indirizzo%type
     ,p_new_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_new_id_amministrazione     in indirizzi_telematici.id_amministrazione%type
     ,p_new_id_aoo                 in indirizzi_telematici.id_aoo%type
     ,p_new_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type
     ,p_new_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_new_note                   in indirizzi_telematici.note%type default null
     ,p_new_protocol               in indirizzi_telematici.protocol%type default null
     ,p_new_server                 in indirizzi_telematici.server%type default null
     ,p_new_port                   in indirizzi_telematici.port%type default null
     ,p_new_utente                 in indirizzi_telematici.utente%type default null
     ,p_new_password               in indirizzi_telematici.password%type default null
     ,p_new_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_new_authentication         in indirizzi_telematici.authentication%type default null
     ,p_new_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_new_tag_mail               in indirizzi_telematici.tag_mail%type default null
     ,p_old_id_indirizzo           in indirizzi_telematici.id_indirizzo%type default null
     ,p_old_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type default null
     ,p_old_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_old_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_old_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_old_indirizzo              in indirizzi_telematici.indirizzo%type default null
     ,p_old_note                   in indirizzi_telematici.note%type default null
     ,p_old_protocol               in indirizzi_telematici.protocol%type default null
     ,p_old_server                 in indirizzi_telematici.server%type default null
     ,p_old_port                   in indirizzi_telematici.port%type default null
     ,p_old_utente                 in indirizzi_telematici.utente%type default null
     ,p_old_password               in indirizzi_telematici.password%type default null
     ,p_old_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_old_authentication         in indirizzi_telematici.authentication%type default null
     ,p_old_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_old_tag_mail               in indirizzi_telematici.tag_mail%type default null
     ,p_check_old                  in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_indirizzo  in indirizzi_telematici.id_indirizzo%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_id_indirizzo in indirizzi_telematici.id_indirizzo%type
     ,p_column       in varchar2
     ,p_value        in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_id_indirizzo           in indirizzi_telematici.id_indirizzo%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type default null
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type default null
     ,p_note                   in indirizzi_telematici.note%type default null
     ,p_protocol               in indirizzi_telematici.protocol%type default null
     ,p_server                 in indirizzi_telematici.server%type default null
     ,p_port                   in indirizzi_telematici.port%type default null
     ,p_utente                 in indirizzi_telematici.utente%type default null
     ,p_password               in indirizzi_telematici.password%type default null
     ,p_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_authentication         in indirizzi_telematici.authentication%type default null
     ,p_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_tag_mail               in indirizzi_telematici.tag_mail%type default null
     ,p_check_old              in integer default 0
   );
   -- Attributo tipo_indirizzo di riga esistente identificata da chiave
   function get_tipo_indirizzo /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.tipo_indirizzo%type;
   pragma restrict_references(get_tipo_indirizzo, wnds);
   -- Attributo id_amministrazione di riga esistente identificata da chiave
   function get_id_amministrazione /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.id_amministrazione%type;
   pragma restrict_references(get_id_amministrazione, wnds);
   -- Attributo id_aoo di riga esistente identificata da chiave
   function get_id_aoo /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.id_aoo%type;
   pragma restrict_references(get_id_aoo, wnds);
   -- Attributo id_unita_organizzativa di riga esistente identificata da chiave
   function get_id_unita_organizzativa /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.id_unita_organizzativa%type;
   pragma restrict_references(get_id_unita_organizzativa, wnds);
   -- Attributo indirizzo di riga esistente identificata da chiave
   function get_indirizzo /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.indirizzo%type;
   pragma restrict_references(get_indirizzo, wnds);
   -- Attributo indirizzo di riga esistente identificata da chiave logica
   function get_indirizzo /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.indirizzo%type;
   pragma restrict_references(get_indirizzo, wnds);
   -- Attributo note di riga esistente identificata da chiave
   function get_note /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.note%type;
   pragma restrict_references(get_note, wnds);
   -- Attributo note di riga esistente identificata da chiave logica
   function get_note /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.note%type;
   pragma restrict_references(get_note, wnds);
   -- Attributo protocol di riga esistente identificata da chiave
   function get_protocol /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.protocol%type;
   pragma restrict_references(get_protocol, wnds);
   -- Attributo protocol di riga esistente identificata da chiave logica
   function get_protocol /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.protocol%type;
   pragma restrict_references(get_protocol, wnds);
   -- Attributo server di riga esistente identificata da chiave
   function get_server /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.server%type;
   pragma restrict_references(get_server, wnds);
   -- Attributo server di riga esistente identificata da chiave logica
   function get_server /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.server%type;
   pragma restrict_references(get_server, wnds);
   -- Attributo port di riga esistente identificata da chiave
   function get_port /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.port%type;
   pragma restrict_references(get_port, wnds);
   -- Attributo port di riga esistente identificata da chiave logica
   function get_port /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.port%type;
   pragma restrict_references(get_port, wnds);
   -- Attributo utente di riga esistente identificata da chiave
   function get_utente /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.utente%type;
   pragma restrict_references(get_utente, wnds);
   -- Attributo utente di riga esistente identificata da chiave logica
   function get_utente /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.utente%type;
   pragma restrict_references(get_utente, wnds);
   -- Attributo password di riga esistente identificata da chiave
   function get_password /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.password%type;
   pragma restrict_references(get_password, wnds);
   -- Attributo password di riga esistente identificata da chiave logica
   function get_password /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.password%type;
   pragma restrict_references(get_password, wnds);
   -- Attributo ssl di riga esistente identificata da chiave
   function get_ssl /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.ssl%type;
   pragma restrict_references(get_ssl, wnds);
   -- Attributo ssl di riga esistente identificata da chiave logica
   function get_ssl /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.ssl%type;
   pragma restrict_references(get_ssl, wnds);
   -- Attributo authentication di riga esistente identificata da chiave
   function get_authentication /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.authentication%type;
   pragma restrict_references(get_authentication, wnds);
   -- Attributo authentication di riga esistente identificata da chiave logica
   function get_authentication /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.authentication%type;
   pragma restrict_references(get_authentication, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave logica
   function get_utente_aggiornamento /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave logica
   function get_data_aggiornamento /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Attributo tag_mail di riga esistente identificata da chiave
   function get_tag_mail /* SLAVE_COPY */
   (p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.tag_mail%type;
   pragma restrict_references(get_tag_mail, wnds);
   -- Attributo tag_mail di riga esistente identificata da chiave logica
   function get_tag_mail /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.tag_mail%type;
   pragma restrict_references(get_tag_mail, wnds);
   -- Ricerca attributo chiave per altri campi
   function get_chiave /* SLAVE_COPY */
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
   ) return indirizzi_telematici.id_indirizzo%type;
   pragma restrict_references(get_chiave, wnds);
   -- Definizione chiave di inserimento di nuovo record
   function get_id_indirizzo return indirizzi_telematici.id_indirizzo%type;
   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_indirizzo           in varchar2 default null
     ,p_tipo_indirizzo         in varchar2 default null
     ,p_id_amministrazione     in varchar2 default null
     ,p_id_aoo                 in varchar2 default null
     ,p_id_unita_organizzativa in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_note                   in varchar2 default null
     ,p_protocol               in varchar2 default null
     ,p_server                 in varchar2 default null
     ,p_port                   in varchar2 default null
     ,p_utente                 in varchar2 default null
     ,p_password               in varchar2 default null
     ,p_ssl                    in varchar2 default null
     ,p_authentication         in varchar2 default null
     ,p_tag_mail               in varchar2 default null
     ,p_other_condition        in varchar2 default null
     ,p_qbe                    in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_indirizzo           in varchar2 default null
     ,p_tipo_indirizzo         in varchar2 default null
     ,p_id_amministrazione     in varchar2 default null
     ,p_id_aoo                 in varchar2 default null
     ,p_id_unita_organizzativa in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_note                   in varchar2 default null
     ,p_protocol               in varchar2 default null
     ,p_server                 in varchar2 default null
     ,p_port                   in varchar2 default null
     ,p_utente                 in varchar2 default null
     ,p_password               in varchar2 default null
     ,p_ssl                    in varchar2 default null
     ,p_authentication         in varchar2 default null
     ,p_tag_mail               in varchar2 default null
     ,p_other_condition        in varchar2 default null
     ,p_qbe                    in number default 0
   ) return integer;
   function is_indirizzo_ok
   (
      p_tipo_entita        in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo     in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_indirizzo       in indirizzi_telematici.id_indirizzo%type
     ,p_id_amministrazione in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo             in indirizzi_telematici.id_aoo%type
     ,p_id_unita           in indirizzi_telematici.id_unita_organizzativa%type
   ) return afc_error.t_error_number;
   function is_ri_ok
   (
      p_tipo_entita        in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo     in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_indirizzo       in indirizzi_telematici.id_indirizzo%type
     ,p_id_amministrazione in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo             in indirizzi_telematici.id_aoo%type
     ,p_id_unita           in indirizzi_telematici.id_unita_organizzativa%type
     ,p_inserting          in number
     ,p_updating           in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_tipo_entita        in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo     in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_indirizzo       in indirizzi_telematici.id_indirizzo%type
     ,p_id_amministrazione in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo             in indirizzi_telematici.id_aoo%type
     ,p_id_unita           in indirizzi_telematici.id_unita_organizzativa%type
     ,p_inserting          in number
     ,p_updating           in number
   );
   -- Aggiornamento dati da scarico IPA
   procedure agg_automatico
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_contatti               in indirizzi_telematici.note%type default null --#689
     ,p_scarico_ipa            in number default null  --#54239
     ,p_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type
     ,p_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type
   );
   -- Cancella indirizzi da scarico IPA #60713
   procedure del_contatti_ipa
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_scarico_ipa            in number default null
   );
end indirizzo_telematico;
/


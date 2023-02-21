CREATE OR REPLACE package ottica is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        Ottica
    DESCRIZIONE: Gestione tabella ottiche.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    27/06/2006  VDAVALLI  Prima emissione.
    01    01/08/2011  MMONARI   Modifiche per ottiche non istituzionali derivate
    02    29/02/2013  ADADAMO   Modificata messaggistica dell'errore s_ott_ist_multiple_msg
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.02';

   -- Tipo del record primary key
   type t_pk is record(
       ottica ottiche.ottica%type);
   -- Exceptions
   ott_ist_multiple exception;
   pragma exception_init(ott_ist_multiple, -20901);
   s_ott_ist_multiple_number constant afc_error.t_error_number := -20901;
   s_ott_ist_multiple_msg    constant afc_error.t_error_msg := 'Per l''amministrazione indicata e'' gia'' presente un''ottica istituzionale  ';

   ott_ist_mancante exception;
   pragma exception_init(ott_ist_mancante, -20902);
   s_ott_ist_mancante_number constant afc_error.t_error_number := -20902;
   s_ott_ist_mancante_msg    constant afc_error.t_error_msg := 'Ottica istituzionale mancante per l''amministrazione indicata';

   ott_ist_errata exception;
   pragma exception_init(ott_ist_errata, -20903);
   s_ott_ist_errata_number constant afc_error.t_error_number := -20903;
   s_ott_ist_errata_msg    constant afc_error.t_error_msg := 'L''ottica istituzionale deve essere gestita a revisioni';

   codice_errato exception;
   pragma exception_init(codice_errato, -20904);
   s_codice_errato_number constant afc_error.t_error_number := -20904;
   s_codice_errato_msg    constant afc_error.t_error_msg := 'Codice non consentito per ottiche gestite internamente';

   ott_origine_errata exception;
   pragma exception_init(codice_errato, -20905);
   s_ott_origine_errata_number constant afc_error.t_error_number := -20905;
   s_ott_origine_errata_msg    constant afc_error.t_error_msg := 'Ottica non utilizzabile come origine';

   /*   -- Exceptions
      <exception_name> exception;
      pragma exception_init( <exception_name>, <error_code> );
      s_<exception_name>_number constant AFC_Error.t_error_number := <error_code>;
      s_<exception_name>_msg    constant AFC_Error.t_error_msg := <error_message>;
   */
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_ottica                   in ottiche.ottica%type
     ,p_descrizione              in ottiche.descrizione%type
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_ottica                   in ottiche.ottica%type
     ,p_new_descrizione              in ottiche.descrizione%type
     ,p_new_descrizione_al1          in ottiche.descrizione_al1%type
     ,p_new_descrizione_al2          in ottiche.descrizione_al2%type
     ,p_new_nota                     in ottiche.nota%type
     ,p_new_amministrazione          in ottiche.amministrazione%type
     ,p_new_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_new_gestione_revisioni       in ottiche.gestione_revisioni%type
     ,p_new_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_new_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_new_utente_aggiornamento     in ottiche.utente_aggiornamento%type
     ,p_new_data_aggiornamento       in ottiche.data_aggiornamento%type
     ,p_old_ottica                   in ottiche.ottica%type default null
     ,p_old_descrizione              in ottiche.descrizione%type default null
     ,p_old_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_old_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_old_nota                     in ottiche.nota%type default null
     ,p_old_amministrazione          in ottiche.amministrazione%type default null
     ,p_old_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_old_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_old_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_old_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_old_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_check_old                    in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_ottica        in ottiche.ottica%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );

   procedure upd_column
   (
      p_ottica in ottiche.ottica%type
     ,p_column in varchar2
     ,p_value  in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_ottica                   in ottiche.ottica%type
     ,p_descrizione              in ottiche.descrizione%type
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
   );

   -- Attributo Descrizione di riga esistente identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);

   -- Attributo nota  di riga esistente identificata da chiave
   function get_nota /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.nota%type;
   pragma restrict_references(get_nota, wnds);

   -- Attributo amministrazione  di riga esistente identificata da chiave
   function get_amministrazione /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.amministrazione%type;
   pragma restrict_references(get_amministrazione, wnds);

   -- Attributo ottica_istituzionale  di riga esistente identificata da chiave
   function get_ottica_istituzionale /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.ottica_istituzionale%type;
   pragma restrict_references(get_ottica_istituzionale, wnds);

   -- Attributo gestione_revisioni  di riga esistente identificata da chiave
   function get_gestione_revisioni /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.gestione_revisioni%type;
   pragma restrict_references(get_gestione_revisioni, wnds);

   -- Attributo ottica_origine  di riga esistente identificata da chiave
   function get_ottica_origine /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.ottica_origine%type;
   pragma restrict_references(get_ottica_origine, wnds);

   -- Attributo aggiornamento_componenti  di riga esistente identificata da chiave
   function get_aggiornamento_componenti /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.aggiornamento_componenti%type;
   pragma restrict_references(get_aggiornamento_componenti, wnds);

   -- Attributo utente_aggiornamento  di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo data_aggiornamento  di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return ottiche.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- Ricerca ottica istituzionale per amministrazione
   function get_ottica_per_amm /* SLAVE_COPY */
   (p_amministrazione in ottiche.amministrazione%type) return ottiche.ottica%type;
   pragma restrict_references(get_ottica_per_amm, wnds);

   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_ottica                   in ottiche.ottica%type default null
     ,p_descrizione              in ottiche.descrizione%type
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_order_condition          in varchar2 default null
     ,p_qbe                      in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_ottica                   in ottiche.ottica%type default null
     ,p_descrizione              in ottiche.descrizione%type default null
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_qbe                      in number default 0
   ) return integer;

   -- Controlla che l'ottica passata sia l'ottica istituzionale
   function is_ottica_istituzionale /* SLAVE_COPY */
   (p_ottica in ottiche.ottica%type) return afc_error.t_error_number;

   function is_codice_ottica_ok
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number;

   function is_ottica_origine_ok
   (
      p_ottica_origine  in ottiche.ottica_origine%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number;

   function is_gestione_revisioni_ok
   (
      p_ottica_istituzionale in ottiche.ottica_istituzionale%type
     ,p_gestione_revisioni   in ottiche.gestione_revisioni%type
   ) return afc_error.t_error_number;

   function is_di_ok
   (
      p_ottica               in ottiche.ottica%type
     ,p_amministrazione      in ottiche.amministrazione%type
     ,p_ottica_istituzionale in ottiche.ottica_istituzionale%type
     ,p_gestione_revisioni   in ottiche.gestione_revisioni%type
   ) return afc_error.t_error_number;

   -- Controllo data integrity
   procedure chk_di
   (
      p_ottica               in ottiche.ottica%type
     ,p_amministrazione      in ottiche.amministrazione%type
     ,p_ottica_istituzionale in ottiche.ottica_istituzionale%type
     ,p_gestione_revisioni   in ottiche.gestione_revisioni%type
   );

   function is_ottica_istituzionale_ok
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number;

   function is_ri_ok
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number;

   -- Controllo data integrity
   procedure chk_ri
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   );

end ottica;
/


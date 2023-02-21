CREATE OR REPLACE package aoo_pkg is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        aoo_pkg
    DESCRIZIONE: Gestione tabella aoo.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    21/07/2006  VDAVALLI  Prima emissione.
    01    02/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    14/02/2014  ADADAMO   Aggiunta is_codice_aoo_ok e modificate chk_di e is_di_ok
    03    03/11/2021  MMONARI   Nuovo campo codice_IPA #52548
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.03';
   -- Tipo del record primary key
   type t_pk is record(
       progr_aoo aoo.progr_aoo%type
      ,dal       aoo.dal%type);
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_number constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg    constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_number constant afc_error.t_error_number := -20902;
   s_dal_errato_msg    constant afc_error.t_error_msg := 'La data di inizio deve essere compresa nel periodo di validita'' precedente';
   dal_errato_ins exception;
   pragma exception_init(dal_errato_ins, -20903);
   s_dal_errato_ins_number constant afc_error.t_error_number := -20903;
   s_dal_errato_ins_msg    constant afc_error.t_error_msg := 'La data di inizio interseca altri periodi della stessa AOO';
   al_errato exception;
   pragma exception_init(al_errato, -20904);
   s_al_errato_number constant afc_error.t_error_number := -20904;
   s_al_errato_msg    constant afc_error.t_error_msg := 'La data di fine errata interseca altri periodi della stessa AOO';
   aoo_non_eliminabile_1 exception;
   pragma exception_init(aoo_non_eliminabile_1, -20905);
   s_aoo_non_eliminabile_1_number constant afc_error.t_error_number := -20905;
   s_aoo_non_eliminabile_1_msg    constant afc_error.t_error_msg := 'Esistono riferimenti su Unita Organizzative. La registrazione di AOO non e'' eliminabile';
   aoo_non_eliminabile_2 exception;
   pragma exception_init(aoo_non_eliminabile_2, -20906);
   s_aoo_non_eliminabile_2_number constant afc_error.t_error_number := -20906;
   s_aoo_non_eliminabile_2_msg    constant afc_error.t_error_msg := 'Esistono riferimenti su Indirizzi Telematici. La registrazione di AOO non e'' eliminabile';
   codice_errato exception;
   pragma exception_init(codice_errato, -20907);
   s_codice_errato_number constant afc_error.t_error_number := -20907;
   s_codice_errato_msg    constant afc_error.t_error_msg := 'Codice area gia'' inserito';
   descrizione_errata exception;
   pragma exception_init(descrizione_errata, -20908);
   s_descrizione_errata_number constant afc_error.t_error_number := -20908;
   s_descrizione_errata_msg    constant afc_error.t_error_msg := 'Descrizione area gia'' utilizzata';
   carattere_non_consentito exception;
   pragma exception_init(carattere_non_consentito, -20909);
   s_carattere_non_consent_number constant afc_error.t_error_number := -20909;
   s_carattere_non_consent_msg    constant afc_error.t_error_msg := 'Carattere non consentito ( #[ )';
   dal_al_ammi_errato exception;
   pragma exception_init(dal_al_ammi_errato, -20910);
   s_dal_al_ammi_errato_number constant afc_error.t_error_number := -20910;
   s_dal_al_ammi_errato_msg    constant afc_error.t_error_msg := 'Periodo non compreso nel periodo di validita'' dell''amministrazione';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_dal                    in aoo.dal%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_descrizione_al1        in aoo.descrizione_al1%type default null
     ,p_descrizione_al2        in aoo.descrizione_al2%type default null
     ,p_des_abb                in aoo.des_abb%type default null
     ,p_des_abb_al1            in aoo.des_abb_al1%type default null
     ,p_des_abb_al2            in aoo.des_abb_al2%type default null
     ,p_indirizzo              in aoo.indirizzo%type default null
     ,p_cap                    in aoo.cap%type default null
     ,p_provincia              in aoo.provincia%type default null
     ,p_comune                 in aoo.comune%type default null
     ,p_telefono               in aoo.telefono%type default null
     ,p_fax                    in aoo.fax%type default null
     ,p_al                     in aoo.al%type default null
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type default null
     ,p_codice_ipa             in aoo.codice_ipa%type default null --#52548
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_progr_aoo              in aoo.progr_aoo%type
     ,p_new_dal                    in aoo.dal%type
     ,p_new_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_new_codice_aoo             in aoo.codice_aoo%type
     ,p_new_descrizione            in aoo.descrizione%type
     ,p_new_descrizione_al1        in aoo.descrizione_al1%type
     ,p_new_descrizione_al2        in aoo.descrizione_al2%type
     ,p_new_des_abb                in aoo.des_abb%type
     ,p_new_des_abb_al1            in aoo.des_abb_al1%type
     ,p_new_des_abb_al2            in aoo.des_abb_al2%type
     ,p_new_indirizzo              in aoo.indirizzo%type default null
     ,p_new_cap                    in aoo.cap%type default null
     ,p_new_provincia              in aoo.provincia%type default null
     ,p_new_comune                 in aoo.comune%type default null
     ,p_new_telefono               in aoo.telefono%type default null
     ,p_new_fax                    in aoo.fax%type default null
     ,p_new_al                     in aoo.al%type
     ,p_new_utente_aggiornamento   in aoo.utente_aggiornamento%type
     ,p_new_data_aggiornamento     in aoo.data_aggiornamento%type
     ,p_old_progr_aoo              in aoo.progr_aoo%type default null
     ,p_old_dal                    in aoo.dal%type default null
     ,p_old_codice_amministrazione in aoo.codice_amministrazione%type default null
     ,p_old_codice_aoo             in aoo.codice_aoo%type default null
     ,p_old_descrizione            in aoo.descrizione%type default null
     ,p_old_descrizione_al1        in aoo.descrizione_al1%type default null
     ,p_old_descrizione_al2        in aoo.descrizione_al2%type default null
     ,p_old_des_abb                in aoo.des_abb%type default null
     ,p_old_des_abb_al1            in aoo.des_abb_al1%type default null
     ,p_old_des_abb_al2            in aoo.des_abb_al2%type default null
     ,p_old_indirizzo              in aoo.indirizzo%type default null
     ,p_old_cap                    in aoo.cap%type default null
     ,p_old_provincia              in aoo.provincia%type default null
     ,p_old_comune                 in aoo.comune%type default null
     ,p_old_telefono               in aoo.telefono%type default null
     ,p_old_fax                    in aoo.fax%type default null
     ,p_old_al                     in aoo.al%type default null
     ,p_old_utente_aggiornamento   in aoo.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in aoo.data_aggiornamento%type default null
     ,p_check_old                  in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_progr_aoo     in aoo.progr_aoo%type
     ,p_dal           in aoo.dal%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
     ,p_column    in varchar2
     ,p_value     in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_dal                    in aoo.dal%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type default null
     ,p_codice_aoo             in aoo.codice_aoo%type default null
     ,p_descrizione            in aoo.descrizione%type default null
     ,p_descrizione_al1        in aoo.descrizione_al1%type default null
     ,p_descrizione_al2        in aoo.descrizione_al2%type default null
     ,p_des_abb                in aoo.des_abb%type default null
     ,p_des_abb_al1            in aoo.des_abb_al1%type default null
     ,p_des_abb_al2            in aoo.des_abb_al2%type default null
     ,p_indirizzo              in aoo.indirizzo%type default null
     ,p_cap                    in aoo.cap%type default null
     ,p_provincia              in aoo.provincia%type default null
     ,p_comune                 in aoo.comune%type default null
     ,p_telefono               in aoo.telefono%type default null
     ,p_fax                    in aoo.fax%type default null
     ,p_al                     in aoo.al%type default null
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type default null
     ,p_check_old              in integer default 0
   );
   -- Attributo dal di riga con periodo di validità comprendente
   -- la data indicata
   function get_dal_id /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.dal%type;
   pragma restrict_references(get_dal_id, wnds);
   -- Attributo descrizione di riga esistente identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);
   -- Attributo codice_amministrazione di riga esistente identificata da chiave
   function get_codice_amministrazione /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.codice_amministrazione%type;
   pragma restrict_references(get_codice_amministrazione, wnds);
   -- Attributo codice_aoo di riga esistente identificata da chiave
   function get_codice_aoo /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.codice_aoo%type;
   pragma restrict_references(get_codice_aoo, wnds);
   function get_codice_ipa /* SLAVE_COPY */ --#52548
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.codice_ipa%type;
   pragma restrict_references(get_codice_ipa, wnds);
   -- Attributo des_abb di riga esistente identificata da chiave
   function get_des_abb /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.des_abb%type;
   pragma restrict_references(get_des_abb, wnds);
   -- Attributo indirizzo di riga esistente identificata da chiave
   function get_indirizzo /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.indirizzo%type;
   pragma restrict_references(get_indirizzo, wnds);
   -- Attributo cap di riga esistente identificata da chiave
   function get_cap /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.cap%type;
   pragma restrict_references(get_cap, wnds);
   -- Attributo comune di riga esistente identificata da chiave
   function get_comune /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.comune%type;
   pragma restrict_references(get_comune, wnds);
   -- Attributo provincia di riga esistente identificata da chiave
   function get_provincia /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.provincia%type;
   pragma restrict_references(get_provincia, wnds);
   -- Attributo telefono di riga esistente identificata da chiave
   function get_telefono /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.telefono%type;
   pragma restrict_references(get_telefono, wnds);
   -- Attributo fax di riga esistente identificata da chiave
   function get_fax /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.fax%type;
   pragma restrict_references(get_fax, wnds);
   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.al%type;
   pragma restrict_references(get_al, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Determinazione del progressivo in inserimento di nuova
   -- area organizzativa omogenea
   function get_id_area return aoo.progr_aoo%type;
   -- Attributo dal valido alla data indicata
   function get_dal_corrente /* SLAVE_COPY */
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_data      in aoo.dal%type
   ) return aoo.dal%type;
   pragma restrict_references(get_dal_corrente, wnds);
   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_progr_aoo              in varchar2 default null
     ,p_dal                    in varchar2 default null
     ,p_codice_amministrazione in varchar2 default null
     ,p_codice_aoo             in varchar2 default null
     ,p_descrizione            in varchar2 default null
     ,p_descrizione_al1        in varchar2 default null
     ,p_descrizione_al2        in varchar2 default null
     ,p_des_abb                in varchar2 default null
     ,p_des_abb_al1            in varchar2 default null
     ,p_des_abb_al2            in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_cap                    in varchar2 default null
     ,p_provincia              in varchar2 default null
     ,p_comune                 in varchar2 default null
     ,p_telefono               in varchar2 default null
     ,p_fax                    in varchar2 default null
     ,p_al                     in varchar2 default null
     ,p_utente_aggiornamento   in varchar2 default null
     ,p_data_aggiornamento     in varchar2 default null
     ,p_order_condition        in varchar2 default null
     ,p_qbe                    in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_progr_aoo              in varchar2 default null
     ,p_dal                    in varchar2 default null
     ,p_codice_amministrazione in varchar2 default null
     ,p_codice_aoo             in varchar2 default null
     ,p_descrizione            in varchar2 default null
     ,p_descrizione_al1        in varchar2 default null
     ,p_descrizione_al2        in varchar2 default null
     ,p_des_abb                in varchar2 default null
     ,p_des_abb_al1            in varchar2 default null
     ,p_des_abb_al2            in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_cap                    in varchar2 default null
     ,p_provincia              in varchar2 default null
     ,p_comune                 in varchar2 default null
     ,p_telefono               in varchar2 default null
     ,p_fax                    in varchar2 default null
     ,p_al                     in varchar2 default null
     ,p_utente_aggiornamento   in varchar2 default null
     ,p_data_aggiornamento     in varchar2 default null
     ,p_qbe                    in number default 0
   ) return integer;
   function is_codice_aoo_ok(p_codice_aoo in aoo.codice_aoo%type)
      return afc_error.t_error_number;
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in aoo.dal%type
     ,p_al  in aoo.al%type
   ) return afc_error.t_error_number;
   function is_di_ok
   (
      p_codice_aoo in aoo.codice_aoo%type
     ,p_dal        in aoo.dal%type
     ,p_al         in aoo.al%type
   ) return afc_error.t_error_number;
   procedure chk_di
   (
      p_codice_aoo in aoo.codice_aoo%type
     ,p_dal        in aoo.dal%type
     ,p_al         in aoo.al%type
   );
   function is_last_record(p_progr_aoo in aoo.progr_aoo%type)
      return afc_error.t_error_number;
   function is_dal_ok
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_old_dal   in aoo.dal%type
     ,p_new_dal   in aoo.dal%type
     ,p_old_al    in aoo.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number;
   function is_al_ok
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_old_dal   in aoo.dal%type
     ,p_old_al    in aoo.al%type
     ,p_new_al    in aoo.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number;
   function is_codice_ok
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
   ) return afc_error.t_error_number;
   function is_descrizione_ok
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
   ) return afc_error.t_error_number;
   function is_ri_ok
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_old_dal                in aoo.dal%type
     ,p_new_dal                in aoo.dal%type
     ,p_old_al                 in aoo.al%type
     ,p_new_al                 in aoo.al%type
     ,p_rowid                  in rowid
     ,p_inserting              in number
     ,p_updating               in number
     ,p_deleting               in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_old_dal                in aoo.dal%type
     ,p_new_dal                in aoo.dal%type
     ,p_old_al                 in aoo.al%type
     ,p_new_al                 in aoo.al%type
     ,p_rowid                  in rowid
     ,p_inserting              in number
     ,p_updating               in number
     ,p_deleting               in number
   );
   -- Determinazione della data AL
   procedure set_data_al
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   );
   -- Aggiornamento data di fine validita' periodo precedente
   procedure set_periodo_precedente
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
     ,p_al        in aoo.al%type
   );
   -- Impostazione integrita' funzionale
   procedure set_fi
   (
      p_progr_aoo     in aoo.progr_aoo%type
     ,p_old_progr_aoo in aoo.progr_aoo%type
     ,p_dal           in aoo.dal%type
     ,p_old_dal       in aoo.dal%type
     ,p_al            in aoo.al%type
     ,p_old_al        in aoo.al%type
     ,p_inserting     in number
     ,p_updating      in number
     ,p_deleting      in number
   );
   -- Ricerca aoo per qualunque parametro
   function trova /* SLAVE_COPY */
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_ni                     in aoo.progr_aoo%type
     ,p_denominazione          in aoo.descrizione%type
     ,p_indirizzo              in aoo.indirizzo%type
     ,p_cap                    in aoo.cap%type
     ,p_citta                  in varchar2
     ,p_provincia              in varchar2
     ,p_regione                in varchar2
     ,p_sito_istituzionale     in as4_anagrafe_soggetti.indirizzo_web%type
     ,p_indirizzo_telematico   in indirizzi_telematici.indirizzo%type
     ,p_data_riferimento       in aoo.dal%type default trunc(sysdate)
   ) return afc.t_ref_cursor;
   -- Aggiornamento dati da scarico IPA
   procedure agg_automatico
   (
      p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_ipa             in aoo.codice_ipa%type  --#52548
     ,p_indirizzo              in aoo.indirizzo%type
     ,p_cap                    in aoo.cap%type
     ,p_localita               in varchar2
     ,p_provincia              in varchar2
     ,p_telefono               in aoo.telefono%type
     ,p_fax                    in aoo.fax%type
     ,p_mail_istituzionale     in indirizzi_telematici.indirizzo%type
     ,p_data_istituzione       in aoo.dal%type
     ,p_data_soppressione      in aoo.al%type
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type
   );
end aoo_pkg;
/


CREATE OR REPLACE package anagrafe_unita_organizzativa is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        anagrafe_unita_organizzativa
    DESCRIZIONE: Gestione tabella anagrafe_unita_organizzative.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore       Descrizione.
    00    13/09/2006  VDAVALLI    Prima emissione.
    01    02/09/2009  VDAVALLI    Modifiche per configurazione master/slave
    02    07/04/2010  APASSUELLO  Modifica per aggiunta del campo note
    03    29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    04    12/05/2010  APASSUELLO  Modifica per aggiunta delle functions: get_descrizione_corrente,
                                  get_codice_uo_corrente, ged_id_suddivisione_corrente che NON scartano
                                  la revisione in modifica
    05    31/05/2010  APASSUELLO  Gestione del campo tipo_unita nelle procedure ins, upd, del, get_tipo_unita
    06    20/12/2010  MMONARI     Dati Storici
    07    02/07/2012  MMONARI     Consolidamento Rel.1.4.1
    08    07/12/2012  MMONARI     Rel.1.4.2
    09    05/03/2013  MMONARI     Redmine Bug #210
    10    15/03/2013  VDAVALLI    Aggiunti controlli su eliminazione record Redmine bug #224
    11    28/04/2013  ADADAMO     Aggiunta gestione della nuova colonna AGGREGATORE feature #236
    12    13/08/2013  ADADAMO     Aggiunto controllo di integrità su AGGREGATORE,
                                  un aggregatore può essere associato ad un sola UO
                                  in un determinato periodo
    13    21/03/2014  VDAVALLI    Gestione nuovo campo SE_FATTURA_ELETTRONICA
    14    15/04/2014  MMONARI     Spostamento della proc. ins_unita_so4_gp4 su SO4GP_PKG #429
    15    16/06/2014  MMONARI     #431 Modifiche retroattive su ANUO. Nuova procedure di eliminazione logica
          13/01/2015  MMONARI     Modifiche a get_num_modifiche_uo per #558
    16    18/08/2015  MMONARI     #634 Modifiche a parametri set_fi per attribuzione automatica ruoli
    17    03/11/2021  MMONARI     #52548 Nuovo campo CODICE_IPA
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.17';
   s_table_name constant afc.t_object_name := 'anagrafe_unita_organizzative';
   s_eliminazione_logica number(1) := 0; --#703
   subtype t_rowtype is anagrafe_unita_organizzative%rowtype;
   -- Tipo del record primary key
   type t_pk is record(
       progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
      ,dal                       anagrafe_unita_organizzative.dal%type);
   -- Tipo periodo (dal e al)
   type t_periodo is record(
       dal date
      ,al  date);
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_num constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_num constant afc_error.t_error_number := -20902;
   s_dal_errato_msg constant afc_error.t_error_msg := 'La data di inizio deve essere compresa nel periodo di validita'' precedente o successivo';
   dal_errato_ins exception;
   pragma exception_init(dal_errato_ins, -20903);
   s_dal_errato_ins_num constant afc_error.t_error_number := -20903;
   s_dal_errato_ins_msg constant afc_error.t_error_msg := 'La data di inizio deve essere superiore all''ultima inserita';
   al_errato exception;
   pragma exception_init(al_errato, -20904);
   s_al_errato_num constant afc_error.t_error_number := -20904;
   s_al_errato_msg constant afc_error.t_error_msg := 'La data di fine puo'' essere modificata solo sull''ultimo periodo';
   auo_non_elim_1 exception;
   pragma exception_init(auo_non_elim_1, -20905);
   s_auo_non_elim_1_num constant afc_error.t_error_number := -20905;
   s_auo_non_elim_1_msg constant afc_error.t_error_msg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Anagrafe unita organizzative non e'' eliminabile';
   auo_non_elim_2 exception;
   pragma exception_init(auo_non_elim_2, -20906);
   s_auo_non_elim_2_num constant afc_error.t_error_number := -20906;
   s_auo_non_elim_2_msg constant afc_error.t_error_msg := 'Esistono riferimenti su Componenti. La registrazione di Anagrafe unita organizzative non e'' eliminabile';
   auo_non_elim_3 exception;
   pragma exception_init(auo_non_elim_3, -20907);
   s_auo_non_elim_3_num constant afc_error.t_error_number := -20907;
   s_auo_non_elim_3_msg constant afc_error.t_error_msg := 'Esistono riferimenti su Ubicazioni Unita. La registrazione di Anagrafe unita organizzative non e'' eliminabile';
   des_abb_errata exception;
   pragma exception_init(des_abb_errata, -20908);
   s_des_abb_errata_num constant afc_error.t_error_number := -20908;
   s_des_abb_errata_msg constant afc_error.t_error_msg := 'Descrizione abbreviata obbligatoria per unita'' appartenenti all''ottica istituzionale';
   progr_aoo_errato exception;
   pragma exception_init(progr_aoo_errato, -20909);
   s_progr_aoo_errato_num constant afc_error.t_error_number := -20909;
   s_progr_aoo_errato_msg constant afc_error.t_error_msg := 'Area org. omogenea obbligatoria per unita'' appartenenti all''ottica istituzionale';
   auo_non_elim_4 exception;
   pragma exception_init(auo_non_elim_4, -20910);
   s_auo_non_elim_4_num constant afc_error.t_error_number := -20910;
   s_auo_non_elim_4_msg constant afc_error.t_error_msg := 'Esistono riferimenti su Indirizzi Telematici. La registrazione di Anagrafe unita organizzative non e'' eliminabile';
   indirizzo_errato exception;
   pragma exception_init(indirizzo_errato, -20911);
   s_indirizzo_errato_num constant afc_error.t_error_number := -20911;
   s_indirizzo_errato_msg constant afc_error.t_error_msg := 'Non indicare l''indirizzo per U.O. dell''ente proprietario';
   codice_errato exception;
   pragma exception_init(codice_errato, -20912);
   s_codice_errato_num constant afc_error.t_error_number := -20912;
   s_codice_errato_msg constant afc_error.t_error_msg := 'Codice unita'' gia'' utilizzato';
   descrizione_errata exception;
   pragma exception_init(descrizione_errata, -20913);
   s_descrizione_errata_num constant afc_error.t_error_number := -20913;
   s_descrizione_errata_msg constant afc_error.t_error_msg := 'Descrizione unita'' gia'' utilizzata';
   des_abb_usata exception;
   pragma exception_init(des_abb_usata, -20914);
   s_des_abb_usata_num constant afc_error.t_error_number := -20914;
   s_des_abb_usata_msg constant afc_error.t_error_msg := 'Descr. abbr. unita'' gia'' utilizzata';
   unita_presente exception;
   pragma exception_init(unita_presente, -20915);
   s_unita_presente_num constant afc_error.t_error_number := -20915;
   s_unita_presente_msg constant afc_error.t_error_msg := 'Impossibile aggiornare data fine validita'' - Unita'' presente in struttura';
   al_errato_ins exception;
   pragma exception_init(al_errato_ins, -20916);
   s_al_errato_ins_num constant afc_error.t_error_number := -20916;
   s_al_errato_ins_msg constant afc_error.t_error_msg := 'La data di fine deve essere superiore all''ultima inserita';
   periodo_errato exception;
   pragma exception_init(periodo_errato, -20917);
   s_periodo_errato_num constant afc_error.t_error_number := -20917;
   s_periodo_errato_msg constant afc_error.t_error_msg := 'Periodo non congruente con i periodi gia'' inseriti';
   revisioni_errate exception;
   pragma exception_init(revisioni_errate, -20918);
   s_revisioni_errate_num constant afc_error.t_error_number := -20918;
   s_revisioni_errate_msg constant afc_error.t_error_msg := 'Incongruenza nell''inserimento delle revisioni';
   auo_non_elim_5 exception;
   pragma exception_init(auo_non_elim_5, -20919);
   s_auo_non_elim_5_num constant afc_error.t_error_number := -20919;
   s_auo_non_elim_5_msg constant afc_error.t_error_msg := 'Esistono riferimenti su Assegnazioni Fisiche. La registrazione di Anagrafe unita organizzative non e'' eliminabile';
   aggregatore_errato exception;
   pragma exception_init(aggregatore_errato, -20920);
   s_aggregatore_errato_num constant afc_error.t_error_number := -20920;
   s_aggregatore_errato_msg constant afc_error.t_error_msg := 'Aggregatore già assegnato ad altra unita''. Inserimento non consetito';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type default null
     ,p_descrizione_al1           in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_descrizione_al2           in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type default null
     ,p_des_abb_al1               in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_des_abb_al2               in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione      in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_tipologia_unita           in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_se_giuridico              in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_assegnazione_componenti   in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                       in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                    in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                       in anagrafe_unita_organizzative.fax%type default null
     ,p_centro                    in anagrafe_unita_organizzative.centro%type default null
     ,p_centro_responsabilita     in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_al                        in anagrafe_unita_organizzative.al%type default null
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_note                      in anagrafe_unita_organizzative.note%type default null
     ,p_tipo_unita                in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_dal_pubb                  in anagrafe_unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in anagrafe_unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in anagrafe_unita_organizzative.al_prec%type default null
     ,p_incarico_resp             in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_etichetta                 in anagrafe_unita_organizzative.etichetta%type default null
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_se_fattura_elettronica    in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
     ,p_codice_ipa                in anagrafe_unita_organizzative.codice_ipa%type  default null --#52548
   );
   -- Inserimento di una riga eliminate logicamente sulla tabella ANAGRAFE_UNITA_ORGANIZZATIVE #703
   procedure ins_anue --#431
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type default null
     ,p_descrizione_al1           in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_descrizione_al2           in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type default null
     ,p_des_abb_al1               in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_des_abb_al2               in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione      in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_tipologia_unita           in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_se_giuridico              in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_assegnazione_componenti   in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                       in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                    in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                       in anagrafe_unita_organizzative.fax%type default null
     ,p_centro                    in anagrafe_unita_organizzative.centro%type default null
     ,p_centro_responsabilita     in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_al                        in anagrafe_unita_organizzative.al%type default null
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_note                      in anagrafe_unita_organizzative.note%type default null
     ,p_tipo_unita                in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_dal_pubb                  in anagrafe_unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in anagrafe_unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in anagrafe_unita_organizzative.al_prec%type default null
     ,p_incarico_resp             in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_etichetta                 in anagrafe_unita_organizzative.etichetta%type default null
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_se_fattura_elettronica    in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                     in anagrafe_unita_organizzative.dal%type
     ,p_new_dal_pubb                in anagrafe_unita_organizzative.dal_pubb%type
     ,p_new_al_pubb                 in anagrafe_unita_organizzative.al_pubb%type
     ,p_new_al_prec                 in anagrafe_unita_organizzative.al_prec%type
     ,p_new_codice_uo               in anagrafe_unita_organizzative.codice_uo%type
     ,p_new_descrizione             in anagrafe_unita_organizzative.descrizione%type
     ,p_new_descrizione_al1         in anagrafe_unita_organizzative.descrizione_al1%type
     ,p_new_descrizione_al2         in anagrafe_unita_organizzative.descrizione_al2%type
     ,p_new_des_abb                 in anagrafe_unita_organizzative.des_abb%type
     ,p_new_des_abb_al1             in anagrafe_unita_organizzative.des_abb_al1%type
     ,p_new_des_abb_al2             in anagrafe_unita_organizzative.des_abb_al2%type
     ,p_new_id_suddivisione         in anagrafe_unita_organizzative.id_suddivisione%type
     ,p_new_ottica                  in anagrafe_unita_organizzative.ottica%type
     ,p_new_revisione_istituzione   in anagrafe_unita_organizzative.revisione_istituzione%type
     ,p_new_revisione_cessazione    in anagrafe_unita_organizzative.revisione_cessazione%type
     ,p_new_tipologia_unita         in anagrafe_unita_organizzative.tipologia_unita%type
     ,p_new_se_giuridico            in anagrafe_unita_organizzative.se_giuridico%type
     ,p_new_assegnazione_componenti in anagrafe_unita_organizzative.assegnazione_componenti%type
     ,p_new_amministrazione         in anagrafe_unita_organizzative.amministrazione%type
     ,p_new_progr_aoo               in anagrafe_unita_organizzative.progr_aoo%type
     ,p_new_indirizzo               in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_new_cap                     in anagrafe_unita_organizzative.cap%type default null
     ,p_new_provincia               in anagrafe_unita_organizzative.provincia%type default null
     ,p_new_comune                  in anagrafe_unita_organizzative.comune%type default null
     ,p_new_telefono                in anagrafe_unita_organizzative.telefono%type default null
     ,p_new_fax                     in anagrafe_unita_organizzative.fax%type default null
     ,p_new_centro                  in anagrafe_unita_organizzative.centro%type
     ,p_new_centro_responsabilita   in anagrafe_unita_organizzative.centro_responsabilita%type
     ,p_new_al                      in anagrafe_unita_organizzative.al%type
     ,p_new_utente_ad4              in anagrafe_unita_organizzative.utente_ad4%type
     ,p_new_utente_aggiornamento    in anagrafe_unita_organizzative.utente_aggiornamento%type
     ,p_new_data_aggiornamento      in anagrafe_unita_organizzative.data_aggiornamento%type
     ,p_new_note                    in anagrafe_unita_organizzative.note%type default null
     ,p_new_tipo_unita              in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_new_incarico_resp           in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_new_etichetta               in anagrafe_unita_organizzative.etichetta%type default null
     ,p_new_aggregatore             in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_new_se_fattura_elettronica  in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
     ,p_old_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_old_dal                     in anagrafe_unita_organizzative.dal%type default null
     ,p_old_dal_pubb                in anagrafe_unita_organizzative.dal_pubb%type
     ,p_old_al_pubb                 in anagrafe_unita_organizzative.al_pubb%type
     ,p_old_al_prec                 in anagrafe_unita_organizzative.al_prec%type
     ,p_old_codice_uo               in anagrafe_unita_organizzative.codice_uo%type default null
     ,p_old_descrizione             in anagrafe_unita_organizzative.descrizione%type default null
     ,p_old_descrizione_al1         in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_old_descrizione_al2         in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_old_des_abb                 in anagrafe_unita_organizzative.des_abb%type default null
     ,p_old_des_abb_al1             in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_old_des_abb_al2             in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_old_id_suddivisione         in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_old_ottica                  in anagrafe_unita_organizzative.ottica%type default null
     ,p_old_revisione_istituzione   in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_old_revisione_cessazione    in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_old_tipologia_unita         in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_old_se_giuridico            in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_old_assegnazione_componenti in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_old_amministrazione         in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_old_progr_aoo               in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_old_indirizzo               in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_old_cap                     in anagrafe_unita_organizzative.cap%type default null
     ,p_old_provincia               in anagrafe_unita_organizzative.provincia%type default null
     ,p_old_comune                  in anagrafe_unita_organizzative.comune%type default null
     ,p_old_telefono                in anagrafe_unita_organizzative.telefono%type default null
     ,p_old_fax                     in anagrafe_unita_organizzative.fax%type default null
     ,p_old_centro                  in anagrafe_unita_organizzative.centro%type default null
     ,p_old_centro_responsabilita   in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_old_al                      in anagrafe_unita_organizzative.al%type default null
     ,p_old_utente_ad4              in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_old_utente_aggiornamento    in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento      in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_old_note                    in anagrafe_unita_organizzative.note%type default null
     ,p_old_tipo_unita              in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_old_incarico_resp           in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_old_etichetta               in anagrafe_unita_organizzative.etichetta%type default null
     ,p_old_aggregatore             in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_old_se_fattura_elettronica  in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
     ,p_check_old                   in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_column                    in varchar2
     ,p_value                     in varchar2 default null
     ,p_literal_value             in number default 1
   );
   procedure upd_column
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_column                    in varchar2
     ,p_value                     in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type default null
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type default null
     ,p_descrizione_al1           in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_descrizione_al2           in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type default null
     ,p_des_abb_al1               in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_des_abb_al2               in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type default null
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione      in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_tipologia_unita           in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_se_giuridico              in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_assegnazione_componenti   in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                       in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                    in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                       in anagrafe_unita_organizzative.fax%type default null
     ,p_centro                    in anagrafe_unita_organizzative.centro%type default null
     ,p_centro_responsabilita     in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_al                        in anagrafe_unita_organizzative.al%type default null
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_note                      in anagrafe_unita_organizzative.note%type default null
     ,p_tipo_unita                in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_dal_pubb                  in anagrafe_unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in anagrafe_unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in anagrafe_unita_organizzative.al_prec%type default null
     ,p_incarico_resp             in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_etichetta                 in anagrafe_unita_organizzative.etichetta%type default null
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_se_fattura_elettronica    in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
     ,p_check_old                 in integer default 0
   );
   -- Cancellazione logica di una riga
   procedure del_logica
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   );
   -- "Descriptor" di riga identificata da chiave
   -- (tratta input nullo ritornando null)
   function get_descriptor /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return varchar2;
   pragma restrict_references(get_descriptor, wnds);
   -- Attributo dal di riga con periodo di validità comprendente
   -- la data indicata
   function get_dal_id /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal%type;
   pragma restrict_references(get_dal_id, wnds);
   -- Attributo dal_pubb di riga con periodo di validità comprendente
   -- la data indicata
   function get_dal_pubb_id /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal_pubb%type;
   pragma restrict_references(get_dal_pubb_id, wnds);
   -- Attributo codice_uo di riga esistente identificata da chiave
   function get_codice_uo /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type;
   pragma restrict_references(get_codice_uo, wnds);
   -- Attributo codice_uo di riga esistente identificata da chiave
   function get_codice_ipa /* SLAVE_COPY */ --#52548
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_ipa%type;
   pragma restrict_references(get_codice_ipa, wnds);
   -- Attributo descrizione di riga esistente identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);
   -- Attributo descrizione_al1 di riga esistente identificata da chiave
   function get_descrizione_al1 /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione_al1%type;
   pragma restrict_references(get_descrizione_al1, wnds);
   -- Attributo descrizione_al2 di riga esistente identificata da chiave
   function get_descrizione_al2 /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione_al2%type;
   pragma restrict_references(get_descrizione_al2, wnds);
   -- Attributo des_abb di riga esistente identificata da chiave
   function get_des_abb /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb%type;
   pragma restrict_references(get_des_abb, wnds);
   -- Attributo des_abb_al1 di riga esistente identificata da chiave
   function get_des_abb_al1 /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb_al1%type;
   pragma restrict_references(get_des_abb_al1, wnds);
   -- Attributo des_abb_al2 di riga esistente identificata da chiave
   function get_des_abb_al2 /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb_al2%type;
   pragma restrict_references(get_des_abb_al2, wnds);
   -- Attributo id_suddivisione di riga esistente identificata da chiave
   function get_id_suddivisione /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.id_suddivisione%type;
   pragma restrict_references(get_id_suddivisione, wnds);
   -- Attributo ottica di riga esistente identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Attributo revisione_istituzione di riga esistente identificata da chiave
   function get_revisione_istituzione /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.revisione_istituzione%type;
   pragma restrict_references(get_revisione_istituzione, wnds);
   -- Attributo revisione_cessazione di riga esistente identificata da chiave
   function get_revisione_cessazione /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.revisione_cessazione%type;
   pragma restrict_references(get_revisione_cessazione, wnds);
   -- Attributo tipologia_unita di riga esistente identificata da chiave
   function get_tipologia_unita /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.tipologia_unita%type;
   pragma restrict_references(get_tipologia_unita, wnds);
   -- Attributo se_giuridico di riga esistente identificata da chiave
   function get_se_giuridico /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.se_giuridico%type;
   pragma restrict_references(get_se_giuridico, wnds);
   -- Attributo assegnazione_componenti di riga esistente identificata da chiave
   function get_assegnazione_componenti /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.assegnazione_componenti%type;
   pragma restrict_references(get_assegnazione_componenti, wnds);
   -- Attributo amministrazione di riga esistente identificata da chiave
   function get_amministrazione /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.amministrazione%type;
   pragma restrict_references(get_amministrazione, wnds);
   -- Attributo progr_aoo di riga esistente identificata da chiave
   function get_progr_aoo /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_aoo%type;
   pragma restrict_references(get_progr_aoo, wnds);
   -- Attributo indirizzo di riga esistente identificata da chiave
   function get_indirizzo /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.indirizzo%type;
   pragma restrict_references(get_indirizzo, wnds);
   -- Attributo cap di riga esistente identificata da chiave
   function get_cap /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.cap%type;
   pragma restrict_references(get_cap, wnds);
   -- Attributo provincia di riga esistente identificata da chiave
   function get_provincia /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.provincia%type;
   pragma restrict_references(get_provincia, wnds);
   -- Attributo comune di riga esistente identificata da chiave
   function get_comune /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.comune%type;
   pragma restrict_references(get_comune, wnds);
   -- Attributo telefono di riga esistente identificata da chiave
   function get_telefono /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.telefono%type;
   pragma restrict_references(get_telefono, wnds);
   -- Attributo fax di riga esistente identificata da chiave
   function get_fax /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.fax%type;
   pragma restrict_references(get_fax, wnds);
   -- Attributo centro di riga esistente identificata da chiave
   function get_centro /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.centro%type;
   pragma restrict_references(get_centro, wnds);
   -- Attributo centro_responsabilita di riga esistente identificata da chiave
   function get_centro_responsabilita /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.centro_responsabilita%type;
   pragma restrict_references(get_centro_responsabilita, wnds);
   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.al%type;
   pragma restrict_references(get_al, wnds);
   -- Attributo utente_AD4 di riga esistente identificata da chiave
   function get_utente_ad4 /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.utente_ad4%type;
   pragma restrict_references(get_utente_ad4, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Attributo note di riga esistente identificata da chiave
   function get_note /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.note%type;
   pragma restrict_references(get_note, wnds);
   -- Attributo tipo_unita di riga esistente identificata da chiave
   function get_tipo_unita /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.tipo_unita%type;
   pragma restrict_references(get_tipo_unita, wnds);
   -- Attributo incarico_resp di riga esistente identificata da chiave
   function get_incarico_resp /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.incarico_resp%type;
   pragma restrict_references(get_incarico_resp, wnds);
   -- Attributo etichetta di riga esistente identificata da chiave
   function get_etichetta /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.etichetta%type;
   pragma restrict_references(get_etichetta, wnds);
   -- Attributo aggregatore di riga esistente identificata da chiave
   function get_aggregatore /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.aggregatore%type;
   pragma restrict_references(get_etichetta, wnds);
   -- Attributo se_fattura_elettronica di riga esistente identificata da chiave
   function get_se_fattura_elettronica /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.se_fattura_elettronica%type;
   pragma restrict_references(get_etichetta, wnds);
   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descrizione               in varchar2 default null
     ,p_descrizione_al1           in varchar2 default null
     ,p_descrizione_al2           in varchar2 default null
     ,p_des_abb                   in varchar2 default null
     ,p_des_abb_al1               in varchar2 default null
     ,p_des_abb_al2               in varchar2 default null
     ,p_id_suddivisione           in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_istituzione     in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_tipologia_unita           in varchar2 default null
     ,p_se_giuridico              in varchar2 default null
     ,p_assegnazione_componenti   in varchar2 default null
     ,p_amministrazione           in varchar2 default null
     ,p_progr_aoo                 in varchar2 default null
     ,p_indirizzo                 in varchar2 default null
     ,p_cap                       in varchar2 default null
     ,p_provincia                 in varchar2 default null
     ,p_comune                    in varchar2 default null
     ,p_telefono                  in varchar2 default null
     ,p_fax                       in varchar2 default null
     ,p_centro                    in varchar2 default null
     ,p_centro_responsabilita     in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_note                      in varchar2 default null
     ,p_tipo_unita                in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_incarico_resp             in varchar2 default null
     ,p_etichetta                 in varchar2 default null
     ,p_utente_ad4                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descrizione               in varchar2 default null
     ,p_descrizione_al1           in varchar2 default null
     ,p_descrizione_al2           in varchar2 default null
     ,p_des_abb                   in varchar2 default null
     ,p_des_abb_al1               in varchar2 default null
     ,p_des_abb_al2               in varchar2 default null
     ,p_id_suddivisione           in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_istituzione     in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_tipologia_unita           in varchar2 default null
     ,p_se_giuridico              in varchar2 default null
     ,p_assegnazione_componenti   in varchar2 default null
     ,p_amministrazione           in varchar2 default null
     ,p_progr_aoo                 in varchar2 default null
     ,p_indirizzo                 in varchar2 default null
     ,p_cap                       in varchar2 default null
     ,p_provincia                 in varchar2 default null
     ,p_comune                    in varchar2 default null
     ,p_telefono                  in varchar2 default null
     ,p_fax                       in varchar2 default null
     ,p_centro                    in varchar2 default null
     ,p_centro_responsabilita     in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_note                      in varchar2 default null
     ,p_tipo_unita                in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_incarico_resp             in varchar2 default null
     ,p_etichetta                 in varchar2 default null
     ,p_utente_ad4                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return integer;
   -- Determinazione del progressivo in inserimento di nuova
   -- unita' organizzativa
   function get_id_unita return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   pragma restrict_references(get_id_unita, wnds);
   -- Attributo dal valido alla data indicata
   function get_dal_corrente /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal%type;
   pragma restrict_references(get_dal_corrente, wnds);
   -- Attributo dal_pubb valido alla data indicata
   function get_dal_pubb_corrente /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal_pubb%type;
   pragma restrict_references(get_dal_pubb_corrente, wnds);
   -- Progr. unità organizzativa x codice
   function get_progr_unor /* SLAVE_COPY */
   (
      p_ottica          in anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type default null
     ,p_utente_ad4      in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_data            in anagrafe_unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unor, wnds);
   -- Attributo codice_uo di ultima riga esistente identificata da chiave
   function get_ultimo_codice
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type;
   -- Date del periodo precedente al periodo dato
   function get_periodo_precedente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_rowid                     in rowid
   ) return afc_periodo.t_periodo;
   -- Restituisce la descrizione dell'unità considerando la revisione in modifica
   function get_descrizione_corrente /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type;
   pragma restrict_references(get_descrizione_corrente, wnds);
   -- Restituisce il codice dell'unità considerando la revisione in modifica
   function get_codice_uo_corrente /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type;
   pragma restrict_references(get_codice_uo_corrente, wnds);
   -- Restituisce il codice dell'unità considerando la revisione in modifica
   function get_codice_ipa_corrente /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_ipa%type;
   pragma restrict_references(get_codice_ipa_corrente, wnds);
   -- Restituisce l'id_suddivisione dell'unità considerando la revisione in modifica
   function get_id_suddivisione_corrente /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.id_suddivisione%type;
   pragma restrict_references(get_id_suddivisione_corrente, wnds);
   -- Restituisce il numero delle modifiche a codice e descrizione dell'unita' nel periodo
   function get_num_modifiche_uo /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_comp_ottica               in componenti.ottica%type
     ,p_comp_rev_cess             in componenti.revisione_cessazione%type
     ,p_comp_rev_mod              in componenti.revisione_cessazione%type
     ,p_comp_dal                  in componenti.dal%type
     ,p_comp_al                   in componenti.al%type
   ) return number;
   pragma restrict_references(get_num_modifiche_uo, wnds);
   -- Per ottiche gestite a revisioni, controllo esistenza revisione in modifica
   -- al momento dell'inserimento di una nuova unita
   procedure chk_ins
   (
      p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
   );
   -- controllo congruenza date
   function is_dal_al_ok
   (
      p_dal in anagrafe_unita_organizzative.dal%type
     ,p_al  in anagrafe_unita_organizzative.al%type
   ) return afc_error.t_error_number;
   -- controllo descr. abbr,
   function is_des_abb_ok
   (
      p_ottica  in anagrafe_unita_organizzative.ottica%type
     ,p_des_abb in anagrafe_unita_organizzative.des_abb%type
   ) return afc_error.t_error_number;
   -- controllo AOO
   function is_aoo_ok
   (
      p_ottica    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_aoo in anagrafe_unita_organizzative.progr_aoo%type
   ) return afc_error.t_error_number;
   -- controllo dati indirizzo
   function is_indirizzo_ok
   (
      p_amministrazione in anagrafe_unita_organizzative.amministrazione%type
     ,p_indirizzo       in anagrafe_unita_organizzative.indirizzo%type
     ,p_cap             in anagrafe_unita_organizzative.cap%type
     ,p_provincia       in anagrafe_unita_organizzative.provincia%type
     ,p_comune          in anagrafe_unita_organizzative.comune%type
     ,p_telefono        in anagrafe_unita_organizzative.telefono%type
     ,p_fax             in anagrafe_unita_organizzative.fax%type
   ) return afc_error.t_error_number;
   -- controllo congruenza revisioni
   function is_revisioni_ok
   (
      p_revisione_istituzione in anagrafe_unita_organizzative.revisione_istituzione%type
     ,p_revisione_cessazione  in anagrafe_unita_organizzative.revisione_cessazione%type
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   function is_di_ok
   (
      p_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                in anagrafe_unita_organizzative.ottica%type
     ,p_des_abb               in anagrafe_unita_organizzative.des_abb%type
     ,p_progr_aoo             in anagrafe_unita_organizzative.progr_aoo%type
     ,p_amministrazione       in anagrafe_unita_organizzative.amministrazione%type
     ,p_indirizzo             in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                   in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia             in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono              in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                   in anagrafe_unita_organizzative.fax%type default null
     ,p_revisione_istituzione in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione  in anagrafe_unita_organizzative.revisione_cessazione%type default null
   ) return afc_error.t_error_number;
   function is_aggregatore_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_al                        in anagrafe_unita_organizzative.al%type
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                in anagrafe_unita_organizzative.ottica%type
     ,p_des_abb               in anagrafe_unita_organizzative.des_abb%type
     ,p_progr_aoo             in anagrafe_unita_organizzative.progr_aoo%type
     ,p_amministrazione       in anagrafe_unita_organizzative.amministrazione%type
     ,p_indirizzo             in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                   in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia             in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono              in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                   in anagrafe_unita_organizzative.fax%type default null
     ,p_revisione_istituzione in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione  in anagrafe_unita_organizzative.revisione_cessazione%type default null
   );
   function is_last_record(p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return afc_error.t_error_number;
   function is_ultimo_periodo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return afc_error.t_error_number;
   function is_al_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
   ) return afc_error.t_error_number;
   function is_periodo_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
   ) return afc_error.t_error_number;
   function is_codice_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) return afc_error.t_error_number;
   function is_descrizione_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) return afc_error.t_error_number;
   function is_des_abb_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) return afc_error.t_error_number;
   function is_ri_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_old_al                    in anagrafe_unita_organizzative.al%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
     ,p_nest_level                in integer
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_old_al                    in anagrafe_unita_organizzative.al%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
     ,p_nest_level                in integer
   );
   function get_periodo_successivo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzativa.t_periodo;
   function get_pk_anue(p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return anagrafe_unita_organizzative.dal%type;
   function is_periodo_eliminato(p_dal in anagrafe_unita_organizzative.dal%type)
      return number;
   -- Determinazione della data AL del record inserito
   procedure set_al_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   );
   -- Aggiornamento data di fine validita' periodo precedente
   procedure set_al_precedente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_al                        in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_deleting                  in number default 0
   );
   -- Aggiornamento data di fine validita' periodo successivo
   procedure set_dal_successivo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
   );
   -- Inserimento / aggiornamento gruppo ad4
   procedure set_gruppo_ad4
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type
   );
   -- procedure di impostazione integrita' funzionale
   procedure set_fi
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_old_progr_unita_org       in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_al                        in anagrafe_unita_organizzative.al%type
     ,p_old_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type
     ,p_old_id_suddivisione       in anagrafe_unita_organizzative.id_suddivisione%type
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type
     ,p_old_progr_aoo             in anagrafe_unita_organizzative.progr_aoo%type
     ,p_des_abb                   in anagrafe_unita_organizzative.descrizione%type
     ,p_old_des_abb               in anagrafe_unita_organizzative.descrizione%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
     ,p_utente_agg                in anagrafe_unita_organizzative.utente_aggiornamento%type
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   );
   -- valorizza la variabile s_tipo_revisione
   procedure set_tipo_revisione
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
   );
end anagrafe_unita_organizzativa;
/


CREATE OR REPLACE package componente is

   /* MASTER_LINK */
   /******************************************************************************
    NOME:        componente
    DESCRIZIONE: Gestione tabella componenti.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore       Descrizione.
    00    02/08/2006  VDAVALLI    Prima emissione.
    01    03/09/2009  VDAVALLI    Modifiche per gestione master/slave
    02    03/09/2009  VDAVALLI    Aggiunta funzione DETERMINA_NOMINATIVO_4
    03    29/04/2010  APASSUELLO  Modifica per aggiunta di controlli
                                  sulla congruenza delle revisioni
    04    13/05/2010  APASSUELLO  Modifica procedure sposta_componente per
                                  gestione dello spostamento senza revisione
    05    19/08/2011  MMONARI     Modifiche per gestione ottiche derivate
    06    20/12/2011  MMONARI     Funzioni per Browser Componenti
    07    20/12/2011  VDAVALLI    Nuove funzioni DETERMINA_NOMINATIVO_7 e
                                  DETERMINA_UTENTE_7 per provincia di Modena
    08    05/12/2011  MMONARI     Modifiche per gestione dati storici
    09    02/03/2012  VDAVALLI    Nuova procedura per inserimento assegnazioni
                                  funzionali
    10    02/07/2012  MMONARI     Consolidamento rel.1.4.1
    11    29/08/2012  VDAVALLI    Aggiunta funzione VERIFICA_EREDITARIETA per
                                  verificare ereditarieta' ruoli
    12    01/02/2013  MMONARI     Redmine Bug #171
    13    18/03/2013  VDAVALLI    Aggiunta funzione determina_nominativo_n_sp_c Bug #227
    14    09/04/2013  ADADAMO     Aggiunta funzione get_desc_comp_tree Bug #216
    15    12/05/2014  MMONARI     Issue #440
                                  issue #457 (segnalazioni errore set_fi)
                                  issue #430 gestione profili
                                  issue #543 nuova variabile s_origine_gp
                      ADADAMO     Issue #572 nuova funzione is_componente_annullabile
                      MMONARI     Issue #641 nuova variabile s_tipo_ripristino
    16    10/08/2014  MMONARI     Issue #634 Nuova proc. Attribuzione_ruoli
          21/08/2014  MMONARI     Issue #550 Nuova variabile s_spostamento
          03/05/2016  MMONARI     Issue #713 - Eredita ruoli su spostamento componente
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.16';
   s_data_limite              date := to_date(3333333, 'j');
   s_eccezione                number(1) := 0; --#440
   s_modifica_componente      number(1) := 0; --#430
   s_aggiorna_date_componente number(1) := 0; --#42480
   s_origine_gp               number(1) := 0; --#543 #550
   s_spostamento              number(1) := 0; --#550
   s_tipo_ripristino          number(1) := 0; --#641
   -- Tipo del record primary key
   type t_pk is record(
       id_componente componenti.id_componente%type);
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_number constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg    constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_number constant afc_error.t_error_number := -20902;
   s_dal_errato_msg    constant afc_error.t_error_msg := 'La data di inizio validita'' deve essere superiore alla data di fine del periodo precedente';
   dal_errato_ins exception;
   pragma exception_init(dal_errato_ins, -20903);
   s_dal_errato_ins_number constant afc_error.t_error_number := -20903;
   s_dal_errato_ins_msg    constant afc_error.t_error_msg := 'La data di inizio deve essere superiore all''ultima inserita';
   al_errato exception;
   pragma exception_init(al_errato, -20904);
   s_al_errato_number constant afc_error.t_error_number := -20904;
   s_al_errato_msg    constant afc_error.t_error_msg := 'La data di fine puo'' essere modificata solo sull''ultimo periodo';
   componenti_istituiti exception;
   pragma exception_init(componenti_istituiti, -20905);
   s_componenti_istituiti_number constant afc_error.t_error_number := -20905;
   s_componenti_istituiti_msg    constant afc_error.t_error_msg := 'Esistono componenti per la revisione istituiti con data antecedente alla data indicata';
   componenti_cessati exception;
   pragma exception_init(componenti_cessati, -20906);
   s_componenti_cessati_number constant afc_error.t_error_number := -20906;
   s_componenti_cessati_msg    constant afc_error.t_error_msg := 'Esistono componenti per la revisione cessati con data successiva alla data indicata';
   ass_prev_assente exception; -- Non modificare questo codice di errore !
   pragma exception_init(ass_prev_assente, -20907);
   s_ass_prev_assente_number constant afc_error.t_error_number := -20907;
   s_ass_prev_assente_msg    constant afc_error.t_error_msg := 'Componente privo di assegnazione prevalente per il periodo indicato';
   ass_prev_multiple exception; -- Non modificare questo codice di errore !
   pragma exception_init(ass_prev_multiple, -20908);
   s_ass_prev_multiple_number constant afc_error.t_error_number := -20908;
   s_ass_prev_multiple_msg    constant afc_error.t_error_msg := 'Componente con più assegnazioni prevalenti per il periodo indicato';
   componente_non_assegnato exception;
   pragma exception_init(componente_non_assegnato, -20909);
   s_componente_non_ass_number constant afc_error.t_error_number := -20909;
   s_componente_non_ass_msg    constant afc_error.t_error_msg := 'Il componente non e'' piu'' assegnato ad alcuna unita'' organizzativa';
   componente_gia_presente exception;
   pragma exception_init(componente_gia_presente, -20910);
   s_componente_gia_pres_number constant afc_error.t_error_number := -20910;
   s_componente_gia_pres_msg    constant afc_error.t_error_msg := 'Il componente  e'' gia'' assegnato all''unita'' organizzativa selezionata';
   revisioni_errate exception;
   pragma exception_init(revisioni_errate, -20911);
   s_revisioni_errate_num constant afc_error.t_error_number := -20911;
   s_revisioni_errate_msg constant afc_error.t_error_msg := 'Incongruenza nell''inserimento delle revisioni';
   modifica_retroattiva exception;
   pragma exception_init(modifica_retroattiva, -20912);
   s_modifica_retroattiva_num constant afc_error.t_error_number := -20912;
   s_modifica_retroattiva_msg constant afc_error.t_error_msg := 'Modifica retroattiva non eseguibile: esistono ruoli applicativi';
   data_inizio_mancante exception;
   pragma exception_init(data_inizio_mancante, -20913);
   s_data_inizio_mancante_num constant afc_error.t_error_number := -20913;
   s_data_inizio_mancante_msg constant afc_error.t_error_msg := 'Dati incompleti: indicare la data di inizio o la revisione di assegnazione';
   uo_non_valida exception;
   pragma exception_init(uo_non_valida, -20914);
   s_uo_non_valida_num constant afc_error.t_error_number := -20914;
   s_uo_non_valida_msg constant afc_error.t_error_msg := 'Unita'' organizzativa non in struttura per il periodo indicato';
   err_set_fi exception;
   pragma exception_init(err_set_fi, -20915); --#457
   s_err_set_fi_num constant afc_error.t_error_number := -20915;
   s_err_set_fi_msg constant afc_error.t_error_msg := 'Errore in aggiornamento del componente';
   --   assegnazione_ripetuta exception;
   --   pragma exception_init(uo_non_valida, -20915);
   --   s_assegnazione_ripetuta_num constant afc_error.t_error_number := -20915;
   --   s_assegnazione_ripetuta_msg constant afc_error.t_error_msg := 'Assegnazione gia'' esistente sulla stessa unita'' organizzativa';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_componente             in componenti.id_componente%type default null
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type default null
      --     ,p_al_prec                   in componenti.al_prec%type default null
     ,p_ni                     in componenti.ni%type default null
     ,p_ci                     in componenti.ci%type default null
     ,p_codice_fiscale         in componenti.codice_fiscale%type default null
     ,p_denominazione          in componenti.denominazione%type default null
     ,p_denominazione_al1      in componenti.denominazione_al1%type default null
     ,p_denominazione_al2      in componenti.denominazione_al2%type default null
     ,p_stato                  in componenti.stato%type default null
     ,p_ottica                 in componenti.ottica%type default null
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type default null
     ,p_dal_pubb               in componenti.dal_pubb%type default null
     ,p_al_pubb                in componenti.al_pubb%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_componente   in componenti.id_componente%type
     ,p_new_progr_unita_org in componenti.progr_unita_organizzativa%type
     ,p_new_dal             in componenti.dal%type
     ,p_new_al              in componenti.al%type
     ,p_new_dal_pubb        in componenti.dal_pubb%type default null
     ,p_new_al_pubb         in componenti.al_pubb%type default null
      --     ,p_new_al_prec                in componenti.al_prec%type default null
     ,p_new_ni                     in componenti.ni%type
     ,p_new_ci                     in componenti.ci%type
     ,p_new_codice_fiscale         in componenti.codice_fiscale%type
     ,p_new_denominazione          in componenti.denominazione%type
     ,p_new_denominazione_al1      in componenti.denominazione_al1%type
     ,p_new_denominazione_al2      in componenti.denominazione_al2%type
     ,p_new_stato                  in componenti.stato%type
     ,p_new_ottica                 in componenti.ottica%type
     ,p_new_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_new_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_new_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_new_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_old_id_componente          in componenti.id_componente%type default null
     ,p_old_progr_unita_org        in componenti.progr_unita_organizzativa%type default null
     ,p_old_dal                    in componenti.dal%type default null
     ,p_old_al                     in componenti.al%type default null
     ,p_old_dal_pubb               in componenti.dal_pubb%type default null
     ,p_old_al_pubb                in componenti.al_pubb%type default null
      --     ,p_old_al_prec                in componenti.al_prec%type default null
     ,p_old_ni                     in componenti.ni%type default null
     ,p_old_ci                     in componenti.ci%type default null
     ,p_old_codice_fiscale         in componenti.codice_fiscale%type default null
     ,p_old_denominazione          in componenti.denominazione%type default null
     ,p_old_denominazione_al1      in componenti.denominazione_al1%type default null
     ,p_old_denominazione_al2      in componenti.denominazione_al2%type default null
     ,p_old_stato                  in componenti.stato%type default null
     ,p_old_ottica                 in componenti.ottica%type default null
     ,p_old_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_old_revisione_cessazione   in componenti.revisione_cessazione%type default null
     ,p_old_utente_aggiornamento   in componenti.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in componenti.data_aggiornamento%type default null
     ,p_check_old                  in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_componente in componenti.id_componente%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_id_componente in componenti.id_componente%type
     ,p_column        in varchar2
     ,p_value         in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_id_componente             in componenti.id_componente%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type default null
     ,p_dal                       in componenti.dal%type default null
     ,p_al                        in componenti.al%type default null
     ,p_dal_pubb                  in componenti.dal_pubb%type default null
     ,p_al_pubb                   in componenti.al_pubb%type default null
      --     ,p_al_prec                   in componenti.al_prec%type default null
     ,p_ni                     in componenti.ni%type default null
     ,p_ci                     in componenti.ci%type default null
     ,p_codice_fiscale         in componenti.codice_fiscale%type default null
     ,p_denominazione          in componenti.denominazione%type default null
     ,p_denominazione_al1      in componenti.denominazione_al1%type default null
     ,p_denominazione_al2      in componenti.denominazione_al2%type default null
     ,p_ottica                 in componenti.ottica%type default null
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type default null
     ,p_check_old              in integer default 0
   );
   -- Attributo progr_unita_organizzativa di riga esistente identificata da chiave
   function get_progr_unita_organizzativa /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type)
      return componenti.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita_organizzativa, wnds);
   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.al%type;
   pragma restrict_references(get_al, wnds);
   -- Attributo dal_pubb di riga esistente identificata da chiave
   function get_dal_pubb /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.dal_pubb%type;
   pragma restrict_references(get_dal_pubb, wnds);
   -- Attributo al_pubb di riga esistente identificata da chiave
   function get_al_pubb /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.al_pubb%type;
   pragma restrict_references(get_al_pubb, wnds);
   -- Attributo al_prec di riga esistente identificata da chiave
   function get_al_prec /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.al_prec%type;
   pragma restrict_references(get_al_prec, wnds);
   -- Attributo ni di riga esistente identificata da chiave
   function get_ni /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.ni%type;
   pragma restrict_references(get_ni, wnds);
   -- Attributo ci di riga esistente identificata da chiave
   function get_ci /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.ci%type;
   pragma restrict_references(get_ci, wnds);
   -- Attributo codice_fiscale di riga esistente identificata da chiave
   function get_codice_fiscale /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.codice_fiscale%type;
   pragma restrict_references(get_codice_fiscale, wnds);
   -- Attributo denominazione di riga esistente identificata da chiave
   function get_denominazione /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.denominazione%type;
   pragma restrict_references(get_denominazione, wnds);
   -- Attributo stato di riga esistente identificata da chiave
   function get_stato /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.stato%type;
   pragma restrict_references(get_stato, wnds);
   -- Attributo ottica di riga esistente identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type) return componenti.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Attributo revisione_assegnazione di riga esistente identificata da chiave
   function get_revisione_assegnazione /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type)
      return componenti.revisione_assegnazione%type;
   pragma restrict_references(get_revisione_assegnazione, wnds);
   -- Attributo revisione_cessazione di riga esistente identificata da chiave
   function get_revisione_cessazione /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type)
      return componenti.revisione_cessazione%type;
   pragma restrict_references(get_revisione_cessazione, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type)
      return componenti.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_componente in componenti.id_componente%type)
      return componenti.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_componente             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_ci                        in varchar2 default null
     ,p_codice_fiscale            in varchar2 default null
     ,p_denominazione             in varchar2 default null
     ,p_denominazione_al1         in varchar2 default null
     ,p_denominazione_al2         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_assegnazione    in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_order_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_componente             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_ci                        in varchar2 default null
     ,p_codice_fiscale            in varchar2 default null
     ,p_denominazione             in varchar2 default null
     ,p_denominazione_al1         in varchar2 default null
     ,p_denominazione_al2         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_assegnazione    in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return integer;
   -- Restituisce l'id componente nuovo in caso di inserimento
   function get_id_componente return componenti.id_componente%type;
   -- Restituisce la descrizione dell'incarico del componente
   function get_descr_incarico /* SLAVE_COPY */
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.descrizione%type;
   -- Restituisce il campo "responsabile" dell'incarico del componente
   function get_se_resp_corrente /* SLAVE_COPY */
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.responsabile%type;
   -- Restituisce il campo "responsabile" dell'incarico del componente
   function get_se_resp_valido /* SLAVE_COPY */
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.responsabile%type;
   -- Restituisce il campo "progr_unita_organizzativa" dell'ultima
   -- assegnazione del componente
   function get_ultima_assegnazione /* SLAVE_COPY */
   (p_ci in componenti.ci%type) return componenti.progr_unita_organizzativa%type;
   function controllo_modificabilita
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
   ) return afc_error.t_error_number;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione comune di Casalecchio di Reno
   function determina_nominativo_cdr(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione provincia di Modena
   function determina_nominativo_provmo(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione comune di San Giuliano Milanese
   function determina_nominativo_sgm(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione SERT Regione Toscana, Campania e Puglia
   function determina_nominativo_n_sp_c(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione comuni di Cornaredo/Vigevano e provincia di Brescia
   function determina_nominativo_4(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione CRV
   function determina_nominativo_5(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione Regione Calabria
   function determina_nominativo_6(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- nuova versione provincia di Modena
   function determina_nominativo_7(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   -- versione Regione MArche
   function determina_nominativo_rm(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Nominativo" da inserire in AD4_UTENTI
   function determina_nominativo(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type;
   -- Calcola il campo "Utente" da inserire in AD4_UTENTI
   -- versione comune di San Giuliano Milanese
   function determina_utente_sgm(p_ni in componenti.ni%type) return ad4_utenti.utente%type;
   -- Calcola il campo "Utente" da inserire in AD4_UTENTI
   -- nuova versione provincia di Modena
   function determina_utente_7(p_ni in componenti.ni%type) return ad4_utenti.utente%type;
   -- Calcola il campo "Utente" da inserire in AD4_UTENTI
   function determina_utente(p_ni in componenti.ni%type) return ad4_utenti.utente%type;
   -- Verifica la presenza di assegnazioni successiva
   function is_ultima_assegnazione(p_id_componente componenti.id_componente%type)
      return afc_error.t_error_number;
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in componenti.dal%type
     ,p_al  in componenti.al%type
   ) return afc_error.t_error_number;
   -- controllo congruenza revisioni
   function is_revisioni_ok
   (
      p_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_ottica                 in componenti.ottica%type
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
   );
   function is_dal_ok
   (
      p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_denominazione             in componenti.denominazione%type
     ,p_old_dal                   in componenti.dal%type
     ,p_new_dal                   in componenti.dal%type
     ,p_old_al                    in componenti.al%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number;
   function is_al_ok
   (
      p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_denominazione             in componenti.denominazione%type
     ,p_old_dal                   in componenti.dal%type
     ,p_old_al                    in componenti.al%type
     ,p_new_al                    in componenti.al%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number;
   function is_componente_ok
   (
      p_ottica        in componenti.ottica%type
     ,p_ni            in componenti.ni%type
     ,p_ci            in componenti.ci%type
     ,p_denominazione in componenti.denominazione%type
     ,p_dal           in componenti.dal%type
   ) return afc_error.t_error_number;
   -- Controlla che il componente non sia gia' associato alla U.O.
   function esiste_componente
   (
      p_id_componente             in componenti.id_componente%type
     ,p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type
     ,p_revisione_cessazione      in componenti.revisione_cessazione%type
   ) return afc_error.t_error_number;
   function is_ri_ok
   (
      p_id_componente            in componenti.id_componente%type
     ,p_ottica                   in componenti.ottica%type
     ,p_ni                       in componenti.ni%type
     ,p_ci                       in componenti.ci%type
     ,p_denominazione            in componenti.denominazione%type
     ,p_old_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_new_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_old_dal                  in componenti.dal%type
     ,p_new_dal                  in componenti.dal%type
     ,p_old_al                   in componenti.al%type
     ,p_new_al                   in componenti.al%type
     ,p_old_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_new_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_componente            in componenti.id_componente%type
     ,p_ottica                   in componenti.ottica%type
     ,p_ni                       in componenti.ni%type
     ,p_ci                       in componenti.ci%type
     ,p_denominazione            in componenti.denominazione%type
     ,p_old_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_new_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_old_dal                  in componenti.dal%type
     ,p_new_dal                  in componenti.dal%type
     ,p_old_al                   in componenti.al%type
     ,p_new_al                   in componenti.al%type
     ,p_old_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_new_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_new_utente_aggiornamento in componenti.utente_aggiornamento%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   );
   -- procedure di settaggio di Functional Integrity
   procedure set_fi
   (
      p_id_componente              in componenti.id_componente%type
     ,p_new_ottica                 in componenti.ottica%type
     ,p_old_ottica                 in componenti.ottica%type
     ,p_old_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_new_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_old_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_new_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_ni                         in componenti.ni%type
     ,p_ci                         in componenti.ci%type
     ,p_new_progr_uo               in componenti.progr_unita_organizzativa%type
     ,p_old_progr_uo               in componenti.progr_unita_organizzativa%type
     ,p_denominazione              in componenti.denominazione%type
     ,p_old_dal                    in componenti.dal%type
     ,p_new_dal                    in componenti.dal%type
     ,p_old_al                     in componenti.al%type
     ,p_new_al                     in componenti.al%type
     ,p_old_dal_pubb               in componenti.dal_pubb%type
     ,p_new_dal_pubb               in componenti.dal_pubb%type
     ,p_old_al_pubb                in componenti.al_pubb%type
     ,p_new_al_pubb                in componenti.al_pubb%type
     ,p_old_al_prec                in componenti.al_prec%type
     ,p_new_al_prec                in componenti.al_prec%type
     ,p_data_aggiornamento         in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento       in componenti.utente_aggiornamento%type
     ,p_inserting                  in number
     ,p_updating                   in number
     ,p_deleting                   in number
   );
   -- Controlla che non esistano componenti assegnati o cessati con la
   -- revisione indicata aventi data inizio o fine validità non congruente
   -- con la data della revisione
   function is_componenti_revisione_ok
   (
      p_ottica         in componenti.ottica%type
     ,p_revisione      in componenti.revisione_assegnazione%type
     ,p_data           in componenti.dal%type
     ,p_tipo_controllo in number default 0
   ) return afc_error.t_error_number;
   /*
   -- Controlla che non esistano componenti privi di assegnazione
   -- a fronte della cessazione di un'unità organizzativa
   function is_componenti_unita_cessata_ok
   ( p_ottica                      in componenti.ottica%type
   , p_progr_unita_organizzativa   in componenti.progr_unita_organizzativa%type
   , p_data                        in componenti.dal%type
   ) return AFC_Error.t_error_number;*/
   -- Backup componenti: in caso di aggiornamento dell'unita' organizzativa
   procedure backup_componente(p_id_componente in componenti.id_componente%type);
   -- Backup componenti: in caso di aggiornamento dell'unita' organizzativa
   procedure recupera_componente(p_id_componente in componenti.id_componente%type);
   -- Inserimento componente
   procedure inserisci_componente
   (
      p_id_componente             in componenti.id_componente%type default null
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type default null
     ,p_ni                        in componenti.ni%type default null
     ,p_ci                        in componenti.ci%type default null
     ,p_codice_fiscale            in componenti.codice_fiscale%type default null
     ,p_denominazione             in componenti.denominazione%type default null
     ,p_denominazione_al1         in componenti.denominazione_al1%type default null
     ,p_denominazione_al2         in componenti.denominazione_al2%type default null
     ,p_stato                     in componenti.stato%type default null
     ,p_ottica                    in componenti.ottica%type default null
     ,p_revisione_assegnazione    in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione      in componenti.revisione_cessazione%type default null
     ,p_incarico                  in attributi_componente.incarico%type default null
     ,p_telefono                  in attributi_componente.telefono%type default null
     ,p_fax                       in attributi_componente.fax%type default null
     ,p_e_mail                    in attributi_componente.e_mail%type default null
     ,p_assegnazione_prevalente   in attributi_componente.assegnazione_prevalente%type default null
     ,p_percentuale_impiego       in attributi_componente.percentuale_impiego%type default null
     ,p_utente_aggiornamento      in componenti.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in componenti.data_aggiornamento%type default null
     ,p_dal_pubb                  in componenti.dal_pubb%type
     ,p_al_pubb                   in componenti.al_pubb%type default null
   );
   -- Eliminazione componente
   procedure elimina_componente
   (
      p_id_componente          in componenti.id_componente%type
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_al                     in componenti.al%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Verifica ereditarieta ruoli
   function verifica_ereditarieta
   (
      p_stringa_sudd registro.valore%type
     ,p_ottica       ottiche.ottica%type
     ,p_revisione    revisioni_struttura.revisione%type
     ,p_data         componenti.dal%type
     ,p_unita_orig   anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_unita_dest   anagrafe_unita_organizzative.progr_unita_organizzativa%type
   ) return afc_error.t_error_number;
   -- Spostamento componente
   procedure sposta_componente
   (
      p_id_componente          in componenti.id_componente%type
     ,p_unita_org_dest         in componenti.progr_unita_organizzativa%type
     ,p_ottica                 in componenti.ottica%type
     ,p_revisione              in componenti.revisione_assegnazione%type default null
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Ripristino componente
   procedure ripristina_componente
   (
      p_id_componente          in componenti.id_componente%type
     ,p_revisione              in componenti.revisione_assegnazione%type
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Annullamento spostamento
   procedure annulla_spostamento
   (
      p_id_componente          in componenti.id_componente%type
     ,p_id_comp_prec           out componenti.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di aggiornamento della data di inizio e fine validità
   -- al momento dell'attivazione della revisione
   procedure update_comp
   (
      p_ottica    in componenti.ottica%type
     ,p_revisione in componenti.revisione_assegnazione%type
     ,p_data      in componenti.dal%type
   );
   -- valorizza la variabile s_tipo_revisione
   procedure set_tipo_revisione
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
   );
   -- Conta le assegnazioni  dell'individuo
   -- per il periodo indicato
   function conta_assegnazioni
   (
      p_ni  in componenti.ni%type
     ,p_dal in componenti.dal%type default null
     ,p_al  in componenti.al%type default null
   ) return number;
   -- procedure di cessazione alla data indicata di una assegnazione o
   -- di tutte le assegnazioni dell'individuo
   procedure chiudi_assegnazioni
   (
      p_ni                     in componenti.ni%type
     ,p_data                   in componenti.al%type
     ,p_id_componente          in componenti.id_componente%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di ripristino delle assegnazioni chiuse
   -- con la procedure chiudi_assegnazione che erano valide alla p_data
   procedure ripristina_assegnazioni
   (
      p_ni                     in componenti.ni%type
     ,p_data                   in componenti.al%type
     ,p_id_componente          in componenti.id_componente%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di eliminazione di una assegnazione
   procedure elimina_assegnazione
   (
      p_id_componente          in componenti.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Conta le assegnazioni ripristinabili alla sysdate dell'individuo
   function conta_assegnazioni_ripr(p_ni in componenti.ni%type) return number;
   -- procedure di inserimento assegnazione funzionale ricavata da altra
   -- assegnazione
   procedure ins_ass_singola
   (
      p_id_componente          in componenti.id_componente%type
     ,p_ottica                 in componenti.ottica%type
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_stringa_unor_out       varchar2
     ,p_ruolo                  in ruoli_componente.ruolo%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di inserimento assegnazione funzionale ricavata da altra
   -- assegnazione
   procedure ins_ass_funzionali
   (
      p_ottica                 in componenti.ottica%type
     ,p_stringa_unor_inp       in varchar2
     ,p_stringa_comp           in varchar2
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_stringa_unor_out       in varchar2
     ,p_ruolo                  in ruoli_componente.ruolo%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di inserimento assegnazione funzionale ricavata da altra
   -- assegnazione
   procedure conferma_incarico
   (
      p_id_componente          in componenti.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di attribuzione automatica dei ruoli applicativi #634
   procedure attribuzione_ruoli
   (
      p_id_componente          in componenti.id_componente%type
     ,p_dal                    in date default null
     ,p_al                     in date default null
     ,p_tipo_variazione        in number default 1
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Verifica le condizioni di attivazione della conferma di incarico
   function attivazione_conferma_incarico(p_id_componente in componenti.id_componente%type)
      return varchar2;
   -- Verifica se sussistono le condizioni per poter eliminare il componente
   function is_componente_eliminabile(p_id_componente in componenti.id_componente%type)
      return varchar2;
   function get_desc_comp_tree
   (
      p_id_componente        in componenti.id_componente%type
     ,p_revisione_modifica   in revisioni_struttura.revisione%type
     ,p_data_riferimento     in date
     ,p_visualizza_incarichi in varchar2
   ) return varchar2;

   function is_componente_annullabile(p_id_componente in componenti.id_componente%type)
      return varchar2;
end componente;
/


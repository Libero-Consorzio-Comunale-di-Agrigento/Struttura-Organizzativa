CREATE OR REPLACE package ubicazione_unita is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        ubicazione_unita
    DESCRIZIONE: Gestione tabella ubicazioni_unita.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.12.
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    12/03/2008  VDAVALLI  Prima emissione.
    01    04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    02/01/2013  ADADAMO   Aggiunta get_uo_competenza
    03    28/02/2013  MMONARI   modificata esiste_associazione (Redmine #199)
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.03';

   s_table_name constant afc.t_object_name := 'ubicazioni_unita';

   subtype t_rowtype is ubicazioni_unita%rowtype;

   -- Tipo del record primary key
   type t_pk is record(
       id_ubicazione_unita ubicazioni_unita.id_ubicazione%type);

   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_number constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg    constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';

   ubicazione_gia_presente exception;
   pragma exception_init(ubicazione_gia_presente, -20902);
   s_ubicazione_gia_pres_number constant afc_error.t_error_number := -20902;
   s_ubicazione_gia_pres_msg    constant afc_error.t_error_msg := 'Ubicazione gia'' presente';

   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_sequenza                  in ubicazioni_unita.sequenza%type default null
     ,p_dal                       in ubicazioni_unita.dal%type default null
     ,p_al                        in ubicazioni_unita.al%type default null
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_id_origine                in ubicazioni_unita.id_origine%type default null
     ,p_utente_aggiornamento      in ubicazioni_unita.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in ubicazioni_unita.data_aggiornamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_ubicazione_unita  in ubicazioni_unita.id_ubicazione%type
     ,p_new_progr_unor           in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_new_sequenza             in ubicazioni_unita.sequenza%type
     ,p_new_dal                  in ubicazioni_unita.dal%type
     ,p_new_al                   in ubicazioni_unita.al%type
     ,p_new_progr_unita_fisica   in ubicazioni_unita.progr_unita_fisica%type
     ,p_new_id_origine           in ubicazioni_unita.id_origine%type default null
     ,p_new_utente_aggiornamento in ubicazioni_unita.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in ubicazioni_unita.data_aggiornamento%type
     ,p_old_id_ubicazione_unita  in ubicazioni_unita.id_ubicazione%type default null
     ,p_old_progr_unor           in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_old_sequenza             in ubicazioni_unita.sequenza%type default null
     ,p_old_dal                  in ubicazioni_unita.dal%type default null
     ,p_old_al                   in ubicazioni_unita.al%type default null
     ,p_old_progr_unita_fisica   in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_old_id_origine           in ubicazioni_unita.id_origine%type default null
     ,p_old_utente_aggiornamento in ubicazioni_unita.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in ubicazioni_unita.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_ubicazione in ubicazioni_unita.id_ubicazione%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );

   procedure upd_column
   (
      p_id_ubicazione in ubicazioni_unita.id_ubicazione%type
     ,p_column        in varchar2
     ,p_value         in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_sequenza                  in ubicazioni_unita.sequenza%type default null
     ,p_dal                       in ubicazioni_unita.dal%type default null
     ,p_al                        in ubicazioni_unita.al%type default null
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_id_origine                in ubicazioni_unita.id_origine%type default null
     ,p_utente_aggiornamento      in ubicazioni_unita.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in ubicazioni_unita.data_aggiornamento%type default null
     ,p_check_old                 in integer default 0
   );

   -- Attributo progr_unita_organizzativa di riga esistente identificata da chiave
   function get_progr_unita_organizzativa /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita_organizzativa, wnds);

   -- Attributo sequenza di riga esistente identificata da chiave
   function get_sequenza /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.sequenza%type;
   pragma restrict_references(get_sequenza, wnds);

   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return ubicazioni_unita.dal%type;
   pragma restrict_references(get_dal, wnds);

   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return ubicazioni_unita.al%type;
   pragma restrict_references(get_al, wnds);

   -- Attributo progr_unita_fisica di riga esistente identificata da chiave
   function get_progr_unita_fisica /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.progr_unita_fisica%type;
   pragma restrict_references(get_progr_unita_fisica, wnds);

   -- Attributo tipo_registrazione di riga esistente identificata da chiave
   function get_id_origine /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.id_origine%type;
   pragma restrict_references(get_id_origine, wnds);

   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   function get_id_ubicazione /* SLAVE_COPY */
   (
      p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
   ) return ubicazioni_unita.id_ubicazione%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_ubicazione             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_id_origine                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_ubicazione             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_id_origine                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return integer;

   -- Generazione di un nuovo id per inserimento record
   function genera_id return ubicazioni_unita.id_ubicazione%type;

   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in ubicazioni_unita.dal%type
     ,p_al  in ubicazioni_unita.al%type
   ) return afc_error.t_error_number;

   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in ubicazioni_unita.dal%type
     ,p_al  in ubicazioni_unita.al%type
   ) return afc_error.t_error_number;

   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in ubicazioni_unita.dal%type
     ,p_al  in ubicazioni_unita.al%type
   );

   -- Controlla che non esista la stessa relazione unita organizzativa/
   -- unita fisica per lo stesso periodo
   function esiste_ubicazione
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
   ) return afc_error.t_error_number;

   function is_ri_ok
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number;

   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
     ,p_inserting                 in number
     ,p_updating                  in number
   );

   function esiste_associazione
   (
      p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_data                      in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
   ) return integer;

   function get_ubicazione_unica
   (
      p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_data                      in ubicazioni_unita.dal%type
   ) return ubicazioni_unita.id_ubicazione%type;

   procedure propaga_unita
   (
      p_ottica                    in anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione           in amministrazioni.codice_amministrazione%type default null
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
     ,p_utente_aggiornamento      in ubicazioni_unita.utente_aggiornamento%type
   );

   procedure aggiorna_unita
   (
      p_id_origine           in ubicazioni_unita.id_origine%type
     ,p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                  in ubicazioni_unita.dal%type
     ,p_al                   in ubicazioni_unita.al%type
     ,p_utente_aggiornamento in ubicazioni_unita.utente_aggiornamento%type
   );

   procedure rimuovi_unita(p_id_origine in ubicazioni_unita.id_origine%type default null);

   function get_uo_competenza
   (
      p_progr_unita_fisica in ubicazioni_unita.progr_unita_fisica%type
     ,p_data_rif           in date
   ) return ubicazioni_unita.progr_unita_organizzativa%type;

end ubicazione_unita;
/


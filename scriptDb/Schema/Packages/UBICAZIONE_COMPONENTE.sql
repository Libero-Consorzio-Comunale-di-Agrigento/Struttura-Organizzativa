CREATE OR REPLACE package ubicazione_componente is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        UBICAZIONE_COMPONENTE
    DESCRIZIONE: Gestione tabella ubicazioni_componente.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.12.
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    13/03/2008  VDAVALLI  Prima emissione.
    01    04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    07/11/2012  MMONARI   Rivisitazione struttura fisica; rel. 1.4.2
    03    22/05/2015  MMONARI   #544, Proc.get_date_ubicazione_comp
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.03';

   s_table_name constant afc.t_object_name := 'ubicazioni_componente';

   subtype t_rowtype is ubicazioni_componente%rowtype;

   -- Tipo del record primary key
   type t_pk is record(
       id_ubicazione_componente ubicazioni_componente.id_ubicazione_componente%type);

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
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return boolean;
   pragma restrict_references(existsid, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type default null
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type default null
     ,p_dal                      in ubicazioni_componente.dal%type default null
     ,p_al                       in ubicazioni_componente.al%type default null
     ,p_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_new_id_componente            in ubicazioni_componente.id_componente%type
     ,p_new_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_new_dal                      in ubicazioni_componente.dal%type
     ,p_new_al                       in ubicazioni_componente.al%type
     ,p_new_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_new_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type
     ,p_new_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type
     ,p_old_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type default null
     ,p_old_id_componente            in ubicazioni_componente.id_componente%type default null
     ,p_old_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type default null
     ,p_old_dal                      in ubicazioni_componente.dal%type default null
     ,p_old_al                       in ubicazioni_componente.al%type default null
     ,p_old_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_old_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type default null
     ,p_check_old                    in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_column                   in varchar2
     ,p_value                    in varchar2 default null
     ,p_literal_value            in number default 1
   );

   procedure upd_column
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_column                   in varchar2
     ,p_value                    in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type default null
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type default null
     ,p_dal                      in ubicazioni_componente.dal%type default null
     ,p_al                       in ubicazioni_componente.al%type default null
     ,p_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
   );

   -- Attributo id_componente di riga esistente identificata da chiave
   function get_id_componente /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.id_componente%type;
   pragma restrict_references(get_id_componente, wnds);

   -- Attributo id_ubicazione_unita di riga esistente identificata da chiave
   function get_id_ubicazione_unita /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.id_ubicazione_unita%type;
   pragma restrict_references(get_id_ubicazione_unita, wnds);

   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.dal%type;
   pragma restrict_references(get_dal, wnds);

   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.al%type;
   pragma restrict_references(get_al, wnds);

   -- Attributo tipo_registrazione di riga esistente identificata da chiave
   function get_id_origine /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.id_origine%type;
   pragma restrict_references(get_id_origine, wnds);

   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_ubicazione_componente in varchar2 default null
     ,p_id_componente            in varchar2 default null
     ,p_id_ubicazione_unita      in varchar2 default null
     ,p_dal                      in varchar2 default null
     ,p_al                       in varchar2 default null
     ,p_id_origine               in varchar2 default null
     ,p_utente_aggiornamento     in varchar2 default null
     ,p_data_aggiornamento       in varchar2 default null
     ,p_other_condition          in varchar2 default null
     ,p_qbe                      in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_ubicazione_componente in varchar2 default null
     ,p_id_componente            in varchar2 default null
     ,p_id_ubicazione_unita      in varchar2 default null
     ,p_dal                      in varchar2 default null
     ,p_al                       in varchar2 default null
     ,p_id_origine               in varchar2 default null
     ,p_utente_aggiornamento     in varchar2 default null
     ,p_data_aggiornamento       in varchar2 default null
     ,p_other_condition          in varchar2 default null
     ,p_qbe                      in number default 0
   ) return integer;

   -- Id. ubicazione di ubicazione del componente alla data indicata
   function get_id_ubicazione_corrente
   (
      p_id_componente in ubicazioni_componente.id_componente%type
     ,p_data          in ubicazioni_componente.dal%type
   ) return ubicazioni_componente.id_ubicazione_componente%type;

   -- Progr. unita' fisica di ubicazione del componente alla data indicata
   function get_ubicazione_corrente
   (
      p_id_componente in ubicazioni_componente.id_componente%type
     ,p_data          in ubicazioni_componente.dal%type
   ) return ubicazioni_unita.progr_unita_fisica%type;

   -- Generazione di un nuovo id per inserimento record
   function genera_id return ubicazioni_componente.id_ubicazione_componente%type;

   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in ubicazioni_componente.dal%type
     ,p_al  in ubicazioni_componente.al%type
   ) return afc_error.t_error_number;

   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in ubicazioni_componente.dal%type
     ,p_al  in ubicazioni_componente.al%type
   ) return afc_error.t_error_number;

   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in ubicazioni_componente.dal%type
     ,p_al  in ubicazioni_componente.al%type
   );

   -- Controlla che non esista la stessa relazione unita fisica/
   -- componente per lo stesso periodo
   function esiste_ubicazione
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal                      in ubicazioni_componente.dal%type
     ,p_al                       in ubicazioni_componente.al%type
   ) return afc_error.t_error_number;

   function is_ri_ok
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal                      in ubicazioni_componente.dal%type
     ,p_al                       in ubicazioni_componente.al%type
     ,p_inserting                in number
     ,p_updating                 in number
   ) return afc_error.t_error_number;

   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal                      in ubicazioni_componente.dal%type
     ,p_al                       in ubicazioni_componente.al%type
     ,p_inserting                in number
     ,p_updating                 in number
   );

   -- procedure di settaggio di Functional Integrity
   procedure set_fi
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in componenti.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_old_dal                  in ubicazioni_componente.dal%type
     ,p_new_dal                  in ubicazioni_componente.dal%type
     ,p_old_al                   in ubicazioni_componente.al%type
     ,p_new_al                   in ubicazioni_componente.al%type
     ,p_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   );
   -- Eliminazione ubicazioni_componente di un componente (delete)
   procedure elimina_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Annullamento ubicazioni_componente di un componente (al)
   procedure annulla_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_al                     in ubicazioni_componente.al%type
     ,p_data_aggiornamento     in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ubicazioni_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Aggiornamento ubicazioni_componente di un componente (dal)
   procedure aggiorna_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_dal                    in ubicazioni_componente.dal%type
     ,p_data_aggiornamento     in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ubicazioni_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Ripristino ubicazioni_componente di un componente (al = null)
   procedure ripristina_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_data_aggiornamento     in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ubicazioni_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Inserisce l'ubicazione dei componenti di una unita'
   procedure associa_componenti
   (
      p_ottica                    in componenti.ottica%type
     ,p_revisione                 in componenti.revisione_assegnazione%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_id_ubicazione_unita       in ubicazioni_unita.id_ubicazione%type
     ,p_dal                       in ubicazioni_componente.dal%type
     ,p_al                        in ubicazioni_componente.al%type
     ,p_id_origine                in ubicazioni_componente.id_origine%type
     ,p_utente_aggiornamento      in ubicazioni_componente.utente_aggiornamento%type
   );

   -- Rimuove le ubicazioni dei componenti di una unita'
   procedure rimuovi_componenti(p_id_origine in ubicazioni_unita.id_origine%type);

   procedure get_date_ubicazione_comp --#544
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal_ubicazione_comp      out varchar2 -- date nel formato dd/mm/yyyy
     ,p_al_ubicazione_comp       out varchar2 -- date nel formato dd/mm/yyyy
     ,p_segnalazione             out varchar2 -- eventuale segnalazione di anomalia
   );
end ubicazione_componente;
/


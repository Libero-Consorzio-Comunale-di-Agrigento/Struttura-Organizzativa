CREATE OR REPLACE package amministrazione is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        amministrazione
    DESCRIZIONE: Gestione tabella amministrazioni.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    19/07/2006  VDAVALLI  Prima emissione.
    01    27/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    </CODE>
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.01';

   -- Tipo del record primary key
   type t_pk is record(
       codice_amministrazione amministrazioni.codice_amministrazione%type);

   /*   -- Exceptions
      <exception_name> exception;
      pragma exception_init( <exception_name>, <error_code> );
      s_<exception_name>_number constant AFC_Error.t_error_number := <error_code>;
      s_<exception_name>_msg    constant AFC_Error.t_error_msg := <error_message>;
      ...
   */
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_new_ni                     in amministrazioni.ni%type
     ,p_new_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_new_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_new_ente                   in amministrazioni.ente%type
     ,p_new_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_old_codice_amministrazione in amministrazioni.codice_amministrazione%type default null
     ,p_old_ni                     in amministrazioni.ni%type default null
     ,p_old_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_old_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_old_ente                   in amministrazioni.ente%type default null
     ,p_old_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_check_old                  in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_column                 in varchar2
     ,p_value                  in varchar2 default null
     ,p_literal_value          in number default 1
   );

   procedure upd_column
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_column                 in varchar2
     ,p_value                  in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type default null
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_check_old              in integer default 0
   );

   -- Attributo ni di riga esistente identificata da chiave
   function get_ni /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.ni%type;
   pragma restrict_references(get_ni, wnds);

   -- Attributo data_istituzione di riga esistdata_istituzione identificata da chiave
   function get_data_istituzione /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.data_istituzione%type;
   pragma restrict_references(get_data_istituzione, wnds);

   -- Attributo data_soppressione di riga esistdata_soppressione identificata da chiave
   function get_data_soppressione /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.data_soppressione%type;
   pragma restrict_references(get_data_soppressione, wnds);

   -- Attributo ente di riga esistente identificata da chiave
   function get_ente /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.ente%type;
   pragma restrict_references(get_ente, wnds);

   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo  di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type default null
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type default null
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_order_condition        in varchar2 default null
     ,p_qbe                    in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type default null
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type default null
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_qbe                    in number default 0
   ) return integer;

   -- Function "Trova" per Jprotocollo   
   function trova /* SLAVE_COPY */
   (
      p_codice               in amministrazioni.codice_amministrazione%type
     ,p_ni                   in amministrazioni.ni%type
     ,p_denominazione        in as4_anagrafe_soggetti.cognome%type
     ,p_indirizzo            in as4_anagrafe_soggetti.indirizzo_res%type
     ,p_cap                  in as4_anagrafe_soggetti.cap_res%type
     ,p_citta                in varchar2
     ,p_provincia            in varchar2
     ,p_regione              in varchar2
     ,p_sito_istituzionale   in as4_anagrafe_soggetti.indirizzo_web%type
     ,p_indirizzo_telematico in indirizzi_telematici.indirizzo%type
     ,p_data_riferimento     in amministrazioni.data_istituzione%type default trunc(sysdate)
   ) return afc.t_ref_cursor;

   -- Scarico dati da IPA
   procedure agg_automatico
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_descrizione            in as4_anagrafe_soggetti.nome%type
     ,p_indirizzo              in as4_anagrafe_soggetti.indirizzo_res%type
     ,p_cap                    in as4_anagrafe_soggetti.cap_res%type
     ,p_localita               in varchar2
     ,p_provincia              in varchar2
     ,p_telefono               in as4_anagrafe_soggetti.tel_res%type
     ,p_fax                    in as4_anagrafe_soggetti.fax_res%type
     ,p_mail_istituzionale     in indirizzi_telematici.indirizzo%type
     ,p_data_istituzione       in as4_anagrafe_soggetti.dal%type
     ,p_data_soppressione      in as4_anagrafe_soggetti.al%type
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type
   );
end amministrazione;
/


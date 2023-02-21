CREATE OR REPLACE package unita_fisica is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        unita_fisica
    DESCRIZIONE: Gestione tabella unita_fisiche.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.12.
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    31/10/2007  VDAVALLI  Prima emissione.
    01    04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    27/08/2012  mmonari   Revisione complessiva struttura fisica
    03    02/01/2013  ADADAMO   Aggiunta get_uo_competenza
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.03';
   s_data_limite date := to_date(3333333, 'j');

   s_table_name constant afc.t_object_name := 'unita_fisiche';

   subtype t_rowtype is unita_fisiche%rowtype;

   -- Tipo del record primary key
   type t_pk is record(
       id_elemento_fisico unita_fisiche.id_elemento_fisico%type);

   -- Exceptions
   ordinamento_errato exception;
   pragma exception_init(ordinamento_errato, -20901);
   s_ordinamento_errato_number constant afc_error.t_error_number := -20901;
   s_ordinamento_errato_msg    constant afc_error.t_error_msg := 'Incongruenza gerarchica tra le tipologie di suddivisione';

   figlio_non_incluso exception;
   pragma exception_init(figlio_non_incluso, -20902);
   s_figlio_non_incluso_number constant afc_error.t_error_number := -20902;
   s_figlio_non_incluso_msg    constant afc_error.t_error_msg := 'Padre non definito per l''intero periodo';

   figli_non_coperti exception;
   pragma exception_init(figli_non_coperti, -20903);
   s_figli_non_coperti_number constant afc_error.t_error_number := -20903;
   s_figli_non_coperti_msg    constant afc_error.t_error_msg := 'Esistono figli non piu'' inclusi nel periodo del padre';

   ass_non_coperte exception;
   pragma exception_init(ass_non_coperte, -20904);
   s_ass_non_coperte_number constant afc_error.t_error_number := -20904;
   s_ass_non_coperte_msg    constant afc_error.t_error_msg := 'Esistono assegnazioni di individui';

   errore_bloccante exception;
   pragma exception_init(ass_non_coperte, -20999);
   s_errore_bloccante_number constant afc_error.t_error_number := -20999;
   s_errore_bloccante_msg    constant afc_error.t_error_msg := 'Rilevato errore bloccante: operazione non eseguita';

   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type
     ,p_amministrazione       in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type default null
     ,p_sequenza              in unita_fisiche.sequenza%type default null
     ,p_dal                   in unita_fisiche.dal%type
     ,p_al                    in unita_fisiche.al%type default null
     ,p_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento    in unita_fisiche.data_aggiornamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type
     ,p_new_amministrazione       in unita_fisiche.amministrazione%type
     ,p_new_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_new_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type
     ,p_new_sequenza              in unita_fisiche.sequenza%type
     ,p_new_dal                   in unita_fisiche.dal%type
     ,p_new_al                    in unita_fisiche.al%type
     ,p_new_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type
     ,p_new_data_aggiornamento    in unita_fisiche.data_aggiornamento%type
     ,p_old_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type default null
     ,p_old_amministrazione       in unita_fisiche.amministrazione%type default null
     ,p_old_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type default null
     ,p_old_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type default null
     ,p_old_sequenza              in unita_fisiche.sequenza%type default null
     ,p_old_dal                   in unita_fisiche.dal%type default null
     ,p_old_al                    in unita_fisiche.al%type default null
     ,p_old_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento    in unita_fisiche.data_aggiornamento%type default null
     ,p_check_old                 in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type
     ,p_column             in varchar2
     ,p_value              in varchar2 default null
     ,p_literal_value      in number default 1
   );

   procedure upd_column
   (
      p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type
     ,p_column             in varchar2
     ,p_value              in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type
     ,p_amministrazione       in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type default null
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type default null
     ,p_sequenza              in unita_fisiche.sequenza%type default null
     ,p_dal                   in unita_fisiche.dal%type default null
     ,p_al                    in unita_fisiche.al%type default null
     ,p_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento    in unita_fisiche.data_aggiornamento%type default null
     ,p_check_old             in integer default 0
   );

   -- Attributo amministrazione di riga esistente identificata da chiave
   function get_amministrazione /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.amministrazione%type;
   pragma restrict_references(get_amministrazione, wnds);

   -- Attributo progr_unita_fisica di riga esistente identificata da chiave
   function get_progr_unita_fisica /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.progr_unita_fisica%type;
   pragma restrict_references(get_progr_unita_fisica, wnds);

   -- Attributo id_unita_fisica_padre di riga esistente identificata da chiave
   function get_id_unita_fisica_padre /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.id_unita_fisica_padre%type;
   pragma restrict_references(get_id_unita_fisica_padre, wnds);

   -- Attributo sequenza di riga esistente identificata da chiave
   function get_sequenza /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.sequenza%type;
   pragma restrict_references(get_sequenza, wnds);

   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.dal%type;
   pragma restrict_references(get_dal, wnds);

   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.al%type;
   pragma restrict_references(get_al, wnds);

   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_elemento_fisico    in varchar2 default null
     ,p_amministrazione       in varchar2 default null
     ,p_progr_unita_fisica    in varchar2 default null
     ,p_id_unita_fisica_padre in varchar2 default null
     ,p_sequenza              in varchar2 default null
     ,p_dal                   in varchar2 default null
     ,p_al                    in varchar2 default null
     ,p_utente_aggiornamento  in varchar2 default null
     ,p_data_aggiornamento    in varchar2 default null
     ,p_other_condition       in varchar2 default null
     ,p_qbe                   in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_elemento_fisico    in varchar2 default null
     ,p_amministrazione       in varchar2 default null
     ,p_progr_unita_fisica    in varchar2 default null
     ,p_id_unita_fisica_padre in varchar2 default null
     ,p_sequenza              in varchar2 default null
     ,p_dal                   in varchar2 default null
     ,p_al                    in varchar2 default null
     ,p_utente_aggiornamento  in varchar2 default null
     ,p_data_aggiornamento    in varchar2 default null
     ,p_other_condition       in varchar2 default null
     ,p_qbe                   in number default 0
   ) return integer;

   -- Attributo id_elemento_fisico di riga identificata da
   -- amministrazione e progr. unita' fisica
   function get_id_elemento
   (
      p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_data               in unita_fisiche.dal%type
   ) return unita_fisiche.id_elemento_fisico%type;

   -- Esistenza unita' figlie dell'unita' indicata
   function is_unita_padre
   (
      p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_data               in unita_fisiche.dal%type
   ) return integer;

   -- Esistenza dell'unita' indicata tra i discendenti dell'unita' di destinazione
   function contiene_unita
   (
      p_amministrazione in unita_fisiche.amministrazione%type
     ,p_id_provenienza  in unita_fisiche.id_elemento_fisico%type
     ,p_id_destinazione in unita_fisiche.id_elemento_fisico%type
     ,p_data            in unita_fisiche.dal%type
   ) return integer;

   -- Spostamento unita' fisica
   procedure sposta_legame
   (
      p_id_elemento_partenza   in unita_fisiche.id_elemento_fisico%type
     ,p_id_elemento_arrivo     in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Elimina logicamente il legame della UF
   procedure elimina_legame
   (
      p_id_elemento            in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Ripristina il legame eliminato
   procedure ripristina_legame
   (
      p_id_elemento            in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Modifica della sequenza di ordinamento tramite drag and drop
   procedure aggiorna_sequenza
   (
      p_id_elemento_partenza   in unita_fisiche.id_elemento_fisico%type
     ,p_id_elemento_arrivo     in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Controlla la coerenza della suddivisione fisica della UF padre
   function chk_ordine_padre
   (
      p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type
   ) return afc_error.t_error_number;

   -- Controlla l'integrita' storica tra padre e figlio
   function chk_integrita_storica_figlio
   (
      p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type
   ) return afc_error.t_error_number;

   -- Controlla l'integrita' storica tra il padre e i figli
   function chk_integrita_storica_padre(p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type)
      return afc_error.t_error_number;

   -- Controlla l'integrita' storica tra la UF e gli individui assegnati
   function chk_integrita_assegnazioni(p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type)
      return afc_error.t_error_number;

   -- Controllo integrita' referenziali
   function is_ri_ok
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_old_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_new_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_old_al             in anagrafe_unita_organizzative.al%type
     ,p_new_al             in anagrafe_unita_organizzative.al%type
     ,p_inserting          in number
     ,p_updating           in number
   ) return afc_error.t_error_number;

   -- Controllo integrita' referenziali
   procedure chk_ri
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_old_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_new_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_old_al             in anagrafe_unita_organizzative.al%type
     ,p_new_al             in anagrafe_unita_organizzative.al%type
     ,p_inserting          in number
     ,p_updating           in number
   );

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   function get_uo_competenza
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_data_rif           in date
   ) return varchar2;

   function get_icona_uo_competenza
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_data_rif           in date
   ) return varchar2;

end unita_fisica;
/


CREATE OR REPLACE package work_revisione is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        work_revisione
    DESCRIZIONE: Gestione tabella work_revisioni.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    17/11/2006  VDAVALLI  Prima emissione.
    01    04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    28/12/2009  VDAVALLI  Aggiunta gestione nuovi campi e nuova funzione
                                get_id_errore
    </CODE>
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.02';

   s_table_name constant afc.t_object_name := 'work_revisioni';

   subtype t_rowtype is work_revisioni%rowtype;

   -- Tipo del record primary key
   type t_pk is record(
       id_work_revisione work_revisioni.id_work_revisione%type);

   -- Exceptions
   /*   <exception_name> exception;
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
   (p_id_work_revisione in work_revisioni.id_work_revisione%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_work_revisione         in work_revisioni.id_work_revisione%type
     ,p_ottica                    in work_revisioni.ottica%type
     ,p_revisione                 in work_revisioni.revisione%type
     ,p_data                      in work_revisioni.data%type
     ,p_messaggio                 in work_revisioni.messaggio%type
     ,p_errore_bloccante          in work_revisioni.errore_bloccante%type
     ,p_progr_unita_organizzativa in work_revisioni.progr_unita_organizzativa%type
     ,p_codice_uo                 in work_revisioni.codice_uo%type
     ,p_descr_uo                  in work_revisioni.descr_uo%type
     ,p_ni                        in work_revisioni.ni%type
     ,p_nominativo                in work_revisioni.nominativo%type
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_work_revisione in work_revisioni.id_work_revisione%type
     ,p_new_ottica            in work_revisioni.ottica%type
     ,p_new_revisione         in work_revisioni.revisione%type
     ,p_new_data              in work_revisioni.data%type
     ,p_new_messaggio         in work_revisioni.messaggio%type
     ,p_new_errore_bloccante  in work_revisioni.errore_bloccante%type
     ,p_new_progr_unor        in work_revisioni.progr_unita_organizzativa%type
     ,p_new_codice_uo         in work_revisioni.codice_uo%type
     ,p_new_descr_uo          in work_revisioni.descr_uo%type
     ,p_new_ni                in work_revisioni.ni%type
     ,p_new_nominativo        in work_revisioni.nominativo%type
     ,p_old_id_work_revisione in work_revisioni.id_work_revisione%type default null
     ,p_old_ottica            in work_revisioni.ottica%type default null
     ,p_old_revisione         in work_revisioni.revisione%type default null
     ,p_old_data              in work_revisioni.data%type default null
     ,p_old_messaggio         in work_revisioni.messaggio%type default null
     ,p_old_errore_bloccante  in work_revisioni.errore_bloccante%type default null
     ,p_old_progr_unor        in work_revisioni.progr_unita_organizzativa%type
     ,p_old_codice_uo         in work_revisioni.codice_uo%type
     ,p_old_descr_uo          in work_revisioni.descr_uo%type
     ,p_old_ni                in work_revisioni.ni%type
     ,p_old_nominativo        in work_revisioni.nominativo%type
     ,p_check_old             in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_work_revisione in work_revisioni.id_work_revisione%type
     ,p_column            in varchar2
     ,p_value             in varchar2 default null
     ,p_literal_value     in number default 1
   );

   procedure upd_column
   (
      p_id_work_revisione in work_revisioni.id_work_revisione%type
     ,p_column            in varchar2
     ,p_value             in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_id_work_revisione         in work_revisioni.id_work_revisione%type
     ,p_ottica                    in work_revisioni.ottica%type default null
     ,p_revisione                 in work_revisioni.revisione%type default null
     ,p_data                      in work_revisioni.data%type default null
     ,p_messaggio                 in work_revisioni.messaggio%type default null
     ,p_errore_bloccante          in work_revisioni.errore_bloccante%type default null
     ,p_progr_unita_organizzativa in work_revisioni.progr_unita_organizzativa%type
     ,p_codice_uo                 in work_revisioni.codice_uo%type
     ,p_descr_uo                  in work_revisioni.descr_uo%type
     ,p_ni                        in work_revisioni.ni%type
     ,p_nominativo                in work_revisioni.nominativo%type
     ,p_check_old                 in integer default 0
   );

   -- Attributo ottica di riga esistente identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.ottica%type;
   pragma restrict_references(get_ottica, wnds);

   -- Attributo revisione di riga esistente identificata da chiave
   function get_revisione /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.revisione%type;
   pragma restrict_references(get_revisione, wnds);

   -- Attributo data di riga esistente identificata da chiave
   function get_data /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.data%type;
   pragma restrict_references(get_data, wnds);

   -- Attributo messaggio di riga esistente identificata da chiave
   function get_messaggio /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.messaggio%type;
   pragma restrict_references(get_messaggio, wnds);

   -- Attributo errore_bloccante di riga esistente identificata da chiave
   function get_errore_bloccante /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.errore_bloccante%type;
   pragma restrict_references(get_errore_bloccante, wnds);

   -- Attributo progr_uinita_organizzativa di riga esistente identificata da chiave
   function get_progr_unita_organizzativa /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita_organizzativa, wnds);

   -- Attributo codice_uo di riga esistente identificata da chiave
   function get_codice_uo /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.codice_uo%type;
   pragma restrict_references(get_codice_uo, wnds);

   -- Attributo descr_uo di riga esistente identificata da chiave
   function get_descr_uo /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.descr_uo%type;
   pragma restrict_references(get_descr_uo, wnds);

   -- Attributo ni di riga esistente identificata da chiave
   function get_ni /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.ni%type;
   pragma restrict_references(get_ni, wnds);

   -- Attributo nominativo di riga esistente identificata da chiave
   function get_nominativo /* SLAVE_COPY */
   (p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.nominativo%type;
   pragma restrict_references(get_nominativo, wnds);

   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_work_revisione         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_data                      in varchar2 default null
     ,p_messaggio                 in varchar2 default null
     ,p_errore_bloccante          in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descr_uo                  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_nominativo                in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_work_revisione         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_data                      in varchar2 default null
     ,p_messaggio                 in varchar2 default null
     ,p_errore_bloccante          in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descr_uo                  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_nominativo                in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return integer;

   function get_id_errore
   (
      p_ottica                    in work_revisioni.ottica%type
     ,p_revisione                 in work_revisioni.revisione%type
     ,p_progr_unita_organizzativa in work_revisioni.progr_unita_organizzativa%type default null
     ,p_ni                        in work_revisioni.ni%type default null
     ,p_errore_bloccante          in work_revisioni.errore_bloccante%type
   ) return work_revisioni.id_work_revisione%type;

end work_revisione;
/


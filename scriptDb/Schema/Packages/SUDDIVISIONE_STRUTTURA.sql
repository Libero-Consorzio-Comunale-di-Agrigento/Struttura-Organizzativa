CREATE OR REPLACE package suddivisione_struttura is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        suddivisione_struttura
    DESCRIZIONE: Gestione tabella suddivisioni_struttura.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore      Descrizione.
    00    28/06/2006  VDAVALLI   Prima emissione.
    01    04/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    02    29/04/2010  APASSUELLO Aggiunta funzione get_ordinamento
    03    01/08/2011  MMONARI    Aggiunta procedura duplica_suddivisioni
    04    05/10/2012  VDAVALLI   Aggiunta funzione get_id_suddisivione
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.04';

   -- Tipo del record primary key
   type t_pk is record(
       id_suddivisione suddivisioni_struttura.id_suddivisione%type);

   /*   -- Exceptions
      ottica_assente exception;
      pragma exception_init( ottica_assente, -20901 );
      s_ottica_assente_number constant AFC_Error.t_error_number := -20901;
      s_ottica_assente_msg    constant AFC_Error.t_error_msg := 'Ottica non codificata';
   */
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_ottica               in suddivisioni_struttura.ottica%type
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type
     ,p_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type
     ,p_new_ottica               in suddivisioni_struttura.ottica%type
     ,p_new_suddivisione         in suddivisioni_struttura.suddivisione%type
     ,p_new_descrizione          in suddivisioni_struttura.descrizione%type
     ,p_new_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type
     ,p_new_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type
     ,p_new_des_abb              in suddivisioni_struttura.des_abb%type
     ,p_new_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type
     ,p_new_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type
     ,p_new_icona_standard       in suddivisioni_struttura.icona_standard%type
     ,p_new_icona_modifica       in suddivisioni_struttura.icona_modifica%type
     ,p_new_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type
     ,p_new_nota                 in suddivisioni_struttura.nota%type
     ,p_new_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type
     ,p_new_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_old_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_old_ottica               in suddivisioni_struttura.ottica%type default null
     ,p_old_suddivisione         in suddivisioni_struttura.suddivisione%type default null
     ,p_old_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_old_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_old_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_old_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_old_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_old_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_old_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_old_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_old_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_old_nota                 in suddivisioni_struttura.nota%type default null
     ,p_old_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_old_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_check_old                in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in varchar2 default null
     ,p_literal_value   in number default 1
   );

   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type
     ,p_ottica               in suddivisioni_struttura.ottica%type
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type
     ,p_descrizione          in suddivisioni_struttura.descrizione%type
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_check_old            in integer default 0
   );

   -- Data un'ottica di origine, duplica le suddivisioni struttura su un'ottica dertivata
   procedure duplica_suddivisioni
   (
      p_ottica_origine in ottiche.ottica_origine%type
     ,p_ottica         in ottiche.ottica%type
   );

   -- Attributo suddivisione di riga esistente identificata da chiave
   function get_suddivisione /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.suddivisione%type;
   pragma restrict_references(get_suddivisione, wnds);

   -- Attributo descrizione di riga esistente identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);

   -- Attributo ottica di riga esistente identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.ottica%type;
   pragma restrict_references(get_ottica, wnds);

   -- Attributo des_abb di riga esistente identificata da chiave
   function get_des_abb /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.des_abb%type;
   pragma restrict_references(get_des_abb, wnds);

   -- Attributo icona_standard di riga esistente identificata da chiave
   function get_icona_standard /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.icona_standard%type;
   pragma restrict_references(get_icona_standard, wnds);

   -- Attributo nota di riga esistente identificata da chiave
   function get_nota /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.nota%type;
   pragma restrict_references(get_nota, wnds);

   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- Attributo ordinamento di riga esistente identificata da chiave
   function get_ordinamento /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.ordinamento%type;
   pragma restrict_references(get_ordinamento, wnds);

   -- Riporta il numero delle suddivisioni struttura di ordinamento inferiore
   function get_livello(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return number;
   pragma restrict_references(get_livello, wnds);

   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_ottica               in suddivisioni_struttura.ottica%type default null
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type default null
     ,p_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_order_condition      in varchar2 default null
     ,p_qbe                  in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_ottica               in suddivisioni_struttura.ottica%type default null
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type default null
     ,p_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_qbe                  in number default 0
   ) return integer;

   function ordertree
   (
      p_level  in number
     ,p_figlio in varchar2
   ) return varchar2;
   v_testo varchar2(200);

   -- Chiave di riga esistente identificata da ottica e suddivisione
   function get_id_suddivisione /* SLAVE_COPY */
   (
      p_ottica       in suddivisioni_struttura.ottica%type
     ,p_suddivisione in suddivisioni_struttura.suddivisione%type
   ) return suddivisioni_struttura.id_suddivisione%type;
   pragma restrict_references(get_id_suddivisione, wnds);

end suddivisione_struttura;
/


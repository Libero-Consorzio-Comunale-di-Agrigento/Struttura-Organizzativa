CREATE OR REPLACE package tipo_incarico is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        Tipo_incarico
    DESCRIZIONE: Gestione tabella tipi_incarico.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore      Descrizione.
    00    20/07/2006  VDAVALLI   Prima emissione.
    01    04/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    02    07/09/2009  VDAVALLI   Aggiunto campo se_aspettativa
    03    21/12/2009  APASSUELLO Aggiunto campo ordinamento
    04    16/04/2010  APASSUELLO Aggiunto campo tipo_incarico
    05    12/08/2015  MMONARI    Aggiunto set_fi per #634
    </CODE>
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.05';

   -- Tipo del record primary key
   type t_pk is record(
       incarico tipi_incarico.incarico%type);
   /*
      -- Exceptions
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
   (p_incarico in tipi_incarico.incarico%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_incarico        in tipi_incarico.incarico%type
     ,p_descrizione     in tipi_incarico.descrizione%type
     ,p_descrizione_al1 in tipi_incarico.descrizione_al1%type default null
     ,p_descrizione_al2 in tipi_incarico.descrizione_al2%type default null
     ,p_responsabile    in tipi_incarico.responsabile%type default null
     ,p_se_aspettativa  in tipi_incarico.se_aspettativa%type default null
     ,p_ordinamento     in tipi_incarico.ordinamento%type default null
     ,p_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_incarico        in tipi_incarico.incarico%type
     ,p_new_descrizione     in tipi_incarico.descrizione%type
     ,p_new_descrizione_al1 in tipi_incarico.descrizione_al1%type
     ,p_new_descrizione_al2 in tipi_incarico.descrizione_al2%type
     ,p_new_responsabile    in tipi_incarico.responsabile%type
     ,p_new_se_aspettativa  in tipi_incarico.se_aspettativa%type
     ,p_new_ordinamento     in tipi_incarico.ordinamento%type
     ,p_new_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
     ,p_old_incarico        in tipi_incarico.incarico%type default null
     ,p_old_descrizione     in tipi_incarico.descrizione%type default null
     ,p_old_descrizione_al1 in tipi_incarico.descrizione_al1%type default null
     ,p_old_descrizione_al2 in tipi_incarico.descrizione_al2%type default null
     ,p_old_responsabile    in tipi_incarico.responsabile%type default null
     ,p_old_se_aspettativa  in tipi_incarico.se_aspettativa%type default null
     ,p_old_ordinamento     in tipi_incarico.ordinamento%type default null
     ,p_old_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
     ,p_check_old           in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_incarico      in tipi_incarico.incarico%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );

   procedure upd_column
   (
      p_incarico in tipi_incarico.incarico%type
     ,p_column   in varchar2
     ,p_value    in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_incarico        in tipi_incarico.incarico%type
     ,p_descrizione     in tipi_incarico.descrizione%type default null
     ,p_descrizione_al1 in tipi_incarico.descrizione_al1%type default null
     ,p_descrizione_al2 in tipi_incarico.descrizione_al2%type default null
     ,p_responsabile    in tipi_incarico.responsabile%type default null
     ,p_se_aspettativa  in tipi_incarico.se_aspettativa%type default null
     ,p_ordinamento     in tipi_incarico.ordinamento%type default null
     ,p_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
     ,p_check_old       in integer default 0
   );

   -- Attributo descrizione di riga esistente identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return tipi_incarico.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);

   -- Attributo responsabile di riga esistente identificata da chiave
   function get_responsabile /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return tipi_incarico.responsabile%type;
   pragma restrict_references(get_responsabile, wnds);

   -- Attributo se_aspettativa di riga esistente identificata da chiave
   function get_se_aspettativa /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return tipi_incarico.se_aspettativa%type;
   pragma restrict_references(get_se_aspettativa, wnds);

   -- Attributo ordinamento di riga esistente identificata da chiave
   function get_ordinamento /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return tipi_incarico.ordinamento%type;
   pragma restrict_references(get_ordinamento, wnds);

   -- Attributo tipo_incarico di riga esistente identificata da chiave
   function get_tipo_incarico /* SLAVE_COPY */
   (p_incarico in tipi_incarico.incarico%type) return tipi_incarico.tipo_incarico%type;
   pragma restrict_references(get_tipo_incarico, wnds);

   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_incarico        in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_descrizione_al1 in varchar2 default null
     ,p_descrizione_al2 in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_se_aspettativa  in varchar2 default null
     ,p_ordinamento     in varchar2 default null
     ,p_tipo_incarico   in varchar2 default null
     ,p_order_condition in varchar2 default null
     ,p_qbe             in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_incarico        in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_descrizione_al1 in varchar2 default null
     ,p_descrizione_al2 in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_se_aspettativa  in varchar2 default null
     ,p_ordinamento     in varchar2 default null
     ,p_tipo_incarico   in varchar2 default null
     ,p_qbe             in number default 0
   ) return integer;
   procedure set_fi
   (
      p_old_responsabile in tipi_incarico.responsabile%type
     ,p_new_responsabile in tipi_incarico.responsabile%type
     ,p_incarico         in tipi_incarico.responsabile%type
   );
end tipo_incarico;
/


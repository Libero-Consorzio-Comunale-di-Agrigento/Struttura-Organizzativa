CREATE OR REPLACE package relazioni_ruoli_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        relazioni_ruoli_tpk
    DESCRIZIONE: Gestione tabella RELAZIONI_RUOLI.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    18/08/2015  mmonari  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'RELAZIONI_RUOLI';
   subtype t_rowtype is relazioni_ruoli%rowtype;
   -- Tipo del record primary key
   subtype t_id_relazione is relazioni_ruoli.id_relazione%type;
   type t_pk is record(
       id_relazione t_id_relazione);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record note
   function pk /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita note
   function can_handle /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita note
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con note indicata
   function exists_id /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con note indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_relazione   in relazioni_ruoli.id_relazione%type default null
     ,p_ottica         in relazioni_ruoli.ottica%type default '%'
     ,p_codice_uo      in relazioni_ruoli.codice_uo%type default '%'
     ,p_uo_discendenti in relazioni_ruoli.uo_discendenti%type default 'NO'
     ,p_suddivisione   in relazioni_ruoli.suddivisione%type default '%'
     ,p_incarico       in relazioni_ruoli.incarico%type default '%'
     ,p_responsabile   in relazioni_ruoli.responsabile%type default '%'
     ,p_dipendente     in relazioni_ruoli.dipendente%type default '%'
     ,p_note           in relazioni_ruoli.note%type
     ,p_ruolo          in relazioni_ruoli.ruolo%type
   );
   function ins /*+ SOA  */
   (
      p_id_relazione   in relazioni_ruoli.id_relazione%type default null
     ,p_ottica         in relazioni_ruoli.ottica%type default '%'
     ,p_codice_uo      in relazioni_ruoli.codice_uo%type default '%'
     ,p_uo_discendenti in relazioni_ruoli.uo_discendenti%type default 'NO'
     ,p_suddivisione   in relazioni_ruoli.suddivisione%type default '%'
     ,p_incarico       in relazioni_ruoli.incarico%type default '%'
     ,p_responsabile   in relazioni_ruoli.responsabile%type default '%'
     ,p_dipendente     in relazioni_ruoli.dipendente%type default '%'
     ,p_note           in relazioni_ruoli.note%type
     ,p_ruolo          in relazioni_ruoli.ruolo%type
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old          in integer default 0
     ,p_new_id_relazione   in relazioni_ruoli.id_relazione%type
     ,p_old_id_relazione   in relazioni_ruoli.id_relazione%type default null
     ,p_new_ottica         in relazioni_ruoli.ottica%type default afc.default_null('RELAZIONI_RUOLI.ottica')
     ,p_old_ottica         in relazioni_ruoli.ottica%type default null
     ,p_new_codice_uo      in relazioni_ruoli.codice_uo%type default afc.default_null('RELAZIONI_RUOLI.codice_uo')
     ,p_old_codice_uo      in relazioni_ruoli.codice_uo%type default null
     ,p_new_uo_discendenti in relazioni_ruoli.uo_discendenti%type default afc.default_null('RELAZIONI_RUOLI.uo_discendenti')
     ,p_old_uo_discendenti in relazioni_ruoli.uo_discendenti%type default null
     ,p_new_suddivisione   in relazioni_ruoli.suddivisione%type default afc.default_null('RELAZIONI_RUOLI.suddivisione')
     ,p_old_suddivisione   in relazioni_ruoli.suddivisione%type default null
     ,p_new_incarico       in relazioni_ruoli.incarico%type default afc.default_null('RELAZIONI_RUOLI.incarico')
     ,p_old_incarico       in relazioni_ruoli.incarico%type default null
     ,p_new_responsabile   in relazioni_ruoli.responsabile%type default afc.default_null('RELAZIONI_RUOLI.responsabile')
     ,p_old_responsabile   in relazioni_ruoli.responsabile%type default null
     ,p_new_dipendente     in relazioni_ruoli.dipendente%type default afc.default_null('RELAZIONI_RUOLI.dipendente')
     ,p_old_dipendente     in relazioni_ruoli.dipendente%type default null
     ,p_new_note           in relazioni_ruoli.note%type default afc.default_null('RELAZIONI_RUOLI.note')
     ,p_old_note           in relazioni_ruoli.note%type default null
     ,p_new_ruolo          in relazioni_ruoli.ruolo%type default afc.default_null('RELAZIONI_RUOLI.ruolo')
     ,p_old_ruolo          in relazioni_ruoli.ruolo%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_relazione  in relazioni_ruoli.id_relazione%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old      in integer default 0
     ,p_id_relazione   in relazioni_ruoli.id_relazione%type
     ,p_ottica         in relazioni_ruoli.ottica%type default null
     ,p_codice_uo      in relazioni_ruoli.codice_uo%type default null
     ,p_uo_discendenti in relazioni_ruoli.uo_discendenti%type default null
     ,p_suddivisione   in relazioni_ruoli.suddivisione%type default null
     ,p_incarico       in relazioni_ruoli.incarico%type default null
     ,p_responsabile   in relazioni_ruoli.responsabile%type default null
     ,p_dipendente     in relazioni_ruoli.dipendente%type default null
     ,p_note           in relazioni_ruoli.note%type default null
     ,p_ruolo          in relazioni_ruoli.ruolo%type default null
   );
   -- Getter per attributo ottica di riga identificata da note
   function get_ottica /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return relazioni_ruoli.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Getter per attributo codice_uo di riga identificata da note
   function get_codice_uo /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.codice_uo%type;
   pragma restrict_references(get_codice_uo, wnds);
   -- Getter per attributo uo_discendenti di riga identificata da note
   function get_uo_discendenti /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.uo_discendenti%type;
   pragma restrict_references(get_uo_discendenti, wnds);
   -- Getter per attributo suddivisione di riga identificata da note
   function get_suddivisione /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.suddivisione%type;
   pragma restrict_references(get_suddivisione, wnds);
   -- Getter per attributo incarico di riga identificata da note
   function get_incarico /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.incarico%type;
   pragma restrict_references(get_incarico, wnds);
   -- Getter per attributo responsabile di riga identificata da note
   function get_responsabile /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.responsabile%type;
   pragma restrict_references(get_responsabile, wnds);
   -- Getter per attributo dipendente di riga identificata da note
   function get_dipendente /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.dipendente%type;
   pragma restrict_references(get_dipendente, wnds);
   -- Getter per attributo note di riga identificata da note
   function get_note /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return relazioni_ruoli.note%type;
   pragma restrict_references(get_note, wnds);
   -- Getter per attributo ruolo di riga identificata da note
   function get_ruolo /* SLAVE_COPY */
   (p_id_relazione in relazioni_ruoli.id_relazione%type) return relazioni_ruoli.ruolo%type;
   pragma restrict_references(get_ruolo, wnds);
   -- Setter per attributo id_relazione di riga identificata da note
   procedure set_id_relazione
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.id_relazione%type default null
   );
   -- Setter per attributo ottica di riga identificata da note
   procedure set_ottica
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.ottica%type default null
   );
   -- Setter per attributo codice_uo di riga identificata da note
   procedure set_codice_uo
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.codice_uo%type default null
   );
   -- Setter per attributo uo_discendenti di riga identificata da note
   procedure set_uo_discendenti
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.uo_discendenti%type default null
   );
   -- Setter per attributo suddivisione di riga identificata da note
   procedure set_suddivisione
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.suddivisione%type default null
   );
   -- Setter per attributo incarico di riga identificata da note
   procedure set_incarico
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.incarico%type default null
   );
   -- Setter per attributo responsabile di riga identificata da note
   procedure set_responsabile
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.responsabile%type default null
   );
   -- Setter per attributo dipendente di riga identificata da note
   procedure set_dipendente
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.dipendente%type default null
   );
   -- Setter per attributo note di riga identificata da note
   procedure set_note
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.note%type default null
   );
   -- Setter per attributo ruolo di riga identificata da note
   procedure set_ruolo
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.ruolo%type default null
   );
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_order_by        in varchar2 default null
     ,p_extra_columns   in varchar2 default null
     ,p_extra_condition in varchar2 default null
     ,p_id_relazione    in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_codice_uo       in varchar2 default null
     ,p_uo_discendenti  in varchar2 default null
     ,p_suddivisione    in varchar2 default null
     ,p_incarico        in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_dipendente      in varchar2 default null
     ,p_note            in varchar2 default null
     ,p_ruolo           in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_relazione    in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_codice_uo       in varchar2 default null
     ,p_uo_discendenti  in varchar2 default null
     ,p_suddivisione    in varchar2 default null
     ,p_incarico        in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_dipendente      in varchar2 default null
     ,p_note            in varchar2 default null
     ,p_ruolo           in varchar2 default null
   ) return integer;
end relazioni_ruoli_tpk;
/


CREATE OR REPLACE package assegnazioni_fisiche_tpk is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        assegnazioni_fisiche_tpk
    DESCRIZIONE: Gestione tabella ASSEGNAZIONI_FISICHE.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision: 16/08/2012 11:11:37
                 SiaPKGen Revision: V1.05.014.
                 SiaTPKDeclare Revision: V1.17.001.
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    16/08/2012  mmonari  Generazione automatica. 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'ASSEGNAZIONI_FISICHE';
   subtype t_rowtype is assegnazioni_fisiche%rowtype;
   -- Tipo del record primary key
   subtype t_id_asfi is assegnazioni_fisiche.id_asfi%type;
   type t_pk is record(
       id_asfi t_id_asfi);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_asfi                   in assegnazioni_fisiche.id_asfi%type default null
     ,p_id_ubicazione_componente  in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_ni                        in assegnazioni_fisiche.ni%type
     ,p_progr_unita_fisica        in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_dal                       in assegnazioni_fisiche.dal%type
     ,p_al                        in assegnazioni_fisiche.al%type default null
     ,p_progr_unita_organizzativa in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_utente_aggiornamento      in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in assegnazioni_fisiche.data_aggiornamento%type default null
   );
   function ins /*+ SOA  */
   (
      p_id_asfi                   in assegnazioni_fisiche.id_asfi%type default null
     ,p_id_ubicazione_componente  in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_ni                        in assegnazioni_fisiche.ni%type
     ,p_progr_unita_fisica        in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_dal                       in assegnazioni_fisiche.dal%type
     ,p_al                        in assegnazioni_fisiche.al%type default null
     ,p_progr_unita_organizzativa in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_utente_aggiornamento      in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in assegnazioni_fisiche.data_aggiornamento%type default null
   ) return number;
   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                    in integer default 0
     ,p_new_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_old_id_asfi                  in assegnazioni_fisiche.id_asfi%type default null
     ,p_new_id_ubicazione_componente in assegnazioni_fisiche.id_ubicazione_componente%type default afc.default_null('ASSEGNAZIONI_FISICHE.id_ubicazione_componente')
     ,p_old_id_ubicazione_componente in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_new_ni                       in assegnazioni_fisiche.ni%type default afc.default_null('ASSEGNAZIONI_FISICHE.ni')
     ,p_old_ni                       in assegnazioni_fisiche.ni%type default null
     ,p_new_progr_unita_fisica       in assegnazioni_fisiche.progr_unita_fisica%type default afc.default_null('ASSEGNAZIONI_FISICHE.progr_unita_fisica')
     ,p_old_progr_unita_fisica       in assegnazioni_fisiche.progr_unita_fisica%type default null
     ,p_new_dal                      in assegnazioni_fisiche.dal%type default afc.default_null('ASSEGNAZIONI_FISICHE.dal')
     ,p_old_dal                      in assegnazioni_fisiche.dal%type default null
     ,p_new_al                       in assegnazioni_fisiche.al%type default afc.default_null('ASSEGNAZIONI_FISICHE.al')
     ,p_old_al                       in assegnazioni_fisiche.al%type default null
     ,p_new_progr_unita_organizzativ in assegnazioni_fisiche.progr_unita_organizzativa%type default afc.default_null('ASSEGNAZIONI_FISICHE.progr_unita_organizzativa')
     ,p_old_progr_unita_organizzativ in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_new_utente_aggiornamento     in assegnazioni_fisiche.utente_aggiornamento%type default afc.default_null('ASSEGNAZIONI_FISICHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento     in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento       in assegnazioni_fisiche.data_aggiornamento%type default afc.default_null('ASSEGNAZIONI_FISICHE.data_aggiornamento')
     ,p_old_data_aggiornamento       in assegnazioni_fisiche.data_aggiornamento%type default null
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_asfi       in assegnazioni_fisiche.id_asfi%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_column  in varchar2
     ,p_value   in date
   );
   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old                 in integer default 0
     ,p_id_asfi                   in assegnazioni_fisiche.id_asfi%type
     ,p_id_ubicazione_componente  in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_ni                        in assegnazioni_fisiche.ni%type default null
     ,p_progr_unita_fisica        in assegnazioni_fisiche.progr_unita_fisica%type default null
     ,p_dal                       in assegnazioni_fisiche.dal%type default null
     ,p_al                        in assegnazioni_fisiche.al%type default null
     ,p_progr_unita_organizzativa in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_utente_aggiornamento      in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in assegnazioni_fisiche.data_aggiornamento%type default null
   );
   -- Getter per attributo id_ubicazione_componente di riga identificata da chiave
   function get_id_ubicazione_componente /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.id_ubicazione_componente%type;
   pragma restrict_references(get_id_ubicazione_componente, wnds);
   -- Getter per attributo ni di riga identificata da chiave
   function get_ni /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return assegnazioni_fisiche.ni%type;
   pragma restrict_references(get_ni, wnds);
   -- Getter per attributo progr_unita_fisica di riga identificata da chiave
   function get_progr_unita_fisica /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.progr_unita_fisica%type;
   pragma restrict_references(get_progr_unita_fisica, wnds);
   -- Getter per attributo dal di riga identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return assegnazioni_fisiche.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Getter per attributo al di riga identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type) return assegnazioni_fisiche.al%type;
   pragma restrict_references(get_al, wnds);
   -- Getter per attributo progr_unita_organizzativa di riga identificata da chiave
   function get_progr_unita_organizzativa /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita_organizzativa, wnds);
   -- Getter per attributo utente_aggiornamento di riga identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Getter per attributo data_aggiornamento di riga identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Setter per attributo id_asfi di riga identificata da chiave
   procedure set_id_asfi
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.id_asfi%type default null
   );
   -- Setter per attributo id_ubicazione_componente di riga identificata da chiave
   procedure set_id_ubicazione_componente
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.id_ubicazione_componente%type default null
   );
   -- Setter per attributo ni di riga identificata da chiave
   procedure set_ni
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.ni%type default null
   );
   -- Setter per attributo progr_unita_fisica di riga identificata da chiave
   procedure set_progr_unita_fisica
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.progr_unita_fisica%type default null
   );
   -- Setter per attributo dal di riga identificata da chiave
   procedure set_dal
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.dal%type default null
   );
   -- Setter per attributo al di riga identificata da chiave
   procedure set_al
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.al%type default null
   );
   -- Setter per attributo progr_unita_organizzativa di riga identificata da chiave
   procedure set_progr_unita_organizzativa
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.progr_unita_organizzativa%type default null
   );
   -- Setter per attributo utente_aggiornamento di riga identificata da chiave
   procedure set_utente_aggiornamento
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.utente_aggiornamento%type default null
   );
   -- Setter per attributo data_aggiornamento di riga identificata da chiave
   procedure set_data_aggiornamento
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.data_aggiornamento%type default null
   );
   -- where_condition per statement di ricerca
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_asfi                   in varchar2 default null
     ,p_id_ubicazione_componente  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
   ) return afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_order_by                  in varchar2 default null
     ,p_extra_columns             in varchar2 default null
     ,p_extra_condition           in varchar2 default null
     ,p_id_asfi                   in varchar2 default null
     ,p_id_ubicazione_componente  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_asfi                   in varchar2 default null
     ,p_id_ubicazione_componente  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
   ) return integer;
end assegnazioni_fisiche_tpk;
/


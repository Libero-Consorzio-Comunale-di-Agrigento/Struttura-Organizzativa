CREATE OR REPLACE package impostazione is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        impostazione
    DESCRIZIONE: Gestione tabella impostazioni.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.23.
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    07/09/2009  VDAVALLI   Prima emissione.
    01    03/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    02    07/09/2009  VDAVALLI   Aggiunti nuovi campi
    03    21/12/2009  APASSUELLO Aggiunto campo DATA_INIZIO_INTEGRAZIONE
    04    08/10/2010  AP         Modificato package per gestione campi OBBLIGO_IMBI, OBBLIGO_SEFI
    </CODE>
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.04';

   s_table_name constant afc.t_object_name := 'impostazioni';

   subtype t_rowtype is impostazioni%rowtype;

   -- Tipo del record primary key
   subtype t_id_parametri is impostazioni.id_parametri%type;

   type t_pk is record(
       id_parametri t_id_parametri);

   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean 
   function canhandle /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_parametri             in impostazioni.id_parametri%type
     ,p_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
   );

   function ins
   (
      p_id_parametri             in impostazioni.id_parametri%type
     ,p_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
   ) return number;

   -- Aggiornamento di una riga
   procedure upd
   (
      p_check_old                    in integer default 0
     ,p_new_id_parametri             in impostazioni.id_parametri%type
     ,p_old_id_parametri             in impostazioni.id_parametri%type default null
     ,p_new_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_old_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_new_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_old_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_new_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_old_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_new_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_old_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_new_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_old_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_new_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_old_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_new_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_old_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_new_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_old_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_new_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_old_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_new_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_old_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_new_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
     ,p_old_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_parametri  in impostazioni.id_parametri%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );

   procedure upd_column
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_column       in varchar2
     ,p_value        in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_check_old                in integer default 0
     ,p_id_parametri             in impostazioni.id_parametri%type
     ,p_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
   );

   -- Getter per attributo integr_cg4 di riga identificata da chiave
   function get_integr_cg4 /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return impostazioni.integr_cg4%type;
   pragma restrict_references(get_integr_cg4, wnds);

   -- Getter per attributo integr_gp4 di riga identificata da chiave
   function get_integr_gp4 /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return impostazioni.integr_gp4%type;

   -- Getter per attributo integr_gs4 di riga identificata da chiave
   function get_integr_gs4 /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return impostazioni.integr_gs4%type;
   pragma restrict_references(get_integr_gs4, wnds);

   -- Getter per attributo assegnazione_definitiva di riga identificata da chiave
   function get_assegnazione_definitiva /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.assegnazione_definitiva%type;
   pragma restrict_references(get_assegnazione_definitiva, wnds);

   -- Getter per attributo procedura_nominativo di riga identificata da chiave
   function get_procedura_nominativo /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.procedura_nominativo%type;
   pragma restrict_references(get_procedura_nominativo, wnds);

   -- Getter per attributo visualizza_suddivisione di riga identificata da chiave
   function get_visualizza_suddivisione /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.visualizza_suddivisione%type;
   pragma restrict_references(get_visualizza_suddivisione, wnds);

   -- Getter per attributo visualizza_codice di riga identificata da chiave
   function get_visualizza_codice /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.visualizza_codice%type;
   pragma restrict_references(get_visualizza_codice, wnds);

   -- Getter per attributo agg_anagrafe_dipendenti di riga identificata da chiave
   function get_agg_anagrafe_dipendenti /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.agg_anagrafe_dipendenti%type;
   pragma restrict_references(get_agg_anagrafe_dipendenti, wnds);

   -- Getter per attributo get_data_inizio_integrazione di riga identificata da chiave
   function get_data_inizio_integrazione /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.data_inizio_integrazione%type;
   pragma restrict_references(get_data_inizio_integrazione, wnds);

   -- Getter per attributo obbligo_imbi di riga identificata da chiave
   function get_obbligo_imbi /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return impostazioni.obbligo_imbi%type;
   pragma restrict_references(get_obbligo_imbi, wnds);

   -- Getter per attributo obbligo_sefi di riga identificata da chiave
   function get_obbligo_sefi /* SLAVE_COPY */
   (p_id_parametri in impostazioni.id_parametri%type) return impostazioni.obbligo_sefi%type;
   pragma restrict_references(get_obbligo_sefi, wnds);

   -- Setter per attributo id_parametri di riga identificata da chiave
   procedure set_id_parametri
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.id_parametri%type default null
   );

   -- Setter per attributo integr_cg4 di riga identificata da chiave
   procedure set_integr_cg4
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.integr_cg4%type default null
   );

   -- Setter per attributo integr_gp4 di riga identificata da chiave
   procedure set_integr_gp4
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.integr_gp4%type default null
   );

   -- Setter per attributo integr_gs4 di riga identificata da chiave
   procedure set_integr_gs4
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.integr_gs4%type default null
   );

   -- Setter per attributo assegnazione_definitiva di riga identificata da chiave
   procedure set_assegnazione_definitiva
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.assegnazione_definitiva%type default null
   );

   -- Setter per attributo procedura_nominativo di riga identificata da chiave
   procedure set_procedura_nominativo
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.procedura_nominativo%type default null
   );

   -- Setter per attributo visualizza_suddivisione di riga identificata da chiave
   procedure set_visualizza_suddivisione
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.visualizza_suddivisione%type default null
   );

   -- Setter per attributo visualizza_codice di riga identificata da chiave
   procedure set_visualizza_codice
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.visualizza_codice%type default null
   );

   -- Setter per attributo agg_anagrafe_dipendenti di riga identificata da chiave
   procedure set_agg_anagrafe_dipendenti
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.agg_anagrafe_dipendenti%type default null
   );

   -- Setter per attributo data_inizio_integrazione di riga identificata da chiave
   procedure set_data_inizio_integrazione
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.data_inizio_integrazione%type default null
   );

   -- Setter per attributo obbligo_imbi di riga identificata da chiave
   procedure set_obbligo_imbi
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.obbligo_imbi%type default null
   );

   -- Setter per attributo obbligo_sefi di riga identificata da chiave
   procedure set_obbligo_sefi
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.obbligo_sefi%type default null
   );

   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_qbe                      in number default 0
     ,p_other_condition          in varchar2 default null
     ,p_order_by                 in varchar2 default null
     ,p_extra_columns            in varchar2 default null
     ,p_extra_condition          in varchar2 default null
     ,p_id_parametri             in varchar2 default null
     ,p_integr_cg4               in varchar2 default null
     ,p_integr_gp4               in varchar2 default null
     ,p_integr_gs4               in varchar2 default null
     ,p_assegnazione_definitiva  in varchar2 default null
     ,p_procedura_nominativo     in varchar2 default null
     ,p_visualizza_suddivisione  in varchar2 default null
     ,p_visualizza_codice        in varchar2 default null
     ,p_agg_anagrafe_dipendenti  in varchar2 default null
     ,p_data_inizio_integrazione in varchar2 default null
     ,p_obbligo_imbi             in varchar2 default null
     ,p_obbligo_sefi             in varchar2 default null
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                      in number default 0
     ,p_other_condition          in varchar2 default null
     ,p_id_parametri             in varchar2 default null
     ,p_integr_cg4               in varchar2 default null
     ,p_integr_gp4               in varchar2 default null
     ,p_integr_gs4               in varchar2 default null
     ,p_assegnazione_definitiva  in varchar2 default null
     ,p_procedura_nominativo     in varchar2 default null
     ,p_visualizza_suddivisione  in varchar2 default null
     ,p_visualizza_codice        in varchar2 default null
     ,p_agg_anagrafe_dipendenti  in varchar2 default null
     ,p_data_inizio_integrazione in varchar2 default null
     ,p_obbligo_imbi             in varchar2 default null
     ,p_obbligo_sefi             in varchar2 default null
   ) return integer;

end impostazione;
/


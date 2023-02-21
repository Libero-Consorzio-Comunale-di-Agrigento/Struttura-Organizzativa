CREATE OR REPLACE package anagrafe_unita_fisica is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        anagrafe_unita_fisica
    DESCRIZIONE: Gestione tabella anagrafe_unita_fisiche.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.55.
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    25/10/2007  VDAVALLI  Prima emissione.
    01    27/08/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    06/10/2011  VDAVALLI  Nuova funzione GET_PROGR_UF
    03    13/08/2012  MMONARI   Revisione complessiva struttura fisica
    04    21/09/2012  VDAVALLI  Aggiunta gestione check DI
    05    02/01/2013  ADADAMO   Redmine Feature #145: Aggiunta get_uo_competenza
    06    19/02/2014  ADADAMO   Aggiunta funzione is_assegnabile_ok e modificate
                                chiamate a funzioni chk_ri e is_ri_ok Bug#387
    07    05/06/2014  ADADAMO   Aggiunta is_unita_in_struttura richiamata da
                                interfaccia per abilitare le assegnazioni fisiche                                 
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.07';

   s_table_name constant afc.t_object_name := 'anagrafe_unita_fisiche';

   subtype t_rowtype is anagrafe_unita_fisiche%rowtype;

   -- Tipo del record primary key
   type t_pk is record(
       progr_unita_fisica anagrafe_unita_fisiche.progr_unita_fisica%type
      ,dal                anagrafe_unita_fisiche.dal%type);

   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_num constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   capienza_superata exception;
   pragma exception_init(capienza_superata, -20902);
   s_capienza_superata_number constant afc_error.t_error_number := -20902;
   s_capienza_superata_msg    constant afc_error.t_error_msg := 'Sono gia'' presenti più'' assegnazioni rispoetto alla capienza indicata';
   dal_sovrapposto exception;
   pragma exception_init(dal_sovrapposto, -20903);
   s_dal_sovrapposto_num constant afc_error.t_error_number := -20903;
   s_dal_sovrapposto_msg constant afc_error.t_error_msg := 'La data di inizio validita'' interseca un''altro periodo di definizione della UF';
   al_sovrapposto exception;
   pragma exception_init(al_sovrapposto, -20904);
   s_al_sovrapposto_num constant afc_error.t_error_number := -20904;
   s_al_sovrapposto_msg constant afc_error.t_error_msg := 'La data di fine validita'' interseca un''altro periodo di definizione della UF';
   esistono_uf exception;
   pragma exception_init(esistono_uf, -20905);
   s_esistono_uf_num constant afc_error.t_error_number := -20905;
   s_esistono_uf_msg constant afc_error.t_error_msg := 'Esistono legami: periodo non eliminabile';
   esistono_assegnazioni exception;
   pragma exception_init(esistono_assegnazioni, -20906);
   s_esistono_assegnazioni_num constant afc_error.t_error_number := -20906;
   s_esistono_assegnazioni_msg constant afc_error.t_error_msg := 'Esistono assegnazioni individuali: periodo non eliminabile';
   esistono_attributi exception;
   pragma exception_init(esistono_attributi, -20907);
   s_esistono_attributi_num constant afc_error.t_error_number := -20907;
   s_esistono_attributi_msg constant afc_error.t_error_msg := 'Esistono attributi dell''unita'' fisica: periodo non eliminabile';
   periodi_sovrapposti exception;
   pragma exception_init(periodi_sovrapposti, -20908);
   s_periodi_sovrapposti_num constant afc_error.t_error_number := -20908;
   s_periodi_sovrapposti_msg constant afc_error.t_error_msg := 'Esistono altri periodi di definizione sovrapposti';
   assegnabile_errato exception;
   pragma exception_init(assegnabile_errato, -20909);
   s_assegnabile_errato_number constant afc_error.t_error_number := -20909;
   s_assegnabile_errato_msg    constant afc_error.t_error_msg := 'Esistono assegnazioni fisiche sull''unita'': impossibile modificare l''attributo ASSEGNABILE.';
   esistono_uf2 exception;
   pragma exception_init(esistono_uf, -20910);
   s_esistono_uf2_num constant afc_error.t_error_number := -20910;
   s_esistono_uf2_msg constant afc_error.t_error_msg := 'Esistono legami incompatibili con le nuove date';

   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type default null
     ,p_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_codice_uf            in anagrafe_unita_fisiche.codice_uf%type
     ,p_denominazione        in anagrafe_unita_fisiche.denominazione%type
     ,p_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_amministrazione      in anagrafe_unita_fisiche.amministrazione%type
     ,p_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
   );
   function ins /*+ SOA  */
   (
      p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type default null
     ,p_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_codice_uf            in anagrafe_unita_fisiche.codice_uf%type
     ,p_denominazione        in anagrafe_unita_fisiche.denominazione%type
     ,p_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_amministrazione      in anagrafe_unita_fisiche.amministrazione%type
     ,p_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
   ) return number;

   -- Aggiornamento di una riga
   procedure upd /*+ SOA  */
   (
      p_check_old                in integer default 0
     ,p_new_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_old_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type default null
     ,p_new_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_old_dal                  in anagrafe_unita_fisiche.dal%type default null
     ,p_new_codice_uf            in anagrafe_unita_fisiche.codice_uf%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.codice_uf')
     ,p_old_codice_uf            in anagrafe_unita_fisiche.codice_uf%type default null
     ,p_new_denominazione        in anagrafe_unita_fisiche.denominazione%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.denominazione')
     ,p_old_denominazione        in anagrafe_unita_fisiche.denominazione%type default null
     ,p_new_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.denominazione_al1')
     ,p_old_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_new_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.denominazione_al2')
     ,p_old_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_new_des_abb              in anagrafe_unita_fisiche.des_abb%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.des_abb')
     ,p_old_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_new_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.des_abb_al1')
     ,p_old_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_new_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.des_abb_al2')
     ,p_old_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_new_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.indirizzo')
     ,p_old_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_new_cap                  in anagrafe_unita_fisiche.cap%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.cap')
     ,p_old_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_new_provincia            in anagrafe_unita_fisiche.provincia%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.provincia')
     ,p_old_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_new_comune               in anagrafe_unita_fisiche.comune%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.comune')
     ,p_old_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_new_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo')
     ,p_old_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_new_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo_al1')
     ,p_old_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_new_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo_al2')
     ,p_old_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_new_amministrazione      in anagrafe_unita_fisiche.amministrazione%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.amministrazione')
     ,p_old_amministrazione      in anagrafe_unita_fisiche.amministrazione%type default null
     ,p_new_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.id_suddivisione')
     ,p_old_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_new_generico             in anagrafe_unita_fisiche.generico%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.generico')
     ,p_old_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_new_al                   in anagrafe_unita_fisiche.al%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.al')
     ,p_old_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_new_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.data_aggiornamento')
     ,p_old_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_new_capienza             in anagrafe_unita_fisiche.capienza%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.capienza')
     ,p_old_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_new_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.assegnabile')
     ,p_old_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_new_note                 in anagrafe_unita_fisiche.note%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.note')
     ,p_old_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_new_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.numero_civico')
     ,p_old_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_new_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.esponente_civico_1')
     ,p_old_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_new_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.esponente_civico_2')
     ,p_old_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_new_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.tipo_civico')
     ,p_old_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_new_id_documento         in anagrafe_unita_fisiche.id_documento%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.id_documento')
     ,p_old_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_new_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.link_planimetria')
     ,p_old_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_column             in varchar2
     ,p_value              in varchar2 default null
     ,p_literal_value      in number default 1
   );

   procedure upd_column
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_column             in varchar2
     ,p_value              in date
   );

   -- Cancellazione di una riga
   procedure del /*+ SOA  */
   (
      p_check_old            in integer default 0
     ,p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_codice_uf            in anagrafe_unita_fisiche.codice_uf%type default null
     ,p_denominazione        in anagrafe_unita_fisiche.denominazione%type default null
     ,p_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_amministrazione      in anagrafe_unita_fisiche.amministrazione%type default null
     ,p_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
   );

   -- Attributo codice_uf di riga esistente identificata da chiave
   function get_codice_uf /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.codice_uf%type;
   pragma restrict_references(get_codice_uf, wnds);

   -- Attributo denominazione di riga esistente identificata da chiave
   function get_denominazione /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.denominazione%type;
   pragma restrict_references(get_denominazione, wnds);

   -- Attributo denominazione_al1 di riga esistente identificata da chiave
   function get_denominazione_al1 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.denominazione_al1%type;
   pragma restrict_references(get_denominazione_al1, wnds);

   -- Attributo denominazione_al2 di riga esistente identificata da chiave
   function get_denominazione_al2 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.denominazione_al2%type;
   pragma restrict_references(get_denominazione_al2, wnds);

   -- Attributo des_abb di riga esistente identificata da chiave
   function get_des_abb /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.des_abb%type;
   pragma restrict_references(get_des_abb, wnds);

   -- Attributo des_abb_al1 di riga esistente identificata da chiave
   function get_des_abb_al1 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.des_abb_al1%type;
   pragma restrict_references(get_des_abb_al1, wnds);

   -- Attributo des_abb_al2 di riga esistente identificata da chiave
   function get_des_abb_al2 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.des_abb_al2%type;
   pragma restrict_references(get_des_abb_al2, wnds);

   -- Attributo indirizzo di riga esistente identificata da chiave
   function get_indirizzo /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.indirizzo%type;
   pragma restrict_references(get_indirizzo, wnds);

   -- Attributo cap di riga esistente identificata da chiave
   function get_cap /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.cap%type;
   pragma restrict_references(get_cap, wnds);

   -- Attributo provincia di riga esistente identificata da chiave
   function get_provincia /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.provincia%type;
   pragma restrict_references(get_provincia, wnds);

   -- Attributo comune di riga esistente identificata da chiave
   function get_comune /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.comune%type;
   pragma restrict_references(get_comune, wnds);

   -- Attributo nota_indirizzo di riga esistente identificata da chiave
   function get_nota_indirizzo /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.nota_indirizzo%type;
   pragma restrict_references(get_nota_indirizzo, wnds);

   -- Attributo nota_indirizzo_al1 di riga esistente identificata da chiave
   function get_nota_indirizzo_al1 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.nota_indirizzo_al1%type;
   pragma restrict_references(get_nota_indirizzo_al1, wnds);

   -- Attributo nota_indirizzo_al2 di riga esistente identificata da chiave
   function get_nota_indirizzo_al2 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.nota_indirizzo_al2%type;
   pragma restrict_references(get_nota_indirizzo_al2, wnds);

   -- Attributo amministrazione di riga esistente identificata da chiave
   function get_amministrazione /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.amministrazione%type;
   pragma restrict_references(get_amministrazione, wnds);

   -- Attributo id_suddivisione di riga esistente identificata da chiave
   function get_id_suddivisione /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.id_suddivisione%type;
   pragma restrict_references(get_id_suddivisione, wnds);

   -- Attributo generico di riga esistente identificata da chiave
   function get_generico /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.generico%type;
   pragma restrict_references(get_generico, wnds);

   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.al%type;
   pragma restrict_references(get_al, wnds);

   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);

   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- Attributo progr_unita_fisica per inserimento nuova riga
   function get_id_unita return anagrafe_unita_fisiche.progr_unita_fisica%type;
   pragma restrict_references(get_data_aggiornamento, wnds);

   -- righe corrispondenti alla selezione indicata
   function get_rows /*+ SOA  */ /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_progr_unita_fisica   in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_codice_uf            in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_indirizzo            in varchar2 default null
     ,p_cap                  in varchar2 default null
     ,p_provincia            in varchar2 default null
     ,p_comune               in varchar2 default null
     ,p_nota_indirizzo       in varchar2 default null
     ,p_nota_indirizzo_al1   in varchar2 default null
     ,p_nota_indirizzo_al2   in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_generico             in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_capienza             in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_note                 in varchar2 default null
     ,p_numero_civico        in varchar2 default null
     ,p_esponente_civico_1   in varchar2 default null
     ,p_esponente_civico_2   in varchar2 default null
     ,p_tipo_civico          in varchar2 default null
     ,p_id_documento         in varchar2 default null
     ,p_link_planimetria     in varchar2 default null
   ) return afc.t_ref_cursor;

   -- Getter per attributo capienza di riga identificata da chiave
   function get_capienza /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.capienza%type;
   pragma restrict_references(get_capienza, wnds);
   -- Getter per attributo assegnabile di riga identificata da chiave
   function get_assegnabile /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.assegnabile%type;
   pragma restrict_references(get_assegnabile, wnds);
   -- Getter per attributo note di riga identificata da chiave
   function get_note /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.note%type;
   pragma restrict_references(get_note, wnds);
   -- Getter per attributo numero_civico di riga identificata da chiave
   function get_numero_civico /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.numero_civico%type;
   pragma restrict_references(get_numero_civico, wnds);
   -- Getter per attributo esponente_civico_1 di riga identificata da chiave
   function get_esponente_civico_1 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.esponente_civico_1%type;
   pragma restrict_references(get_esponente_civico_1, wnds);
   -- Getter per attributo esponente_civico_2 di riga identificata da chiave
   function get_esponente_civico_2 /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.esponente_civico_2%type;
   pragma restrict_references(get_esponente_civico_2, wnds);
   -- Getter per attributo tipo_civico di riga identificata da chiave
   function get_tipo_civico /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.tipo_civico%type;
   pragma restrict_references(get_tipo_civico, wnds);
   -- Getter per attributo id_documento di riga identificata da chiave
   function get_id_documento /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.id_documento%type;
   pragma restrict_references(get_id_documento, wnds);
   -- Getter per attributo link_planimetria di riga identificata da chiave
   function get_link_planimetria /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.link_planimetria%type;
   pragma restrict_references(get_link_planimetria, wnds);
   -- Getter per attributo immagine_planimetria di riga identificata da chiave
   function get_immagine_planimetria /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.immagine_planimetria%type;
   pragma restrict_references(get_immagine_planimetria, wnds);
   -- Setter per attributo progr_unita_fisica di riga identificata da chiave
   procedure set_progr_unita_fisica
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.progr_unita_fisica%type default null
   );
   -- Setter per attributo dal di riga identificata da chiave
   procedure set_dal
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.dal%type default null
   );
   -- Setter per attributo codice_uf di riga identificata da chiave
   procedure set_codice_uf
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.codice_uf%type default null
   );
   -- Setter per attributo denominazione di riga identificata da chiave
   procedure set_denominazione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.denominazione%type default null
   );
   -- Setter per attributo denominazione_al1 di riga identificata da chiave
   procedure set_denominazione_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.denominazione_al1%type default null
   );
   -- Setter per attributo denominazione_al2 di riga identificata da chiave
   procedure set_denominazione_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.denominazione_al2%type default null
   );
   -- Setter per attributo des_abb di riga identificata da chiave
   procedure set_des_abb
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.des_abb%type default null
   );
   -- Setter per attributo des_abb_al1 di riga identificata da chiave
   procedure set_des_abb_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.des_abb_al1%type default null
   );
   -- Setter per attributo des_abb_al2 di riga identificata da chiave
   procedure set_des_abb_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.des_abb_al2%type default null
   );
   -- Setter per attributo indirizzo di riga identificata da chiave
   procedure set_indirizzo
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.indirizzo%type default null
   );
   -- Setter per attributo cap di riga identificata da chiave
   procedure set_cap
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.cap%type default null
   );
   -- Setter per attributo provincia di riga identificata da chiave
   procedure set_provincia
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.provincia%type default null
   );
   -- Setter per attributo comune di riga identificata da chiave
   procedure set_comune
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.comune%type default null
   );
   -- Setter per attributo nota_indirizzo di riga identificata da chiave
   procedure set_nota_indirizzo
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.nota_indirizzo%type default null
   );
   -- Setter per attributo nota_indirizzo_al1 di riga identificata da chiave
   procedure set_nota_indirizzo_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
   );
   -- Setter per attributo nota_indirizzo_al2 di riga identificata da chiave
   procedure set_nota_indirizzo_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
   );
   -- Setter per attributo amministrazione di riga identificata da chiave
   procedure set_amministrazione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.amministrazione%type default null
   );
   -- Setter per attributo id_suddivisione di riga identificata da chiave
   procedure set_id_suddivisione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.id_suddivisione%type default null
   );
   -- Setter per attributo generico di riga identificata da chiave
   procedure set_generico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.generico%type default null
   );
   -- Setter per attributo al di riga identificata da chiave
   procedure set_al
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.al%type default null
   );
   -- Setter per attributo utente_aggiornamento di riga identificata da chiave
   procedure set_utente_aggiornamento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.utente_aggiornamento%type default null
   );
   -- Setter per attributo data_aggiornamento di riga identificata da chiave
   procedure set_data_aggiornamento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.data_aggiornamento%type default null
   );
   -- Setter per attributo capienza di riga identificata da chiave
   procedure set_capienza
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.capienza%type default null
   );
   -- Setter per attributo assegnabile di riga identificata da chiave
   procedure set_assegnabile
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.assegnabile%type default null
   );
   -- Setter per attributo note di riga identificata da chiave
   procedure set_note
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.note%type default null
   );
   -- Setter per attributo numero_civico di riga identificata da chiave
   procedure set_numero_civico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.numero_civico%type default null
   );
   -- Setter per attributo esponente_civico_1 di riga identificata da chiave
   procedure set_esponente_civico_1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.esponente_civico_1%type default null
   );
   -- Setter per attributo esponente_civico_2 di riga identificata da chiave
   procedure set_esponente_civico_2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.esponente_civico_2%type default null
   );
   -- Setter per attributo tipo_civico di riga identificata da chiave
   procedure set_tipo_civico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.tipo_civico%type default null
   );
   -- Setter per attributo id_documento di riga identificata da chiave
   procedure set_id_documento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.id_documento%type default null
   );
   -- Setter per attributo link_planimetria di riga identificata da chiave
   procedure set_link_planimetria
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.link_planimetria%type default null
   );
   -- Setter per attributo immagine_planimetria di riga identificata da chiave
   procedure set_immagine_planimetria
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.immagine_planimetria%type default null
   );
   -- controllo congruenza date
   function is_dal_al_ok
   (
      p_dal in anagrafe_unita_fisiche.dal%type
     ,p_al  in anagrafe_unita_fisiche.al%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in anagrafe_unita_fisiche.dal%type
     ,p_al  in anagrafe_unita_fisiche.al%type
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in anagrafe_unita_fisiche.dal%type
     ,p_al  in anagrafe_unita_fisiche.al%type
   );
   -- Controllo validita' dal
   function is_dal_ok
   (
      p_progr_uf  in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_old_dal   in assegnazioni_fisiche.dal%type
     ,p_new_dal   in assegnazioni_fisiche.dal%type
     ,p_old_al    in assegnazioni_fisiche.al%type
     ,p_new_al    in assegnazioni_fisiche.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) return afc_error.t_error_number;
   -- controllo di validita' al
   function is_al_ok
   (
      p_progr_uf  in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_old_dal   in assegnazioni_fisiche.dal%type
     ,p_new_dal   in assegnazioni_fisiche.dal%type
     ,p_old_al    in assegnazioni_fisiche.al%type
     ,p_new_al    in assegnazioni_fisiche.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) return afc_error.t_error_number;
   function is_capienza_ok
   (
      p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_capienza in anagrafe_unita_fisiche.capienza%type
   ) return afc_error.t_error_number;

   function is_assegnabile_ok(p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type)
      return afc_error.t_error_number;

   function is_ri_ok
   (
      p_progr_uf        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_capienza        in anagrafe_unita_fisiche.capienza%type
     ,p_denominazione   in anagrafe_unita_fisiche.denominazione%type
     ,p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_old_dal         in assegnazioni_fisiche.dal%type
     ,p_new_dal         in assegnazioni_fisiche.dal%type
     ,p_old_al          in assegnazioni_fisiche.al%type
     ,p_new_al          in assegnazioni_fisiche.al%type
     ,p_old_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_new_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_rowid           in rowid
     ,p_inserting       in number
     ,p_updating        in number
     ,p_deleting        in number
   ) return afc_error.t_error_number;
   procedure chk_ri
   (
      p_progr_uf        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_capienza        in anagrafe_unita_fisiche.capienza%type
     ,p_denominazione   in anagrafe_unita_fisiche.denominazione%type
     ,p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_old_dal         in assegnazioni_fisiche.dal%type
     ,p_new_dal         in assegnazioni_fisiche.dal%type
     ,p_old_al          in assegnazioni_fisiche.al%type
     ,p_new_al          in assegnazioni_fisiche.al%type
     ,p_old_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_new_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_rowid           in rowid
     ,p_inserting       in number
     ,p_updating        in number
     ,p_deleting        in number
   );
   procedure set_fi
   (
      p_progr_uf        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_capienza        in anagrafe_unita_fisiche.capienza%type
     ,p_denominazione   in anagrafe_unita_fisiche.denominazione%type
     ,p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_old_dal         in assegnazioni_fisiche.dal%type
     ,p_new_dal         in assegnazioni_fisiche.dal%type
     ,p_old_al          in assegnazioni_fisiche.al%type
     ,p_new_al          in assegnazioni_fisiche.al%type
     ,p_rowid           in rowid
     ,p_inserting       in number
     ,p_updating        in number
     ,p_deleting        in number
   );
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_progr_unita_fisica   in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_codice_uf            in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_indirizzo            in varchar2 default null
     ,p_cap                  in varchar2 default null
     ,p_provincia            in varchar2 default null
     ,p_comune               in varchar2 default null
     ,p_nota_indirizzo       in varchar2 default null
     ,p_nota_indirizzo_al1   in varchar2 default null
     ,p_nota_indirizzo_al2   in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_generico             in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_capienza             in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_note                 in varchar2 default null
     ,p_numero_civico        in varchar2 default null
     ,p_esponente_civico_1   in varchar2 default null
     ,p_esponente_civico_2   in varchar2 default null
     ,p_tipo_civico          in varchar2 default null
     ,p_id_documento         in varchar2 default null
     ,p_link_planimetria     in varchar2 default null
   ) return afc.t_statement;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_progr_unita_fisica   in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_codice_uf            in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_indirizzo            in varchar2 default null
     ,p_cap                  in varchar2 default null
     ,p_provincia            in varchar2 default null
     ,p_comune               in varchar2 default null
     ,p_nota_indirizzo       in varchar2 default null
     ,p_nota_indirizzo_al1   in varchar2 default null
     ,p_nota_indirizzo_al2   in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_generico             in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_capienza             in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_note                 in varchar2 default null
     ,p_numero_civico        in varchar2 default null
     ,p_esponente_civico_1   in varchar2 default null
     ,p_esponente_civico_2   in varchar2 default null
     ,p_tipo_civico          in varchar2 default null
     ,p_id_documento         in varchar2 default null
     ,p_link_planimetria     in varchar2 default null
   ) return integer;

   -- Attributo dal di riga con periodo di validità comprendente
   -- la data indicata
   function get_dal_id /* SLAVE_COPY */
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.dal%type;
   pragma restrict_references(get_dal_id, wnds);

   -- Attributo progressivo di riga con amministrazione e codice indicati e
   -- periodo di validita' comprendente la data indicata
   function get_progr_uf /* SLAVE_COPY */
   (
      p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_dal             in anagrafe_unita_fisiche.dal%type default null
   ) return anagrafe_unita_fisiche.progr_unita_fisica%type;
   pragma restrict_references(get_dal_id, wnds);
   function get_dal_min /* SLAVE_COPY */
   (p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type)
      return anagrafe_unita_fisiche.dal%type;
   pragma restrict_references(get_dal_min, wnds);
   function get_max_al /* SLAVE_COPY */
   (p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type)
      return anagrafe_unita_fisiche.al%type;
   pragma restrict_references(get_max_al, wnds);

   function get_uo_competenza
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione    in anagrafe_unita_fisiche.amministrazione%type
     ,p_data_riferimento   in date
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   
  function is_unita_in_struttura(p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type)
  return varchar2;
   
end anagrafe_unita_fisica;
/


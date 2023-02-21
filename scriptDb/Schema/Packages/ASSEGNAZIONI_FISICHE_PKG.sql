CREATE OR REPLACE package assegnazioni_fisiche_pkg is
   /******************************************************************************
    NOME:        assegnazioni_fisiche_pkg
    DESCRIZIONE: Gestione tabella ASSEGNAZIONI_FISICHE.
    ANNOTAZIONI: .
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    16/08/2012  mmonari  Generazione automatica
    01    03/07/2013  vari     nuova funzione get_unita_fisica Feature#306
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione   constant afc.t_revision := 'V1.01';
   s_table_name  constant afc.t_object_name := 'ASSEGNAZIONI_FISICHE';
   s_data_limite constant date := to_date(3333333, 'j');
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_num constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_num constant afc_error.t_error_number := -20902;
   s_dal_errato_msg constant afc_error.t_error_msg := 'La data di inizio deve essere compresa nel periodo di validita'' precedente';
   dal_sovrapposto exception;
   pragma exception_init(dal_sovrapposto, -20903);
   s_dal_sovrapposto_num constant afc_error.t_error_number := -20903;
   s_dal_sovrapposto_msg constant afc_error.t_error_msg := 'La data di inizio validita'' interseca un''altro periodo di assegnazione dello stesso individuo';
   al_sovrapposto exception;
   pragma exception_init(al_sovrapposto, -20904);
   s_al_sovrapposto_num constant afc_error.t_error_number := -20904;
   s_al_sovrapposto_msg constant afc_error.t_error_msg := 'La data di fine validita'' interseca un''altro periodo di assegnazione dello stesso individuo';
   al_maggiore_uf exception;
   pragma exception_init(al_maggiore_uf, -20905);
   s_al_maggiore_uf_num constant afc_error.t_error_number := -20905;
   s_al_maggiore_uf_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere successiva alla data di fine dell''Unita'' Fisica';
   dal_minore_uf exception;
   pragma exception_init(dal_minore_uf, -20906);
   s_dal_minore_uf_num constant afc_error.t_error_number := -20906;
   s_dal_minore_uf_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio dell''Unita'' Fisica';
   dal_minore_comp exception;
   pragma exception_init(dal_minore_comp, -20907);
   s_dal_minore_comp_num constant afc_error.t_error_number := -20907;
   s_dal_minore_comp_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio del periodo del componente';
   dal_minore_uo exception;
   pragma exception_init(dal_minore_uo, -20908);
   s_dal_minore_uo_num constant afc_error.t_error_number := -20908;
   s_dal_minore_uo_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio dell''Unita'' Organizzativa';
   al_maggiore_comp exception;
   pragma exception_init(al_maggiore_comp, -20909);
   s_al_maggiore_comp_num constant afc_error.t_error_number := -20909;
   s_al_maggiore_comp_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere successiva alla data di fine del periodo del componente';
   al_maggiore_uo exception;
   pragma exception_init(al_maggiore_uo, -20910);
   s_al_maggiore_uo_num constant afc_error.t_error_number := -20910;
   s_al_maggiore_uo_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere successiva alla data di fine dell''Unita'' Organizzativa';
   superata_capienza_uf exception;
   pragma exception_init(al_maggiore_uo, -20911);
   s_superata_capienza_uf_num constant afc_error.t_error_number := -20911;
   s_superata_capienza_uf_msg constant afc_error.t_error_msg := 'Superata la capienza massima prevista per l''unita'' fisica';
   esistono_attributi exception;
   pragma exception_init(esistono_attributi, -20912);
   s_esistono_attributi_num constant afc_error.t_error_number := -20912;
   s_esistono_attributi_msg constant afc_error.t_error_msg := 'Esistono attributi dell''assegnazione'' fisica: periodo non eliminabile';
   periodi_sovrapposti exception;
   pragma exception_init(periodi_sovrapposti, -20913);
   s_periodi_sovrapposti_num constant afc_error.t_error_number := -20913;
   s_periodi_sovrapposti_msg constant afc_error.t_error_msg := 'Esistono altri periodi di assegnazione sovrapposti';
   uf_non_valida exception;
   pragma exception_init(uf_non_valida, -20914);
   s_uf_non_valida_num constant afc_error.t_error_number := -20914;
   s_uf_non_valida_msg constant afc_error.t_error_msg := 'Unita'' fisica non in struttura prima del ';
   -- Versione e revisione
   function versione return varchar2;
   pragma restrict_references(versione, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Check Data Integrity
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in assegnazioni_fisiche.dal%type
     ,p_al  in assegnazioni_fisiche.al%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in assegnazioni_fisiche.dal%type
     ,p_al  in assegnazioni_fisiche.al%type
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in assegnazioni_fisiche.dal%type
     ,p_al  in assegnazioni_fisiche.al%type
   );
   -- Check Referential Integrity
   -- Controllo validita' dal
   function is_dal_ok
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                  in assegnazioni_fisiche.dal%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
   ) return afc_error.t_error_number;
   -- controllo di validita' al
   function is_al_ok
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_al                   in assegnazioni_fisiche.al%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
   ) return afc_error.t_error_number;
   -- Controllo congruita' capienza UF/numero assegnazioni
   function is_capienza_uf_ok
   (
      p_id_asfi  in assegnazioni_fisiche.id_asfi%type
     ,p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type
   ) return afc_error.t_error_number;
   -- Controllo se il soggetto e' esterno
   function is_soggetto_esterno
   (
      p_ni              in assegnazioni_fisiche.ni%type
     ,p_amministrazione in ottiche.amministrazione%type
     ,p_dal             in date
     ,p_al              in date
   ) return varchar2;
   -- Dato l'ni di un soggetto restituisce l'unita fisica di assegnazione
   function get_unita_fisica
   (
      p_ni   assegnazioni_fisiche.ni%type
     ,p_data assegnazioni_fisiche.dal%type
   ) return assegnazioni_fisiche.progr_unita_fisica%type;
   -- recupera l'id successivo
   function get_id_asfi return number;
   -- function di gestione di Referential Integrity
   function is_ri_ok
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                  in assegnazioni_fisiche.dal%type
     ,p_new_dal                  in assegnazioni_fisiche.dal%type
     ,p_old_al                   in assegnazioni_fisiche.al%type
     ,p_new_al                   in assegnazioni_fisiche.al%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                  in assegnazioni_fisiche.dal%type
     ,p_new_dal                  in assegnazioni_fisiche.dal%type
     ,p_old_al                   in assegnazioni_fisiche.al%type
     ,p_new_al                   in assegnazioni_fisiche.al%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   );
   -- Spostamento di un individuo da una UF ad un'altra
   procedure sposta_assegnazione
   (
      p_id_elemento_arrivo     in unita_organizzative.id_elemento%type
     ,p_id_asfi                in assegnazioni_fisiche.id_asfi%type
     ,p_dal                    in assegnazioni_fisiche.dal%type
     ,p_al                     in assegnazioni_fisiche.al%type
     ,p_data_aggiornamento     in assegnazioni_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in assegnazioni_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   /* >>> La sezione seguente prevede le eventuali operazioni di Functional Integrity
   -- Set Functional Integrity
   procedure set_FI
   ( p_<attributo> in ASSEGNAZIONI_FISICHE.<attributo>%type
   , ...
   );*/
end assegnazioni_fisiche_pkg;
/


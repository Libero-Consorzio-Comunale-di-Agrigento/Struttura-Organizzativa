CREATE OR REPLACE package so4gp_pkg is
   /* MASTER_LINK */
   /******************************************************************************
   NOME:        SO4GP_PKG.
   DESCRIZIONE: Funzioni e procedures per integrazione SO4/GP4.
                Versione per integrazione simulata con GP4.
   ANNOTAZIONI: .
   REVISIONI:   .
   Rev.  Data        Autore               Descrizione.
   ----  ----------  ------               ---------------------------------------------------.
   00    27/03/2014  ADADAMO/MMONARI      Prima emissione, #429
   01    26/09/2014  ADADAMO              Aggiunta set_inmo per gestire chiamata
                                          da trigger ubicazioni_componente_tiu in
                                          caso di integrazione con IRIS Bug#525
                                          #550 nuova funzione sposta_componente_gps
   02    29/04/2015  MMONARI              Aggiunta aggiorna_imputazione_gps #594
         08/05/2015  MMONARI              Aggiunta get_padre_giuridico #593
   03    12/10/2020  MMONARI              #45269, disaccoppiamento oggetti integrazione GPs
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.03';
   /*   d_<varTypeName> dataType;
        subtype <t_subTypeName> is d_<varTypeName>%type;
   -- Public constant declarations
      <CONSTANTNAME> constant <dataType> := <Value>;*/
   -- Public variable declarations
   s_p00so4_ins number(1);
   -- Public function and procedure declarations
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function is_int_gp4 return boolean;
   function is_int_gps return boolean;
   function get_moas_id return number;
   function get_id_soggetto_as4(p_ni componenti.ni%type) return componenti.ni%type;
   function get_ni_p00(p_ni componenti.ni%type) return componenti.ni%type;
   function get_ni_as4(p_ni componenti.ni%type) return componenti.ni%type; --#45269
   function get_ci --#45269
   (
      p_ni  in componenti.ni%type
     ,p_dal in date default null
   ) return varchar2;
   function get_ni_unor(p_progr_unor componenti.progr_unita_organizzativa%type)
      return number;
   function get_padre_giuridico --#593
   (
      p_progr_unita_organizzativa componenti.progr_unita_organizzativa%type
     ,p_dal                       componenti.dal%type
     ,p_ottica                    componenti.ottica%type
   ) return componenti.progr_unita_organizzativa%type;
   procedure ins_modifiche_assegnazioni
   (
      p_ottica            in ottiche.ottica%type
     ,p_ni                in componenti.ni%type
     ,p_ci                in componenti.ci%type
     ,p_provenienza       in varchar2
     ,p_data_modifica     in date
     ,p_revisione_so4     in componenti.revisione_assegnazione%type
     ,p_utente            in componenti.utente_aggiornamento%type
     ,p_data_acquisizione in date
     ,p_data_cessazione   in date
     ,p_data_eliminazione in date
     ,p_funzionale        in varchar2
   );
   procedure tratta_moas_verifica_revisione
   (
      p_ottica    in ottiche.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   );
   procedure tratta_most_attivazione_rev
   (
      p_ottica    in ottiche.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   );
   procedure riempi_vista_imputazioni(p_progr_unor unita_organizzative.progr_unita_organizzativa%type);
   function get_sede_unica(p_ni_gp4 number) return number;
   function get_label_sede return varchar2;
   function get_valore_gradazione
   (
      p_tipo_incarico             in tipi_incarico.incarico%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_suddivisione              in suddivisioni_struttura.suddivisione%type default null
     ,p_gradazione                in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_data                      date
   ) return number;
   function get_fascia_gradazione
   (
      p_tipo_incarico             in tipi_incarico.incarico%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_suddivisione              in suddivisioni_struttura.suddivisione%type
     ,p_gradazione                in anagrafe_unita_organizzative.tipologia_unita%type
     ,p_data                      date
   ) return varchar2;
   function controllo_modificabilita
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
   ) return afc_error.t_error_number;
   function get_numero_ci(p_ni componenti.ni%type) return number;
   function is_componente_ok
   (
      p_ci            componenti.ci%type
     ,p_data_modifica date
   ) return varchar2;
   procedure ins_unita_so4_gp4
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   );
   function is_struttura_integrata
   (
      p_amministrazione in varchar2
     ,p_ottica          in varchar2
   ) return varchar2;
   function get_data_modifica_moas(p_ci in number) return date;
   function get_no_elaborazione(p_provenienza in varchar2) return number;
   function get_gestione_gp4(p_amministrazione in varchar2) return varchar2;
   procedure set_data_modifica_moas
   (
      p_ci   in number
     ,p_data in date
   );
   procedure acquisizione_componenti_gp4
   (
      p_prima_acquisizione varchar2
     ,p_ci                 number default null
     ,p_no_elaborazione    number default null
   );
   -- Bug#525
   procedure set_inmo
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in ubicazioni_componente.dal%type
   );
   procedure sposta_componente_gps
   (
      p_ci                        in componenti.ci%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type
     ,p_assegnazione_prevalente   in attributi_componente.assegnazione_prevalente%type
     ,p_amministrazione           in amministrazioni.codice_amministrazione%type
     ,p_utente                    in componenti.utente_aggiornamento%type
   );
   procedure ripristina_componente_gps
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente                  in componenti.utente_aggiornamento%type
   );
   procedure aggiorna_imputazione_gps --#594
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_old_dal                 in componenti.dal%type
     ,p_old_al                  in componenti.al%type
     ,p_sede                    in imputazioni_bilancio.numero%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente                  in imputazioni_bilancio.utente_agg%type
   );
end so4gp_pkg;
/


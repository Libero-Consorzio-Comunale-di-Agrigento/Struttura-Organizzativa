CREATE OR REPLACE package so4_pubblicazione_modifiche is
   /******************************************************************************
    NOME:        so4_pubblicazione_modifiche
    DESCRIZIONE: Metodi per la pubblicazione delle modifiche
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore       Descrizione.
    00    13/01/2014  MMONARI      Prima emissione.
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.0';
   s_data_limite date := to_date(3333333, 'j');
   s_notificato  number(1);
   s_ottica componenti.ottica%type;
   
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   procedure registra_evento
   (
      p_oggetto         in so4_eventi.oggetto%type
     ,p_id_modifica     in so4_eventi.id_modifica%type
     ,p_categoria       in so4_eventi.categoria%type
     ,p_tipo            in so4_eventi.tipo%type
     ,p_amministrazione in so4_eventi.amministrazione%type
     ,p_ottica          in so4_eventi.ottica%type
   );

   procedure completa_eventi;

   procedure notifica_eventi;

   procedure pubblica_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in date
   );

   procedure set_inizio_acquisizione
   (
      p_modulo          in iscrizioni_pubblicazione.modulo%type
     ,p_time            in timestamp
     ,p_amministrazione in ottiche.amministrazione%type default null
     ,p_ottica          in ottiche.ottica%type default null
   );

   procedure registra_ottica
   (
      p_new_ottica in ottiche_b%rowtype
     ,p_old_ottica in ottiche_b%rowtype
     ,p_operazione in varchar2
   );

   procedure registra_amministrazione
   (
      p_new_amministrazione in amministrazioni_b%rowtype
     ,p_old_amministrazione in amministrazioni_b%rowtype
     ,p_operazione          in varchar2
   );

   procedure registra_revisione_struttura
   (
      p_new_revisione_struttura in revisioni_struttura_b%rowtype
     ,p_old_revisione_struttura in revisioni_struttura_b%rowtype
     ,p_operazione              in varchar2
   );

   procedure registra_unita_organizzativa
   (
      p_new_unita_organizzativa in unita_organizzative_b%rowtype
     ,p_old_unita_organizzativa in unita_organizzative_b%rowtype
     ,p_operazione              in varchar2
   );

   procedure registra_anagrafe_unita_org
   (
      p_new_anagrafe_unita_org in anagrafe_unita_organizzative_b%rowtype
     ,p_old_anagrafe_unita_org in anagrafe_unita_organizzative_b%rowtype
     ,p_operazione             in varchar2
   );

   procedure registra_componente
   (
      p_new_componente in componenti_b%rowtype
     ,p_old_componente in componenti_b%rowtype
     ,p_operazione     in varchar2
   );

   procedure registra_attributo_componente
   (
      p_new_attributo_componente in attributi_componente_b%rowtype
     ,p_old_attributo_componente in attributi_componente_b%rowtype
     ,p_operazione               in varchar2
   );

   procedure registra_ruolo_componente
   (
      p_new_ruolo_componente in ruoli_componente_b%rowtype
     ,p_old_ruolo_componente in ruoli_componente_b%rowtype
     ,p_operazione           in varchar2
   );

   procedure registra_imputazione_bilancio
   (
      p_new_imputazione_bilancio in imputazioni_bilancio_b%rowtype
     ,p_old_imputazione_bilancio in imputazioni_bilancio_b%rowtype
     ,p_operazione               in varchar2
   );

   procedure registra_ubicazione_componente
   (
      p_new_ubicazione_componente in ubicazioni_componente_b%rowtype
     ,p_old_ubicazione_componente in ubicazioni_componente_b%rowtype
     ,p_operazione                in varchar2
   );

   procedure registra_unita_fisica
   (
      p_new_unita_fisica in unita_fisiche_b%rowtype
     ,p_old_unita_fisica in unita_fisiche_b%rowtype
     ,p_operazione       in varchar2
   );

   procedure registra_anagrafe_unita_fis
   (
      p_new_anagrafe_unita_fis in anagrafe_unita_fisiche_b%rowtype
     ,p_old_anagrafe_unita_fis in anagrafe_unita_fisiche_b%rowtype
     ,p_operazione             in varchar2
   );

   procedure registra_ubicazione_unita
   (
      p_new_ubicazione_unita in ubicazioni_unita_b%rowtype
     ,p_old_ubicazione_unita in ubicazioni_unita_b%rowtype
     ,p_operazione           in varchar2
   );

   procedure registra_assegnazione_fisica
   (
      p_new_assegnazione_fisica in assegnazioni_fisiche_b%rowtype
     ,p_old_assegnazione_fisica in assegnazioni_fisiche_b%rowtype
     ,p_operazione              in varchar2
   );

   procedure registra_soggetto_rubrica
   (
      p_new_soggetto_rubrica in soggetti_rubrica_b%rowtype
     ,p_old_soggetto_rubrica in soggetti_rubrica_b%rowtype
     ,p_operazione           in varchar2
   );

end so4_pubblicazione_modifiche;
/


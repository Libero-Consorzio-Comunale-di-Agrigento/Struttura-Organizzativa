CREATE OR REPLACE package controlli_componenti is
   /******************************************************************************
    NOME:        controlli_componenti
    DESCRIZIONE: Raggruppa le funzioni di controllo dei dati caricati in so4 
                 relative a componenti e tabelle dipendenti
    ANNOTAZIONI: 
   
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    13/11/2012  VDAVALLI  Prima emissione.
    </CODE>
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.0';

   -- Restituisce versione del package
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);

   function get_nominativo(p_ni anagrafe_soggetti.ni%type) return varchar2;

   -- Registrazione messaggio di errore bloccante in tabella KEY_ERROR_LOG
   procedure registra_errore
   (
      p_text     key_error_log.error_text%type
     ,p_usertext key_error_log.error_usertext%type
     ,p_session  key_error_log.error_session%type
   );
   -- Registrazione segnalazione informativa in tabella KEY_ERROR_LOG
   procedure registra_info
   (
      p_text     key_error_log.error_text%type
     ,p_usertext key_error_log.error_usertext%type default null
     ,p_session  key_error_log.error_session%type
   );

   -- Controllo COMPONENTI: utenti mancanti
   procedure chk_soggetti(p_tipo_elaborazione number);

   -- Controllo COMPONENTI: incarichi mancanti
   procedure chk_incarichi(p_tipo_elaborazione number);

   -- Controllo COMPONENTI: congruenza date tabelle dipendenti
   procedure controllo_dipendenze(p_tipo_elaborazione number);

   -- Controllo COMPONENTI: DAL congruente con REVISIONE_ASSEGNAZIONE
   procedure comp_controllo_1(p_tipo_elaborazione number);

   -- Controllo COMPONENTI: AL congruente con REVISIONE_CESSAZIONE
   procedure comp_controllo_2(p_tipo_elaborazione number);

   -- Controllo COMPONENTI: congruenza DAL e DAL_PUBB
   procedure comp_controllo_3(p_tipo_elaborazione number);

   -- Controllo COMPONENTI: congruenza AL e AL_PUBB
   procedure comp_controllo_4(p_tipo_elaborazione number);

   -- Controllo ATTRIBUTI_COMPONENTE: DAL congruente con REVISIONE_ASSEGNAZIONE
   procedure atco_controllo_1(p_tipo_elaborazione number);

   -- Controllo ATTRIBUTI_COMPONENTE: AL congruente con REVISIONE_CESSAZIONE
   procedure atco_controllo_2(p_tipo_elaborazione number);

   -- Controllo ATTRIBUTI_COMPONENTE: congruenza DAL e DAL_PUBB
   procedure atco_controllo_3(p_tipo_elaborazione number);

   -- Controllo ATTRIBUTI_COMPONENTE: congruenza AL e AL_PUBB
   procedure atco_controllo_4(p_tipo_elaborazione number);

   -- Controllo FK
   procedure chk_fk(p_tipo_elaborazione number);

   -- Controlli funzionali
   procedure chk_fi(p_tipo_elaborazione number);

   -- Controllo Assegnazioni Fisiche
   procedure chk_assegnazioni_fisiche(p_tipo_elaborazione number);

   -- Controllo Soggetti Rubrica
   procedure chk_rubrica(p_tipo_elaborazione number);

   -- Esecuzione di tutti i controlli in sequenza
   procedure main
   (
      p_ottica            varchar2
     ,p_tipo_elaborazione number
   );

end controlli_componenti;
/


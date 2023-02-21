CREATE OR REPLACE package so4_pkg is
   /******************************************************************************
   NOME:        SO4_PKG.
   DESCRIZIONE: Procedure e Funzioni di utilita' comune per l'applicativo Struttura Organizzativa
   ANNOTAZIONI: .
   REVISIONI: .
   Rev.  Data        Autore  Descrizione.
   00    21/09/2006  VD      Prima emissione.
   01    09/08/2012  AD      Aggiunta funzione e variabile di appoggio da utilizzare
                             per l'ordinamento della struttura nelle stampe
   02    15/10/2012  AD      Aggiunte funzione per fascia e peso economico per
                             stampa struttura con budget
         26/10/2012  AD      Aggiunta funzione per la formattazione delle cifre
         31/10/2012  AD      Aggiunta funzione per la totalizzazione sulle AP (REMA)
   03    26/02/2013  AD      Aggiunta funzione get_integrazione_gp (Redmine #184)
         20/03/2013  AD      Aggiunta funzione check_assegnazione_prev (Redmine #184)
         28/03/2013  AD      Aggiunta funzione get_data_riferimento
   04    18/12/2013  AD      Aggiunta funzione get_data_elab_stampa
         03/01/2014  AD      Modificata funzione ordertree per gestire la dimensione della
                             stringa da concatenare per gestire l'ordinamento
         28/01/2014  AD      Aggiunta funzione per determinare la sede di imputazione
   05    13/05/2014  ADADAMO Issue #444 aggiunta funzione per get dei dati di pubblicazione
         10/12/2014  MMONARI Issue #548 : nuove funzioni generiche per la determinazione delle
                             date di pubblicazione
   06    23/05/2016  ADADAMO Aggiunte funzioni invalid_object_handler e check_db_integrity
                             per gestione oggetti invalidi (Issue #179)
   07    10/05/2017  MMONARI Aggiunte funzioni get_mail_soggetto (Issue #772)
   08    18/06/2018  ADADAMO Aggiunta funzione per verifica componente di integrazione con
                             AS4 in versione 4.4 o successive   (Issue #28857)
   09    28/09/2018  MMONARI (Issue #30648)
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.09';
   type t_periodo is record(
       dal date
      ,al  date);
   -- Public function and procedure declarations
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   procedure init_cronologia
   (
      p_utente   in out varchar2
     ,p_data_agg in out date
   );
   function ordertree
   (
      p_level  in number
     ,p_figlio in varchar2
     ,p_strlen in number default 16
   ) return varchar2;
   v_testo varchar2(32000);
   function unita_get_peso_economico
   (
      p_progr_unita anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_ottica      componenti.ottica%type default null
     ,p_data        componenti.dal%type default null
   ) return number;
   function get_assegnazione_logica
   (
      p_ni              componenti.ni%type
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.progr_unita_organizzativa%type;
   function get_assegnazione_logica
   (
      p_ni                   componenti.ni%type
     ,p_amministrazione      amministrazioni.codice_amministrazione%type default null
     ,p_data                 componenti.dal%type default null
     ,p_ottica               componenti.ottica%type default '%'
     ,p_ottica_istituzionale ottiche.ottica_istituzionale%type default 'SI'
   ) return componenti.id_componente%type;
   function get_descr_assegnazione_logica
   (
      p_ni                   componenti.ni%type
     ,p_amministrazione      amministrazioni.codice_amministrazione%type default null
     ,p_data                 componenti.dal%type default null
     ,p_ottica               componenti.ottica%type default '%'
     ,p_ottica_istituzionale ottiche.ottica_istituzionale%type default 'SI'
   ) return varchar2;
   function unita_get_fascia
   (
      p_progr_unita anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_ottica      componenti.ottica%type default null
     ,p_data        componenti.dal%type default null
   ) return varchar2;
   function get_totale_per_suddivisione
   (
      p_progr_uo in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica   in anagrafe_unita_organizzative.ottica%type
     ,p_data     in date
   ) return number;
   function get_desc_totali(p_ottica in ottiche.ottica%type) return varchar2;
   function formatta_numero(p_numero in number) return varchar2;
   function get_totale_ap
   (
      p_progr_uo in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica   in anagrafe_unita_organizzative.ottica%type
     ,p_data     in date
   ) return number;
   function get_next_codice_uo(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return anagrafe_unita_organizzative.codice_uo%type;
   function get_next_codice_uf(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return anagrafe_unita_fisiche.codice_uf%type;
   function get_integrazione_gp return varchar2;
   function get_integrazione_as4new return varchar2;
   function check_assegnazione_prev
   (
      p_valore in varchar2
     ,p_ottica in ottiche.ottica%type
   ) return number;
   function get_data_riferimento(p_ottica in ottiche.ottica%type) return date;
   function get_data_elab_stampa(p_ottica in ottiche.ottica%type) return date;
   function get_sede(p_numero in imputazioni_bilancio.numero%type) return varchar2;
   function get_mail_soggetto(p_ni in anagrafe_soggetti.ni%type)
      return anagrafe_soggetti.indirizzo_web%type; --#772
   procedure notifica_mail
   (
      p_name         varchar2
     ,p_sender_email varchar2
     ,p_recipient    varchar2
     ,p_subject      varchar2
     ,p_text_msg     varchar2
   ); --#772
   function get_dati_pubblicazione
   (
      p_oggetto in varchar2
     ,p_pk      in number
   ) return varchar2;
   function al_pubblicazione --#548
   (
      p_operazione   in varchar2
     ,p_contesto     in varchar2
     ,p_al_pubb_prec in date default to_date(3333333, 'j')
     ,p_new_al       in date default to_date(3333333, 'j')
     ,p_old_al       in date default to_date(3333333, 'j')
     ,p_al_limite    in date default to_date(3333333, 'j')
     ,p_intersezione in number default 0
   ) return date;
   function dal_pubblicazione --#548
   (
      p_operazione    in varchar2
     ,p_contesto      in varchar2
     ,p_dal_pubb_prec in date default to_date(3333333, 'j')
     ,p_new_dal       in date default to_date(2222222, 'j')
     ,p_old_dal       in date default to_date(2222222, 'j')
     ,p_dal_limite    in date default to_date(2222222, 'j')
   ) return date;
   function invalid_object_handler return number;
   function check_db_integrity return number;
   function check_ruolo_riservato(p_ruolo in ruoli_componente.ruolo%type) return number; --#30648
end so4_pkg;
/


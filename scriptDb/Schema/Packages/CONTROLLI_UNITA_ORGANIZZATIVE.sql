CREATE OR REPLACE package controlli_unita_organizzative is
   /******************************************************************************
    NOME:        controlli_unita_organizzative
    DESCRIZIONE: Raggruppa le funzioni di controllo dei dati caricati in so4
                 relative a anagrafe_unita_organizzative e unita_organizzative.
    ANNOTAZIONI: 
   
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    13/11/2012  VDAVALLI  Prima emissione.
    01    01/10/2014  VDAVALLI  Aggiunti nuovi controlli
    </CODE>
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.0';

   -- Restituisce versione del package
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);

   -- Registrazione messaggio di errore bloccante in tabella KEY_ERROR_LOG
   procedure registra_errore
   (
      p_text     varchar2
     ,p_usertext varchar2
   );
   -- Registrazione segnalazione informativa in tabella KEY_ERROR_LOG
   procedure registra_info
   (
      p_text     varchar2
     ,p_usertext varchar2 default null
   );

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo OTTICA
   procedure anuo_controllo_01(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo AMMINISTRAZIONE
   procedure anuo_controllo_02(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo AOO
   procedure anuo_controllo_03(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo ID_SUDDIVISIONE
   procedure anuo_controllo_04(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo CENTRO_COSTO
   procedure anuo_controllo_05(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo AGGREGATORE
   procedure anuo_controllo_06(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo INCARICO_RESP
   procedure anuo_controllo_07(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: controllo utente_ad4
   procedure anuo_controllo_08(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: DAL congruente con REVISIONE_ISTITUZIONE
   procedure anuo_controllo_09(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: AL congruente con REVISIONE_CESSAZIONE
   procedure anuo_controllo_10(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: periodi sovrapposti
   procedure anuo_controllo_11;

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: dal_pubb valorizzato in presenza di dal
   procedure anuo_controllo_12(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: al_pubb valorizzato in presenza di al
   procedure anuo_controllo_13(p_tipo_elaborazione number);

   -- Controllo ANAGRAFE_UNITA_ORGANIZZATIVE: periodi sovrapposti per date di pubblicazione
   procedure anuo_controllo_14;

   -- Controllo UNITA_ORGANIZZATIVE: esistenza unita' in ANAGRAFE_UNITA_ORGANIZZATIVE
   procedure unor_controllo_1(p_tipo_elaborazione number);

   -- Controllo UNITA_ORGANIZZATIVE: DAL congruente con REVISIONE_ISTITUZIONE
   procedure unor_controllo_2(p_tipo_elaborazione number);

   -- Controllo UNITA_ORGANIZZATIVE: AL congruente con REVISIONE_CESSAZIONE
   procedure unor_controllo_3(p_tipo_elaborazione number);

   -- Controllo UNITA_ORGANIZZATIVE: periodi sovrapposti
   procedure unor_controllo_4;

   -- Controllo UNITA_ORGANIZZATIVE: dal_pubb valorizzato in presenza di dal
   procedure unor_controllo_5(p_tipo_elaborazione number);

   -- Controllo UNITA_ORGANIZZATIVE: al_pubb valorizzato in presenza di al
   procedure unor_controllo_6(p_tipo_elaborazione number);

   -- Controllo UNITA_ORGANIZZATIVE: periodi sovrapposti
   procedure unor_controllo_7;

   -- Controlli incrociati ANAGRAFE_UNITA_ORGANIZZATIVE / UNITA_ORGANIZZATIVE
   procedure controlli_incrociati_1;

   -- Controlli incrociati padri / figli UNITA_ORGANIZZATIVE
   procedure controlli_incrociati_2;

   -- Esecuzione di tutti i controlli in sequenza
   procedure main
   (
      p_ottica            varchar2
     ,p_tipo_elaborazione number
   );

end controlli_unita_organizzative;
/


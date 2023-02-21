CREATE OR REPLACE package so4as4_pkg is
   /******************************************************************************
    NOME:        SO4AS4_PKG
    DESCRIZIONE: Procedure e Funzioni di utilita' per interagire con AS4 nella
                 versione 4.4 o successive
    ANNOTAZIONI: .
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    00    28/05/2018  AD      Prima emissione.
    01    03/04/2019  SN      Aggiunta procedure trasco_iniziale
    02    15/03/2022  MM      #54239
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.02';
   -- Public function and procedure declarations
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   procedure allinea_uo
   (
      p_ni_as4                    in as4_anagrafe_soggetti.ni%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type --#54239
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type
     ,p_comune                    in anagrafe_unita_organizzative.comune%type
     ,p_cap                       in anagrafe_unita_organizzative.cap%type
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type
     ,p_fax                       in anagrafe_unita_organizzative.fax%type
     ,p_utente_agg                in anagrafe_unita_organizzative.utente_aggiornamento%type
   );
   procedure allinea_aoo
   (
      p_ni_as4      in as4_anagrafe_soggetti.ni%type
     ,p_progr_aoo   in aoo.progr_aoo%type
     ,p_dal         in aoo.dal%type
     ,p_old_dal     in aoo.dal%type
     ,p_descrizione in aoo.descrizione%type
     ,p_indirizzo   in aoo.indirizzo%type
     ,p_provincia   in aoo.provincia%type
     ,p_comune      in aoo.comune%type
     ,p_cap         in aoo.cap%type
     ,p_telefono    in aoo.telefono%type
     ,p_fax         in aoo.fax%type
     ,p_utente_agg  in aoo.utente_aggiornamento%type
   );
   procedure allinea_indirizzo_telematico
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_old_indirizzo          in indirizzi_telematici.indirizzo%type
     ,p_utente_agg             in indirizzi_telematici.utente_aggiornamento%type
      --,P_INSERTING                IN NUMBER
   );

   procedure allinea_amm
   (
      p_ni_as4     in as4_anagrafe_soggetti.ni%type
     ,p_codice_amm in amministrazioni.codice_amministrazione%type
   );

   procedure trasco_iniziale;
end so4as4_pkg;
/


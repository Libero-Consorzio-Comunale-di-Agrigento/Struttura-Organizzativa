CREATE OR REPLACE package gps_util is

   type t_ref_cursor is ref cursor;
   s_result varchar2(32000);

   /******************************************************************************
    NOME:        GPS_UTIL
    DESCRIZIONE: Contiene funzioni utilizzate per l'integrazione con GPS
    ANNOTAZIONI: I metodi richiamati direttamente da GPS sono:
                - chiudi_assegnazione
                - del_assegnazione
                - get_assegnazione_between
                - get_assegnazione_struttura
                - get_assegnazioni_imputazioni
                - get_assegnazioni_periodo
                - get_ultima_revisione
                - get_unita_discendenti
                - ins_assegnazione
                - prima_assegnazione
                - rettifica_assegnazione
                - rettifica_incarico
                - ultima_assegnazione
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    25/02/2010  APASSUELLO  Prima emissione.
    01    05/12/2011  ADADAMO     Aggiunta funzione per cursore delle assegnazioni
                                  considerando la storicità delle eventuali imputazioni
                                  contabili
    02    21/03/2012  ADADAMO     Aggiunta check_esiste_attributo
    03    29/04/2013  ADADAMO     Nuova funzione get_al_unor
    04    07/05/2013  MMONARI     Redmine #191 - Ereditarieta' ruoli e variazioni retroattive
    05    10/01/2014  MSARTI      Migliorate le segnalazioni di errore
    06    06/10/2014  ADADAMO     Aggiunta is_dipendente_componente per non gestire
                                  gli individui con componente=NO nella classe di
                                  rapporto F7163 (GPS)
    07    10/12/2014  MMONARI     Modifiche alla gestione delle date di pubblicazione
                                  su COMP, ATCO, RUCO, IMBI, UBCO
                                  a fronte di modifiche di GPS #548
    08    29/04/2015  MMONARI     #594 : Rettifica_imputazione
          18/05/2015  MMONARI     #588 : modifiche a ripristina_ruoli
    09    28/12/2016  MSARTI      Con Angelo: definita is_periodo_eliminabile (Issue 19851)
    10    20/10/2015  MMONARI     #639 : modifiche ai parametri di Rettifica_imputazione
          04/02/2016  MMONARI     #681 : nuove funzioni per assegnazione fisica
          09/08/2016  MMONARI     #737 : nuova variabile s_result
          28/12/2016  MSARTI      #748 : Con Angelo: definita is_periodo_eliminabile (Issue 19851)
    11    30/08/2017  MMONARI     #787 : Nuova funzione get_componenti_uo per GPSDO
    12    21/10/2018  MMONARI     #31549 : eliminata la is_dipendente_componente
          15/03/2019  MMONARI     #33820 : nuova funzione get_progr_uo
          10/10/2019  MMONARI     #37425 : modifiche all'ereditarieta' dei ruoli delle assegnazioni funzionali
          17/03/2021  MMONARI     #49029 : nuova funzione get_uo_modificate
    13    10/11/2022  MMONARI     #60318 : nuova proc. ins_assegnazione_funzionale
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V13';
   ------------------------------------------------------------------------------
   -- Exceptions
   err_ins_comp exception;
   pragma exception_init(err_ins_comp, -20901);
   s_err_ins_comp_number constant afc_error.t_error_number := -20901;
   s_err_ins_comp_msg    constant afc_error.t_error_msg := 'Errore durante l''inserimento di un record nella tabella COMPONENTI';
   err_ins_imput_bil exception;
   pragma exception_init(err_ins_imput_bil, -20902);
   s_err_ins_imput_bil_number constant afc_error.t_error_number := -20902;
   s_err_ins_imput_bil_msg    constant afc_error.t_error_msg := 'Errore durante l''inserimento di un record nella tabella IMPUTAZIONI_BILANCIO';
   err_select_comp exception;
   pragma exception_init(err_select_comp, -20903);
   s_err_select_comp_number constant afc_error.t_error_number := -20903;
   s_err_select_comp_msg    constant afc_error.t_error_msg := 'Errore durante l''esecuzione della query sulla tabella COMPONENTI';
   err_date_cess exception;
   pragma exception_init(err_date_cess, -20904);
   s_err_date_cess_number constant afc_error.t_error_number := -20904;
   s_err_date_cess_msg    constant afc_error.t_error_msg := 'Errore di date incongruenti';
   err_comp_get_unita exception;
   pragma exception_init(err_comp_get_unita, -20905);
   s_err_comp_get_unita_number constant afc_error.t_error_number := -20905;
   s_err_comp_get_unita_msg    constant afc_error.t_error_msg := 'Errore durante l''estrazione dell''unità di assegnazione prevalente per il componente';
   err_comp_get_imputaz exception;
   pragma exception_init(err_comp_get_imputaz, -20906);
   s_err_comp_get_imputaz_number constant afc_error.t_error_number := -20906;
   s_err_comp_get_imputaz_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione dell''imputazione contabile per il componente';
   err_get_strutt exception;
   pragma exception_init(err_get_strutt, -20907);
   s_err_get_strutt_number constant afc_error.t_error_number := -20907;
   s_err_get_strutt_msg    constant afc_error.t_error_msg := 'Errore durante l''esecuzione della query per l''estrazione della struttura organizzativa';
   err_ins_attr_comp exception;
   pragma exception_init(err_ins_attr_comp, -20908);
   s_err_ins_attr_comp_number constant afc_error.t_error_number := -20908;
   s_err_ins_attr_comp_msg    constant afc_error.t_error_msg := 'Errore durante l''inserimento di un record nella tabella ATTRIBUTI_COMPONENTE';
   err_upd_comp exception;
   pragma exception_init(err_upd_comp, -20909);
   s_err_upd_comp_number constant afc_error.t_error_number := -20909;
   s_err_upd_comp_msg    constant afc_error.t_error_msg := 'Errore durante l''aggiornamento di un record nella tabella COMPONENTI';
   err_get_uo exception;
   pragma exception_init(err_get_uo, -20910);
   s_err_get_uo_number constant afc_error.t_error_number := -20910;
   s_err_get_uo_msg    constant afc_error.t_error_msg := 'Errore durante l''esecuzione della query per l''estrazione dell''unità organizzativa';
   err_del_comp exception;
   pragma exception_init(err_del_comp, -20911);
   s_err_del_comp_number constant afc_error.t_error_number := -20911;
   s_err_del_comp_msg    constant afc_error.t_error_msg := 'Errore durante la cancellazione del componente';
   err_sel_attr_comp exception;
   pragma exception_init(err_sel_attr_comp, -20912);
   s_err_sel_attr_comp_number constant afc_error.t_error_number := -20912;
   s_err_sel_attr_comp_msg    constant afc_error.t_error_msg := 'Errore durante l''esecuzione della query sulla tabella ATTRIBUTI_COMPONENTE';
   err_upd_attr exception;
   pragma exception_init(err_upd_attr, -20913);
   s_err_upd_attr_number constant afc_error.t_error_number := -20913;
   s_err_upd_attr_msg    constant afc_error.t_error_msg := 'Errore durante l''aggiornamento di un record nella tabella ATTRIBUTI_COMPONENTE';
   err_data_comp exception;
   pragma exception_init(err_data_comp, -20914);
   s_err_data_comp_number constant afc_error.t_error_number := -20914;
   s_err_data_comp_msg    constant afc_error.t_error_msg := 'Errore. Nella tabella COMPONENTE esiste un''assegnazione con data di inizio validità maggiore';
   err_stato_comp exception;
   pragma exception_init(err_stato_comp, -20915);
   s_err_stato_comp_number constant afc_error.t_error_number := -20915;
   s_err_stato_comp_msg    constant afc_error.t_error_msg := 'Errore. Non e'' possibile modificare assegnazioni definitive';
   s_err_sel_comp_nodataf exception;
   pragma exception_init(s_err_sel_comp_nodataf, -20916);
   s_err_sel_comp_nodataf_number constant afc_error.t_error_number := -20916;
   s_err_sel_comp_nodataf_msg    constant afc_error.t_error_msg := 'Errore durante l''esecuzione della query sulla tabella COMPONENTI. La query non ha estratto nessun dato';
   s_err_sel_comp_toomanyr exception;
   pragma exception_init(s_err_sel_comp_toomanyr, -20917);
   s_err_sel_comp_toomanyr_number constant afc_error.t_error_number := -20917;
   s_err_sel_comp_toomanyr_msg    constant afc_error.t_error_msg := 'Errore durante l''esecuzione della query sulla tabella COMPONENTI. La query ha estratto troppi dati';
   s_err_comp_get_unit_ndf exception;
   pragma exception_init(s_err_comp_get_unit_ndf, -20918);
   s_err_comp_get_unit_ndf_number constant afc_error.t_error_number := -20918;
   s_err_comp_get_unit_ndf_msg    constant afc_error.t_error_msg := 'Errore durante l''estrazione dell''unità di assegnazione prevalente per il componente. Nessun record estratto.';
   s_err_comp_get_unit_tmr exception;
   pragma exception_init(s_err_comp_get_unit_tmr, -20919);
   s_err_comp_get_unit_tmr_number constant afc_error.t_error_number := -20919;
   s_err_comp_get_unit_tmr_msg    constant afc_error.t_error_msg := 'Errore durante l''estrazione dell''unità di assegnazione prevalente per il componente. Sono stati estratti troppi record.';
   s_err_comp_get_imp_ndf exception;
   pragma exception_init(s_err_comp_get_imp_ndf, -20920);
   s_err_comp_get_imp_ndf_number constant afc_error.t_error_number := -20920;
   s_err_comp_get_imp_ndf_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione dell''imputazione contabile per il componente. Nessun record estratto.';
   s_err_comp_get_imp_tmr exception;
   pragma exception_init(s_err_comp_get_imp_tmr, -20921);
   s_err_comp_get_imp_tmr_number constant afc_error.t_error_number := -20921;
   s_err_comp_get_imp_tmr_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione dell''imputazione contabile per il componente. Sono stati estratti troppi record.';
   s_err_rett_per_ass_ndf exception;
   pragma exception_init(s_err_rett_per_ass_ndf, -20922);
   s_err_rett_per_ass_number_ndf constant afc_error.t_error_number := -20922;
   s_err_rett_per_ass_msg_ndf    constant afc_error.t_error_msg := 'Errore nella rettifica del periodo di assegnazione del componente. Non esiste il periodo da modificare.';
   s_err_rett_per_ass_tmr exception;
   pragma exception_init(s_err_rett_per_ass_tmr, -20923);
   s_err_rett_per_ass_number_tmr constant afc_error.t_error_number := -20923;
   s_err_rett_per_ass_msg_tmr    constant afc_error.t_error_msg := 'Errore nella rettifica del periodo di assegnazione del componente. Esistono più assegnazioni alla stessa data.';
   s_err_rett_per_ass_ps exception;
   pragma exception_init(s_err_rett_per_ass_ps, -20924);
   s_err_rett_per_ass_number_ps constant afc_error.t_error_number := -20924;
   s_err_rett_per_ass_msg_ps    constant afc_error.t_error_msg := 'Errore nella rettifica del periodo di assegnazione del componente. Esistono altri periodi di assegnazione sovrapposti';
   s_err_rett_inc_no_rec exception;
   pragma exception_init(s_err_rett_inc_no_rec, -20925);
   s_err_rett_inc_no_rec_number constant afc_error.t_error_number := -20925;
   s_err_rett_inc_no_rec_msg    constant afc_error.t_error_msg := 'Errore nella rettifica dell''incarico del componente. Non esistono assegnazioni nel periodo indicato';
   s_err_get_ass_ndf exception;
   pragma exception_init(s_err_get_ass_ndf, -20926);
   s_err_get_ass_ndf_number constant afc_error.t_error_number := -20926;
   s_err_get_ass_ndf_msg    constant afc_error.t_error_msg := 'Errore nella determinazione del periodo di assegnazione del componente. Non esiste il periodo indicato.';
   s_err_del_per_ass_ndf exception;
   pragma exception_init(s_err_del_per_ass_ndf, -20927);
   s_err_del_per_ass_number_ndf constant afc_error.t_error_number := -20927;
   s_err_del_per_ass_msg_ndf    constant afc_error.t_error_msg := 'Errore nell''eliminazione del periodo di assegnazione del componente. Non esiste nessun periodo con questa decorrenza.';
   s_err_del_per_ass_tmr exception;
   pragma exception_init(s_err_del_per_ass_tmr, -20928);
   s_err_del_per_ass_number_tmr constant afc_error.t_error_number := -20928;
   s_err_del_per_ass_msg_tmr    constant afc_error.t_error_msg := 'Errore nell''eliminazione del periodo di assegnazione del componente. Esistono più assegnazioni con la stessa decorrenza.';
   componente_gia_presente exception;
   pragma exception_init(componente_gia_presente, -20929);
   s_componente_gia_pres_number constant afc_error.t_error_number := -20929;
   s_componente_gia_pres_msg    constant afc_error.t_error_msg := componente.s_componente_gia_pres_msg;
   err_ruoli_comp exception;
   pragma exception_init(err_stato_comp, -20930);
   s_err_ruoli_comp_number constant afc_error.t_error_number := -20930;
   s_err_ruoli_comp_msg    constant afc_error.t_error_msg := 'Errore. Non e'' possibile modificare assegnazioni con ruoli attivi';
   componente_in_modifica exception;
   pragma exception_init(componente_in_modifica, -20931);
   s_componente_in_mod_number constant afc_error.t_error_number := -20931;
   s_componente_in_mod_msg    constant afc_error.t_error_msg := 'Il soggetto e'' interessato dalla revisione in modifica. Operazione non eseguita.';
   componente_non_determinabile exception;
   pragma exception_init(componente_non_determinabile, -20932);
   s_componente_indet_number constant afc_error.t_error_number := -20932;
   s_componente_indet_msg    constant afc_error.t_error_msg := 'Componente non determinabile. Aggiornamento imputazione non eseguito';
   imputazione_non_modificabile exception;
   pragma exception_init(imputazione_non_modificabile, -20933);
   s_imputazione_non_mod_number constant afc_error.t_error_number := -20933;
   s_imputazione_non_mod_msg    constant afc_error.t_error_msg := 'Errore in aggiornamento dell''imputazione contabile';
   s_err_get_inc_ndf exception;
   pragma exception_init(s_err_get_inc_ndf, -20934); --#31549
   s_err_get_inc_ndf_number constant afc_error.t_error_number := -20934;
   s_err_get_inc_ndf_msg    constant afc_error.t_error_msg := 'Errore nella determinazione dell''incarico del componente. Non esiste il periodo indicato.';
   ------------------------------------------------------------------------------
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   ------------------------------------------------------------------------------
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   ------------------------------------------------------------------------------
   -- Ritorna il livello di ordinamento dell'unita' data
   function get_livello_uo(p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return suddivisioni_struttura.ordinamento%type;
   ------------------------------------------------------------------------------
   -- Ritorna il progressivo dell'unita' data
   function get_progr_uo
   (
      p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   ------------------------------------------------------------------------------
   -- Ritorna l'unita' organizzativa superiore all'unita' data, avente l'ordinamento
   -- della suddivisione uguale a quello indicato
   function get_livello_gerarchia
   (
      p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_livello    in number
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   ------------------------------------------------------------------------------
   -- Ritorna la struttura dell'amministrazione richiesta alla data
   -- specificata.
   function get_struttura
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_data            in date
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Ritorna un cursore con elenco delle UO dell'amministrazione rettificate su Anagrafe
   -- dopo l'utima revisione o storicizzate extra revisione
   function get_uo_modificate
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Funzione per cartellino interattivo. Ritorna SI/NO se esiste il componente
   -- nella UO con progressivo p_progr_unita_org, con ruolo p_ruolo alla data
   -- indicata.
   function exists_ruolo_comp
   (
      p_ci              in componenti.ci%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           in ad4_ruoli.ruolo%type
     ,p_data            in date
   ) return varchar2;
   ------------------------------------------------------------------------------
   -- Ritorna il progressivo dell'unita' organizzativa di assegnazione su SO4
   -- dati l'identificativo del dipendente e il periodo ( p_dal = componenti.dal)
   function get_assegnazione_struttura
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
   ) return number;
   ------------------------------------------------------------------------------
   -- Ritorna l'incarico su SO4 del dipendente alla data indicata #31549
   function get_incarico
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in componenti.ni%type -- NI di GPS.rapporti_individuali
     ,p_ci              in componenti.ci%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_data            in date default trunc(sysdate)
   ) return varchar2;
   ------------------------------------------------------------------------------
   function get_rilevanza_assegnazione
   (
      p_id_componente componenti.id_componente%type
     ,p_dal           componenti.dal%type
   ) return varchar2;
   ------------------------------------------------------------------------------
   -- Ritorna il progressivo dell'unita' organizzativa di assegnazione su SO4
   -- dati l'identificativo del dipendente e il periodo
   -- ( p_dal between componenti.dal and componenti.al)
   function get_assegnazione_between
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
   ) return number;
   ------------------------------------------------------------------------------
   -- Ritorna 1 se l'individuo è in struttura alla data indicata, 0 altrimenti
   function is_assegnato
   (
      p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_amministrazione in amministrazioni.codice_amministrazione%type default null
   ) return number;
   ------------------------------------------------------------------------------
   -- Funzione per cartellino interattivo. Ritorna un cursore contenente
   -- l'elenco dei record con tutte le unità discendenti dell'unità data.
   function get_unita_discendenti
   (
      p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            in date
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Funzione per cartellino interattivo. Ritorna l'elenco delle unità
   -- organizzative subordinate all'unità data, in ordine gerarchico con
   -- i componenti che ne fanno parte
   function get_unita_componenti
   (
      p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            in date
     ,p_tipo_ricerca    in number default 1
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Funzione per determinare l'AL sulla vista UNITA_ORGANIZZATIVE di GPS
   function get_al_unor
   (
      p_ottica        revisioni_struttura.ottica%type
     ,p_revisione     revisioni_struttura.revisione%type
     ,p_dal           revisioni_struttura.dal%type
     ,p_al            date
     ,p_revisione_rif revisioni_struttura.revisione%type
   ) return date;
   ------------------------------------------------------------------------------
   function get_assegnazione_fisica --#681
   (
      p_ci   componenti.ci%type
     ,p_data componenti.dal%type default null
     ,p_tipo number default 1
   ) return varchar2;
   ------------------------------------------------------------------------------
   -- Effettua una nuova assegnazione inserendo un nuovo componente.
   procedure ins_assegnazione
   (
      p_amministrazione         in amministrazioni.codice_amministrazione%type
     ,p_ni                      in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci                      in componenti.ci%type
     ,p_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_imputaz_contab          in imputazioni_bilancio.numero%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_incarico                in tipi_incarico.incarico%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg              in componenti.utente_aggiornamento%type
     ,p_data_agg                in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   -- Crea una nuova assegnazione (F/88)
   procedure ins_assegnazione_funzionale --#60318
   (
      p_amministrazione         in amministrazioni.codice_amministrazione%type
     ,p_ni                      in p00_dipendenti_soggetti.ni_gp4%type
     ,p_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_incarico                in tipi_incarico.incarico%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg              in componenti.utente_aggiornamento%type
     ,p_data_agg                in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   procedure tratta_assegnazioni_funzionali
   (
      p_ottica          in componenti.ottica%type
     ,p_ni              in componenti.ni%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal             in componenti.dal%type
     ,p_al              in componenti.al%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_data_agg        in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   -- Modifica un'assegnazione esistente spostando il componente
   procedure sposta_assegnazione
   (
      p_amministrazione         in amministrazioni.codice_amministrazione%type
     ,p_ni                      in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci                      in componenti.ci%type
     ,p_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_imputaz_contab          in imputazioni_bilancio.numero%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_incarico                in tipi_incarico.incarico%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg              in componenti.utente_aggiornamento%type
     ,p_data_agg                in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   -- Chiude un'assegnazione ed elimina il componente
   procedure chiudi_assegnazione
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_data_cessazione in componenti.al%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_data_agg        in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   -- Restituisce l'unità organizzativa di assegnazione prevalente del componente
   -- identificato dal ci
   function comp_get_unita
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
   ) return componenti.progr_unita_organizzativa%type;
   ------------------------------------------------------------------------------
   -- Restituisce l'imputazione contabile del componente identificato dal ci
   function comp_get_imputazione
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
   ) return imputazioni_bilancio.numero%type;
   ------------------------------------------------------------------------------
   -- Restituisce l'unità organizzativa di assegnazione prevalente del componente
   -- identificato dal ci.
   function comp_get_dati_unita
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Ritorna un ref_cursor contenente i campi livello, descrizione, icona
   -- della UO con progressivo specificato.
   function get_unita_organizzativa_puo
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            in date
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Ritorna un ref_cursor contenente i campi livello, descrizione, icona
   -- della UO con descrizione specificata.
   function get_unita_organizzativa_desc
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_descrizione     in varchar2
     ,p_data            in date
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   -- Metodo che ritorna 1 se il periodo è eliminabile #748
   function is_periodo_eliminabile
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal             in componenti.dal%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_dal_rapporto    in date default null
     ,p_al_rapporto     in date default null
   ) return number;
   ------------------------------------------------------------------------------
   -- Cancella un'assegnazione controllando prima che sia la più recente in ordine
   -- di tempo
   procedure del_assegnazione
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal             in componenti.dal%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_dal_rapporto    in date default null
     ,p_al_rapporto     in date default null
   );
   ------------------------------------------------------------------------------
   -- Aggiorna il progressivo dell'unità organizzativa
   procedure rettifica_assegnazione
   (
      p_amministrazione            in amministrazioni.codice_amministrazione%type
     ,p_amministrazione_precedente in amministrazioni.codice_amministrazione%type
     ,p_ni                         in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci                         in componenti.ci%type
     ,p_progr_unita_org            in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_imputaz_contab             in imputazioni_bilancio.numero%type
     ,p_dal                        in componenti.dal%type
     ,p_al                         in componenti.al%type
     ,p_ass_prevalente             in attributi_componente.assegnazione_prevalente%type
     ,p_dal_precedente             in componenti.dal%type
     ,p_utente_agg                 in componenti.utente_aggiornamento%type
     ,p_data_agg                   in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   -- Restituisce gli estremi della prima assegnazione del componente nel periodo dato
   procedure prima_assegnazione
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_dal_assegnazione        in out componenti.dal%type
     ,p_al_assegnazione         in out componenti.al%type
     ,p_ni                      in componenti.ni%type default null
     ,p_amministrazione         in amministrazioni.codice_amministrazione%type default null
   );
   ------------------------------------------------------------------------------
   -- Restituisce gli estremi dell'ultima assegnazione del componente nel periodo dato
   procedure ultima_assegnazione
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_dal_assegnazione        in out componenti.dal%type
     ,p_al_assegnazione         in out componenti.al%type
     ,p_ni                      in componenti.ni%type default null
     ,p_amministrazione         in amministrazioni.codice_amministrazione%type default null
   );
   -----------------------------------------------------------------------------
   -- Aggiorna l'incarico del componente
   procedure rettifica_incarico
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_al              in componenti.al%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_incarico        in tipi_incarico.incarico%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_data_agg        in componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   -- Restituisce l'ultima revisione per le amministrazioni integrate
   function get_ultima_revisione(p_amministrazione in amministrazioni.codice_amministrazione%type)
      return revisioni_struttura.revisione%type;
   ------------------------------------------------------------------------------
   function get_assegnazioni_revisioni
   (
      p_da_revisione revisioni_struttura.revisione%type
     ,p_a_revisione  revisioni_struttura.revisione%type
   ) return t_ref_cursor;
   ------------------------------------------------------------------------------
   function get_assegnazioni_periodo
   (
      p_ci  in componenti.ci%type
     ,p_dal in componenti.dal%type
     ,p_al  in componenti.al%type
   ) return t_ref_cursor;
   ------------------------------------------------------------------------------
   function revisione_get_dal
   (
      p_revisione       revisioni_struttura.revisione%type
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return date;
   ------------------------------------------------------------------------------
   function get_assegnazioni_imputazioni
   (
      p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_al              in componenti.al%type
     ,p_assegnazione    in attributi_componente.assegnazione_prevalente%type
     ,p_ni              in componenti.ni%type default null
     ,p_amministrazione in amministrazioni.codice_amministrazione%type default null
   ) return t_ref_cursor;
   ------------------------------------------------------------------------------
   function check_esiste_attributo
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return boolean;
   ------------------------------------------------------------------------------
   function check_esiste_assegnazione --#60318
   (
      p_amministrazione         in amministrazioni.codice_amministrazione%type
     ,p_ni                      in p00_dipendenti_soggetti.ni_gp4%type
     ,p_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                    in date
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
   ) return number;
   ------------------------------------------------------------------------------
   procedure valorizza_variabili(p_ottica in componenti.ottica%type);
   ------------------------------------------------------------------------------
   procedure copia_ruoli
   (
      p_dal            in date
     ,p_al             in date
     ,p_ni             in componenti.ni%type
     ,p_ci             in componenti.ci%type
     ,p_ottica         in componenti.ottica%type
     ,p_ass_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_progr_uo       in componenti.progr_unita_organizzativa%type default null --#37425
   );
   ------------------------------------------------------------------------------
   procedure ripristina_ruoli
   (
      p_ni                        componenti.ni%type
     ,p_ci                        componenti.ci%type
     ,p_ottica                    componenti.ottica%type
     ,p_dal                       date
     ,p_al                        date
     ,p_dal_comp                  componenti.dal%type --#588
     ,p_al_comp                   componenti.al%type
     ,p_progr_unita_organizzativa componenti.progr_unita_organizzativa%type
     ,p_id_componente             componenti.id_componente%type
     ,p_utente_aggiornamento      componenti.utente_aggiornamento%type
     ,p_data_aggiornamento        componenti.data_aggiornamento%type
   );
   ------------------------------------------------------------------------------
   function is_componente_modificabile
   (
      p_ci     in componenti.ci%type
     ,p_ottica in componenti.ottica%type
     ,p_dal    in date
     ,p_al     in date
   ) return varchar2;
   ------------------------------------------------------------------------------
   function get_settore_giuridico_comp(p_id_componente componenti.id_componente%type)
      return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   ------------------------------------------------------------------------------
   -- #31549 function is_dipendente_componente(p_ci in componenti.ci%type) return varchar2; --eliminata con #31549
   ------------------------------------------------------------------------------
   function get_componenti_uo --#787
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica    ottiche.ottica%type default null
     ,p_data      componenti.dal%type default null
   ) return afc.t_ref_cursor;
   ------------------------------------------------------------------------------
   procedure rettifica_imputazione
   (
      p_ci                        componenti.ci%type
     ,p_dal                       componenti.dal%type
     ,p_al                        componenti.dal%type
     ,p_rilevanza                 in varchar2
     ,p_progr_unita_organizzativa componenti.progr_unita_organizzativa%type
     ,p_imputazione               imputazioni_bilancio.numero%type
     ,p_utente_agg                componenti.utente_aggiornamento%type
     ,p_ottica                    componenti.ottica%type default null --#639
     ,p_storicizza                in number default null
     ,p_ni                        in componenti.ni%type default null
     ,p_amministrazione           in amministrazioni.codice_amministrazione%type default null
   );

   procedure set_inmo --#737
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in ubicazioni_componente.dal%type
   );

end gps_util;
/


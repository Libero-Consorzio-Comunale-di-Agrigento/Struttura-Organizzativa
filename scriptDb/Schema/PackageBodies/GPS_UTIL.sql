CREATE OR REPLACE package body gps_util is

   /******************************************************************************
   NOME:          GPS_UTIL
   DESCRIZIONE:   Contiene funzioni utilizzate per l'integrazione con GPS
   ANNOTAZIONI:   I metodi richiamati direttamente da GPS sono:

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

   REVISIONI:.
   Rev.                  Data        Autore           Descrizione.
   000                   25/02/2010  APASSUELLO       Prima emissione.
   001                   01/03/2011  MMONARI          Mod. per GPS
                         14/03/2011  MMONARI          Mod. per GPS
                         15/03/2011  MMONARI          Mod. per GPS
                         18/03/2011  MSARTI           Mod. function versione per ora-err
                         18/03/2011  MMONARI          Mod. per GPS + Mod. per mutanza trigger
                         22/03/2011  MMONARI          Mod. per GPS - Versione 1.2 del GPS
   002                   29/03/2011  MMONARI          Mod. per GPS rif. attività A42321.0.5
                                                      (prima_assegnazione, ultima_assegnazione)
   003                   15/04/2011  MMONARI          Mod. per GPS per A42634 (get_assegnazioni_periodo)
                                                      Mod. per GPS per A42199 (get_assegnazioni_between)
                         19/04/2011  MMONARI          Mod. per GPS per A42321.0.7
   004                   31/05/2011  MMONARI          Mod. ins_assegnazione (caso: periodo chiuso inserito su singolo
                                                      periodo aperto con dal coincidente) - A44255
   005                   06/12/2011  MMONARI          Correzione controllo stato D su INS_ASSEGNAZIONI
   006                   05/12/2011  ADADAMO          Aggiunta funzione per cursore delle assegnazion
                                                      considerando la storicità delle eventuali imputazioni contabili
   007                   07/02/2012  MMONARI          Mod. per permettere assestamenti a componenti definitivi
   008                   21/03/2012  ADADAMO          Modifiche per gestire l'inserimento automatico
                                                      dell'attributo del componente
   009                   21/05/2012  MSARTI           Mod. ordine di update su ins_assegnazione (A49006)
   010                   29/04/2013  ADADAMO          Nuova funzione get_al_unor
                                                      Modifica funzione get_ultima_revisione
   012                   07/05/2013  MMONARI          Redmine #191 - Ereditarieta' ruoli e variazioni retroattive
   013                   10/01/2014  MSARTI           Migliorate le segnalazioni di errore
   014                   20/02/2014  ADADAMO/MMONARI  Correzione gestione cancellazione logica
                         27/02/2014  ADADAMO/MMONARI  Correzione gestione tipo_assegnazione Bug#355 SO4
                                                      Bug #4247 GPS
                         11/03/2014  ADADAMO          Modificato cursore assegnazioni_periodo per
                                                      gestire il caso in cui non è stato gestito il se_giuridico
                         12/03/2014  ADADAMO          Modificata gestione cancellazione nel caso di periodi
                                                      non contigui, ad esempio, individui con più rapporti
                                                      di lavoro successivi non continui sullo stesso CI
                         13/03/2014  ADADAMO          Predisposta del_assegnazione per ricevere in
                                                      input le date del rapporto di lavoro necessarie per
                                                      decidere quali periodi utilizzare a copertura del
                                                      periodo eliminato
   015                   22/04/2014  ADADAMO          Introdotte nuove funzionalita' per gestione acquisizione
                                                      e rimossi riferimenti al package so4gp4 (Bug#4950 lato GPS e Bug#418)
   016                   05/05/2014  MMONARI          Ereditarieta' ruoli issue#191
   017                   06/10/2014  ADADAMO          Aggiunta is_dipendente_componente per non gestire
                                                      gli individui con componente=NO nella classe di
                                                      rapporto F7163 (GPS)
                         10/10/2014  MMONARI          Modifiche a Rettifica_assegnazione #537
                         10/10/2014  MMONARI          Modifiche a Rettifica_assegnazione #536
                         19/11/2014  MMONARI          Modifiche alla gestione delle date di pubblicazione
                                                      su COMP, ATCO, RUCO, IMBI, UBCO a fronte di modifiche di GPS #548
   018                   29/04/2015  MMONARI          #594 : Rettifica_imputazione
                         18/05/2015  MMONARI          #588 : modifiche ad ins_assegnazione
                                                             e rettifica_assegnazione ; Angelo del_assegnazione
   019                   28/12/2016  MSARTI           Con Angelo: definita is_periodo_eliminabile (Issue 19851)
   020                   19/10/2015  MMONARI          #639 : Rettifica imputazione e ins_assegnazione
                         05/11/2015  MMONARI          #658 : Rettifica_assegnazione
                         18/11/2015  MMONARI          #663 : ins_assegnazione per sovrapposizioni
                         12/01/2016  MMONARI          #673 : verifica parametri dal_pubblicazione e al_pubblicazione
                         26/01/2016  MMONARI          #678 : modifiche a ins_assegnazione
                         04/02/2016  MMONARI          #681 : nuova funzione get_assegnazione_fisica
                         28/04/2016  MMONARI          #714 : modifiche a rettifica_assegnazione
                         05/05/2016  MMONARI          #716 : modifiche a rettifica_incarico
                         28/05/2016  MMONARI          #733 : modifiche a ultima_assegnazione
                         09/08/2016  MMONARI          #737 : nuova procedure set_inmo
   021                   08/08/2017  MMONARI          #777 : Rettifica assegnazione a parita' di date: eredita ruoli
                         30/08/2017  MMONARI          #787 : Nuova funzione get_componenti_uo per GPSDO
                         24/10/2017  MMONARI          #760 #764
   022                   21/10/2018  MMONARI          #31549 : eliminata la is_dipendente_componente
                                                               completati i parametri di get_assegnazioni_imputazioni,
                                                               prima_assegnazione,ultima_assegnazione,rettifica_imputazione
                                                               Nuova funzione GET_INCARICO
                         15/03/2019  MMONARI          #33820 : nuova funzione get_progr_uo
                         30/09/2019  MMONARI          #32719 : Correzione di rettifica_imputazioni
                         10/10/2019  MMONARI          #37425 : modifiche all'ereditarieta' dei ruoli delle assegnazioni funzionali
                         17/03/2021  MMONARI          #49029 : nuova funzione get_uo_modificate
                         17/03/2021  MMONARI          #48986 : corretto assestamento periodi adiacenti in rettifica_assegnazione
    023                  10/11/2022  MMONARI          #60318 : nuova proc. ins_assegnazione_funzionale
   *********************************************************************************************************************/
   s_revisione_body         varchar2(30) := '023 - 10/11/2022';
   s_error_table            afc_error.t_error_table;
   s_error_detail           afc_error.t_error_table;
   s_dummy                  varchar2(1);
   s_eredita_ruoli_sudd     registro.valore%type;
   s_oggi                   date := trunc(sysdate);
   s_revisione_mod          revisioni_struttura.revisione%type;
   s_segnalazione_bloccante varchar2(1);
   s_segnalazione           varchar2(2000);

   -- parametri di configurazione definiti sui registri
   s_eredita_ruoli  registro.valore%type := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                              ,'EreditaRuoli'
                                                                              ,0)
                                               ,'NO');
   s_ruoli_skema    registro.valore%type := nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                                                              ,'AcquisizioneRuoliDaGP4'
                                                                              ,0)
                                               ,'NO');
   s_progetti_ruoli registro.valore%type := nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                                                              ,'ProgettiRuoliDaGP4'
                                                                              ,0)
                                               ,'');
   s_moduli_ruoli   registro.valore%type := nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                                                              ,'ModuliRuoliDaGP4'
                                                                              ,0)
                                               ,'');
   --------------------------------------------------------------------------------
   function versione return varchar2 is /* SLAVE_COPY */
      /******************************************************************************
            NOME:  versione
            DESCRIZIONE: Versione e revisione di distribuzione del package.
            RITORNA:  varchar2 stringa contenente versione e revisione.
            NOTE:  Primo numero  : versione compatibilità del Package.
             Secondo numero: revisione del Package specification.
             Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end; -- gps_util.versione
   ------------------------------------------------------------------------------
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      /******************************************************************************
             NOME:  error_message
             DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
             NOTE:  Restituisce il messaggio abbinato al numero indicato nella tabella
              s_error_table del Package. Se p_error_number non e presente nella
              tabella s_error_table viene lanciata l'exception -20011 (vedi AFC_Error)
      ******************************************************************************/
      d_result afc_error.t_error_msg;
      d_detail afc_error.t_error_msg;
   begin
      if s_error_detail.exists(p_error_number) then
         d_detail := s_error_detail(p_error_number);
      end if;
      if s_error_table.exists(p_error_number) then
         d_result := s_error_table(p_error_number) || d_detail;
         s_error_detail(p_error_number) := '';
      else
         raise_application_error(afc_error.exception_not_in_table_number
                                ,afc_error.exception_not_in_table_msg);
      end if;
      return d_result;
   end error_message; -- assegnazioni_struttura_pkg.error_message
   --------------------------------------------------------------------------------
   function check_esiste_attributo
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return boolean is
      dummy varchar2(1);
   begin
      begin
         select 'x'
           into dummy
           from attributi_componente
          where id_componente = p_id_componente
            and dal = p_dal;
         return true;
      exception
         when no_data_found then
            return false;
      end;
   end;
   --------------------------------------------------------------------------------
   function check_esiste_assegnazione --#60318
   (
      p_amministrazione         in amministrazioni.codice_amministrazione%type
     ,p_ni                      in p00_dipendenti_soggetti.ni_gp4%type
     ,p_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                    in date
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type  default null
   ) return number is
      dummy                varchar2(1);
      d_ottica_ist         ottiche.ottica%type;
      d_ni_as4             as4_anagrafe_soggetti.ni%type;
      d_id_componente      componenti.id_componente%type;
      d_id_attr_componente attributi_componente.id_attr_componente%type;
   begin
      d_ottica_ist := ottica.get_ottica_per_amm(p_amministrazione);
      d_ni_as4     := so4gp_pkg.get_id_soggetto_as4(p_ni);
      valorizza_variabili(d_ottica_ist);
      begin
         select 'x'
           into dummy
           from vista_componenti c
          where ni = d_ni_as4
            and progr_unita_organizzativa = p_progr_unita_org
            and tipo_assegnazione = p_tipo_assegnazione
            and assegnazione_prevalente =
                nvl(p_assegnazione_prevalente, assegnazione_prevalente)
            and p_data between dal and nvl(al, to_date(3333333, 'j'));
         return 1;
      exception
         when no_data_found then
            return 0;
      end;
   end;
   ------------------------------------------------------------------------------
   function get_rilevanza_assegnazione
   (
      p_id_componente componenti.id_componente%type
     ,p_dal           componenti.dal%type
   ) return varchar2 is
      d_result varchar2(1);
   begin
      if substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(p_id_componente
                                                                                                            ,p_dal))
               ,1
               ,1) = '1' then
         -- inquadramento
         d_result := 'Q';
      elsif substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(p_id_componente
                                                                                                               ,p_dal))
                  ,1
                  ,1) = '9' then
         -- incarico
         d_result := 'I';
      else
         d_result := '';
      end if;
      return d_result;
   end;
   ------------------------------------------------------------------------------
   function get_assegnazione_struttura
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
   ) return number is
      d_ottica_ist  ottiche.ottica%type;
      d_progressivo unita_organizzative.progr_unita_organizzativa%type;
      /******************************************************************************
            NOME:  get_assegnazione_struttura
            DESCRIZIONE: Ritorna il progressivo unità organizzativa della UO di assegnazione
            RITORNA:  Number contenente il progressivo unità organizzativa della UO di assegnazione
      ******************************************************************************/
   begin
      begin
         d_ottica_ist := ottica.get_ottica_per_amm(p_amministrazione);
         select c.progr_unita_organizzativa
           into d_progressivo
           from componenti c
          where c.ottica = d_ottica_ist
            and c.ci = p_ci
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and substr(p_ass_prevalente, 1, 1) =
                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                   ,c.dal))
                      ,1
                      ,1)
            and c.dal = p_dal;
      exception
         when no_data_found then
            raise_application_error(s_err_get_ass_ndf_number, s_err_get_ass_ndf_msg);
      end;
      return d_progressivo;
   end;
   ------------------------------------------------------------------------------
   function get_incarico
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in componenti.ni%type -- NI di GPS.rapporti_individuali
     ,p_ci              in componenti.ci%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_data            in date default trunc(sysdate)
   ) return varchar2 is
      d_ottica_ist ottiche.ottica%type;
      d_incarico   attributi_componente.incarico%type;
      d_ni         componenti.ni%type;
      /******************************************************************************
            NOME:  get_incarico
            DESCRIZIONE: Ritorna l'incarico dell'assegnazione istituzionale su SO4
                         del dipendente dato alla data indicata
            ISSUE: #31549
      ******************************************************************************/
   begin
      begin
         d_ottica_ist := ottica.get_ottica_per_amm(p_amministrazione);
         d_ni         := so4gp_pkg.get_id_soggetto_as4(p_ni);

         select c.incarico
           into d_incarico
           from vista_componenti c
          where c.ottica = d_ottica_ist
            and c.ni = d_ni
            and c.ci = p_ci
            and nvl(p_data, s_oggi) between c.dal and nvl(c.al, to_date(3333333, 'j'))
            and c.tipo_assegnazione = 'I'
            and substr(p_ass_prevalente, 1, 1) = substr(c.assegnazione_prevalente, 1, 1);
      exception
         when no_data_found then
            raise_application_error(s_err_get_inc_ndf_number, s_err_get_inc_ndf_msg);
         when others then
            d_incarico := 'non.det.';
      end;
      return d_incarico;
   end;
   ------------------------------------------------------------------------------
   function get_assegnazione_between
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
   ) return number is
      d_ottica_ist  ottiche.ottica%type;
      d_progressivo unita_organizzative.progr_unita_organizzativa%type;
      /******************************************************************************
            NOME:  get_assegnazione_between
            DESCRIZIONE: Ritorna il progressivo unità organizzativa della UO di assegnazione
             ( p_dal between componenti.dal and componenti.al )
            RITORNA:  Number contenente il progressivo unità organizzativa della UO di assegnazione
      ******************************************************************************/
   begin
      begin
         d_ottica_ist := ottica.get_ottica_per_amm(p_amministrazione);
         select c.progr_unita_organizzativa
           into d_progressivo
           from componenti c
          where c.ottica = d_ottica_ist
            and c.ci = p_ci
            and substr(p_ass_prevalente, 1, 1) =
                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                   ,c.dal))
                      ,1
                      ,1)
            and p_dal between c.dal and nvl(c.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            raise_application_error(s_err_get_ass_ndf_number, s_err_get_ass_ndf_msg);
      end;
      return d_progressivo;
   end;
   ------------------------------------------------------------------------------
   function is_assegnato
   (
      p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_amministrazione in amministrazioni.codice_amministrazione%type default null
   ) return number is
      d_ottica_ist ottiche.ottica%type;
      d_assegnato  number(1) := 0;
      /******************************************************************************
            NOME:  is_assegnato
            DESCRIZIONE: Ritorna 1 se l'individuo è in struttura alla data indicata, 0 altrimenti
      ******************************************************************************/
   begin
      begin
         d_ottica_ist := ottica.get_ottica_per_amm(p_amministrazione);
         select 1
           into d_assegnato
           from componenti c
          where c.ottica = nvl(d_ottica_ist, c.ottica)
            and c.ci = p_ci
            and p_ass_prevalente =
                attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                            ,c.dal))
            and p_data between dal and nvl(c.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            return d_assegnato;
      end;
      return d_assegnato;
   end;
   ------------------------------------------------------------------------------
   -- Ritorna il livello di ordinamento dell'unita' data
   function get_livello_uo(p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return suddivisioni_struttura.ordinamento%type is
      d_result suddivisioni_struttura.ordinamento%type;
   begin
      begin
         select ordinamento
           into d_result
           from anagrafe_unita_organizzative a
               ,suddivisioni_struttura       s
          where a.progr_unita_organizzativa = p_progr_unor
            and a.dal = (select max(dal)
                           from anagrafe_unita_organizzative
                          where progr_unita_organizzativa = p_progr_unor)
            and a.id_suddivisione = s.id_suddivisione;
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
      end;
      --
      if d_result > 4 then
         d_result := 4;
      end if;
      --
      return d_result;
      --
   end;
   ------------------------------------------------------------------------------
   -- Ritorna il progressivo dell'unita' data
   function get_progr_uo
   (
      p_amministrazione anagrafe_unita_organizzative.amministrazione%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        get_progr_uo.
       DESCRIZIONE: Dato un codice U.O., restituisce il progressivo relativo
                    all'amministrazione indicata valido alla data effettiva
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
       PARAMETRI:   p_amministrazione    amministrazione da trattare
                    p_codice_uo          codice dell'unita' organizzativa
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)

       RITORNA:     progressivo dell'unita' organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     15/03/2019  MM        Prima emissione. #33820
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_data   date := nvl(p_data, s_oggi);
   begin
      begin
         select progr_unita_organizzativa
           into d_result
           from anagrafe_unita_organizzative
          where amministrazione = p_amministrazione
            and codice_uo = p_codice_uo
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := to_number(null);
      end;
      return d_result;
   end;
   ------------------------------------------------------------------------------
   -- Ritorna l'unita' organizzativa superiore all'unita' data, avente l'ordinamento
   -- della suddivisione uguale a quello indicato
   function get_livello_gerarchia
   (
      p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_livello    in number
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      d_ottica          ottiche.ottica%type;
      d_data            date;
      d_ref_cursor      afc.t_ref_cursor;
      d_progr_unor      unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo       anagrafe_unita_organizzative.codice_uo%type;
      d_descr_uo        anagrafe_unita_organizzative.descrizione%type;
      d_dal             anagrafe_unita_organizzative.dal%type;
      d_al              anagrafe_unita_organizzative.al%type;
      d_id_suddivisione anagrafe_unita_organizzative.id_suddivisione%type;
      d_ordinamento     suddivisioni_struttura.ordinamento%type;
      d_result          anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica := anagrafe_unita_organizzativa.get_ottica(p_progr_unor, trunc(sysdate));
      select max(dal)
        into d_data
        from unita_organizzative
       where progr_unita_organizzativa = p_progr_unor
         and ottica = d_ottica;
      if d_data is not null then
         d_ref_cursor := so4_util.get_ascendenti_sudd(p_progr_unor, d_data, d_ottica);
         if d_ref_cursor%isopen then
            fetch d_ref_cursor
               into d_progr_unor
                   ,d_codice_uo
                   ,d_descr_uo
                   ,d_dal
                   ,d_al
                   ,d_id_suddivisione;
            while d_ref_cursor%found
            loop
               --
               -- da sostituire con function quando sarà fatta sul package suddivisione_struttura
               --
               begin
                  select ordinamento
                    into d_ordinamento
                    from suddivisioni_struttura
                   where id_suddivisione = d_id_suddivisione;
               exception
                  when no_data_found then
                     d_ordinamento := to_number(null);
                  when too_many_rows then
                     d_ordinamento := to_number(null);
               end;
               if d_ordinamento > 4 then
                  d_ordinamento := 4;
               end if;
               if d_ordinamento = p_livello then
                  d_result := d_progr_unor;
               end if;
               fetch d_ref_cursor
                  into d_progr_unor
                      ,d_codice_uo
                      ,d_descr_uo
                      ,d_dal
                      ,d_al
                      ,d_id_suddivisione;
            end loop;
         end if;
      end if;
      --
      return d_result;
      --
   end;
   --------------------------------------------------------------------------------
   function get_struttura
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_data            in date
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  get_struttura
            DESCRIZIONE: Ritorna la struttura dell'amministrazione richiesta alla data
             specificata.
            RITORNA:  Un cursore con la struttura dell'amministrazione. I campi
             restituiti sono livello, descrizione, icona (e ordinamento).
            NOTE:
      ******************************************************************************/
      d_ottica_ist    ottiche.ottica%type;
      d_revisione_mod revisioni_struttura.revisione%type;
      d_result        afc.t_ref_cursor;
   begin
      d_ottica_ist    := ottica.get_ottica_per_amm(p_amministrazione);
      d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      begin
         open d_result for
            select so4_util.get_livello(u.progr_unita_organizzativa, p_data, u.ottica) as livello
                  ,u.progr_unita_organizzativa
                  ,suddivisione_struttura.get_des_abb(anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                                                      ,p_data)) || ':' ||
                   anagrafe_unita_organizzativa.get_codice_uo(u.progr_unita_organizzativa
                                                             ,p_data) || '-' ||
                   anagrafe_unita_organizzativa.get_descrizione(u.progr_unita_organizzativa
                                                               ,p_data) as descrizione
                  ,suddivisione_struttura.get_icona_standard(anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                                                             ,p_data)) as icona
                  ,so4_util.get_ordinamento(u.progr_unita_organizzativa
                                           ,p_data
                                           ,d_ottica_ist
                                           ,p_amministrazione) as ordinamento
              from unita_organizzative u
             where u.ottica = d_ottica_ist
               and u.revisione != d_revisione_mod
               and p_data between u.dal and nvl(decode(u.revisione_cessazione
                                                      ,d_revisione_mod
                                                      ,to_date(null)
                                                      ,u.al)
                                               ,p_data)
             order by ordinamento;
      exception
         when others then
            raise_application_error(s_err_get_strutt_number, s_err_get_strutt_msg);
      end;
      return d_result;
   end; -- gps_util.get_struttura
   --#49029--------------------------------------------------------------------
   function get_uo_modificate
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  get_uo_modificate
            DESCRIZIONE: Ritorna un cursore con elenco delle UO dell'amministrazione rettificate su Anagrafe
                         dopo l'utima revisione o storicizzate extra revisione
      ******************************************************************************/
      d_ottica_ist    ottiche.ottica%type;
      d_revisione_mod revisioni_struttura.revisione%type;
      d_result        afc.t_ref_cursor;
   begin
      d_ottica_ist    := ottica.get_ottica_per_amm(p_amministrazione);
      d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      begin
         open d_result for
         --storicizzazioni
            select a.progr_unita_organizzativa
                  ,a.dal
                  ,a.codice_uo
                  ,a.descrizione
                  ,a.des_abb
                  ,suddivisione_struttura.get_suddivisione(a.id_suddivisione) suddivisione
                  ,a.se_giuridico
                  ,a.incarico_resp
                  ,a.assegnazione_componenti
                  ,a.al
                  ,a.utente_aggiornamento
                  ,a.data_aggiornamento
                  ,'S' operazione
              from anagrafe_unita_organizzative a
             where a.ottica = d_ottica_ist
               and a.revisione_istituzione != d_revisione_mod
               and dal <= nvl(al, to_date(3333333, 'j'))
               and exists
             (select 1
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = a.progr_unita_organizzativa
                       and revisione_istituzione = a.revisione_istituzione
                       and ottica = a.ottica
                       and al = a.dal - 1)
            union
            --rettifiche post ultima revisione
            select a.progr_unita_organizzativa
                  ,a.dal
                  ,a.codice_uo
                  ,a.descrizione
                  ,a.des_abb
                  ,suddivisione_struttura.get_suddivisione(a.id_suddivisione) suddivisione
                  ,a.se_giuridico
                  ,a.incarico_resp
                  ,a.assegnazione_componenti
                  ,a.al
                  ,a.utente_aggiornamento
                  ,a.data_aggiornamento
                  ,'R' operazione
              from anagrafe_unita_organizzative a
             where a.ottica = d_ottica_ist
               and a.revisione_istituzione != d_revisione_mod
               and dal <= nvl(al, to_date(3333333, 'j'))
               and data_aggiornamento >
                   (select data_aggiornamento
                      from revisioni_struttura r
                     where ottica = a.ottica
                       and stato = 'A'
                       and revisione = (select max(revisione)
                                          from revisioni_struttura
                                         where ottica = a.ottica
                                           and stato = 'A'))
               and not exists
             (select 1
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = a.progr_unita_organizzativa
                       and revisione_istituzione = a.revisione_istituzione
                       and ottica = a.ottica
                       and dal = a.al + 1)
               and not exists
             (select 1
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = a.progr_unita_organizzativa
                       and revisione_istituzione = a.revisione_istituzione
                       and ottica = a.ottica
                       and al = a.dal - 1)
             order by 1
                     ,2;
      end;
      return(d_result);
   end; -- gps_util.get_uo_modificate
   --------------------------------------------------------------------------------
   function exists_ruolo_comp
   (
      p_ci              in componenti.ci%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           in ad4_ruoli.ruolo%type
     ,p_data            in date
   ) return varchar2 is
      /******************************************************************************
            NOME:  exists_ruolo_comp
            DESCRIZIONE: Ritorna SI/NO a seconda che esista o meno il componente con CI dato,
             nella UO con progressivo p_progr_unita_org, con ruolo p_ruolo alla
             data indicata.
            RITORNA:  SI/NO.
            NOTE:
      ******************************************************************************/
      d_id_comp componenti.id_componente%type default null;
      d_result  varchar2(2) default 'NO';
   begin
      begin
         select c.id_componente as id_componente
           into d_id_comp
           from componenti           c
               ,attributi_componente a
               ,ruoli_componente     r
          where c.id_componente = a.id_componente
            and c.id_componente = r.id_componente
            and c.ci = p_ci
            and c.progr_unita_organizzativa = p_progr_unita_org
            and a.assegnazione_prevalente like '1%'
            and a.tipo_assegnazione = 'I'
            and r.ruolo = p_ruolo
            and p_data between c.dal and nvl(decode(c.revisione_cessazione
                                                   ,revisione_struttura.get_revisione_mod(c.ottica)
                                                   ,to_date(null)
                                                   ,c.al)
                                            ,p_data)
            and p_data between a.dal and nvl(decode(a.revisione_cessazione
                                                   ,revisione_struttura.get_revisione_mod(c.ottica)
                                                   ,to_date(null)
                                                   ,a.al)
                                            ,p_data)
            and p_data between r.dal and nvl(r.al, p_data);
      exception
         when no_data_found then
            d_result := 'NO';
      end;
      if d_id_comp is null then
         d_result := 'NO';
      else
         d_result := 'SI';
      end if;
      return d_result;
   end; -- gps_util.exists_ruolo_comp
   --------------------------------------------------------------------------------
   function get_unita_discendenti
   (
      p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            in date
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  get_unita_discendenti
            DESCRIZIONE: Restituisce l'elenco dei record con le unità discendenti
             dell'unità data.
            RITORNA:  Un cursore contenente l'elenco dei record con tutte le
             unità discendenti dell'unità data.
            NOTE:
      ******************************************************************************/
      d_ottica ottiche.ottica%type;
      d_result afc.t_ref_cursor;
   begin
      d_ottica := anagrafe_unita_organizzativa.get_ottica(p_progr_unita_org, p_data);
      if ottica.is_ottica_istituzionale(d_ottica) = 1 then
         open d_result for
            select u.progr_unita_organizzativa as progr_uo
                  ,anagrafe_unita_organizzativa.get_codice_uo(u.progr_unita_organizzativa
                                                             ,p_data) as codice_uo
                  ,anagrafe_unita_organizzativa.get_descrizione(u.progr_unita_organizzativa
                                                               ,p_data) as descrizione
              from unita_organizzative u
             where u.ottica = d_ottica
               and p_data between u.dal and nvl(u.al, p_data)
            connect by prior u.progr_unita_organizzativa = u.id_unita_padre
            --and p_data between prior u.dal and nvl(prior u.al, p_data)
             start with u.progr_unita_organizzativa = p_progr_unita_org
                    and p_data between u.dal and nvl(u.al, p_data);
      else
         open d_result for
            select 00000000
                  ,'XXXXXXXXXXXXXXXX'
                  ,'Errore: l''ottica non è istituzionale.'
              from dual;
      end if;
      return d_result;
   end; -- gps_util.get_unita_discendenti
   --------------------------------------------------------------------------------
   function get_unita_componenti
   (
      p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            in date
     ,p_tipo_ricerca    in number default 1
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  get_unita_componenti
            DESCRIZIONE: Restituisce l'elenco dei record con le unità discendenti
             dell'unità data, in ordine gerarchico con l'indicazione dei
             componenti che ne fanno parte.
            RITORNA:  Un cursore contenente l'elenco dei record.
            NOTE:  Utilizza la tabella di appoggio UNITA_DISCENDENTI_TMP
      ******************************************************************************/
      d_result afc.t_ref_cursor;
   begin
      begin
         if p_tipo_ricerca = 1 then
            open d_result for
               select c.progr_unita_organizzativa as progr_uo
                     ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                                ,p_data) as codice_uo
                     ,anagrafe_unita_organizzativa.get_descrizione(c.progr_unita_organizzativa
                                                                  ,p_data) as descrizione_uo
                     ,c.ci as ci
                     ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME') as cognome
                     ,soggetti_get_descr(c.ni, trunc(sysdate), 'NOME') as nome
                 from componenti c
                where c.progr_unita_organizzativa = p_progr_unita_org
                  and p_data between c.dal and nvl(decode(c.revisione_cessazione
                                                         ,revisione_struttura.get_revisione_mod(c.ottica)
                                                         ,to_date(null)
                                                         ,c.al)
                                                  ,p_data)
                  and c.revisione_assegnazione <>
                      revisione_struttura.get_revisione_mod(c.ottica)
                  and c.ci is not null;
         else
            open d_result for
               select c.progr_unita_organizzativa as progr_uo
                     ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                                ,p_data) as codice_uo
                     ,anagrafe_unita_organizzativa.get_descrizione(c.progr_unita_organizzativa
                                                                  ,p_data) as descrizione_uo
                     ,c.ci as ci
                     ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME') as cognome
                     ,soggetti_get_descr(c.ni, trunc(sysdate), 'NOME') as nome
                 from componenti c
                where c.progr_unita_organizzativa in
                      (select u.progr_unita_organizzativa as progr_uo
                         from unita_organizzative u
                        where p_data between u.dal and
                              nvl(decode(u.revisione_cessazione
                                        ,revisione_struttura.get_revisione_mod(u.ottica)
                                        ,to_date(null)
                                        ,u.al)
                                 ,p_data)
                       connect by prior u.id_elemento = u.id_unita_padre
                        start with u.progr_unita_organizzativa = p_progr_unita_org
                               and p_data between u.dal and nvl(u.al, p_data))
                  and p_data between c.dal and nvl(decode(c.revisione_cessazione
                                                         ,revisione_struttura.get_revisione_mod(c.ottica)
                                                         ,to_date(null)
                                                         ,c.al)
                                                  ,p_data)
                  and c.revisione_assegnazione <>
                      revisione_struttura.get_revisione_mod(c.ottica)
                  and c.ci is not null
                order by so4_util.get_ordinamento(c.progr_unita_organizzativa
                                                 ,p_data
                                                 ,c.ottica);
         end if;
      exception
         when others then
            open d_result for
               select 00000000 as zero1
                     ,00000000 as zero2
                     ,'XXXXXXXXXXXXXXXX' as xxx
                     ,'Errore: nell''estrazione dei componenti.' as descrizione
                 from dual;
      end;
      return d_result;
   end; -- gps_util.get_unita_componenti
   --------------------------------------------------------------------------------
   function get_al_unor
   (
      p_ottica        revisioni_struttura.ottica%type
     ,p_revisione     revisioni_struttura.revisione%type
     ,p_dal           revisioni_struttura.dal%type
     ,p_al            date
     ,p_revisione_rif revisioni_struttura.revisione%type
   ) return date is
      /******************************************************************************
            NOME:  get_al_unor
            DESCRIZIONE: Calcola la data finale dei periodi di P00.UNITA_ORGANIZZATIVE
      ******************************************************************************/
      d_al            date;
      d_dal_succ      date;
      d_dummy         varchar2(1);
      d_max_revisione revisioni_struttura.revisione%type;
   begin
      select max(revisione)
        into d_max_revisione
        from revisioni_struttura
       where stato = 'A'
         and ottica = p_ottica;
      if p_revisione = p_revisione_rif and p_revisione_rif <> d_max_revisione then
         d_al := to_date(null);
      else
         begin
            select dal
              into d_dal_succ
              from revisioni_struttura r
             where dal = (select min(dal)
                            from revisioni_struttura
                           where ottica = r.ottica
                             and revisione <= p_revisione_rif
                             and dal > p_dal)
               and ottica = p_ottica;
            raise too_many_rows;
         exception
            when no_data_found then
               d_al := to_date(null);
            when too_many_rows then
               begin
                  select 'x'
                    into d_dummy
                    from revisioni_struttura
                   where dal between p_dal and (d_dal_succ - 1)
                     and ottica = p_ottica
                     and revisione > p_revisione
                     and revisione > p_revisione_rif;
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     d_al := d_dal_succ - 1;
                  when no_data_found then
                     d_al := p_al;
               end;
         end;
      end if;
      return d_al;
   end; -- gps_util.get_al_unor
   --------------------------------------------------------------------------------
   function get_assegnazione_fisica --#681
   (
      p_ci   componenti.ci%type
     ,p_data componenti.dal%type default null
     ,p_tipo number default 1
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_assegnazione_fisica.
       DESCRIZIONE: Dato il CI di un componente, restituisce l'unita' di assegnazione
                    fisica valida alla data.
       PARAMETRI:   p_tipo               Determina il tipo di dato che viene restituito. Valori possibili
                    1                    Descrizione dell'unita' fisica
                    2                    Codice dell'unita' fisica
                    3                    Descrizione UF||Codice UF (tra parentesi)
                    4                    Descr.Suddivisione Fisica||Descrizione UF||Codice UF (tra parentesi)
                    5                    Concatenazione delle UF del ramo di assegnazione
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   04/02/2016  MM        Prima emissione.
      ******************************************************************************/
      d_result             varchar2(2000);
      d_ni                 assegnazioni_fisiche.ni%type;
      d_progr_unita_fisica assegnazioni_fisiche.progr_unita_fisica%type;
      d_codice_uf          anagrafe_unita_fisiche.codice_uf%type;
      d_denominazione      anagrafe_unita_fisiche.denominazione%type;
      d_suddivisione       suddivisioni_fisiche.id_suddivisione%type;
      d_data               date;
   begin
      -- Si valorizzano i parametri di default
      if p_data is null then
         d_data := trunc(sysdate);
      else
         d_data := trunc(p_data);
      end if;
      -- Determiniamo l'NI del soggetto
      begin
         select ni_as4
           into d_ni
           from p00_dipendenti_soggetti
          where ni_gp4 = (select ni from p00_rapporti_individuali where ci = p_ci);
      exception
         when no_data_found then
            d_ni := to_number(null);
      end;
      -- determinazione dell'assegnazione fisica del soggetto
      if d_ni is not null then
         begin
            select progr_unita_fisica
              into d_progr_unita_fisica
              from assegnazioni_fisiche a
             where a.ni = d_ni
               and d_data between a.dal and nvl(a.al, to_date(3333333, 'j'));
         exception
            when no_data_found then
               d_result := 'Nessuna assegnazione fisica';
            when others then
               d_result := 'Assegnazione fisica errata';
         end;
      else
         d_result := 'Soggetto non determinabile';
      end if;
      -- determiniamo i dati della UF
      if d_progr_unita_fisica is not null and d_result is null and p_tipo < 5 then
         begin
            select a.codice_uf
                  ,a.denominazione
                  ,a.id_suddivisione
              into d_codice_uf
                  ,d_denominazione
                  ,d_suddivisione
              from anagrafe_unita_fisiche a
             where progr_unita_fisica = d_progr_unita_fisica
               and d_data between dal and nvl(al, to_date(3333333, 'j'));
         exception
            when others then
               d_result := 'Unita'' fisica errata';
         end;
      end if;
      -- Formattiamo i dati della UF in base al formato richiesto
      if d_result is null then
         if p_tipo = 1 then
            d_result := d_denominazione;
         elsif p_tipo = 2 then
            d_result := d_codice_uf;
         elsif p_tipo = 3 then
            d_result := d_denominazione || ' (' || d_codice_uf || ')';
         elsif p_tipo = 4 then
            d_result := nvl(suddivisione_fisica.get_des_abb(d_suddivisione)
                           ,'(Suddivisione non definita)') || ' : ' || d_denominazione || ' (' ||
                        d_codice_uf || ')';
         elsif p_tipo = 5 then
            d_result := so4_util_fis.get_stringa_ascendenti(d_progr_unita_fisica
                                                           ,d_data
                                                           ,anagrafe_unita_fisica.get_amministrazione(d_progr_unita_fisica
                                                                                                     ,anagrafe_unita_fisica.get_dal_id(d_progr_unita_fisica
                                                                                                                                      ,d_data))
                                                           ,2);
         end if;
      end if;
      --
      return d_result;
      --
   end;
   --------------------------------------------------------------------------------
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
   ) is
      /******************************************************************************
            NOME:  ins_assegnazione
            DESCRIZIONE: Effettua una nuova assegnazione per il componente identificato
             dall'ni di p00. Un periodo di incarico viene indicato come assegnazione
             non prevalente con codice "riservato" 99
            NOTE:  L'eliminazione di periodi di assegnazione determina la cancellazione
             "logica" dei relativi ruoli applicativi. L'inserimento del nuovo periodo
             deve valutare la necessità di ereditare i ruoli dal/i periodo/i
             sostituiti o dal periodo contiguo immediatamente precedente.
             Ogni riferimento alle funzioni dal_pubblicazione e al_pubblicazione
             e' stato introdotto con la #548
             Completamente ridisegnata per la #588
      ******************************************************************************/
      d_result             afc_error.t_error_number := afc_error.ok;
      d_ottica_ist         ottiche.ottica%type;
      d_ni_as4             as4_anagrafe_soggetti.ni%type;
      d_id_componente      componenti.id_componente%type;
      d_id_comp_al         componenti.id_componente%type;
      w_atco               attributi_componente%rowtype;
      w_num_atco           number;
      d_id_attr_componente attributi_componente.id_attr_componente%type;
      d_dal_pubb           componenti.dal_pubb%type;
      d_al_pubb            componenti.al_pubb%type;
      d_gg_so4             number(8);
      d_gg_gps             number(8) := nvl(p_al, to_date(3333333, 'j')) - p_dal + 1;
      d_num_progr          number(8);
      d_progr              componenti.progr_unita_organizzativa%type;
      d_rilevanza          varchar2(1);
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      componente.s_origine_gp            := 1; --#550 #543
      imputazione_bilancio.s_origine_gps := 1; --#594
      d_ottica_ist                       := ottica.get_ottica_per_amm(p_amministrazione);
      d_ni_as4                           := so4gp_pkg.get_id_soggetto_as4(p_ni);
      valorizza_variabili(d_ottica_ist);

      -- #639 verifica se la chiamata di gps è dovuta ad una storicizzazione della sola imputazione
      select sum(least(nvl(c.al, to_date(3333333, 'j')), nvl(p_al, to_date(3333333, 'j'))) -
                 greatest(dal, p_dal) + 1)
            ,count(distinct progr_unita_organizzativa)
            ,min(progr_unita_organizzativa)
        into d_gg_so4
            ,d_num_progr
            ,d_progr
        from vista_componenti c
       where c.ottica = d_ottica_ist
         and c.dal <= nvl(p_al, to_date(3333333, 'j'))
         and nvl(c.al, to_date(3333333, 'j')) >= p_dal
         and c.dal <= nvl(c.al, to_date(3333333, 'j'))
         and nvl(c.ci, p_ci) = p_ci
         and ni = d_ni_as4
         and tipo_assegnazione = 'I'
         and ((assegnazione_prevalente like '1%' and p_assegnazione_prevalente like '1%') or
             (assegnazione_prevalente = 99 and p_assegnazione_prevalente = 99));

      if d_gg_so4 = d_gg_gps and d_num_progr = 1 and d_progr = p_progr_unita_org then
         --stessa durata, stessa uo, verifichiamo se è cambiata l'imputazione
         select sum(least(nvl(c.al, to_date(3333333, 'j'))
                         ,nvl(p_al, to_date(3333333, 'j'))) - greatest(dal, p_dal) + 1)
               ,count(distinct numero)
               ,min(numero)
           into d_gg_so4
               ,d_num_progr
               ,d_progr
           from vista_imputazioni c
          where c.ottica = d_ottica_ist
            and c.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(c.al, to_date(3333333, 'j')) >= p_dal
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and nvl(c.ci, p_ci) = p_ci
            and ni = d_ni_as4
            and tipo_assegnazione = 'I'
            and ((assegnazione_prevalente like '1%' and
                p_assegnazione_prevalente like '1%') or
                (assegnazione_prevalente = 99 and p_assegnazione_prevalente = 99));

         if d_gg_so4 <> d_gg_gps or d_num_progr <> 1 or d_progr = p_imputaz_contab then
            --imputazione modificata, ricostruiamo la storicita' sull'intero periodo
            select decode(p_assegnazione_prevalente, 99, 'I', 'Q')
              into d_rilevanza
              from dual;
            rettifica_imputazione(p_ci
                                 ,p_dal
                                 ,p_al
                                 ,d_rilevanza
                                 ,p_progr_unita_org
                                 ,p_imputaz_contab
                                 ,p_utente_agg
                                 ,d_ottica_ist
                                 ,1);
         end if;
      else
         --Trattamento precedente, gestione dell'assegnazione
         if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or
            length(s_eredita_ruoli_sudd) <> 0 then
            --#191
            copia_ruoli(p_dal
                       ,to_date(null)
                       ,d_ni_as4
                       ,p_ci
                       ,d_ottica_ist
                       ,''
                       ,p_progr_unita_org); --#37425
         end if;
         if is_componente_modificabile(p_ci, d_ottica_ist, p_dal, p_al) = 'SI' then
            begin
               revisione_struttura.s_attivazione := 1;
               -- verifichiamo se esistono record sui quali dobbiamo farci spazio
               for comp in (select c.*
                              from componenti c
                             where c.ottica = d_ottica_ist
                               and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                               and nvl(c.al, to_date(3333333, 'j')) >= p_dal
                               and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                               and nvl(c.ci, p_ci) = p_ci
                               and ni = d_ni_as4
                                  --
                               and (c.progr_unita_organizzativa = p_progr_unita_org --#588 --#663
                                   and exists (select 'x'
                                                 from attributi_componente
                                                where id_componente = c.id_componente
                                                  and substr(assegnazione_prevalente, 1, 1) <> '1'
                                                  and substr(p_assegnazione_prevalente, 1, 1) = '1') or
                                    exists
                                    (select 'x'
                                       from attributi_componente
                                      where id_componente = c.id_componente
                                        and substr(assegnazione_prevalente, 1, 1) =
                                            substr(p_assegnazione_prevalente, 1, 1)))
                             order by id_componente)
               loop
                  --preleva i dati relativi all'attributo componente relativo
                  select count(*)
                    into w_num_atco
                    from attributi_componente a
                   where id_componente = comp.id_componente;
                  select a.*
                    into w_atco
                    from attributi_componente a
                   where id_componente = comp.id_componente
                     and nvl(comp.al, to_date(3333333, 'j')) between a.dal and
                         nvl(a.al, to_date(3333333, 'j'));
                  --analizziamo la relazione tra il record da inserire e gli eventuali record intersecati
                  if p_dal <= comp.dal and nvl(p_al, to_date(3333333, 'j')) >=
                     nvl(comp.al, to_date(3333333, 'j')) then
                     --periodo incluso o coincidente per date; viene eseguita l'eliminazione logica del componente
                     ruolo_componente.s_eliminazione_logica := 1;
                     update componenti c
                        set al_pubb = so4_pkg.al_pubblicazione('E', 'C', comp.al_pubb)
                           ,al_prec = al
                           ,al      = dal - 1
                      where id_componente = comp.id_componente;
                     update attributi_componente a
                        set al_prec = al
                           ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', comp.al_pubb)
                           ,al      = dal - 1
                      where id_componente = comp.id_componente;
                     delete from ubicazioni_componente
                      where id_componente = comp.id_componente;
                     delete from imputazioni_bilancio
                      where id_componente = comp.id_componente;
                     for ruco in (select *
                                    from ruoli_componente
                                   where id_componente = comp.id_componente)
                     loop
                        ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                                  ,p_data_agg
                                                                  ,p_utente_agg
                                                                  ,s_segnalazione_bloccante
                                                                  ,s_segnalazione);
                     end loop;
                     ruolo_componente.s_eliminazione_logica := 0;
                  elsif p_dal >= comp.dal and nvl(p_al, to_date(3333333, 'j')) <=
                        nvl(comp.al, to_date(3333333, 'j')) then
                     --periodo includente; il componente viene assestato e si inserisce lo spezzone mancante successivo al p_al
                     update componenti c
                        set al_pubb = so4_pkg.al_pubblicazione('U'
                                                              ,'C'
                                                              ,comp.al_pubb
                                                              ,(p_dal - 1)
                                                              ,comp.al)
                           ,al      = p_dal - 1
                      where id_componente = comp.id_componente;
                     --
                     if w_num_atco > 1 then
                        begin
                           select a.*
                             into w_atco
                             from attributi_componente a
                            where id_componente = comp.id_componente --#678
                              and (p_dal - 1) between a.dal and
                                  nvl(a.al, to_date(3333333, 'j'));
                        exception
                           when no_data_found then
                              null;
                        end;
                        update attributi_componente
                           set al_pubb = so4_pkg.al_pubblicazione('E', 'A', comp.al_pubb) --#678
                              ,al      = dal - 1 --cancellazione logica
                         where id_componente = comp.id_componente --#678
                           and dal > p_dal - 1;
                        update attributi_componente a
                           set al_pubb = so4_pkg.al_pubblicazione('U'
                                                                 ,'A'
                                                                 ,w_atco.al_pubb
                                                                 ,(p_dal - 1)
                                                                 ,a.al)
                              ,al      = p_dal - 1
                         where id_componente = comp.id_componente
                           and p_dal between dal and nvl(al, to_date(3333333, 'j'));
                     end if;
                     --
                     if nvl(p_al, to_date(3333333, 'j')) <
                        nvl(comp.al, to_date(3333333, 'j')) then
                        d_id_comp_al := componente.get_id_componente;
                        componente.ins(p_id_componente             => d_id_comp_al
                                      ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                                      ,p_dal                       => nvl(p_al
                                                                         ,to_date(3333333
                                                                                 ,'j')) + 1
                                      ,p_al                        => comp.al
                                      ,p_ni                        => comp.ni
                                      ,p_ci                        => comp.ci
                                      ,p_codice_fiscale            => comp.codice_fiscale
                                      ,p_denominazione             => comp.denominazione
                                      ,p_denominazione_al1         => comp.denominazione_al1
                                      ,p_denominazione_al2         => comp.denominazione_al2
                                      ,p_stato                     => comp.stato
                                      ,p_ottica                    => comp.ottica
                                      ,p_dal_pubb                  => so4_pkg.dal_pubblicazione('I'
                                                                                               ,'C'
                                                                                               ,''
                                                                                               ,nvl(p_al
                                                                                                   ,to_date(3333333
                                                                                                           ,'j')) + 1)
                                      ,p_al_pubb                   => so4_pkg.al_pubblicazione('I'
                                                                                              ,'C'
                                                                                              ,''
                                                                                              ,comp.al)
                                      ,p_revisione_assegnazione    => comp.revisione_assegnazione
                                      ,p_revisione_cessazione      => comp.revisione_cessazione
                                      ,p_utente_aggiornamento      => p_utente_agg
                                      ,p_data_aggiornamento        => p_data_agg);
                        --#548
                        imputazione_bilancio.ins(p_id_imputazione => ''
                                                ,p_id_componente  => d_id_comp_al
                                                ,p_numero         => p_imputaz_contab
                                                ,p_dal            => nvl(p_al
                                                                        ,to_date(3333333
                                                                                ,'j')) + 1
                                                ,p_al             => comp.al
                                                ,p_utente_agg     => p_utente_agg
                                                ,p_data_agg       => p_data_agg);
                        if gps_util.check_esiste_attributo(d_id_comp_al
                                                          ,nvl(p_al
                                                              ,to_date(3333333, 'j')) + 1) then
                           -- attributo già inserito faccio upd
                           d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_comp_al
                                                                                              ,nvl(p_al
                                                                                                  ,to_date(3333333
                                                                                                          ,'j')) + 1);
                           update attributi_componente
                              set incarico                = w_atco.incarico
                                 ,telefono                = w_atco.telefono
                                 ,fax                     = w_atco.fax
                                 ,e_mail                  = w_atco.e_mail
                                 ,tipo_assegnazione       = w_atco.tipo_assegnazione
                                 ,assegnazione_prevalente = w_atco.assegnazione_prevalente
                                 ,percentuale_impiego     = w_atco.percentuale_impiego
                                 ,ottica                  = w_atco.ottica
                                 ,revisione_assegnazione  = w_atco.revisione_assegnazione
                                 ,revisione_cessazione    = w_atco.revisione_cessazione
                                 ,utente_aggiornamento    = p_utente_agg
                                 ,data_aggiornamento      = p_data_agg
                            where id_attr_componente = d_id_attr_componente;
                        else
                           attributo_componente.ins(p_id_attr_componente      => null
                                                   ,p_id_componente           => d_id_comp_al
                                                   ,p_dal                     => nvl(p_al
                                                                                    ,to_date(3333333
                                                                                            ,'j')) + 1
                                                   ,p_al                      => comp.al --#678
                                                   ,p_incarico                => w_atco.incarico
                                                   ,p_telefono                => w_atco.telefono
                                                   ,p_fax                     => w_atco.fax
                                                   ,p_e_mail                  => w_atco.e_mail
                                                   ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                                   ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                                   ,p_ottica                  => w_atco.ottica
                                                   ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                                   ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                                   ,p_utente_aggiornamento    => p_utente_agg
                                                   ,p_data_aggiornamento      => p_data_agg);
                        end if;
                        if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or
                           length(s_eredita_ruoli_sudd) <> 0 then
                           --#191
                           ripristina_ruoli(comp.ni
                                           ,p_ci
                                           ,comp.ottica
                                           ,to_date(nvl(p_al, to_date(3333333, 'j')) + 1)
                                           ,comp.al
                                           ,to_date(nvl(p_al, to_date(3333333, 'j')) + 1)
                                           ,comp.al
                                           ,comp.progr_unita_organizzativa
                                           ,d_id_comp_al
                                           ,p_utente_agg
                                           ,p_data_agg);
                        end if;
                     end if;
                  elsif p_dal between comp.dal and nvl(comp.al, to_date(3333333, 'j')) and
                        not (nvl(p_al, to_date(3333333, 'j')) between comp.dal and
                         nvl(comp.al, to_date(3333333, 'j'))) then
                     --periodo include il solo p_dal; assesta la data finale del componente ed elimina logicamente
                     --le registrazioni accessorie successive
                     update attributi_componente
                        set al      = dal - 1
                           ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', d_al_pubb)
                      where id_componente = comp.id_componente
                        and dal > p_dal - 1;
                     for ruco in (select id_ruolo_componente
                                    from ruoli_componente
                                   where id_componente = comp.id_componente
                                     and dal <= nvl(al, to_date(3333333, 'j'))
                                     and dal > p_dal - 1)
                     loop
                        ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                                  ,p_data_agg
                                                                  ,p_utente_agg
                                                                  ,s_segnalazione_bloccante
                                                                  ,s_segnalazione);
                     end loop;
                     delete from imputazioni_bilancio
                      where id_componente = comp.id_componente
                        and dal > p_dal - 1;
                     delete from ubicazioni_componente
                      where id_componente = comp.id_componente
                        and dal > p_dal - 1;
                     update componenti c
                        set al_pubb                = so4_pkg.al_pubblicazione('U'
                                                                             ,'C'
                                                                             ,c.al_pubb
                                                                             ,(p_dal - 1)
                                                                             ,c.al)
                           ,al                     = p_dal - 1
                           ,c.utente_aggiornamento = p_utente_agg
                           ,c.data_aggiornamento   = p_data_agg
                      where id_componente = comp.id_componente;
                     update imputazioni_bilancio --#548
                        set al         = p_dal - 1
                           ,utente_agg = p_utente_agg
                           ,data_agg   = p_data_agg
                      where id_componente = comp.id_componente
                        and p_dal - 1 between dal and nvl(al, to_date(3333333, 'j'));
                     update ubicazioni_componente --#548
                        set al                   = p_dal - 1
                           ,utente_aggiornamento = p_utente_agg
                           ,data_aggiornamento   = p_data_agg
                      where id_componente = comp.id_componente --d_id_comp_dal
                        and p_dal - 1 between dal and nvl(al, to_date(3333333, 'j'));
                     /* se il periodo precedente era pubblicato prima della sysdate,viene creato un periodo fittizio
                     per mantenere il flusso storico delle assegnazioni pubblicate */
                     if comp.dal_pubb < trunc(sysdate) and (p_dal - 1) < trunc(sysdate) then
                        d_id_componente := componente.get_id_componente();
                        componente.ins(p_id_componente             => d_id_componente
                                      ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                                      ,p_dal                       => comp.dal
                                      ,p_al                        => comp.dal - 1
                                      ,p_ni                        => comp.ni
                                      ,p_ci                        => comp.ci
                                      ,p_stato                     => 'P'
                                      ,p_ottica                    => comp.ottica
                                      ,p_dal_pubb                  => comp.dal_pubb
                                      ,p_al_pubb                   => (trunc(sysdate) - 1)
                                      ,p_utente_aggiornamento      => comp.utente_aggiornamento
                                      ,p_data_aggiornamento        => comp.data_aggiornamento);
                        ripristina_ruoli(comp.ni
                                        ,p_ci
                                        ,comp.ottica
                                        ,comp.dal
                                        ,(trunc(sysdate) - 1)
                                        ,comp.dal
                                        ,(comp.dal - 1)
                                        ,comp.progr_unita_organizzativa
                                        ,d_id_componente
                                        ,p_utente_agg
                                        ,p_data_agg);
                     end if;
                     -------------------
                  elsif nvl(p_al, to_date(3333333, 'j')) between comp.dal and
                        nvl(comp.al, to_date(3333333, 'j')) and
                        not
                         (p_dal between comp.dal and nvl(comp.al, to_date(3333333, 'j'))) then
                     --periodo include il solo p_al; assesta la data iniziale del componente ed elimina logicamente
                     --le registrazioni accessorie precedenti
                     update attributi_componente
                        set al      = dal - 1
                           ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', comp.al_pubb)
                      where id_componente = comp.id_componente
                        and nvl(al, to_date(3333333, 'j')) < p_al + 1;
                     for ruco in (select id_ruolo_componente
                                    from ruoli_componente
                                   where id_componente = comp.id_componente
                                     and dal <= nvl(al, to_date(3333333, 'j'))
                                     and nvl(al, to_date(3333333, 'j')) < p_al + 1)
                     loop
                        ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                                  ,p_data_agg
                                                                  ,p_utente_agg
                                                                  ,s_segnalazione_bloccante
                                                                  ,s_segnalazione);
                     end loop;
                     delete from imputazioni_bilancio
                      where id_componente = comp.id_componente
                        and nvl(al, to_date(3333333, 'j')) < p_al + 1;
                     delete from ubicazioni_componente
                      where id_componente = comp.id_componente
                        and nvl(al, to_date(3333333, 'j')) < p_al + 1;

                     --determinazione della data di pubblicazione in relazione alla data della modifica
                     if (p_al + 1) > trunc(sysdate) then
                        d_dal_pubb := p_al + 1;
                     else
                        d_dal_pubb := so4_pkg.dal_pubblicazione('U'
                                                               ,'C'
                                                               ,comp.dal_pubb
                                                               ,(p_al + 1)
                                                               ,comp.dal);
                     end if;

                     update componenti c
                        set c.dal                  = p_al + 1
                           ,c.dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                              ,'C'
                                                                              ,d_dal_pubb
                                                                              ,(p_al + 1)
                                                                              ,c.dal)
                           ,c.utente_aggiornamento = p_utente_agg
                           ,c.data_aggiornamento   = p_data_agg
                      where id_componente = comp.id_componente;
                     update imputazioni_bilancio --#548
                        set dal        = p_al + 1
                           ,utente_agg = p_utente_agg
                           ,data_agg   = p_data_agg
                      where id_componente = comp.id_componente
                        and nvl(al, to_date(3333333, 'j')) >= p_al + 1;
                     update ubicazioni_componente --#548
                        set dal                  = p_al + 1
                           ,utente_aggiornamento = p_utente_agg
                           ,data_aggiornamento   = p_data_agg
                      where id_componente = comp.id_componente
                        and nvl(al, to_date(3333333, 'j')) >= p_al + 1;
                     /* se il periodo precedente era pubblicato prima della sysdate,viene creato un periodo fittizio
                     per mantenere il flusso storico delle assegnazioni pubblicate */
                     if comp.dal_pubb < trunc(sysdate) and (p_al + 1) > trunc(sysdate) then
                        d_id_componente := componente.get_id_componente();
                        componente.ins(p_id_componente             => d_id_componente
                                      ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                                      ,p_dal                       => comp.dal
                                      ,p_al                        => comp.dal - 1
                                      ,p_ni                        => comp.ni
                                      ,p_ci                        => comp.ci
                                      ,p_stato                     => 'P'
                                      ,p_ottica                    => comp.ottica
                                      ,p_dal_pubb                  => comp.dal_pubb
                                      ,p_al_pubb                   => (trunc(sysdate) - 1)
                                      ,p_utente_aggiornamento      => comp.utente_aggiornamento
                                      ,p_data_aggiornamento        => comp.data_aggiornamento);
                        ripristina_ruoli(comp.ni
                                        ,p_ci
                                        ,comp.ottica
                                        ,comp.dal
                                        ,(trunc(sysdate) - 1)
                                        ,comp.dal
                                        ,(comp.dal - 1)
                                        ,comp.progr_unita_organizzativa
                                        ,d_id_componente
                                        ,p_utente_agg
                                        ,p_data_agg);
                     end if;
                  end if;
               end loop;
               -- inserimento del nuovo record
               begin
                  --determina le date di pubblicazione per il nuovo record
                  d_dal_pubb      := so4_pkg.dal_pubblicazione('I', 'C', '', p_dal);
                  d_al_pubb       := so4_pkg.al_pubblicazione('I', 'C', '', p_al);
                  d_id_componente := componente.get_id_componente();
                  componente.ins(p_id_componente             => d_id_componente
                                ,p_progr_unita_organizzativa => p_progr_unita_org
                                ,p_dal                       => p_dal
                                ,p_al                        => p_al
                                ,p_ni                        => d_ni_as4
                                ,p_ci                        => p_ci
                                ,p_stato                     => 'P'
                                ,p_ottica                    => d_ottica_ist
                                ,p_dal_pubb                  => d_dal_pubb
                                ,p_al_pubb                   => d_al_pubb
                                ,p_utente_aggiornamento      => p_utente_agg
                                ,p_data_aggiornamento        => p_data_agg);
               end;
               if gps_util.check_esiste_attributo(d_id_componente, p_dal) then
                  -- attributo già inserito faccio upd
                  d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_componente
                                                                                     ,p_dal);
                  update attributi_componente
                     set incarico                = p_incarico
                        ,assegnazione_prevalente = p_assegnazione_prevalente
                        ,tipo_assegnazione       = 'I'
                        ,percentuale_impiego     = 100
                        ,ottica                  = d_ottica_ist
                        ,utente_aggiornamento    = p_utente_agg
                        ,data_aggiornamento      = p_data_agg
                   where id_attr_componente = d_id_attr_componente;
               else
                  begin
                     attributo_componente.ins(p_id_componente           => d_id_componente
                                             ,p_dal                     => p_dal
                                             ,p_al                      => p_al
                                             ,p_incarico                => p_incarico
                                             ,p_assegnazione_prevalente => p_assegnazione_prevalente
                                             ,p_tipo_assegnazione       => 'I'
                                             ,p_percentuale_impiego     => 100
                                             ,p_ottica                  => d_ottica_ist
                                             ,p_dal_pubb                => d_dal_pubb
                                             ,p_al_pubb                 => d_al_pubb
                                             ,p_utente_aggiornamento    => p_utente_agg
                                             ,p_data_aggiornamento      => p_data_agg);
                  exception
                     when others then
                        raise;
                  end;
               end if;
               if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or
                  length(s_eredita_ruoli_sudd) <> 0 then
                  --#191
                  ripristina_ruoli(d_ni_as4
                                  ,p_ci
                                  ,d_ottica_ist
                                  ,p_dal
                                  ,p_al
                                  ,p_dal
                                  ,p_al
                                  ,p_progr_unita_org
                                  ,d_id_componente
                                  ,p_utente_agg
                                  ,p_data_agg);
               end if;
               if p_imputaz_contab is not null then
                  begin
                     imputazione_bilancio.ins(p_id_imputazione => null
                                             ,p_id_componente  => d_id_componente
                                             ,p_numero         => p_imputaz_contab
                                             ,p_dal            => p_dal
                                             ,p_al             => p_al
                                             ,p_utente_agg     => p_utente_agg
                                             ,p_data_agg       => p_data_agg);
                  exception
                     when others then
                        d_result := s_err_ins_imput_bil_number;
                  end;
               end if;
            end;
            revisione_struttura.s_attivazione := 0;
         else
            -- componente gia' interessato dalla revisione in modifica
            d_result := s_componente_in_mod_number;
         end if;
      end if;
      componente.s_origine_gp            := 0; --#550 #543
      imputazione_bilancio.s_origine_gps := 0; --#594
      --      end if;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- gps_util.ins_assegnazione
   --------------------------------------------------------------------------------
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
   ) is
      /******************************************************************************
            NOME:  ins_assegnazione_funzionale
            DESCRIZIONE: Crea una nuova assegnazione funzionale per il soggetto identificato
             dall'ni di p00.
            NOTE:
      ******************************************************************************/
      d_result             afc_error.t_error_number := afc_error.ok;
      d_ottica_ist         ottiche.ottica%type;
      d_ni_as4             as4_anagrafe_soggetti.ni%type;
      d_id_componente      componenti.id_componente%type;
      d_id_attr_componente attributi_componente.id_attr_componente%type;
      d_dal_pubb           componenti.dal_pubb%type;
      d_al_pubb            componenti.al_pubb%type;
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      componente.s_origine_gp            := 1; --#550 #543
      imputazione_bilancio.s_origine_gps := 1; --#594
      d_ottica_ist                       := ottica.get_ottica_per_amm(p_amministrazione);
      d_ni_as4                           := so4gp_pkg.get_id_soggetto_as4(p_ni);
      valorizza_variabili(d_ottica_ist);

      begin
         --determina le date di pubblicazione per il nuovo record
         d_dal_pubb      := so4_pkg.dal_pubblicazione('I', 'C', '', p_dal);
         d_al_pubb       := so4_pkg.al_pubblicazione('I', 'C', '', p_al);
         d_id_componente := componente.get_id_componente();
         componente.ins(p_id_componente             => d_id_componente
                       ,p_progr_unita_organizzativa => p_progr_unita_org
                       ,p_dal                       => p_dal
                       ,p_al                        => p_al
                       ,p_ni                        => d_ni_as4
                       ,p_stato                     => 'P'
                       ,p_ottica                    => d_ottica_ist
                       ,p_dal_pubb                  => d_dal_pubb
                       ,p_al_pubb                   => d_al_pubb
                       ,p_utente_aggiornamento      => p_utente_agg
                       ,p_data_aggiornamento        => p_data_agg);
      exception
         when others then
            raise;
      end;
      if gps_util.check_esiste_attributo(d_id_componente, p_dal) then
         -- attributo già inserito faccio upd
         d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_componente
                                                                            ,p_dal);
         update attributi_componente
            set incarico                = p_incarico
               ,assegnazione_prevalente = p_assegnazione_prevalente
               ,tipo_assegnazione       = 'F'
               ,percentuale_impiego     = 100
               ,ottica                  = d_ottica_ist
               ,utente_aggiornamento    = p_utente_agg
               ,data_aggiornamento      = p_data_agg
          where id_attr_componente = d_id_attr_componente;
      else
         begin
            attributo_componente.ins(p_id_componente           => d_id_componente
                                    ,p_dal                     => p_dal
                                    ,p_al                      => p_al
                                    ,p_incarico                => p_incarico
                                    ,p_assegnazione_prevalente => p_assegnazione_prevalente
                                    ,p_tipo_assegnazione       => 'F'
                                    ,p_percentuale_impiego     => 100
                                    ,p_ottica                  => d_ottica_ist
                                    ,p_dal_pubb                => d_dal_pubb
                                    ,p_al_pubb                 => d_al_pubb
                                    ,p_utente_aggiornamento    => p_utente_agg
                                    ,p_data_aggiornamento      => p_data_agg);
         exception
            when others then
               raise;
         end;
      end if;
      revisione_struttura.s_attivazione  := 0;
      componente.s_origine_gp            := 0; --#550 #543
      imputazione_bilancio.s_origine_gps := 0; --#594
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure tratta_assegnazioni_funzionali
   (
      p_ottica          in componenti.ottica%type
     ,p_ni              in componenti.ni%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal             in componenti.dal%type
     ,p_al              in componenti.al%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_data_agg        in componenti.data_aggiornamento%type
   ) is
      /******************************************************************************
            NOME:  tratta_assegnazioni_funzionali #588
            DESCRIZIONE: Dato un periodo corrispondente ad una ssegnazione istituzionale,
             verifica la presenza di assegnazioni non istituzionali sulla stessa UO,
             intersecanti. Gli intervalli di intersezione, vengono annullati
             nell'assegnazione istituzionale.
            NOTE:  L'eliminazione di periodi di assegnazione determina la cancellazione
             "logica" dei relativi ruoli applicativi. L'inserimento del nuovo periodo
             deve valutare la necessità di ereditare i ruoli dal/i periodo/i
             sostituiti o dal periodo contiguo immediatamente precedente.
      ******************************************************************************/
      d_result             afc_error.t_error_number := afc_error.ok;
      d_id_componente      componenti.id_componente%type;
      d_id_comp_al         componenti.id_componente%type;
      w_comp               componenti%rowtype;
      w_atco               attributi_componente%rowtype;
      d_id_attr_componente attributi_componente.id_attr_componente%type;
      d_dal_pubb           componenti.dal_pubb%type;
      d_al_pubb            componenti.al_pubb%type;
   begin
      componente.s_origine_gp            := 1; --#550 #543
      imputazione_bilancio.s_origine_gps := 1; --#594
      valorizza_variabili(p_ottica);
      --verifica la presenza di assegnazioni non istituzionali da trattare
      for comp in (select *
                     from componenti c
                    where c.ni = p_ni
                      and c.ottica = p_ottica
                      and c.progr_unita_organizzativa = p_progr_unita_org
                      and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                      and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                      and nvl(c.al, to_date(3333333, 'j')) >= p_dal
                      and exists (select 'x'
                             from attributi_componente
                            where id_componente = c.id_componente
                              and assegnazione_prevalente not like '1%'
                              and assegnazione_prevalente <> 99)
                    order by c.dal)
      loop
         --preleva i dati relativi all'attributo componente relativo
         select a.*
           into w_atco
           from attributi_componente a
          where id_componente = comp.id_componente
            and nvl(comp.al, to_date(3333333, 'j')) between a.dal and
                nvl(a.al, to_date(3333333, 'j'));
         --rileviamo la presenza di ruoli da trattare
         if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or
            length(s_eredita_ruoli_sudd) <> 0 then
            --#191
            copia_ruoli(comp.dal
                       ,comp.al
                       ,p_ni
                       ,''
                       ,p_ottica
                       ,w_atco.assegnazione_prevalente);
         end if;
         --analizziamo la relazione tra il record da inserire e gli eventuali record intersecati
         if p_dal <= comp.dal and
            nvl(p_al, to_date(3333333, 'j')) >= nvl(comp.al, to_date(3333333, 'j')) then
            --periodo incluso o coincidente per date; viene eseguita l'eliminazione logica del componente
            revisione_struttura.s_attivazione := 1;
            update componenti c
               set al_pubb = so4_pkg.al_pubblicazione('E', 'C', comp.al_pubb)
                  ,al_prec = al
                  ,al      = dal - 1
             where id_componente = comp.id_componente;
            update attributi_componente a
               set al_prec = al
                  ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', comp.al_pubb)
                  ,al      = dal - 1
             where id_componente = comp.id_componente;
            for ruco in (select *
                           from ruoli_componente
                          where id_componente = comp.id_componente)
            loop
               ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                         ,p_data_agg
                                                         ,p_utente_agg
                                                         ,s_segnalazione_bloccante
                                                         ,s_segnalazione);
            end loop;
            revisione_struttura.s_attivazione := 0;
         elsif p_dal >= comp.dal and
               nvl(p_al, to_date(3333333, 'j')) <= nvl(comp.al, to_date(3333333, 'j')) then
            --periodo includente; il componente viene assestato e si inserisce lo spezzone mancante successivo al p_al
            update componenti c
               set al_pubb = so4_pkg.al_pubblicazione('U'
                                                     ,'C'
                                                     ,comp.al_pubb
                                                     ,(p_dal - 1)
                                                     ,comp.al)
                  ,al      = p_dal - 1
             where id_componente = comp.id_componente;
            --
            update attributi_componente a
               set al_pubb = so4_pkg.al_pubblicazione('U'
                                                     ,'A'
                                                     ,w_atco.al_pubb
                                                     ,(p_dal - 1)
                                                     ,a.al)
                  ,al      = p_dal - 1
             where id_attr_componente = w_atco.id_attr_componente;
            --
            if nvl(p_al, to_date(3333333, 'j')) < nvl(comp.al, to_date(3333333, 'j')) then
               d_id_comp_al := componente.get_id_componente;
               componente.ins(p_id_componente             => d_id_comp_al
                             ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                             ,p_dal                       => nvl(p_al
                                                                ,to_date(3333333, 'j')) + 1
                             ,p_al                        => comp.al
                             ,p_ni                        => comp.ni
                             ,p_ci                        => comp.ci
                             ,p_codice_fiscale            => comp.codice_fiscale
                             ,p_denominazione             => comp.denominazione
                             ,p_denominazione_al1         => comp.denominazione_al1
                             ,p_denominazione_al2         => comp.denominazione_al2
                             ,p_stato                     => comp.stato
                             ,p_ottica                    => comp.ottica
                             ,p_dal_pubb                  => so4_pkg.dal_pubblicazione('I'
                                                                                      ,'C'
                                                                                      ,''
                                                                                      ,nvl(p_al
                                                                                          ,to_date(3333333
                                                                                                  ,'j')) + 1)
                             ,p_al_pubb                   => so4_pkg.al_pubblicazione('I'
                                                                                     ,'C'
                                                                                     ,''
                                                                                     ,comp.al)
                             ,p_revisione_assegnazione    => comp.revisione_assegnazione
                             ,p_revisione_cessazione      => comp.revisione_cessazione
                             ,p_utente_aggiornamento      => p_utente_agg
                             ,p_data_aggiornamento        => p_data_agg);
               if gps_util.check_esiste_attributo(d_id_comp_al
                                                 ,nvl(p_al, to_date(3333333, 'j')) + 1) then
                  -- attributo già inserito faccio upd
                  d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_comp_al
                                                                                     ,nvl(p_al
                                                                                         ,to_date(3333333
                                                                                                 ,'j')) + 1);
                  update attributi_componente
                     set incarico                = w_atco.incarico
                        ,telefono                = w_atco.telefono
                        ,fax                     = w_atco.fax
                        ,e_mail                  = w_atco.e_mail
                        ,tipo_assegnazione       = w_atco.tipo_assegnazione
                        ,assegnazione_prevalente = w_atco.assegnazione_prevalente
                        ,percentuale_impiego     = w_atco.percentuale_impiego
                        ,ottica                  = w_atco.ottica
                        ,revisione_assegnazione  = w_atco.revisione_assegnazione
                        ,revisione_cessazione    = w_atco.revisione_cessazione
                        ,utente_aggiornamento    = p_utente_agg
                        ,data_aggiornamento      = p_data_agg
                   where id_attr_componente = d_id_attr_componente;
               else
                  attributo_componente.ins(p_id_attr_componente      => null
                                          ,p_id_componente           => d_id_comp_al
                                          ,p_dal                     => nvl(p_al
                                                                           ,to_date(3333333
                                                                                   ,'j')) + 1
                                          ,p_al                      => w_comp.al
                                          ,p_incarico                => w_atco.incarico
                                          ,p_telefono                => w_atco.telefono
                                          ,p_fax                     => w_atco.fax
                                          ,p_e_mail                  => w_atco.e_mail
                                          ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                          ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                          ,p_ottica                  => w_atco.ottica
                                          ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                          ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                          ,p_utente_aggiornamento    => p_utente_agg
                                          ,p_data_aggiornamento      => p_data_agg);
               end if;
               if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or
                  length(s_eredita_ruoli_sudd) <> 0 then
                  --#191
                  ripristina_ruoli(comp.ni
                                  ,''
                                  ,comp.ottica
                                  ,to_date(nvl(p_al, to_date(3333333, 'j')) + 1)
                                  ,comp.al
                                  ,to_date(nvl(p_al, to_date(3333333, 'j')) + 1)
                                  ,comp.al
                                  ,comp.progr_unita_organizzativa
                                  ,d_id_comp_al
                                  ,p_utente_agg
                                  ,p_data_agg);
               end if;
            end if;
         elsif p_dal between comp.dal and nvl(comp.al, to_date(3333333, 'j')) and
               not (nvl(p_al, to_date(3333333, 'j')) between comp.dal and
                nvl(comp.al, to_date(3333333, 'j'))) then
            --periodo include il solo p_dal; assesta la data finale del componente ed elimina logicamente
            --le registrazioni accessorie successive
            update attributi_componente
               set al      = dal - 1
                  ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', d_al_pubb)
             where id_componente = comp.id_componente
               and dal > p_dal - 1;
            for ruco in (select id_ruolo_componente
                           from ruoli_componente
                          where id_componente = comp.id_componente
                            and dal <= nvl(al, to_date(3333333, 'j'))
                            and dal > p_dal - 1)
            loop
               ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                         ,p_data_agg
                                                         ,p_utente_agg
                                                         ,s_segnalazione_bloccante
                                                         ,s_segnalazione);
            end loop;
            update componenti c
               set al_pubb                = so4_pkg.al_pubblicazione('U'
                                                                    ,'C'
                                                                    ,c.al_pubb
                                                                    ,(p_dal - 1)
                                                                    ,c.al)
                  ,al                     = p_dal - 1
                  ,c.utente_aggiornamento = p_utente_agg
                  ,c.data_aggiornamento   = p_data_agg
             where id_componente = comp.id_componente;
            /* se il periodo precedente era pubblicato prima della sysdate,viene creato un periodo fittizio
            per mantenere il flusso storico delle assegnazioni pubblicate */
            if comp.dal_pubb < trunc(sysdate) and (p_dal - 1) < trunc(sysdate) then
               d_id_componente := componente.get_id_componente();
               componente.ins(p_id_componente             => d_id_componente
                             ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                             ,p_dal                       => comp.dal
                             ,p_al                        => comp.dal - 1
                             ,p_ni                        => comp.ni
                             ,p_ci                        => comp.ci
                             ,p_stato                     => 'P'
                             ,p_ottica                    => comp.ottica
                             ,p_dal_pubb                  => comp.dal_pubb
                             ,p_al_pubb                   => (trunc(sysdate) - 1)
                             ,p_utente_aggiornamento      => comp.utente_aggiornamento
                             ,p_data_aggiornamento        => comp.data_aggiornamento);
               ripristina_ruoli(comp.ni
                               ,''
                               ,comp.ottica
                               ,comp.dal
                               ,(trunc(sysdate) - 1)
                               ,comp.dal
                               ,(comp.dal - 1)
                               ,comp.progr_unita_organizzativa
                               ,d_id_componente
                               ,p_utente_agg
                               ,p_data_agg);
            end if;
            -------------------
         elsif nvl(p_al, to_date(3333333, 'j')) between comp.dal and
               nvl(comp.al, to_date(3333333, 'j')) and
               not (p_dal between comp.dal and nvl(comp.al, to_date(3333333, 'j'))) then
            --periodo include il solo p_al; assesta la data iniziale del componente ed elimina logicamente
            --le registrazioni accessorie precedenti
            update attributi_componente
               set al      = dal - 1
                  ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', comp.al_pubb)
             where id_componente = comp.id_componente
               and nvl(al, to_date(3333333, 'j')) < p_al + 1;
            for ruco in (select id_ruolo_componente
                           from ruoli_componente
                          where id_componente = comp.id_componente
                            and dal <= nvl(al, to_date(3333333, 'j'))
                            and nvl(al, to_date(3333333, 'j')) < p_al + 1)
            loop
               ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                         ,p_data_agg
                                                         ,p_utente_agg
                                                         ,s_segnalazione_bloccante
                                                         ,s_segnalazione);
            end loop;
            --determinazione della data di pubblicazione in relazione alla data della modifica
            if (p_al + 1) > trunc(sysdate) then
               d_dal_pubb := p_al + 1;
            else
               d_dal_pubb := so4_pkg.dal_pubblicazione('U'
                                                      ,'C'
                                                      ,comp.dal_pubb
                                                      ,(p_al + 1)
                                                      ,comp.dal);
            end if;

            update componenti c
               set c.dal                  = p_al + 1
                  ,c.dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                     ,'C'
                                                                     ,d_dal_pubb
                                                                     ,(p_al + 1)
                                                                     ,c.dal)
                  ,c.utente_aggiornamento = p_utente_agg
                  ,c.data_aggiornamento   = p_data_agg
             where id_componente = comp.id_componente;
            /* se il periodo precedente era pubblicato prima della sysdate,viene creato un periodo fittizio
            per mantenere il flusso storico delle assegnazioni pubblicate */
            if comp.dal_pubb < trunc(sysdate) and (p_al + 1) > trunc(sysdate) then
               d_id_componente := componente.get_id_componente();
               componente.ins(p_id_componente             => d_id_componente
                             ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                             ,p_dal                       => comp.dal
                             ,p_al                        => comp.dal - 1
                             ,p_ni                        => comp.ni
                             ,p_ci                        => comp.ci
                             ,p_stato                     => 'P'
                             ,p_ottica                    => comp.ottica
                             ,p_dal_pubb                  => comp.dal_pubb
                             ,p_al_pubb                   => (trunc(sysdate) - 1)
                             ,p_utente_aggiornamento      => comp.utente_aggiornamento
                             ,p_data_aggiornamento        => comp.data_aggiornamento);
               ripristina_ruoli(comp.ni
                               ,''
                               ,comp.ottica
                               ,comp.dal
                               ,(trunc(sysdate) - 1)
                               ,comp.dal
                               ,(comp.dal - 1)
                               ,comp.progr_unita_organizzativa
                               ,d_id_componente
                               ,p_utente_agg
                               ,p_data_agg);
            end if;
         end if;
      end loop;
      componente.s_origine_gp            := 0;
      imputazione_bilancio.s_origine_gps := 0;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end;
   --------------------------------------------------------------------------------
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
   ) is
      /******************************************************************************
            NOME:  sposta_assegnazione
            DESCRIZIONE: Modifica l'assegnazione del componente identificato dall'ni di p00
            NOTE:
      ******************************************************************************/
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      gps_util.chiudi_assegnazione(p_amministrazione => p_amministrazione
                                  ,p_ni              => p_ni
                                  ,p_ci              => p_ci
                                  ,p_data_cessazione => (p_dal - 1)
                                  ,p_ass_prevalente  => p_assegnazione_prevalente
                                  ,p_utente_agg      => p_utente_agg
                                  ,p_data_agg        => p_data_agg);
      gps_util.ins_assegnazione(p_amministrazione         => p_amministrazione
                               ,p_ni                      => p_ni
                               ,p_ci                      => p_ci
                               ,p_progr_unita_org         => p_progr_unita_org
                               ,p_imputaz_contab          => p_imputaz_contab
                               ,p_dal                     => p_dal
                               ,p_al                      => p_al
                               ,p_incarico                => p_incarico
                               ,p_assegnazione_prevalente => p_assegnazione_prevalente
                               ,p_utente_agg              => p_utente_agg
                               ,p_data_agg                => p_data_agg);
      --end if;
   end; -- gps_util.sposta_assegnazione
   --------------------------------------------------------------------------------
   procedure prima_assegnazione
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_dal_assegnazione        in out componenti.dal%type
     ,p_al_assegnazione         in out componenti.al%type
     ,p_ni                      in componenti.ni%type default null --#31549
     ,p_amministrazione         in amministrazioni.codice_amministrazione%type default null
   ) is
      /******************************************************************************
            NOME:  prima_assegnazione
            DESCRIZIONE: Restituisce gli estremi della prima assegnazione del componente nel periodo dato
            NOTE:
      ******************************************************************************/
      d_ottica ottiche.ottica%type := ottica.get_ottica_per_amm(p_amministrazione);
   begin
      begin
         select dal
               ,al
           into p_dal_assegnazione
               ,p_al_assegnazione
           from componenti c
          where c.ci = p_ci
            and c.ottica = nvl(d_ottica, c.ottica)
            and c.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(c.al, to_date(3333333, 'j')) >= p_dal
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and c.dal = (select min(dal)
                           from componenti
                          where ci = c.ci --#31549
                            and ottica = c.ottica
                            and dal <= nvl(al, to_date(3333333, 'j'))
                            and dal <= nvl(p_al, to_date(3333333, 'j'))
                            and nvl(al, to_date(3333333, 'j')) >= p_dal
                            and substr(p_assegnazione_prevalente, 1, 1) =
                                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(id_componente
                                                                                                                                   ,dal))
                                      ,1
                                      ,1)
                            and substr(p_assegnazione_prevalente, 1, 1) =
                                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                                   ,c.dal))
                                      ,1
                                      ,1));
      exception
         when no_data_found then
            null;
      end;
   end; -- gps_util.prima_assegnazione
   --------------------------------------------------------------------------------
   procedure ultima_assegnazione
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_dal_assegnazione        in out componenti.dal%type
     ,p_al_assegnazione         in out componenti.al%type
     ,p_ni                      in componenti.ni%type default null --#31549
     ,p_amministrazione         in amministrazioni.codice_amministrazione%type default null
   ) is
      /******************************************************************************
            NOME:  ultima_assegnazione
            DESCRIZIONE: Restituisce gli estremi dell'ultima assegnazione del componente nel periodo dato
            NOTE:
      ******************************************************************************/
      d_ottica ottiche.ottica%type := ottica.get_ottica_per_amm(p_amministrazione);
   begin
      begin
         select dal
               ,al
           into p_dal_assegnazione
               ,p_al_assegnazione
           from componenti c
          where c.ci = p_ci
            and c.ottica = nvl(d_ottica, c.ottica)
            and c.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(c.al, to_date(3333333, 'j')) >= p_dal
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and c.dal = (select max(dal)
                           from componenti
                          where ci = c.ci
                            and ottica = c.ottica --#31549
                            and dal <= nvl(al, to_date(3333333, 'j')) --#733
                            and dal <= nvl(p_al, to_date(3333333, 'j'))
                            and nvl(al, to_date(3333333, 'j')) >= p_dal
                            and substr(p_assegnazione_prevalente, 1, 1) =
                                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(id_componente
                                                                                                                                   ,dal))
                                      ,1
                                      ,1))
            and substr(p_assegnazione_prevalente, 1, 1) =
                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                   ,c.dal))
                      ,1
                      ,1);
      exception
         when no_data_found then
            null;
      end;
   end; -- gps_util.ultima_assegnazione
   --------------------------------------------------------------------------------
   procedure chiudi_assegnazione
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni              in p00_dipendenti_soggetti.ni_gp4%type
     ,p_ci              in componenti.ci%type
     ,p_data_cessazione in componenti.al%type
     ,p_ass_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_utente_agg      in componenti.utente_aggiornamento%type
     ,p_data_agg        in componenti.data_aggiornamento%type
   ) is
      /******************************************************************************
             NOME:  chiudi_assegnazione
             DESCRIZIONE: Chiude l'assegnazione del componente identificato dall'ni di p00
             NOTE:  Viene eseguita la chiusura "semplice" del periodo di assegnazione.
              Con essa verranno chiusi anche i ruoli applicativi, per i quali non
              dobbiamo prevedere, in questo caso, alcuna funzione di ripristino o
              ereditarieta'
              Ogni riferimento alle funzioni dal_pubblicazione e al_pubblicazione
              e' stato introdotto con la #548
      ******************************************************************************/
      d_result        afc_error.t_error_number := afc_error.ok;
      d_ottica_ist    ottiche.ottica%type;
      d_ni_as4        as4_anagrafe_soggetti.ni%type;
      d_id_componente componenti.id_componente%type;
      d_dal           componenti.dal%type;
      d_al            componenti.al%type;
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      componente.s_origine_gp            := 1; --#550 #543
      imputazione_bilancio.s_origine_gps := 1; --#594
      d_ottica_ist                       := ottica.get_ottica_per_amm(p_amministrazione);
      d_ni_as4                           := so4gp_pkg.get_id_soggetto_as4(p_ni);
      begin
         --determina i dati dell'ultimo periodo di assegnazione del soggetto
         select c.id_componente
               ,c.dal
               ,c.al
           into d_id_componente
               ,d_dal
               ,d_al
           from componenti c
          where c.ni = d_ni_as4
            and c.ci = p_ci
            and c.ottica = d_ottica_ist
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and substr(p_ass_prevalente, 1, 1) =
                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                   ,c.dal))
                      ,1
                      ,1)
            and c.dal = (select max(dal)
                           from componenti d
                          where d.ni = c.ni
                            and d.ci = c.ci
                            and d.ottica = c.ottica
                            and dal <= nvl(al, to_date(3333333, 'j'))
                            and substr(p_ass_prevalente, 1, 1) =
                                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(d.id_componente
                                                                                                                                   ,d.dal))
                                      ,1
                                      ,1));
      exception
         when no_data_found then
            d_result := s_err_sel_comp_nodataf_number;
         when too_many_rows then
            d_result := s_err_sel_comp_toomanyr_number;
         when others then
            d_result := s_err_select_comp_number;
      end;
      if (d_dal >= p_data_cessazione) then
         --  d_result := s_err_date_cess_number;
         /* Nuova gestione della chiusura del rapporto (#536)
         Chiusura del periodo che comprende la data di cessazione
         Eliminazione logica di tutti i periodi successivi alla data di cessazione
         */
         --chiusura dell'eventuale periodo che comprende la data di cessazione
         update componenti c
            set al                   = p_data_cessazione
               ,utente_aggiornamento = p_utente_agg
               ,data_aggiornamento   = trunc(sysdate)
          where c.ottica = d_ottica_ist
            and c.ci = p_ci
            and nvl(p_data_cessazione, to_date(3333333, 'j')) between c.dal and
                nvl(c.al, to_date(3333333, 'j'))
            and dal <= nvl(al, to_date(3333333, 'j'))
            and exists (select 'x'
                   from attributi_componente
                  where id_componente = c.id_componente
                    and substr(assegnazione_prevalente, 1, 1) =
                        substr(p_ass_prevalente, 1, 1)
                    and dal <= nvl(al, to_date(3333333, 'j')));
         --eliminazione logica di tutti i periodi successivi alla data di cessazione
         revisione_struttura.s_attivazione := 1;
         for comp in (select *
                        from componenti c
                       where c.ottica = d_ottica_ist
                         and c.ci = p_ci
                         and c.dal > p_data_cessazione
                         and dal <= nvl(al, to_date(3333333, 'j'))
                         and exists
                       (select 'x'
                                from attributi_componente
                               where id_componente = c.id_componente
                                 and substr(assegnazione_prevalente, 1, 1) =
                                     substr(p_ass_prevalente, 1, 1)
                                 and nvl(tipo_assegnazione, 'I') = 'I'
                                 and dal <= nvl(al, to_date(3333333, 'j'))))
         loop
            update componenti c
               set al_prec = al
                  ,al_pubb = so4_pkg.al_pubblicazione('E', 'C', comp.al_pubb)
                  ,al      = dal - 1 --(al minore del dal);
             where id_componente = comp.id_componente;
            update attributi_componente
               set al_pubb = so4_pkg.al_pubblicazione('E', 'A', comp.al_pubb)
                  ,al      = dal - 1 --cancellazione logica
             where id_componente = comp.id_componente;
            delete from imputazioni_bilancio where id_componente = comp.id_componente;
            -- elimino logicamente i ruoli e li reinserisco se previsto da registro --#191
            ruolo_componente.s_eliminazione_logica := 1;
            for ruco in (select *
                           from ruoli_componente
                          where id_componente = comp.id_componente
                            and dal <= nvl(al, to_date(3333333, 'j')))
            loop
               update ruoli_componente
                  set al_prec              = al
                     ,al_pubb              = so4_pkg.al_pubblicazione('E'
                                                                     ,'R'
                                                                     ,ruco.al_pubb)
                     ,al                   = dal - 1
                     ,data_aggiornamento   = nvl(p_data_agg, data_aggiornamento)
                     ,utente_aggiornamento = nvl(p_utente_agg, utente_aggiornamento)
                where id_ruolo_componente = ruco.id_ruolo_componente;
            end loop;
         end loop;
         revisione_struttura.s_attivazione      := 0;
         ruolo_componente.s_eliminazione_logica := 0;
      else
         begin
            update componenti c
               set c.al                   = p_data_cessazione
                  ,c.utente_aggiornamento = p_utente_agg
                  ,c.data_aggiornamento   = p_data_agg
             where c.id_componente = d_id_componente;
         exception
            when others then
               d_result := s_err_upd_comp_number;
               s_error_detail(d_result) := chr(10) ||
                                           substr(sqlerrm, instr(sqlerrm, 'ORA-'), 150);
         end;
      end if;
      componente.s_origine_gp            := 0; --#550 #543
      imputazione_bilancio.s_origine_gps := 0; --#594
      --end if;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- gps_util.chiudi_assegnazione
   --------------------------------------------------------------------------------
   function comp_get_unita
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
            NOME:  comp_get_unita
            DESCRIZIONE: Restituisce l'unità organizzativa di assegnazione prevalente del componente
             identificato dal ci
            RITORNA:  Il progressivo dell'UO di assegnazione prevalente oppure il
             codice di errore
            NOTE:
      ******************************************************************************/
      d_ottica_ist    ottiche.ottica%type;
      d_revisione_mod revisioni_struttura.revisione%type;
      d_result        componenti.progr_unita_organizzativa%type;
   begin
      d_ottica_ist    := ottica.get_ottica_per_amm(p_amministrazione);
      d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      begin
         select c.progr_unita_organizzativa
           into d_result
           from componenti           c
               ,attributi_componente a
          where c.id_componente = a.id_componente
            and c.ottica = d_ottica_ist
            and c.ci = p_ci
            and a.assegnazione_prevalente like '1%'
            and p_data between c.dal and
                nvl(decode(c.revisione_cessazione, d_revisione_mod, to_date(null), c.al)
                   ,p_data)
            and p_data between a.dal and
                nvl(decode(a.revisione_cessazione, d_revisione_mod, to_date(null), a.al)
                   ,p_data)
            and nvl(c.revisione_assegnazione, -2) <> d_revisione_mod
            and nvl(a.revisione_assegnazione, -2) <> d_revisione_mod;
      exception
         when no_data_found then
            raise_application_error(s_err_comp_get_unit_ndf_number
                                   ,s_err_comp_get_unit_ndf_msg);
            return s_err_comp_get_unit_ndf_number;
         when too_many_rows then
            raise_application_error(s_err_comp_get_unit_tmr_number
                                   ,s_err_comp_get_unit_tmr_msg);
            return s_err_comp_get_unit_tmr_number;
         when others then
            raise_application_error(s_err_comp_get_unita_number
                                   ,s_err_comp_get_unita_msg);
            return s_err_comp_get_unita_number;
      end;
      return d_result;
   end; -- gps_util.comp_get_unita
   --------------------------------------------------------------------------------
   function comp_get_imputazione
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
   ) return imputazioni_bilancio.numero%type is
      /******************************************************************************
            NOME:  comp_get_imputazione
            DESCRIZIONE: Restituisce l'imputazione contabile del componente identificato dal ci
            RITORNA:  Il valore dell'imputazione contabile oppure il codice di errore
            NOTE:
      ******************************************************************************/
      d_ottica_ist    ottiche.ottica%type;
      d_revisione_mod revisioni_struttura.revisione%type;
      d_id_componente componenti.id_componente%type;
      d_result        imputazioni_bilancio.numero%type;
   begin
      d_ottica_ist    := ottica.get_ottica_per_amm(p_amministrazione);
      d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      begin
         select c.id_componente
           into d_id_componente
           from componenti           c
               ,attributi_componente a
          where c.id_componente = a.id_componente
            and c.ottica = d_ottica_ist
            and c.ci = p_ci
            and a.assegnazione_prevalente like '1%'
            and p_data between c.dal and
                nvl(decode(c.revisione_cessazione, d_revisione_mod, to_date(null), c.al)
                   ,p_data)
            and p_data between a.dal and
                nvl(decode(a.revisione_cessazione, d_revisione_mod, to_date(null), a.al)
                   ,p_data)
            and nvl(c.revisione_assegnazione, -2) <> d_revisione_mod
            and nvl(a.revisione_assegnazione, -2) <> d_revisione_mod;
      exception
         when no_data_found then
            raise_application_error(s_err_comp_get_imp_ndf_number
                                   ,s_err_comp_get_imp_ndf_msg);
            return s_err_comp_get_imp_ndf_number;
         when too_many_rows then
            raise_application_error(s_err_comp_get_imp_tmr_number
                                   ,s_err_comp_get_imp_tmr_msg);
            return s_err_comp_get_imp_tmr_number;
         when others then
            raise_application_error(s_err_comp_get_imputaz_number
                                   ,s_err_comp_get_imputaz_msg);
            return s_err_comp_get_imputaz_number;
      end;
      d_result := imputazione_bilancio.get_imputazione_corrente(d_id_componente, p_data);
      if d_result is null then
         return s_err_comp_get_imputaz_number;
      else
         return d_result;
      end if;
   end; -- gps_util.comp_get_imputazione
   --------------------------------------------------------------------------------
   function comp_get_dati_unita
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ci              in componenti.ci%type
     ,p_data            in date
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  comp_get_dati_unita
            DESCRIZIONE: Restituisce l'unità organizzativa di assegnazione prevalente del componente
             identificato dal ci.
            RITORNA:  Un cursore contenente progressivo, codice e descrizione del'UO
             di assegnazione prevalente per il componente indicato.
            NOTE:
      ******************************************************************************/
      d_progr_uo anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_result   afc.t_ref_cursor;
   begin
      d_progr_uo := comp_get_unita(p_amministrazione => p_amministrazione
                                  ,p_ci              => p_ci
                                  ,p_data            => p_data);
      begin
         open d_result for
            select d_progr_uo
                  ,anagrafe_unita_organizzativa.get_codice_uo(d_progr_uo, p_data)
                  ,anagrafe_unita_organizzativa.get_descrizione(d_progr_uo, p_data)
              from dual;
      exception
         when others then
            raise_application_error(s_err_comp_get_unita_number
                                   ,s_err_comp_get_unita_msg);
      end;
      return d_result;
   end; -- gps_util.comp_get_dati_unita
   --------------------------------------------------------------------------------
   function get_unita_organizzativa_puo
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_progr_unita_org in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            in date
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  get_unita_organizzativa_puo
            DESCRIZIONE: Ritorna un ref_cursor contenente i campi livello, descrizione, icona
             della UO con progressivo specificato.
            RITORNA:  ref_cursor
            NOTE:
      ******************************************************************************/
      d_ottica_ist    ottiche.ottica%type;
      d_revisione_mod revisioni_struttura.revisione%type;
      d_result        afc.t_ref_cursor;
   begin
      d_ottica_ist    := ottica.get_ottica_per_amm(p_amministrazione);
      d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      begin
         open d_result for
            select so4_util.get_livello(u.progr_unita_organizzativa, p_data, u.ottica) as livello
                  ,u.progr_unita_organizzativa
                  ,suddivisione_struttura.get_des_abb(anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                                                      ,p_data)) || ':' ||
                   anagrafe_unita_organizzativa.get_codice_uo(u.progr_unita_organizzativa
                                                             ,p_data) || '-' ||
                   anagrafe_unita_organizzativa.get_descrizione(u.progr_unita_organizzativa
                                                               ,p_data) as descrizione
                  ,suddivisione_struttura.get_icona_standard(anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                                                             ,p_data)) as icona
              from unita_organizzative u
             where u.ottica = d_ottica_ist
               and u.progr_unita_organizzativa = p_progr_unita_org
               and u.revisione != d_revisione_mod
               and p_data between u.dal and nvl(decode(u.revisione_cessazione
                                                      ,d_revisione_mod
                                                      ,to_date(null)
                                                      ,u.al)
                                               ,p_data);
      exception
         when others then
            raise_application_error(s_err_get_uo_number, s_err_get_uo_msg);
      end;
      return d_result;
   end; -- gps_util.get_unita_organizzativa_puo
   --------------------------------------------------------------------------------
   function get_unita_organizzativa_desc
   (
      p_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_descrizione     in varchar2
     ,p_data            in date
   ) return afc.t_ref_cursor is
      /******************************************************************************
            NOME:  get_unita_organizzativa_desc
            DESCRIZIONE:
            RITORNA:
            NOTE:
      ******************************************************************************/
      d_ottica_ist    ottiche.ottica%type;
      d_revisione_mod revisioni_struttura.revisione%type;
      d_result        afc.t_ref_cursor;
   begin
      d_ottica_ist    := ottica.get_ottica_per_amm(p_amministrazione);
      d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      begin
         open d_result for
            select *
              from (select so4_util.get_livello(u.progr_unita_organizzativa
                                               ,p_data
                                               ,u.ottica) as livello
                          ,u.progr_unita_organizzativa
                          ,suddivisione_struttura.get_des_abb(anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                                                              ,p_data)) || ':' ||
                           anagrafe_unita_organizzativa.get_codice_uo(u.progr_unita_organizzativa
                                                                     ,p_data) || '-' ||
                           anagrafe_unita_organizzativa.get_descrizione(u.progr_unita_organizzativa
                                                                       ,p_data) as descrizione
                          ,suddivisione_struttura.get_icona_standard(anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                                                                     ,p_data)) as icona
                          ,so4_util.get_ordinamento(u.progr_unita_organizzativa
                                                   ,p_data
                                                   ,d_ottica_ist
                                                   ,p_amministrazione) as ordinamento
                      from unita_organizzative u
                     where u.ottica = d_ottica_ist
                       and u.revisione != d_revisione_mod
                       and p_data between u.dal and nvl(decode(u.revisione_cessazione
                                                              ,d_revisione_mod
                                                              ,to_date(null)
                                                              ,u.al)
                                                       ,p_data)) struttura
             where struttura.descrizione = p_descrizione;
      exception
         when others then
            raise_application_error(s_err_get_strutt_number, s_err_get_strutt_msg);
      end;
      return d_result;
   end; -- gps_util.get_unita_organizzativa_desc
   --------------------------------------------------------------------------------
   function is_periodo_eliminabile --#748
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
   ) return number is
      /******************************************************************************
       NOME:            is_periodo_eliminabile
       DESCRIZIONE:     Ritorna 1 se il periodo è eliminabile
       NOTE:            Stessi controlli della del_assegnazione
                        Utile per GPs per la Issue 19851
      ******************************************************************************/
      d_result     number(1) := 0;
      d_ottica_ist ottiche.ottica%type;
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      --         valorizza_variabili(d_ottica_ist);
      d_ottica_ist := ottica.get_ottica_per_amm(p_amministrazione);
      begin
         select 1
           into d_result
           from dual
          where exists (select 1
                   from componenti c
                  where c.ottica = d_ottica_ist
                    and c.ci = p_ci
                    and c.dal = p_dal
                    and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                    and c.progr_unita_organizzativa = p_progr_unita_org
                    and substr(p_ass_prevalente, 1, 1) =
                        substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                           ,c.dal))
                              ,1
                              ,1));
      exception
         when no_data_found then
            begin
               select 1
                 into d_result
                 from dual
                where exists (select 1
                         from vista_imputazioni
                        where ci = p_ci
                          and dal = p_dal
                          and ottica = d_ottica_ist
                          and progr_unita_organizzativa = p_progr_unita_org
                          and substr(assegnazione_prevalente, 1, 1) =
                              substr(p_ass_prevalente, 1, 1));
            exception
               when no_data_found then
                  d_result := 0;
            end;
         when too_many_rows then
            d_result := 1;
      end;
      --end if;
      return d_result;
   end;
   --------------------------------------------------------------------------------
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
   ) is
      /******************************************************************************
            NOME:  del_assegnazione
            DESCRIZIONE: Cancella un'assegnazione controllando prima che sia la più
             recente in ordine di tempo in modo da non lasciare buchi
            NOTE:  L'eliminazione del periodo determina la cancellazione logica dei
             ruoli applicativi. Lo stiramento dei periodi di assegnazione contigui,
             deve determinare un analogo stiramento dei relativi ruoli.
             Ogni riferimento alle funzioni dal_pubblicazione e al_pubblicazione
             e' stato introdotto con la #548
      ******************************************************************************/
      d_result         afc_error.t_error_number := afc_error.ok;
      d_ottica_ist     ottiche.ottica%type;
      d_id_componente  componenti.id_componente%type;
      d_stato          componenti.stato%type;
      d_ruoli          number := 0;
      d_al             componenti.al%type;
      d_al_prec        componenti.al%type;
      d_imbi_del       boolean := false; --#594
      d_id_imputazione imputazioni_bilancio.id_imputazione%type;
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      componente.s_origine_gp            := 1; --#550 #543
      imputazione_bilancio.s_origine_gps := 1; --#594
      d_ottica_ist                       := ottica.get_ottica_per_amm(p_amministrazione);
      valorizza_variabili(d_ottica_ist);
      begin
         select c.id_componente
               ,c.stato
               ,c.al
               ,(select count(*)
                  from ruoli_componente
                 where id_componente = c.id_componente)
           into d_id_componente
               ,d_stato
               ,d_al
               ,d_ruoli
           from componenti c
          where c.ottica = d_ottica_ist
            and c.ci = p_ci
            and c.dal = p_dal
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and c.progr_unita_organizzativa = p_progr_unita_org
            and substr(p_ass_prevalente, 1, 1) =
                substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                   ,c.dal))
                      ,1
                      ,1);
      exception
         when no_data_found then
            --#594
            begin
               select id_imputazione
                 into d_id_imputazione
                 from vista_imputazioni
                where ci = p_ci
                  and dal = p_dal
                  and ottica = d_ottica_ist
                  and progr_unita_organizzativa = p_progr_unita_org
                  and substr(assegnazione_prevalente, 1, 1) =
                      substr(p_ass_prevalente, 1, 1);
               d_imbi_del := true;
               imputazione_bilancio.del(d_id_imputazione);
            exception
               when no_data_found then
                  d_result := s_err_del_per_ass_number_ndf;
            end;
            --  return;
         when too_many_rows then
            d_result := s_err_del_per_ass_number_tmr;
            --return;
         when others then
            d_result := s_err_select_comp_number;
            --  return;
      end;
      if d_result = afc_error.ok and not d_imbi_del then
         --#594
         -- eliminazione logica del periodo indicato
         revisione_struttura.s_attivazione := 1;
         update componenti c
            set al_prec = al
               ,al_pubb = so4_pkg.al_pubblicazione('E', 'C', c.al_pubb)
               ,al      = dal - 1 --(al minore del dal)
          where id_componente = d_id_componente;
         update attributi_componente a
            set al_pubb = so4_pkg.al_pubblicazione('E', 'A', a.al_pubb)
               ,al      = dal - 1 --cancellazione logica
          where id_componente = d_id_componente;
         for ruco in (select * from ruoli_componente where id_componente = d_id_componente)
         loop
            ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                      ,s_oggi
                                                      ,p_utente_agg
                                                      ,s_segnalazione_bloccante
                                                      ,s_segnalazione);
         end loop;
         delete from imputazioni_bilancio where id_componente = d_id_componente;
         revisione_struttura.s_attivazione := 0;
         -- assestamento delle date dei periodi contigui
         -- se cancello il primo periodo devo colmare stirando il dal del secondo.
         -- se cancello un periodo dal secondo in poi, si allunga l'al del periodo precedente
         if substr(p_ass_prevalente, 1, 1) = 1 then
            begin
               select 'x'
                 into s_dummy
                 from componenti c
                where c.ottica = d_ottica_ist
                  and c.ci = p_ci
                  and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                  and c.dal < p_dal
                  and nvl(c.al, to_date(3333333, 'J')) = p_dal - 1 -- devo usare il periodo precedente solo
                     -- se contiguo al periodo che sto cancellando
                  and c.dal >= nvl(p_dal_rapporto, c.dal)
                     -- devono appartenere al medesimo rapporto di lavoro
                  and nvl(c.al, to_date(3333333, 'j')) <=
                      nvl(p_al_rapporto, nvl(c.al, to_date(3333333, 'j')))
               --
               ;
               raise too_many_rows;
            exception
               when no_data_found then
                  -- il nostro periodo e' il primo
                  -- determino il periodo successivo a quello eliminato
                  begin
                     select c.id_componente
                       into d_id_componente
                       from componenti c
                      where c.ottica = d_ottica_ist
                        and c.ci = p_ci
                        and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                        and attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                        ,c.dal)) like '1%'
                        and c.dal =
                            (select min(dal)
                               from componenti
                              where ci = p_ci
                                and dal > p_dal
                                and dal <= nvl(al, to_date(3333333, 'j'))
                                and attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(id_componente
                                                                                                                                ,dal)) like '1%');
                     update componenti c
                        set c.dal                  = p_dal
                           ,c.utente_aggiornamento = p_utente_agg
                           ,c.data_aggiornamento   = trunc(sysdate)
                      where c.id_componente = d_id_componente;
                  exception
                     when no_data_found then
                        null;
                  end;
               when too_many_rows then
                  -- il nostro periodo non e' il primo
                  -- determino il periodo precedente a quello eliminato
                  -- per allineare la cessazione
                  select c.id_componente
                        ,c.al
                    into d_id_componente
                        ,d_al_prec
                    from componenti c
                   where c.ottica = d_ottica_ist
                     and c.ci = p_ci
                     and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                     and attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                     ,c.dal)) like '1%'
                     and c.dal =
                         (select max(dal)
                            from componenti
                           where ci = p_ci
                             and dal < p_dal
                             and dal <= nvl(al, to_date(3333333, 'j'))
                             and attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(id_componente
                                                                                                                             ,dal)) like '1%');
                  update componenti c
                     set c.al                   = d_al
                        ,c.utente_aggiornamento = p_utente_agg
                        ,c.data_aggiornamento   = trunc(sysdate)
                   where c.id_componente = d_id_componente;
                  --stira anche i ruoli del componente modificato, se la data di termine concideva con quella del componente #191
                  update ruoli_componente r
                     set al                   = d_al
                        ,utente_aggiornamento = p_utente_agg
                        ,data_aggiornamento   = trunc(sysdate)
                   where id_componente = d_id_componente
                     and nvl(al, to_date(3333333, 'j')) =
                         nvl(d_al_prec, to_date(3333333, 'j'))
                     and dal <= nvl(al, to_date(3333333, 'j'));
            end;
         end if;
      end if;
      componente.s_origine_gp            := 0; --#550 #543
      imputazione_bilancio.s_origine_gps := 0; --#594
      --end if;
      d_imbi_del := false; --#594
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- gps_util.del_assegnazione
   --------------------------------------------------------------------------------
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
   ) is
      /******************************************************************************
            NOME:  rettifica_assegnazione
            DESCRIZIONE: Aggiorna il progressivo dell'unità organizzativa e/o le date del periodo
            NOTE: Ogni riferimento alle funzioni dal_pubblicazione e al_pubblicazione
                  e' stato introdotto con la #548

      ******************************************************************************/
      d_result               afc_error.t_error_number := afc_error.ok;
      d_ottica_ist           ottiche.ottica%type;
      d_ottica_precedente    ottiche.ottica%type;
      d_ni_as4               componenti.ni%type := so4gp_pkg.get_id_soggetto_as4(p_ni);
      d_id_componente        componenti.id_componente%type;
      d_id_componente_new    componenti.id_componente%type;
      d_id_attr_componente   attributi_componente.id_attr_componente%type;
      d_id_ruco              ruoli_componente.id_ruolo_componente%type;
      d_al_precedente        date;
      d_dal_pubb             date;
      d_al_pubb              date;
      d_data_limite          date;
      d_incarico             attributi_componente.incarico%type; --#658
      d_progr_unita_org_prec anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_num_record           number(6);
      w_comp                 componenti%rowtype;
      w_comp_reset           componenti%rowtype;
      w_atco                 attributi_componente%rowtype;
      errore exception;
   begin
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      imputazione_bilancio.s_origine_gps := 1; --#594
      componente.s_origine_gp            := 1; --#550 #543
      d_ottica_ist                       := ottica.get_ottica_per_amm(p_amministrazione);
      d_ottica_precedente                := ottica.get_ottica_per_amm(p_amministrazione_precedente);
      valorizza_variabili(d_ottica_ist);
      begin
         begin
            select c.*
              into w_comp
              from componenti c
             where c.ottica = d_ottica_precedente
               and c.ci = p_ci
               and dal <= nvl(al, to_date(3333333, 'j'))
               and exists (select 'x'
                      from attributi_componente
                     where id_componente = c.id_componente
                       and substr(assegnazione_prevalente, 1, 1) =
                           substr(p_ass_prevalente, 1, 1)
                       and dal <= nvl(al, to_date(3333333, 'j')))
               and c.dal = p_dal_precedente;
            d_id_componente        := w_comp.id_componente;
            d_al_precedente        := w_comp.al;
            d_progr_unita_org_prec := w_comp.progr_unita_organizzativa;
            select a.*
              into w_atco
              from attributi_componente a
             where id_componente = d_id_componente
               and dal <= nvl(al, to_date(3333333, 'j'))
               and dal = (select max(dal)
                            from attributi_componente
                           where id_componente = a.id_componente
                             and dal <= nvl(al, to_date(3333333, 'j')));
         exception
            when no_data_found then
               begin
                  select c.*
                    into w_comp
                    from componenti c
                   where c.ottica = d_ottica_precedente
                     and c.ci = p_ci
                     and dal <= nvl(al, to_date(3333333, 'j'))
                     and exists (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and substr(assegnazione_prevalente, 1, 1) =
                                 substr(p_ass_prevalente, 1, 1)
                             and dal <= nvl(al, to_date(3333333, 'j')))
                     and c.dal <= p_dal
                     and nvl(c.al, to_date(3333333, 'j')) >=
                         nvl(p_al, to_date(3333333, 'j'));

                  begin
                     --#658
                     select incarico
                       into d_incarico
                       from attributi_componente
                      where id_componente = w_comp.id_componente
                        and p_dal between dal and nvl(al, to_date(3333333, 'j'));
                  exception
                     when others then
                        d_incarico := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                        ,'Incarico Default'
                                                                        ,0)
                                         ,'ASS');
                  end;

                  -- su COMPONENTI esiste un periodo che comprende quello rettificato su GPS
                  -- eseguiamo una INS_ASSEGNAZIONE #536
                  gps_util.ins_assegnazione(p_amministrazione         => p_amministrazione
                                           ,p_ni                      => p_ni
                                           ,p_ci                      => p_ci
                                           ,p_progr_unita_org         => p_progr_unita_org
                                           ,p_imputaz_contab          => p_imputaz_contab
                                           ,p_dal                     => p_dal
                                           ,p_al                      => p_al
                                           ,p_incarico                => d_incarico --#658
                                           ,p_assegnazione_prevalente => p_ass_prevalente
                                           ,p_utente_agg              => p_utente_agg
                                           ,p_data_agg                => p_data_agg);
                  d_id_componente := -1;
               exception
                  when no_data_found then
                     d_result := s_err_rett_per_ass_number_ndf;
                     raise errore;
               end;
            when too_many_rows then
               d_result := s_err_rett_per_ass_number_tmr;
               raise errore;
            when others then
               d_result := s_err_select_comp_number;
               raise errore;
         end;
         if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or
            length(s_eredita_ruoli_sudd) <> 0 then
            --#191
            copia_ruoli(p_dal
                       ,to_date(null)
                       ,w_comp.ni
                       ,p_ci
                       ,d_ottica_precedente
                       ,w_atco.assegnazione_prevalente);
         end if;
         if is_componente_modificabile(p_ci, d_ottica_ist, p_dal, p_al) = 'SI' and
            d_id_componente is not null and d_id_componente <> -1 --#658
          then
            revisione_struttura.s_attivazione := 1;
            if d_progr_unita_org_prec <> p_progr_unita_org and
               not
                (p_dal <> p_dal_precedente or nvl(p_al, to_date(3333333, 'j')) <>
                nvl(d_al_precedente, to_date(3333333, 'j'))) then
               -- viene modificata solo la UO: cancello logicamente il periodo e ne introduco uno nuovo
               -- gli eventuali ruoli vengono applicati al nuovo periodo di componenti
               begin
                  -- eliminazione logica del componente rettificato
                  update componenti c
                     set al_prec = al
                        ,al_pubb = so4_pkg.al_pubblicazione('E', 'C', w_comp.al_pubb)
                        ,al      = dal - 1 --(al minore del dal)
                   where id_componente = d_id_componente;
                  update attributi_componente
                     set al_pubb = so4_pkg.al_pubblicazione('E', 'A', w_comp.al_pubb)
                        ,al      = dal - 1 --cancellazione logica
                   where id_componente = d_id_componente;
                  --inserimento del nuovo componente
                  d_id_componente_new := componente.get_id_componente();
                  begin
                     --determina le date di pubblicazione per il nuovo record
                     d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'C', '', w_comp.dal);
                     d_al_pubb  := so4_pkg.al_pubblicazione('I', 'C', '', w_comp.al);
                     componente.ins(p_id_componente             => d_id_componente_new
                                   ,p_progr_unita_organizzativa => p_progr_unita_org
                                   ,p_dal                       => w_comp.dal
                                   ,p_al                        => w_comp.al
                                   ,p_ni                        => w_comp.ni
                                   ,p_ci                        => w_comp.ci
                                   ,p_stato                     => 'P'
                                   ,p_ottica                    => d_ottica_ist
                                   ,p_dal_pubb                  => d_dal_pubb
                                   ,p_al_pubb                   => d_al_pubb
                                   ,p_utente_aggiornamento      => p_utente_agg
                                   ,p_data_aggiornamento        => p_data_agg);
                  exception
                     when others then
                        if substr(sqlerrm, instr(sqlerrm, 'ORA-') + 3, 6) =
                           componente.s_componente_gia_pres_number then
                           d_result := s_componente_gia_pres_number;
                        else
                           d_result := s_err_ins_comp_number;
                        end if;
                  end;
                  if gps_util.check_esiste_attributo(d_id_componente_new, p_dal) then
                     -- attributo già inserito faccio upd
                     d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_componente_new
                                                                                        ,p_dal);
                     update attributi_componente
                        set incarico                = w_atco.incarico
                           ,assegnazione_prevalente = w_atco.assegnazione_prevalente
                           ,tipo_assegnazione       = 'I'
                           ,percentuale_impiego     = 100
                           ,ottica                  = d_ottica_ist
                           ,utente_aggiornamento    = p_utente_agg
                           ,data_aggiornamento      = p_data_agg
                      where id_attr_componente = d_id_attr_componente;
                  else
                     begin
                        attributo_componente.ins(p_id_componente           => d_id_componente_new
                                                ,p_dal                     => p_dal
                                                ,p_al                      => p_al
                                                ,p_incarico                => w_atco.incarico
                                                ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                                ,p_tipo_assegnazione       => 'I'
                                                ,p_percentuale_impiego     => 100
                                                ,p_ottica                  => d_ottica_ist
                                                ,p_dal_pubb                => d_dal_pubb
                                                ,p_al_pubb                 => d_al_pubb
                                                ,p_utente_aggiornamento    => p_utente_agg
                                                ,p_data_aggiornamento      => p_data_agg);
                     exception
                        when others then
                           raise;
                     end;
                  end if;
                  -- elimino logicamente i ruoli e li reinserisco se previsto da registro --#191
                  ruolo_componente.s_eliminazione_logica := 1;
                  for ruco in (select *
                                 from ruoli_componente r
                                where id_componente = d_id_componente
                                  and dal <= nvl(al_prec, to_date(3333333, 'j'))
                                  and ruolo_componente.get_origine(r.id_ruolo_componente) in
                                      ('P', 'S') --#760 #764
                                order by id_ruolo_componente) --#777
                  loop
                     update ruoli_componente
                        set al_prec              = al
                           ,al_pubb              = so4_pkg.al_pubblicazione('E'
                                                                           ,'R'
                                                                           ,ruco.al_pubb)
                           ,al                   = dal - 1
                           ,data_aggiornamento   = nvl(p_data_agg, data_aggiornamento)
                           ,utente_aggiornamento = nvl(p_utente_agg, utente_aggiornamento)
                      where id_ruolo_componente = ruco.id_ruolo_componente
                        and ruco.dal <= nvl(ruco.al, to_date(3333333, 'j')); --#760 #764
                     if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or --#191
                        length(s_eredita_ruoli_sudd) <> 0 then
                        select ruoli_componente_sq.nextval into d_id_ruco from dual;
                        ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                            ,p_id_componente        => d_id_componente_new
                                            ,p_ruolo                => ruco.ruolo
                                            ,p_dal                  => p_dal
                                            ,p_al                   => p_al
                                            ,p_dal_pubb             => d_dal_pubb
                                            ,p_al_pubb              => d_al_pubb
                                            ,p_utente_aggiornamento => p_utente_agg
                                            ,p_data_aggiornamento   => p_data_agg);
                     end if;
                  end loop;
                  -- trasferisce l'imputazione bilancio sul nuovo componente
                  update imputazioni_bilancio --#548
                     set id_componente = d_id_componente_new
                   where id_componente = d_id_componente;
                  ruolo_componente.s_eliminazione_logica := 0;
               end;
            else
               -- modifiche alle date
               begin
                  -- verifica la sovrapposizione dei nuovi estremi con periodi di assegnazione preesistenti
                  begin
                     select count(c.dal)
                       into d_num_record
                       from componenti c
                      where c.ottica = d_ottica_ist
                        and c.ci = p_ci
                        and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                        and c.dal <= nvl(p_al, to_date(3333333, 'j'))
                        and nvl(c.al, to_date(3333333, 'j')) >= p_dal
                        and exists
                      (select 'x'
                               from attributi_componente
                              where id_componente = c.id_componente
                                and substr(assegnazione_prevalente, 1, 1) =
                                    substr(p_ass_prevalente, 1, 1)
                                and dal <= nvl(al, to_date(3333333, 'j')));
                     /* elimino logicamente tutte le registrazioni correlate
                     (attributi, ruoli, ubicazioni, imputazioni)
                     che restano completamente al di fuori dei nuovi estremi
                     */
                     begin
                        update attributi_componente
                           set al_prec = al
                              ,al_pubb = so4_pkg.al_pubblicazione('E'
                                                                 ,'C'
                                                                 ,w_comp.al_pubb)
                              ,al      = dal - 1 --cancellazione logica
                         where id_componente = d_id_componente
                           and dal <= nvl(al, to_date(3333333, 'j'))
                           and nvl(al, to_date(3333333, 'j')) < p_dal;
                        for ruco in (select *
                                       from ruoli_componente
                                      where id_componente = d_id_componente
                                        and dal <= nvl(al, to_date(3333333, 'j'))
                                        and nvl(al, to_date(3333333, 'j')) < p_dal)
                        loop
                           ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                                     ,p_data_agg
                                                                     ,p_utente_agg
                                                                     ,s_segnalazione_bloccante
                                                                     ,s_segnalazione);
                        end loop;
                        delete from imputazioni_bilancio
                         where id_componente = d_id_componente
                           and nvl(al, to_date(3333333, 'j')) < p_dal;
                        delete from ubicazioni_componente
                         where id_componente = d_id_componente
                           and nvl(al, to_date(3333333, 'j')) < p_dal;
                        update attributi_componente
                           set al_prec = al
                              ,al      = dal - 1 --cancellazione logica
                              ,al_pubb = so4_pkg.al_pubblicazione('E'
                                                                 ,'C'
                                                                 ,w_comp.al_pubb)
                         where id_componente = d_id_componente
                           and dal > nvl(p_al, to_date(3333333, 'j'));
                        delete from imputazioni_bilancio
                         where id_componente = d_id_componente
                           and dal > nvl(p_al, to_date(3333333, 'j'));
                        delete from ubicazioni_componente
                         where id_componente = d_id_componente
                           and dal > nvl(p_al, to_date(3333333, 'j'));
                        for ruco in (select *
                                       from ruoli_componente
                                      where id_componente = d_id_componente
                                        and dal > nvl(p_al, to_date(3333333, 'j')))
                        loop
                           ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                                     ,p_data_agg
                                                                     ,p_utente_agg
                                                                     ,s_segnalazione_bloccante
                                                                     ,s_segnalazione);
                        end loop;
                     end;
                     if d_num_record in (0, 1) then
                        begin
                           if p_progr_unita_org = d_progr_unita_org_prec then
                              --  UO non modificata
                              --revisione_struttura.s_attivazione := 0; --#191
                              revisione_struttura.s_attivazione := 1; --#714
                              update componenti c
                                 set c.dal                  = p_dal
                                    ,c.dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                                       ,'C'
                                                                                       ,w_comp.dal_pubb
                                                                                       ,p_dal
                                                                                       ,c.dal)
                                    ,c.al                   = p_al
                                    ,c.al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                                      ,'C'
                                                                                      ,w_comp.al_pubb
                                                                                      ,p_al
                                                                                      ,c.al)
                                    ,c.utente_aggiornamento = p_utente_agg
                                    ,c.data_aggiornamento   = p_data_agg
                               where c.id_componente = d_id_componente;
                              update ruoli_componente r
                                 set r.dal                  = p_dal
                                    ,r.dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                                       ,'C'
                                                                                       ,w_comp.dal_pubb
                                                                                       ,p_dal
                                                                                       ,r.dal)
                                    ,r.al                   = p_al
                                    ,r.al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                                      ,'C'
                                                                                      ,w_comp.al_pubb
                                                                                      ,p_al
                                                                                      ,r.al)
                                    ,r.utente_aggiornamento = p_utente_agg
                                    ,r.data_aggiornamento   = p_data_agg
                               where r.id_componente = d_id_componente;
                              /*update componenti c
                                 set c.dal      = p_dal
                                    ,c.dal_pubb = so4_pkg.dal_pubblicazione('U'
                                                                           ,'C'
                                                                           ,w_comp.dal_pubb
                                                                           ,p_dal
                                                                           ,c.dal)
                                     --  ,c.progr_unita_organizzativa = p_progr_unita_org
                                    ,c.utente_aggiornamento = p_utente_agg
                                    ,c.data_aggiornamento   = p_data_agg
                               where c.id_componente = d_id_componente;
                              update componenti c
                                 set c.al                   = p_al
                                    ,c.al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                                      ,'C'
                                                                                      ,w_comp.al_pubb
                                                                                      ,p_al
                                                                                      ,c.al)
                                    ,c.utente_aggiornamento = p_utente_agg
                                    ,c.data_aggiornamento   = p_data_agg
                               where c.id_componente = d_id_componente;*/
                              revisione_struttura.s_attivazione := 0; --#714
                           else
                              -- UO modificata : eliminazione logica del periodo ed inserimento del componente sulla nuova UO
                              begin
                                 update componenti c
                                    set al_prec = al
                                       ,al_pubb = so4_pkg.al_pubblicazione('E'
                                                                          ,'C'
                                                                          ,c.al_pubb)
                                       ,al      = dal - 1 --(al minore del dal)
                                  where id_componente = d_id_componente;
                                 update attributi_componente a
                                    set al_pubb = so4_pkg.al_pubblicazione('E'
                                                                          ,'A'
                                                                          ,a.al_pubb)
                                       ,al      = dal - 1 --cancellazione logica
                                  where id_componente = d_id_componente;
                                 --inserimento del nuovo componente
                                 d_id_componente_new := componente.get_id_componente();
                                 begin
                                    --determina le date di pubblicazione per il nuovo record
                                    d_dal_pubb := so4_pkg.dal_pubblicazione('I'
                                                                           ,'C'
                                                                           ,''
                                                                           ,p_dal);
                                    d_al_pubb  := so4_pkg.al_pubblicazione('I'
                                                                          ,'C'
                                                                          ,''
                                                                          ,p_al);
                                    componente.ins(p_id_componente             => d_id_componente_new
                                                  ,p_progr_unita_organizzativa => p_progr_unita_org
                                                  ,p_dal                       => p_dal
                                                  ,p_al                        => p_al
                                                  ,p_ni                        => w_comp.ni
                                                  ,p_ci                        => w_comp.ci
                                                  ,p_stato                     => 'P'
                                                  ,p_ottica                    => d_ottica_ist
                                                  ,p_dal_pubb                  => d_dal_pubb
                                                  ,p_al_pubb                   => d_al_pubb
                                                  ,p_utente_aggiornamento      => p_utente_agg
                                                  ,p_data_aggiornamento        => p_data_agg);
                                 exception
                                    when others then
                                       if substr(sqlerrm, instr(sqlerrm, 'ORA-') + 3, 6) =
                                          componente.s_componente_gia_pres_number then
                                          d_result := s_componente_gia_pres_number;
                                       else
                                          d_result := s_err_ins_comp_number;
                                       end if;
                                 end;
                                 if gps_util.check_esiste_attributo(d_id_componente_new
                                                                   ,p_dal) then
                                    -- attributo già inserito faccio upd
                                    d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_componente_new
                                                                                                       ,p_dal);
                                    update attributi_componente
                                       set incarico                = w_atco.incarico
                                          ,assegnazione_prevalente = w_atco.assegnazione_prevalente
                                          ,tipo_assegnazione       = 'I'
                                          ,percentuale_impiego     = 100
                                          ,ottica                  = d_ottica_ist
                                          ,utente_aggiornamento    = p_utente_agg
                                          ,data_aggiornamento      = p_data_agg
                                     where id_attr_componente = d_id_attr_componente;
                                 else
                                    begin
                                       attributo_componente.ins(p_id_componente           => d_id_componente_new
                                                               ,p_dal                     => p_dal
                                                               ,p_al                      => p_al
                                                               ,p_incarico                => w_atco.incarico
                                                               ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                                               ,p_tipo_assegnazione       => 'I'
                                                               ,p_percentuale_impiego     => 100
                                                               ,p_ottica                  => d_ottica_ist
                                                               ,p_dal_pubb                => d_dal_pubb
                                                               ,p_al_pubb                 => d_al_pubb
                                                               ,p_utente_aggiornamento    => p_utente_agg
                                                               ,p_data_aggiornamento      => p_data_agg);
                                    exception
                                       when others then
                                          raise;
                                    end;
                                 end if;
                                 -- trasporto le imputazioni sul nuovo componente
                                 update imputazioni_bilancio
                                    set id_componente = d_id_componente_new
                                       ,dal           = p_dal
                                       ,al            = p_al
                                  where id_componente = d_id_componente;
                                 -- elimino logicamente i ruoli e li reinserisco se previsto da registro --#191
                                 ruolo_componente.s_eliminazione_logica := 1;
                                 for ruco in (select *
                                                from ruoli_componente
                                               where id_componente = d_id_componente
                                                 and dal <= nvl(al, to_date(3333333, 'j')))
                                 loop
                                    update ruoli_componente
                                       set al_prec              = al
                                          ,al_pubb              = so4_pkg.al_pubblicazione('E'
                                                                                          ,'R'
                                                                                          ,ruco.al_pubb)
                                          ,al                   = dal - 1
                                          ,data_aggiornamento   = nvl(p_data_agg
                                                                     ,data_aggiornamento)
                                          ,utente_aggiornamento = nvl(p_utente_agg
                                                                     ,utente_aggiornamento)
                                     where id_ruolo_componente = ruco.id_ruolo_componente;
                                    if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or --#191
                                       length(s_eredita_ruoli_sudd) <> 0 then
                                       select ruoli_componente_sq.nextval
                                         into d_id_ruco
                                         from dual;
                                       ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                                           ,p_id_componente        => d_id_componente_new
                                                           ,p_ruolo                => ruco.ruolo
                                                           ,p_dal                  => p_dal
                                                           ,p_al                   => p_al
                                                           ,p_dal_pubb             => d_dal_pubb
                                                           ,p_al_pubb              => d_al_pubb
                                                           ,p_utente_aggiornamento => p_utente_agg
                                                           ,p_data_aggiornamento   => p_data_agg);
                                    end if;
                                 end loop;
                                 ruolo_componente.s_eliminazione_logica := 0;
                              end;
                           end if;
                           -- assestamento degli estremi dei periodi adiacenti
                           update componenti c
                              set c.dal                  = p_al + 1
                                 ,c.dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                                    ,'C'
                                                                                    ,c.dal_pubb
                                                                                    ,(p_al + 1)
                                                                                    ,c.dal)
                                 ,c.utente_aggiornamento = p_utente_agg
                                 ,c.data_aggiornamento   = p_data_agg
                            where c.ottica = d_ottica_ist
                              and c.ci = p_ci
                              and c.dal = d_al_precedente + 1
                              and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                              and exists
                            (select 'x'
                                     from attributi_componente
                                    where id_componente = c.id_componente
                                      and substr(assegnazione_prevalente, 1, 1) =
                                          substr(p_ass_prevalente, 1, 1)
                                      and dal <= nvl(al, to_date(3333333, 'j')));
                           update componenti c
                              set al                     = p_dal - 1
                                 ,c.al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                                   ,'C'
                                                                                   ,c.al_pubb
                                                                                   ,(p_dal - 1)
                                                                                   ,c.al)
                                 ,c.utente_aggiornamento = p_utente_agg
                                 ,c.data_aggiornamento   = p_data_agg
                            where c.ottica = d_ottica_ist
                              and c.ci = p_ci
                              and c.al = p_dal_precedente - 1
                              and p_dal <> p_dal_precedente --#48986
                              and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                              and exists
                            (select 'x'
                                     from attributi_componente
                                    where id_componente = c.id_componente
                                      and substr(assegnazione_prevalente, 1, 1) =
                                          substr(p_ass_prevalente, 1, 1)
                                      and dal <= nvl(al, to_date(3333333, 'j')));
                        end;
                     elsif d_num_record > 1 then
                        -- spezziamo le registrazioni che includono gli estremi e modifichiamo tutte quelle comprese
                        -- determiniamo il record che contiene la data di inizio del periodo di modifica
                        begin
                           select c.*
                             into w_comp
                             from componenti c
                            where c.ottica = d_ottica_ist
                              and c.ci = p_ci
                              and p_dal between c.dal and
                                  nvl(c.al, to_date(3333333, 'j'))
                              and dal <= nvl(al, to_date(3333333, 'j'))
                              and exists
                            (select 'x'
                                     from attributi_componente
                                    where id_componente = c.id_componente
                                      and substr(assegnazione_prevalente, 1, 1) =
                                          substr(p_ass_prevalente, 1, 1)
                                      and dal <= nvl(al, to_date(3333333, 'j')));
                        exception
                           when no_data_found then
                              if p_dal_precedente > p_dal then
                                 -- caso dell'anticipo del primo periodo con gia' presenti periodi successivi
                                 select c.*
                                   into w_comp
                                   from componenti c
                                  where c.ottica = d_ottica_ist
                                    and c.ci = p_ci
                                    and dal <= nvl(al, to_date(3333333, 'j'))
                                    and exists
                                  (select 'x'
                                           from attributi_componente
                                          where id_componente = c.id_componente
                                            and substr(assegnazione_prevalente, 1, 1) =
                                                substr(p_ass_prevalente, 1, 1)
                                            and dal <= nvl(al, to_date(3333333, 'j')))
                                    and c.dal =
                                        (select min(dal)
                                           from componenti c1
                                          where c1.ottica = d_ottica_ist
                                            and c1.ci = p_ci
                                            and dal <= nvl(al, to_date(3333333, 'j'))
                                            and c1.dal > p_dal
                                            and exists
                                          (select 'x'
                                                   from attributi_componente
                                                  where id_componente = c1.id_componente
                                                    and substr(assegnazione_prevalente
                                                              ,1
                                                              ,1) =
                                                        substr(p_ass_prevalente, 1, 1)
                                                    and dal <=
                                                        nvl(al, to_date(3333333, 'j'))));
                              end if;
                        end;
                        update componenti c
                           set al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                              ,'C'
                                                                              ,c.al_pubb
                                                                              ,(p_dal - 1)
                                                                              ,c.al)
                              ,al                   = p_dal - 1
                              ,utente_aggiornamento = p_utente_agg
                              ,data_aggiornamento   = trunc(sysdate)
                         where c.id_componente = w_comp.id_componente
                           and c.dal <= p_dal - 1;

                        if p_progr_unita_org <> d_progr_unita_org_prec then
                           -- UO modificata, eliminazione logica del componente rettificato
                           begin
                              update componenti c
                                 set al_prec = al
                                    ,al_pubb = so4_pkg.al_pubblicazione('E'
                                                                       ,'C'
                                                                       ,c.al_pubb)
                                    ,al      = dal - 1 --(al minore del dal)
                               where id_componente = d_id_componente;
                              update attributi_componente a
                                 set al_pubb = so4_pkg.al_pubblicazione('E'
                                                                       ,'A'
                                                                       ,a.al_pubb)
                                    ,al      = dal - 1 --cancellazione logica
                               where id_componente = d_id_componente;
                              --inserimento del nuovo componente
                              d_id_componente_new := componente.get_id_componente();
                              begin
                                 --determina le date di pubblicazione per il nuovo record
                                 d_dal_pubb := so4_pkg.dal_pubblicazione('I'
                                                                        ,'C'
                                                                        ,''
                                                                        ,p_dal);
                                 d_al_pubb  := so4_pkg.al_pubblicazione('I'
                                                                       ,'C'
                                                                       ,''
                                                                       ,d_al_precedente);
                                 componente.ins(p_id_componente             => d_id_componente_new
                                               ,p_progr_unita_organizzativa => p_progr_unita_org
                                               ,p_dal                       => p_dal
                                               ,p_al                        => d_al_precedente
                                               ,p_ni                        => w_comp.ni
                                               ,p_ci                        => w_comp.ci
                                               ,p_stato                     => 'P'
                                               ,p_ottica                    => d_ottica_ist
                                               ,p_dal_pubb                  => d_dal_pubb
                                               ,p_al_pubb                   => d_al_pubb
                                               ,p_utente_aggiornamento      => p_utente_agg
                                               ,p_data_aggiornamento        => p_data_agg);
                              exception
                                 when others then
                                    if substr(sqlerrm, instr(sqlerrm, 'ORA-') + 3, 6) =
                                       componente.s_componente_gia_pres_number then
                                       d_result := s_componente_gia_pres_number;
                                    else
                                       d_result := s_err_ins_comp_number;
                                    end if;
                              end;
                              if gps_util.check_esiste_attributo(d_id_componente_new
                                                                ,p_dal) then
                                 -- attributo già inserito faccio upd
                                 d_id_attr_componente := attributo_componente.get_id_attr_componente(d_id_componente_new
                                                                                                    ,p_dal);
                                 update attributi_componente
                                    set incarico                = w_atco.incarico
                                       ,assegnazione_prevalente = w_atco.assegnazione_prevalente
                                       ,tipo_assegnazione       = 'I'
                                       ,percentuale_impiego     = 100
                                       ,ottica                  = d_ottica_ist
                                       ,utente_aggiornamento    = p_utente_agg
                                       ,data_aggiornamento      = p_data_agg
                                  where id_attr_componente = d_id_attr_componente;
                              else
                                 begin
                                    attributo_componente.ins(p_id_componente           => d_id_componente_new
                                                            ,p_dal                     => p_dal
                                                            ,p_al                      => d_al_precedente
                                                            ,p_incarico                => w_atco.incarico
                                                            ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                                            ,p_tipo_assegnazione       => 'I'
                                                            ,p_percentuale_impiego     => 100
                                                            ,p_ottica                  => d_ottica_ist
                                                            ,p_dal_pubb                => d_dal_pubb
                                                            ,p_al_pubb                 => d_al_pubb
                                                            ,p_utente_aggiornamento    => p_utente_agg
                                                            ,p_data_aggiornamento      => p_data_agg);
                                 exception
                                    when others then
                                       raise;
                                 end;
                              end if;
                              -- trasporto le imputazioni sul nuovo componente
                              update imputazioni_bilancio
                                 set id_componente = d_id_componente_new
                                    ,dal           = p_dal
                                    ,al            = d_al_precedente
                               where id_componente = d_id_componente;
                              -- elimino logicamente i ruoli e li reinserisco se previsto da registro --#191
                              ruolo_componente.s_eliminazione_logica := 1;
                              for ruco in (select *
                                             from ruoli_componente
                                            where id_componente = d_id_componente
                                              and dal <= nvl(al, to_date(3333333, 'j')))
                              loop
                                 update ruoli_componente
                                    set al_prec              = al
                                       ,al_pubb              = so4_pkg.al_pubblicazione('E'
                                                                                       ,'R'
                                                                                       ,ruco.al_pubb)
                                       ,al                   = dal - 1
                                       ,data_aggiornamento   = nvl(p_data_agg
                                                                  ,data_aggiornamento)
                                       ,utente_aggiornamento = nvl(p_utente_agg
                                                                  ,utente_aggiornamento)
                                  where id_ruolo_componente = ruco.id_ruolo_componente;
                                 if s_eredita_ruoli <> 'NO' or s_ruoli_skema <> 'NO' or --#191
                                    length(s_eredita_ruoli_sudd) <> 0 then
                                    select ruoli_componente_sq.nextval
                                      into d_id_ruco
                                      from dual;
                                    ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                                        ,p_id_componente        => d_id_componente_new
                                                        ,p_ruolo                => ruco.ruolo
                                                        ,p_dal                  => p_dal
                                                        ,p_al                   => d_al_precedente
                                                        ,p_dal_pubb             => d_dal_pubb
                                                        ,p_al_pubb              => d_al_pubb
                                                        ,p_utente_aggiornamento => p_utente_agg
                                                        ,p_data_aggiornamento   => p_data_agg);
                                 end if;
                              end loop;
                              ruolo_componente.s_eliminazione_logica := 0;
                           end;
                        else
                           -- UO invariata, modifico solo il dal
                           update componenti c
                              set dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                                  ,'C'
                                                                                  ,w_comp.dal_pubb
                                                                                  ,p_dal
                                                                                  ,p_dal_precedente)
                                 ,dal                  = p_dal
                                 ,utente_aggiornamento = p_utente_agg
                                 ,data_aggiornamento   = trunc(sysdate)
                            where c.id_componente = d_id_componente;
                        end if;

                        -------------------------------------------------------------------------------------------------------------------

                        --determiniamo il record che contiene la data di fine del periodo di modifica
                        begin
                           select c.*
                             into w_comp
                             from componenti c
                            where c.ottica = d_ottica_ist
                              and c.ci = p_ci
                              and nvl(p_al, to_date(3333333, 'j')) between c.dal and
                                  nvl(c.al, to_date(3333333, 'j'))
                              and dal <= nvl(al, to_date(3333333, 'j'))
                              and exists
                            (select 'x'
                                     from attributi_componente
                                    where id_componente = c.id_componente
                                      and substr(assegnazione_prevalente, 1, 1) =
                                          substr(p_ass_prevalente, 1, 1)
                                      and dal <= nvl(al, to_date(3333333, 'j')));
                        exception
                           when no_data_found then
                              /*#714 la nuova data di termine non e' contenuta in alcun preesistente periodo
                                     svuota la variabile w_comp
                              */
                              w_comp := w_comp_reset;
                        end;

                        update componenti c
                           set dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                               ,'C'
                                                                               ,c.dal_pubb
                                                                               ,nvl(p_al
                                                                                   ,to_date(3333333
                                                                                           ,'j')) + 1
                                                                               ,c.dal)
                              ,al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                              ,'C'
                                                                              ,c.al_pubb
                                                                              ,c.al
                                                                              ,c.al)
                              ,dal                  = nvl(p_al, to_date(3333333, 'j')) + 1
                              ,utente_aggiornamento = p_utente_agg
                              ,data_aggiornamento   = trunc(sysdate)
                         where c.id_componente = w_comp.id_componente
                           and nvl(c.al, to_date(3333333, 'j')) >=
                               nvl(p_al, to_date(3333333, 'j')) + 1;

                        -- eliminazione logica dei periodi_inclusi
                        for comp in (select *
                                       from componenti c
                                      where c.ottica = d_ottica_ist
                                        and c.ci = p_ci
                                        and c.id_componente not in
                                            (d_id_componente
                                            ,nvl(d_id_componente_new, d_id_componente))
                                        and c.dal >= p_dal
                                        and nvl(c.al, to_date(3333333, 'j')) <=
                                            nvl(p_al, to_date(3333333, 'j'))
                                        and dal <= nvl(al, to_date(3333333, 'j'))
                                        and exists
                                      (select 'x'
                                               from attributi_componente
                                              where id_componente = c.id_componente
                                                and substr(assegnazione_prevalente, 1, 1) =
                                                    substr(p_ass_prevalente, 1, 1)
                                                and nvl(tipo_assegnazione, 'I') = 'I'
                                                and dal <= nvl(al, to_date(3333333, 'j'))))
                        loop

                           update componenti c
                              set al_prec = al
                                 ,al      = dal - 1 --(al minore del dal)
                                 ,al_pubb = so4_pkg.al_pubblicazione('E', 'C', c.al_pubb)
                            where id_componente = comp.id_componente;
                           update attributi_componente a
                              set al      = dal - 1 --cancellazione logica
                                 ,al_pubb = so4_pkg.al_pubblicazione('E', 'A', a.al_pubb)
                            where id_componente = comp.id_componente;
                           delete from imputazioni_bilancio --#548
                            where id_componente = comp.id_componente;
                           -- elimino logicamente i ruoli e li reinserisco se previsto da registro --#191
                           ruolo_componente.s_eliminazione_logica := 1;
                           for ruco in (select *
                                          from ruoli_componente
                                         where id_componente = comp.id_componente
                                           and dal <= nvl(al, to_date(3333333, 'j')))
                           loop
                              update ruoli_componente
                                 set al_prec              = al
                                    ,al                   = dal - 1
                                    ,al_pubb              = so4_pkg.al_pubblicazione('E'
                                                                                    ,'R'
                                                                                    ,ruco.al_pubb)
                                    ,data_aggiornamento   = nvl(p_data_agg
                                                               ,data_aggiornamento)
                                    ,utente_aggiornamento = nvl(p_utente_agg
                                                               ,utente_aggiornamento)
                               where id_ruolo_componente = ruco.id_ruolo_componente;
                           end loop;
                           ruolo_componente.s_eliminazione_logica := 0;
                        end loop;
                        -- determina il limite massimo del periodo di pubblicazione del record da modificare
                        if nvl(p_al, to_date(3333333, 'j')) < s_oggi then
                           begin
                              select al_pubb
                                into d_data_limite
                                from componenti
                               where id_componente =
                                     nvl(d_id_componente_new, d_id_componente);
                           exception
                              when no_data_found then
                                 d_data_limite := to_date(null);
                           end;
                        else
                           begin
                              select min(dal_pubb - 1)
                                into d_data_limite
                                from componenti c
                               where c.ottica = d_ottica_ist
                                 and c.ci = p_ci
                                 and c.id_componente not in
                                     (d_id_componente
                                     ,nvl(d_id_componente_new, d_id_componente))
                                 and nvl(p_al, to_date(3333333, 'j')) >= c.dal_pubb
                                 and dal_pubb <= nvl(al_pubb, to_date(3333333, 'j'))
                                 and exists
                               (select 'x'
                                        from attributi_componente
                                       where id_componente = c.id_componente
                                         and substr(assegnazione_prevalente, 1, 1) =
                                             substr(p_ass_prevalente, 1, 1)
                                         and nvl(tipo_assegnazione, 'I') = 'I'
                                         and dal_pubb <=
                                             nvl(al_pubb, to_date(3333333, 'j')));
                           exception
                              when no_data_found then
                                 d_data_limite := to_date(null);
                           end;
                        end if;
                        -- #537 spostata l'update dopo l'eliminazione dei periodi inclusi
                        update componenti c
                           set al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                              ,'C'
                                                                              ,c.al_pubb
                                                                              ,p_al
                                                                              ,c.al
                                                                              ,d_data_limite
                                                                              ,1)
                              ,al                   = p_al
                              ,utente_aggiornamento = p_utente_agg
                              ,data_aggiornamento   = trunc(sysdate)
                         where c.id_componente =
                               nvl(d_id_componente_new, d_id_componente);
                     end if;
                  end;
               end;
            end if;
            revisione_struttura.s_attivazione := 0;
         elsif d_id_componente = -1 then
            --#658
            null;
         else
            -- componente gia' interessato dalla revisione in modifica
            d_result := s_componente_in_mod_number;
         end if;
         --tratta le eventuali assegnazioni funzionali preesistenti sulla stessa UO #588
         tratta_assegnazioni_funzionali(d_ottica_ist
                                       ,d_ni_as4
                                       ,p_progr_unita_org
                                       ,p_dal
                                       ,p_al
                                       ,p_utente_agg
                                       ,p_data_agg);
      exception
         when others then
            s_error_detail(d_result) := chr(10) || ' ' || substr(sqlerrm, 1, 150);
            raise errore;
      end;
      componente.s_origine_gp            := 0; --#550 #543
      imputazione_bilancio.s_origine_gps := 0; --#594
      --end if;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   exception
      when errore then
         raise_application_error(s_err_upd_comp_number
                                ,error_message(s_err_upd_comp_number) || ' : ' ||
                                 s_error_detail(d_result));
   end; -- gps_util.rettifica_assegnazione
   --------------------------------------------------------------------------------
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
   ) is
      /******************************************************************************
            NOME:  rettifica_incarico
            DESCRIZIONE: Aggiorna l'incarico dell'attributo componente
            NOTE:  La modifica viene eseguita anche sulle assegnazioni definitive.
                   Ogni riferimento alle funzioni dal_pubblicazione e al_pubblicazione
                   e' stato introdotto con la #548
      ******************************************************************************/
      d_result     afc_error.t_error_number := afc_error.ok;
      d_ottica_ist ottiche.ottica%type;
      w_atco       attributi_componente%rowtype;
      d_num_record number(8);
      d_dal_pubb   attributi_componente.dal_pubb%type;
      d_al_pubb    attributi_componente.al_pubb%type;
   begin
      revisione_struttura.s_attivazione := 1; --#716
      --if is_dipendente_componente(p_ci) = 'SI' then #31549
      componente.s_origine_gp := 1; --#550 #543
      d_ottica_ist            := ottica.get_ottica_per_amm(p_amministrazione);
      valorizza_variabili(d_ottica_ist);
      select count(a.dal)
        into d_num_record
        from attributi_componente a
            ,componenti           c
       where c.id_componente = a.id_componente
         and c.ottica = d_ottica_ist
         and c.ci = p_ci
         and a.dal <= nvl(a.al, to_date(3333333, 'j'))
         and c.dal <= nvl(c.al, to_date(3333333, 'j'))
         and a.dal <= nvl(p_al, to_date(3333333, 'j'))
         and nvl(a.al, to_date(3333333, 'j')) >= p_dal
         and exists (select 'x'
                from attributi_componente
               where id_componente = c.id_componente
                 and dal <= nvl(al, to_date(3333333, 'j'))
                 and substr(assegnazione_prevalente, 1, 1) =
                     substr(p_ass_prevalente, 1, 1));
      if d_num_record = 0 then
         -- non ci sono registrazioni da modificare
         d_result := s_err_rett_inc_no_rec_number;
         return;
      elsif d_num_record = 1 then
         --determino il record di attributi_componente interessato dalla modifica
         select a.*
           into w_atco
           from attributi_componente a
               ,componenti           c
          where c.id_componente = a.id_componente
            and c.ottica = d_ottica_ist
            and c.ci = p_ci
            and a.dal <= nvl(a.al, to_date(3333333, 'j'))
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and a.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(a.al, to_date(3333333, 'j')) >= p_dal
            and exists (select 'x'
                   from attributi_componente
                  where id_componente = c.id_componente
                    and substr(assegnazione_prevalente, 1, 1) =
                        substr(p_ass_prevalente, 1, 1)
                    and dal <= nvl(al, to_date(3333333, 'j')));
         if p_incarico <> w_atco.incarico then
            -- coincidenti per dal
            if p_dal = w_atco.dal and
               nvl(p_al, to_date(3333333, 'j')) < nvl(w_atco.al, to_date(3333333, 'j')) then
               update attributi_componente a
                  set incarico             = p_incarico
                     ,al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                     ,'A'
                                                                     ,a.al_pubb
                                                                     ,p_al
                                                                     ,a.al)
                     ,al                   = p_al
                     ,utente_aggiornamento = p_utente_agg
                     ,data_aggiornamento   = trunc(sysdate)
                where a.id_attr_componente = w_atco.id_attr_componente;
               d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'A', '', (p_al + 1));
               d_al_pubb  := so4_pkg.al_pubblicazione('I', 'A', '', w_atco.al);
               attributo_componente.ins(p_id_componente           => w_atco.id_componente
                                       ,p_dal                     => p_al + 1
                                       ,p_al                      => w_atco.al
                                       ,p_incarico                => w_atco.incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                       ,p_tipo_assegnazione       => w_atco.tipo_assegnazione
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => w_atco.ottica
                                       ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                       ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_dal_pubb                => d_dal_pubb
                                       ,p_al_pubb                 => d_al_pubb
                                       ,p_utente_aggiornamento    => p_utente_agg
                                       ,p_data_aggiornamento      => trunc(sysdate)
                                       ,p_voto                    => w_atco.voto);
            elsif nvl(p_al, to_date(3333333, 'j')) =
                  nvl(w_atco.al, to_date(3333333, 'j')) and p_dal > w_atco.dal then
               --coincidenti per data di fine
               update attributi_componente a
                  set incarico             = p_incarico
                     ,dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                      ,'A'
                                                                      ,a.dal_pubb
                                                                      ,p_dal
                                                                      ,a.dal)
                     ,dal                  = p_dal
                     ,utente_aggiornamento = p_utente_agg
                     ,data_aggiornamento   = trunc(sysdate)
                where a.id_attr_componente = w_atco.id_attr_componente;
               d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'A', '', w_atco.dal);
               d_al_pubb  := so4_pkg.al_pubblicazione('I', 'A', '', (p_dal - 1));
               attributo_componente.ins(p_id_componente           => w_atco.id_componente
                                       ,p_dal                     => w_atco.dal
                                       ,p_al                      => p_dal - 1
                                       ,p_incarico                => w_atco.incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                       ,p_tipo_assegnazione       => w_atco.tipo_assegnazione
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => w_atco.ottica
                                       ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                       ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_dal_pubb                => d_dal_pubb
                                       ,p_al_pubb                 => d_al_pubb
                                       ,p_utente_aggiornamento    => p_utente_agg
                                       ,p_data_aggiornamento      => trunc(sysdate)
                                       ,p_voto                    => w_atco.voto);
            elsif nvl(p_al, to_date(3333333, 'j')) <
                  nvl(w_atco.al, to_date(3333333, 'j')) and p_dal > w_atco.dal then
               --periodo completamente incluso
               update attributi_componente a
                  set incarico             = p_incarico
                     ,dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                      ,'A'
                                                                      ,a.dal_pubb
                                                                      ,p_dal
                                                                      ,a.dal)
                     ,al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                     ,'A'
                                                                     ,a.al_pubb
                                                                     ,p_al
                                                                     ,a.al)
                     ,dal                  = p_dal
                     ,al                   = p_al
                     ,utente_aggiornamento = p_utente_agg
                     ,data_aggiornamento   = trunc(sysdate)
                where a.id_attr_componente = w_atco.id_attr_componente;
               d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'A', '', w_atco.dal);
               d_al_pubb  := so4_pkg.al_pubblicazione('I', 'A', '', (p_dal - 1));
               attributo_componente.ins(p_id_componente           => w_atco.id_componente
                                       ,p_dal                     => w_atco.dal
                                       ,p_al                      => p_dal - 1
                                       ,p_incarico                => w_atco.incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                       ,p_tipo_assegnazione       => w_atco.tipo_assegnazione
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => w_atco.ottica
                                       ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                       ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_dal_pubb                => d_dal_pubb
                                       ,p_al_pubb                 => d_al_pubb
                                       ,p_utente_aggiornamento    => p_utente_agg
                                       ,p_data_aggiornamento      => trunc(sysdate)
                                       ,p_voto                    => w_atco.voto);
               d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'A', '', (p_al + 1));
               d_al_pubb  := so4_pkg.al_pubblicazione('I', 'A', '', w_atco.al);
               attributo_componente.ins(p_id_componente           => w_atco.id_componente
                                       ,p_dal                     => p_al + 1
                                       ,p_al                      => w_atco.al
                                       ,p_incarico                => w_atco.incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                       ,p_tipo_assegnazione       => w_atco.tipo_assegnazione
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => w_atco.ottica
                                       ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                       ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_dal_pubb                => d_dal_pubb
                                       ,p_al_pubb                 => d_al_pubb
                                       ,p_utente_aggiornamento    => p_utente_agg
                                       ,p_data_aggiornamento      => trunc(sysdate)
                                       ,p_voto                    => w_atco.voto);
               --periodo coincidente
            elsif nvl(p_al, to_date(3333333, 'j')) =
                  nvl(w_atco.al, to_date(3333333, 'j')) and p_dal = w_atco.dal then
               update attributi_componente a
                  set incarico             = p_incarico
                     ,utente_aggiornamento = p_utente_agg
                     ,data_aggiornamento   = trunc(sysdate)
                where a.id_attr_componente = w_atco.id_attr_componente;
            end if;
         end if;
      elsif d_num_record > 1 then
         -- spezziamo le registrazioni che includono gli estremi e modifichiamo tutte quelle comprese
         -- determiniamo il record che contiene la data di inizio del periodo di modifica
         select a.*
           into w_atco
           from attributi_componente a
               ,componenti           c
          where c.id_componente = a.id_componente
            and c.ottica = d_ottica_ist
            and c.ci = p_ci
            and a.dal <= nvl(a.al, to_date(3333333, 'j'))
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and p_dal between a.dal and nvl(a.al, to_date(3333333, 'j'))
            and substr(assegnazione_prevalente, 1, 1) = substr(p_ass_prevalente, 1, 1);
         if p_incarico <> w_atco.incarico then
            if w_atco.dal <= p_dal - 1 then
               update attributi_componente a
                  set al_pubb              = so4_pkg.al_pubblicazione('U'
                                                                     ,'A'
                                                                     ,a.al_pubb
                                                                     ,(p_dal - 1)
                                                                     ,a.al)
                     ,al                   = p_dal - 1
                     ,utente_aggiornamento = p_utente_agg
                     ,data_aggiornamento   = trunc(sysdate)
                where a.id_attr_componente = w_atco.id_attr_componente;
               d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'A', '', p_dal);
               d_al_pubb  := so4_pkg.al_pubblicazione('I', 'A', '', w_atco.al);
               attributo_componente.ins(p_id_componente           => w_atco.id_componente
                                       ,p_dal                     => p_dal
                                       ,p_al                      => w_atco.al
                                       ,p_incarico                => p_incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                       ,p_tipo_assegnazione       => w_atco.tipo_assegnazione
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => w_atco.ottica
                                       ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                       ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_dal_pubb                => d_dal_pubb
                                       ,p_al_pubb                 => d_al_pubb
                                       ,p_utente_aggiornamento    => p_utente_agg
                                       ,p_data_aggiornamento      => trunc(sysdate)
                                       ,p_voto                    => w_atco.voto);
            end if;
         end if;
         --determiniamo il record che contiene la data di fine del periodo di modifica
         select a.*
           into w_atco
           from attributi_componente a
               ,componenti           c
          where c.id_componente = a.id_componente
            and c.ottica = d_ottica_ist
            and c.ci = p_ci
            and a.dal <= nvl(a.al, to_date(3333333, 'j'))
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and nvl(p_al, to_date(3333333, 'j')) between a.dal and
                nvl(a.al, to_date(3333333, 'j'))
            and substr(assegnazione_prevalente, 1, 1) = substr(p_ass_prevalente, 1, 1);
         if p_incarico <> w_atco.incarico then
            if nvl(w_atco.al, to_date(3333333, 'j')) >=
               nvl(p_al, to_date(3333333, 'j')) + 1 then
               update attributi_componente a
                  set dal_pubb             = so4_pkg.dal_pubblicazione('U'
                                                                      ,'A'
                                                                      ,a.dal_pubb
                                                                      ,(p_al + 1)
                                                                      ,a.dal)
                     ,dal                  = p_al + 1
                     ,utente_aggiornamento = p_utente_agg
                     ,data_aggiornamento   = trunc(sysdate)
                where a.id_attr_componente = w_atco.id_attr_componente;
               d_dal_pubb := so4_pkg.dal_pubblicazione('I', 'A', '', w_atco.dal);
               d_al_pubb  := so4_pkg.al_pubblicazione('I', 'A', '', p_al);
               attributo_componente.ins(p_id_componente           => w_atco.id_componente
                                       ,p_dal                     => w_atco.dal
                                       ,p_al                      => p_al
                                       ,p_incarico                => p_incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => w_atco.assegnazione_prevalente
                                       ,p_tipo_assegnazione       => w_atco.tipo_assegnazione
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => w_atco.ottica
                                       ,p_revisione_assegnazione  => w_atco.revisione_assegnazione
                                       ,p_revisione_cessazione    => w_atco.revisione_cessazione
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_dal_pubb                => d_dal_pubb
                                       ,p_al_pubb                 => d_al_pubb
                                       ,p_utente_aggiornamento    => p_utente_agg
                                       ,p_data_aggiornamento      => trunc(sysdate)
                                       ,p_voto                    => w_atco.voto);
            end if;
         end if;
         -- periodi_inclusi
         update attributi_componente a
            set a.incarico             = p_incarico
               ,a.utente_aggiornamento = p_utente_agg
               ,a.data_aggiornamento   = p_data_agg
          where id_componente in
                (select id_componente
                   from componenti
                  where ci = p_ci
                    and ottica = d_ottica_ist
                    and dal <= nvl(al, to_date(3333333, 'j'))
                    and dal <= nvl(p_al, to_date(3333333, 'j'))
                    and nvl(al, to_date(3333333, 'j')) >= p_dal)
            and a.dal >= p_dal
            and nvl(a.al, to_date(3333333, 'j')) <= nvl(p_al, to_date(3333333, 'j'))
            and a.incarico <> p_incarico
            and substr(p_ass_prevalente, 1, 1) = substr(a.assegnazione_prevalente, 1, 1)
            and a.incarico <> p_incarico;
      end if;
      componente.s_origine_gp := 0; --#550 #543
      --end if;
      revisione_struttura.s_attivazione := 0; --#716
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- gps_util.rettifica_incarico
   --------------------------------------------------------------------------------
   function get_ultima_revisione(p_amministrazione in amministrazioni.codice_amministrazione%type)
      return revisioni_struttura.revisione%type is
      d_result number;
   begin
      begin
         select max(revisione)
           into d_result
           from revisioni_struttura
          where ottica = (select ottica
                            from ottiche
                           where ottica_istituzionale = 'SI'
                             and amministrazione = p_amministrazione)
            and stato = 'A';
      exception
         when no_data_found then
            d_result := -1;
      end;
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function get_assegnazioni_revisioni
   (
      p_da_revisione revisioni_struttura.revisione%type
     ,p_a_revisione  revisioni_struttura.revisione%type
   ) return t_ref_cursor is
      /******************************************************************************
            NOME:  get_assegnazioni_revisioni
            DESCRIZIONE: Dato un range di revisioni, restituisce tutte le assegnazioni
             eseguite nell'ambito delle revisioni interessate
            RITORNA:  t_ref_cursor
      ******************************************************************************/
      d_result t_ref_cursor;
   begin
      open d_result for
         select c.ci
               ,c.dal
               ,c.al
               ,c.progr_unita_organizzativa settore
               ,c.revisione_assegnazione
               ,c.revisione_cessazione
               ,r.tipo_registro
               ,r.anno
               ,r.numero
               ,attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                            ,c.dal)) assegnazione_prevalente
           from componenti          c
               ,revisioni_struttura r
          where c.revisione_assegnazione between p_da_revisione and p_a_revisione
            and c.revisione_assegnazione = r.revisione
            and r.ottica in (select ottica
                               from ottiche o
                              where ottica_istituzionale = 'SI'
                                and so4gp_pkg.is_struttura_integrata(o.amministrazione, '') = 'SI' --#429
                             )
          order by ci
                  ,dal;
      --
      return d_result;
      --
   end get_assegnazioni_revisioni;
   --------------------------------------------------------------------------------
   function get_assegnazioni_periodo
   (
      p_ci  in componenti.ci%type
     ,p_dal in componenti.dal%type
     ,p_al  in componenti.al%type
   ) return t_ref_cursor is
      /******************************************************************************
            NOME:  get_assegnazioni_periodo
            DESCRIZIONE: Dato un periodo, restituisce tutte le assegnazioni
             eseguite nell'ambito del periodo interessato
            RITORNA:  t_ref_cursor
      ******************************************************************************/
      d_result t_ref_cursor;
   begin
      open d_result for
         select c.ci
               ,greatest(c.dal, p_dal) dal
               ,least(nvl(c.al, to_date(3333333, 'j')), nvl(p_al, to_date(3333333, 'j'))) al
               ,c.progr_unita_organizzativa settore
               ,nvl(unita_organizzativa.get_progr_unita(so4_util.unita_get_gerarchia_giuridico(c.progr_unita_organizzativa
                                                                                              ,c.ottica
                                                                                              ,c.dal))
                   ,c.progr_unita_organizzativa) settore_giuridico
               ,substr(attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(c.id_componente
                                                                                                                   ,c.dal))
                      ,1
                      ,1) assegnazione_prevalente
               ,c.revisione_assegnazione
               ,revisione_struttura.get_tipo_registro(c.ottica, c.revisione_assegnazione) tipo_registro
               ,revisione_struttura.get_anno(c.ottica, c.revisione_assegnazione) anno
               ,revisione_struttura.get_numero(c.ottica, c.revisione_assegnazione) numero
           from componenti c
          where c.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(c.al, to_date(3333333, 'j')) >= p_dal
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and ci = p_ci
            and c.ottica in (select ottica
                               from ottiche o
                              where ottica_istituzionale = 'SI'
                                and so4gp_pkg.is_struttura_integrata(o.amministrazione, '') = 'SI' --#429
                             )
          order by ci
                  ,dal;
      --
      return d_result;
      --
   end get_assegnazioni_periodo;
   --------------------------------------------------------------------------------
   function get_settore_giuridico_comp(p_id_componente componenti.id_componente%type)
      return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
   begin
      return nvl(unita_organizzativa.get_progr_unita(so4_util.unita_get_gerarchia_giuridico(componente.get_progr_unita_organizzativa(p_id_componente)
                                                                                           ,componente.get_ottica(p_id_componente)
                                                                                           ,componente.get_dal(p_id_componente)))
                ,componente.get_progr_unita_organizzativa(p_id_componente));
   end;
   --------------------------------------------------------------------------------
   function revisione_get_dal
   (
      p_revisione       revisioni_struttura.revisione%type
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return date is
      /******************************************************************************
            nome:  revisione_get_dal
            descrizione: la data di attivazione della revisione
            parametri:p_revisionenumero della revisione da trattare
             p_amministrazioneamministrazione di riferimento.
            ritorna:  date data di attivazione della revisione
            revisioni:
            rev.  data  autore descrizione
            ----  ----------  --------  ----------------------------------------------------
            00012/04/2011  MMprima emissione.
      ******************************************************************************/
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type := to_date(null);
   begin
      if p_amministrazione is not null then
         d_ottica := ottica.get_ottica_per_amm(p_amministrazione);
         d_data   := revisione_struttura.get_dal(d_ottica, p_revisione);
      else
         null;
         begin
            select min(dal)
              into d_data
              from revisioni_struttura r
             where revisione = p_revisione
               and ottica in
                   (select ottica from ottiche where ottica_istituzionale = 'SI');
         exception
            when no_data_found then
               raise_application_error(-20999
                                      ,'Impossibile determinare la data di validita'' della revisione');
         end;
      end if;
      if d_data is null then
         return to_date('');
         raise_application_error(-20999
                                ,'Impossibile determinare la data di validita'' della revisione');
      else
         return d_data;
      end if;
   end; -- so4_util.revisione_get_dal
   --------------------------------------------------------------------------------
   function get_assegnazioni_imputazioni
   (
      p_ci              in componenti.ci%type
     ,p_dal             in componenti.dal%type
     ,p_al              in componenti.al%type
     ,p_assegnazione    in attributi_componente.assegnazione_prevalente%type
     ,p_ni              in componenti.ni%type default null --#31549
     ,p_amministrazione in amministrazioni.codice_amministrazione%type default null
   ) return t_ref_cursor is
      /******************************************************************************
            NOME:  get_assegnazioni_imputazioni
            DESCRIZIONE: Dato un periodo, restituisce tutte le assegnazioni
             eseguite nell'ambito del periodo interessato considerando le
             storicita' delle imputazioni a bilancio
            RITORNA:  t_ref_cursor
      ******************************************************************************/
      d_result t_ref_cursor;
      d_ottica ottiche.ottica%type := ottica.get_ottica_per_amm(p_amministrazione);
   begin
      open d_result for
         select c.ci
               ,greatest(c.dal, p_dal) dal
               ,least(nvl(c.al, to_date(3333333, 'j')), nvl(p_al, to_date(3333333, 'j'))) al
               ,c.settore
               ,c.assegnazione_prevalente
               ,c.sede
               ,c.tipo_registro
               ,c.anno
               ,c.numero
           from (select nvl(imbi.dal, comp.dal) dal
                       ,nvl(imbi.al, comp.al) al
                       ,comp.ci
                       ,comp.progr_unita_organizzativa settore
                       ,attributo_componente.get_assegnazione_prevalente(attributo_componente.get_id_attr_componente(comp.id_componente
                                                                                                                    ,nvl(imbi.dal
                                                                                                                        ,comp.dal))) assegnazione_prevalente
                       ,imbi.numero sede
                       ,revisione_struttura.get_tipo_registro(comp.ottica
                                                             ,comp.revisione_assegnazione) tipo_registro
                       ,revisione_struttura.get_anno(comp.ottica
                                                    ,comp.revisione_assegnazione) anno
                       ,revisione_struttura.get_numero(comp.ottica
                                                      ,comp.revisione_assegnazione) numero
                   from componenti           comp
                       ,imputazioni_bilancio imbi
                  where comp.id_componente = imbi.id_componente(+)
                    and comp.ottica = nvl(d_ottica, comp.ottica)
                    and comp.dal <= nvl(comp.al, to_date(3333333, 'j'))
                    and comp.ottica in
                        (select ottica
                           from ottiche o
                          where ottica_istituzionale = 'SI'
                            and so4gp_pkg.is_struttura_integrata(o.amministrazione, '') = 'SI' --#429
                         )) c
          where c.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(c.al, to_date(3333333, 'j')) >= p_dal
            and ci = p_ci
            and nvl(substr(assegnazione_prevalente, 1, 1), 1) =
                substr(p_assegnazione, 1, 1)
          order by ci
                  ,dal;
      --
      return d_result;
      --
   end get_assegnazioni_imputazioni;
   --------------------------------------------------------------------------------
   procedure valorizza_variabili(p_ottica in componenti.ottica%type) is
      /******************************************************************************
            NOME:  valorizza_variabili
            DESCRIZIONE: Valorizza le variabili globali con i parametri dei registri
            NOTE:
      ******************************************************************************/
   begin
      s_eredita_ruoli      := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                ,'EreditaRuoli'
                                                                ,0)
                                 ,'NO');
      s_ruoli_skema        := nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                                                ,'AcquisizioneRuoliDaGP4'
                                                                ,0)
                                 ,'NO');
      s_eredita_ruoli_sudd := registro_utility.leggi_stringa('PRODUCTS/SI4SO/' ||
                                                             p_ottica
                                                            ,'Ereditarieta ruoli'
                                                            ,0);
      s_revisione_mod      := revisione_struttura.get_revisione_mod(p_ottica);
      if s_ruoli_skema = 'SI' then
         s_progetti_ruoli := nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                                               ,'ProgettiRuoliDaGP4'
                                                               ,0)
                                ,'x');
         s_moduli_ruoli   := nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                                               ,'ModuliRuoliDaGP4'
                                                               ,0)
                                ,'x');
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure ripristina_ruoli
   (
      p_ni                        componenti.ni%type
     ,p_ci                        componenti.ci%type
     ,p_ottica                    componenti.ottica%type
     ,p_dal                       date
     ,p_al                        date
     ,p_dal_comp                  componenti.dal%type
     ,p_al_comp                   componenti.al%type
     ,p_progr_unita_organizzativa componenti.progr_unita_organizzativa%type
     ,p_id_componente             componenti.id_componente%type
     ,p_utente_aggiornamento      componenti.utente_aggiornamento%type
     ,p_data_aggiornamento        componenti.data_aggiornamento%type
   ) is
      d_id_ruco  ruoli_componente.id_ruolo_componente%type;
      d_dal_pubb ruoli_componente.dal_pubb%type;
      d_al_pubb  ruoli_componente.al_pubb%type;
   begin
      -- #191
      ruolo_componente.s_eliminazione_logica := 1;
      for ruco in (select r.*
                         ,(select 'SI'
                             from ad4_ruoli
                            where ruolo = r.ruolo
                              and (modulo like '%' || s_moduli_ruoli || ',%')
                               or progetto like '%' || s_progetti_ruoli || ',%') progetto_modulo_ok
                         ,greatest(p_dal, r.dal) dal_ruolo
                         ,decode(least(nvl(p_al, to_date(3333333, 'j'))
                                      ,nvl(r.al, to_date(3333333, 'j')))
                                ,to_date(3333333, 'j')
                                ,to_date(null)
                                ,least(nvl(p_al, to_date(3333333, 'j'))
                                      ,nvl(r.al, to_date(3333333, 'j')))) al_ruolo
                         ,decode(r.progr_unita_organizzativa
                                ,p_progr_unita_organizzativa
                                ,'SI'
                                ,'NO') uo_ruolo_ok
                         ,(select dal_pubb
                             from componenti
                            where id_componente = p_id_componente) dal_pubb_comp
                         ,(select al_pubb
                             from componenti
                            where id_componente = p_id_componente) al_pubb_comp
                     from ruoli_componente_temp r
                    where ni = p_ni
                      and (ci = p_ci or p_ci is null)
                      and ottica = p_ottica
                      and dal <= nvl(p_al, to_date(3333333, 'j'))
                      and nvl(al, to_date(3333333, 'j')) >= p_dal
                    order by r.ruolo
                            ,r.dal)
      loop
         begin
            --inserisce il ruolo applicativo, in funzione dei registri #191
            if (s_ruoli_skema = 'SI' and nvl(ruco.progetto_modulo_ok, 'NO') = 'SI') or
               s_eredita_ruoli = 'SI' or
               (s_eredita_ruoli = 'UO' and nvl(ruco.uo_ruolo_ok, 'NO') = 'SI') then
               begin
                  select 'x'
                    into s_dummy
                    from ruoli_componente
                   where id_componente in
                         (select id_componente
                            from componenti
                           where ni = p_ni
                             and (ci = p_ci or p_ci is null))
                     and ruolo = ruco.ruolo
                     and dal <= nvl(al, to_date(3333333, 'j'))
                     and nvl(p_al, to_date(3333333, 'j')) between dal and
                         nvl(al, to_date(3333333, 'j'));
               exception
                  when no_data_found then
                     null;
                  when too_many_rows then
                     null;
               end;
               if p_dal_comp > nvl(p_al_comp, to_date(3333333, 'j')) then
                  d_dal_pubb := ruco.dal_ruolo;
                  d_al_pubb  := ruco.al_ruolo;
               else
                  d_dal_pubb := ruco.dal_pubb_comp;
                  d_al_pubb  := ruco.al_pubb_comp;
               end if;
               select ruoli_componente_sq.nextval into d_id_ruco from dual;
               ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                   ,p_id_componente        => p_id_componente
                                   ,p_ruolo                => ruco.ruolo
                                   ,p_dal                  => ruco.dal_ruolo
                                   ,p_al                   => ruco.al_ruolo
                                   ,p_dal_pubb             => d_dal_pubb
                                   ,p_al_pubb              => d_al_pubb
                                   ,p_utente_aggiornamento => p_utente_aggiornamento
                                   ,p_data_aggiornamento   => p_data_aggiornamento);
            end if;
         exception
            when others then
               null;
         end;
      end loop;
      ruolo_componente.s_eliminazione_logica := 0;
   end;
   --------------------------------------------------------------------------------
   function is_componente_modificabile
   (
      p_ci     in componenti.ci%type
     ,p_ottica in componenti.ottica%type
     ,p_dal    in date
     ,p_al     in date
   ) return varchar2 is
      /******************************************************************************
            NOME:  is_componente_modificabile
            DESCRIZIONE: verifica se per l'individuo esistono periodi interessati dall'eventuale
             revisione in modifica.
      ******************************************************************************/
      d_result varchar2(2) := 'SI';
   begin
      --il controllo viene eseguito se i parametri non sono errati ed esiste una revisione in modifica
      if p_dal is not null and p_dal <= nvl(p_al, to_date(3333333, 'j')) and
         s_revisione_mod <> -1 then
         begin
            select 'x'
              into s_dummy
              from dual
             where exists (select 'x'
                      from componenti c
                     where ottica = p_ottica
                       and ci = p_ci
                       and nvl(c.dal, to_date(2222222, 'j')) <=
                           nvl(p_al, to_date(3333333, 'j'))
                       and nvl(c.al, to_date(3333333, 'j')) >= p_dal
                       and (c.revisione_assegnazione = s_revisione_mod or
                           c.revisione_cessazione = s_revisione_mod))
                or exists
             (select 'x'
                      from attributi_componente a
                     where ottica = p_ottica
                       and exists (select 'x'
                              from componenti
                             where id_componente = a.id_componente
                               and ottica = p_ottica
                               and nvl(dal, to_date(2222222, 'j')) <=
                                   nvl(p_al, to_date(3333333, 'j'))
                               and nvl(al, to_date(3333333, 'j')) >= p_dal
                               and ci = p_ci)
                       and (a.revisione_assegnazione = s_revisione_mod or
                           a.revisione_cessazione = s_revisione_mod));
            raise too_many_rows;
         exception
            when too_many_rows then
               -- Il soggetto e' stato modificato nella revisione in modifica di so4.
               -- Accantoniamo la modifica di assegnazione per poterla valutare quando
               -- verra' attivata la revisione.
               d_result := 'NO';
            when no_data_found then
               null;
         end;
      end if;
      return d_result;
   end;
   --------------------------------------------------------------------------------
   procedure copia_ruoli
   (
      p_dal            in date
     ,p_al             in date
     ,p_ni             in componenti.ni%type
     ,p_ci             in componenti.ci%type
     ,p_ottica         in componenti.ottica%type
     ,p_ass_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_progr_uo       in componenti.progr_unita_organizzativa%type default null --#37425
   ) is
      /******************************************************************************
            NOME:  Copia_ruoli
            DESCRIZIONE: registra su tabella temporanea i ruoli in previsti per il componente nel periodo
            NOTE:
      ******************************************************************************/
   begin
      -- #191
      delete from ruoli_componente_temp
       where ni = p_ni
         and (ci = p_ci or p_ci is null);
      for coru in (select c.*
                     from componenti c
                    where nvl(c.al, to_date(3333333, 'j')) >= p_dal
                      and dal <= nvl(p_al, to_date(3333333, 'j'))
                      and ni = p_ni
                      and ((ci = p_ci or p_ci is null) or --#37425
                           (progr_unita_organizzativa = p_progr_uo and
                           p_progr_uo is not null))
                      and c.ottica = p_ottica
                      and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                      and (p_ass_prevalente is null or exists
                           (select 'x'
                              from attributi_componente
                             where id_componente = c.id_componente
                               and substr(assegnazione_prevalente, 1, 1) =
                                   substr(p_ass_prevalente, 1, 1)
                               and dal <= nvl(al, to_date(3333333, 'j')))))
      loop
         for ruco in (select r.*
                        from ruoli_componente r
                       where id_componente = coru.id_componente
                         and so4_pkg.check_ruolo_riservato(r.ruolo) = 0 --#30648
                         and nvl(r.al_pubb, to_date(3333333, 'j')) >= p_dal)
         loop
            insert into ruoli_componente_temp
            values
               (coru.id_componente
               ,coru.ni
               ,nvl(coru.ci, p_ci)
               ,greatest(ruco.dal, p_dal)
               ,least(nvl(ruco.al, to_date(3333333, 'j'))
                     ,nvl(p_al, to_date(3333333, 'j')))
               ,coru.progr_unita_organizzativa
               ,ruco.ruolo
               ,coru.ottica
               ,ruco.dal_pubb
               ,ruco.al_pubb);
         end loop;
      end loop;
   end;

   --------------------------------------------------------------------------------
   --#31549
   /*function is_dipendente_componente(p_ci in componenti.ci%type) return varchar2 is
      d_result   varchar2(2) := 'NO';
      d_rapporto varchar2(8);
   begin
      if p_ci is not null then
         begin
            select rapporto
              into d_rapporto
              from p00_rapporti_individuali
             where ci = p_ci;
            d_result := p00_classi_rapporto_tpk.get_componente(d_rapporto);
         exception
            when no_data_found then
               null;
         end;
      end if;
      return d_result;
   end;*/
   --------------------------------------------------------------------------------
   function get_componenti_uo --#787
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica    ottiche.ottica%type default null
     ,p_data      componenti.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        get_componenti_uo.
       DESCRIZIONE: Dato un codice U.O., restituisce l'elenco (ni - descrizione)
                    dei componenti dell'unita (assegnazioni istituzionali giuridiche)
       PARAMETRI:   p_codice_uo          codice dell'unita organizzativa
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei
                    componenti dell'unita organizzativa separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   30/08/2017  MM        Prima emissione.
      ******************************************************************************/
      d_result afc.t_ref_cursor;
   begin
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select ni
               ,nominativo descrizione
               ,decode(substr(assegnazione_prevalente, 1, 1), '1', 'Q', '9', 'I') rilevanza
               ,so4_util.comp_get_utente(ni) utente
           from vista_assegnazioni c
          where c.codice_uo = p_codice_uo
            and c.ottica = p_ottica
            and nvl(p_data, s_oggi) between c.dal and nvl(c.al, to_date(3333333, 'j'))
          order by decode(c.responsabile, 'SI', 1, 2)
                  ,2
                  ,1;
      --
      return d_result;
      --
   end;
   --------------------------------------------------------------------------------
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
     ,p_ni                        in componenti.ni%type default null --#31549
     ,p_amministrazione           in amministrazioni.codice_amministrazione%type default null
   ) is
      d_result         afc_error.t_error_number := afc_error.ok;
      d_id_imputazione imputazioni_bilancio.id_imputazione%type;
      d_id_componente  componenti.id_componente%type;
      d_ottica         ottiche.ottica%type;
   begin
      --#31549
      if p_ottica is null then
         d_ottica := ottica.get_ottica_per_amm(p_amministrazione);
      else
         d_ottica := p_ottica;
      end if;
      --#594
      imputazione_bilancio.s_origine_gps := 1;
      if p_storicizza is null then
         --rettifica di un periodo specifico
         --determiniamo il componente
         begin
            select id_componente
              into d_id_componente
              from vista_componenti c
             where c.ci = p_ci
               and p_dal between c.dal and nvl(c.al, to_date(3333333, 'j')) -- c.dal = p_dal
               and c.progr_unita_organizzativa = p_progr_unita_organizzativa
               and (p_rilevanza = 'Q' and c.assegnazione_prevalente like '1%' or
                   p_rilevanza = 'I' and c.assegnazione_prevalente = 99);
         exception
            when no_data_found then
               d_result := s_componente_indet_number;
         end;
         if d_result = afc_error.ok then
            --determiniamo l'imputazione bilancio
            begin
               select id_imputazione
                 into d_id_imputazione
                 from imputazioni_bilancio imbi
                where dal = p_dal
                  and id_componente = d_id_componente;
            exception
               when no_data_found then
                  d_id_imputazione := null;
            end;
            --applica l'aggiornamento
            begin
               if d_id_imputazione is null then
                  imputazione_bilancio.ins(null
                                          ,d_id_componente
                                          ,p_imputazione
                                          ,p_dal
                                          ,p_al
                                          ,p_utente_agg
                                          ,trunc(sysdate));
               else
                  update imputazioni_bilancio
                     set numero = p_imputazione
                        ,al     = p_al
                   where id_imputazione = d_id_imputazione;
               end if;
            exception
               when others then
                  d_result := s_imputazione_non_mod_number;
            end;
         end if;
      else
         --#639
         --ricostruzione della storicita' dell'imputazione bilancio per l'intero periodo gps
         --elimino tutti i periodi inclusi tra p_dal e p_al
         delete from imputazioni_bilancio i
          where i.dal >= p_dal
            and nvl(i.al, to_date(3333333, 'j')) <= nvl(p_al, to_date(3333333, 'j'))
            and id_componente in
                (select id_componente
                   from componenti c
                  where ci = p_ci
                    and ottica = nvl(p_ottica, d_ottica)
                    and (p_rilevanza = 'Q' and exists
                         (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente like '1%') or
                         p_rilevanza = 'I' and exists
                         (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente = 99)));
         --rettifico il periodo di imputazione che contiene p_dal
         update imputazioni_bilancio i
            set al = p_dal - 1
          where p_dal between dal and nvl(al, to_date(3333333, 'j'))
            and id_componente in
                (select id_componente
                   from componenti c
                  where ci = p_ci
                    and ottica = nvl(p_ottica, d_ottica)
                    and (p_rilevanza = 'Q' and exists
                         (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente like '1%') or
                         p_rilevanza = 'I' and exists
                         (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente = 99)));
         --rettifico il periodo di imputazione che contiene il p_al #37219
         update imputazioni_bilancio i
            set dal = p_al + 1
          where nvl(p_al, to_date(3333333, 'j')) between dal and
                nvl(al, to_date(3333333, 'j'))
            and id_componente in
                (select id_componente
                   from componenti c
                  where ci = p_ci
                    and ottica = nvl(p_ottica, d_ottica)
                    and (p_rilevanza = 'Q' and exists
                         (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente like '1%') or
                         p_rilevanza = 'I' and exists
                         (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente = 99)));
         --inserisco la nuova imputazione, rispettando i periodi di COMPONENTI
         for comp in (select *
                        from componenti c
                       where ci = p_ci
                         and ottica = nvl(p_ottica, d_ottica)
                         and dal <= nvl(p_al, to_date(3333333, 'j'))
                         and nvl(al, to_date(3333333, 'j')) >= p_dal
                         and dal <= nvl(al, to_date(3333333, 'j'))
                         and (p_rilevanza = 'Q' and exists
                              (select 'x'
                                 from attributi_componente
                                where id_componente = c.id_componente
                                  and assegnazione_prevalente like '1%') or
                              p_rilevanza = 'I' and exists
                              (select 'x'
                                 from attributi_componente
                                where id_componente = c.id_componente
                                  and assegnazione_prevalente = 99))
                       order by dal)
         loop
            --inserisce i nuovi periodi di imputazione sui componenti preesistenti
            imputazione_bilancio.ins(p_id_imputazione => ''
                                    ,p_id_componente  => comp.id_componente
                                    ,p_numero         => p_imputazione
                                    ,p_dal            => p_dal
                                    ,p_al             => p_al
                                    ,p_utente_agg     => p_utente_agg);

         end loop;
      end if;
      imputazione_bilancio.s_origine_gps := 0;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result) || ' ' || sqlerrm);
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure set_inmo --#737
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in ubicazioni_componente.dal%type
   ) is
      d_ci          componenti.ci%type;
      d_ni          p00_rapporti_individuali.ni%type;
      d_progressivo number(8);
      d_statement   afc.t_statement;
      d_dummy       varchar2(1);
   begin
      begin
         select 'x'
           into d_dummy
           from obj
          where object_name = upper('P00_INDIVIDUI_MODIFICATI');
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            begin

               d_ci := componente.get_ci(p_id_componente);

               if d_ci is not null then
                  begin
                     select ni_gp4
                       into d_ni
                       from p00_dipendenti_soggetti d
                      where ni_as4 = componente.get_ni(p_id_componente);
                  exception
                     when no_data_found then
                        d_ni := null;
                     when too_many_rows then
                        d_ni := null;
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in lettura P00_DIPENDENTI_SOGGETTI - ' ||
                                                sqlerrm);
                  end;
                  if d_ni is not null then
                     d_statement := 'begin select p00_inmo_sq.nextval into gps_util.s_result from dual; end;';
                     afc.sql_execute(d_statement);

                     d_progressivo := gps_util.s_result;

                     d_statement := 'insert into p00_individui_modificati' || chr(10) ||
                                    '                     (ni' || chr(10) ||
                                    '                     ,progressivo' || chr(10) ||
                                    '                     ,tabella' || chr(10) ||
                                    '                     ,rilevanza' || chr(10) ||
                                    '                     ,dal' || chr(10) ||
                                    '                     ,operazione' || chr(10) ||
                                    '                     ,utente' || chr(10) ||
                                    '                     ,data_agg' || chr(10) ||
                                    '                     ,ci)' || chr(10) ||
                                    '                  values' || chr(10) ||
                                    '                     (' || d_ni || chr(10) ||
                                    '                     ,' || d_progressivo || chr(10) ||
                                    '                     ,''SEDI_FISICHE''' || chr(10) ||
                                    '                     ,''''' || chr(10) ||
                                    '                     ,to_date( ''' ||
                                    to_char(p_dal, afc.date_format) ||
                                    ''', afc.date_format )' || chr(10) ||
                                    '                     ,''I''' || chr(10) ||
                                    '                     ,''SO4''' || chr(10) ||
                                    '                     ,trunc(sysdate)' || chr(10) ||
                                    '                     ,' || d_ci || ')';

                     afc.sql_execute(d_statement);
                  end if;
               end if;

            end;
      end;
   end set_inmo;
   --------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_err_ins_comp_number) := s_err_ins_comp_msg;
   s_error_table(s_err_ins_imput_bil_number) := s_err_ins_imput_bil_msg;
   s_error_table(s_err_select_comp_number) := s_err_select_comp_msg;
   s_error_table(s_err_date_cess_number) := s_err_date_cess_msg;
   s_error_table(s_err_comp_get_unita_number) := s_err_comp_get_unita_msg;
   s_error_table(s_err_comp_get_imputaz_number) := s_err_comp_get_imputaz_msg;
   s_error_table(s_err_get_strutt_number) := s_err_get_strutt_msg;
   s_error_table(s_err_ins_attr_comp_number) := s_err_ins_attr_comp_msg;
   s_error_table(s_err_upd_comp_number) := s_err_upd_comp_msg;
   s_error_table(s_err_get_uo_number) := s_err_get_uo_msg;
   s_error_table(s_err_del_comp_number) := s_err_del_comp_msg;
   s_error_table(s_err_sel_attr_comp_number) := s_err_sel_attr_comp_msg;
   s_error_table(s_err_upd_attr_number) := s_err_upd_attr_msg;
   s_error_table(s_err_data_comp_number) := s_err_data_comp_msg;
   s_error_table(s_err_stato_comp_number) := s_err_stato_comp_msg;
   s_error_table(s_err_sel_comp_nodataf_number) := s_err_sel_comp_nodataf_msg;
   s_error_table(s_err_sel_comp_toomanyr_number) := s_err_sel_comp_toomanyr_msg;
   s_error_table(s_err_comp_get_unit_ndf_number) := s_err_comp_get_unit_ndf_msg;
   s_error_table(s_err_comp_get_unit_tmr_number) := s_err_comp_get_unit_tmr_msg;
   s_error_table(s_err_comp_get_imp_ndf_number) := s_err_comp_get_imp_ndf_number;
   s_error_table(s_err_comp_get_imp_tmr_number) := s_err_comp_get_imp_tmr_msg;
   s_error_table(s_componente_gia_pres_number) := s_componente_gia_pres_msg;
   s_error_table(s_err_ruoli_comp_number) := s_err_ruoli_comp_msg;
   s_error_table(s_componente_in_mod_number) := s_componente_in_mod_msg;
   s_error_table(s_componente_indet_number) := s_componente_indet_msg;
   s_error_table(s_imputazione_non_mod_number) := s_imputazione_non_mod_msg;
   s_error_table(s_err_del_per_ass_number_ndf) := s_err_del_per_ass_msg_ndf;
   s_error_table(s_err_del_per_ass_number_tmr) := s_err_del_per_ass_msg_tmr;
   s_error_table(s_err_rett_per_ass_number_ndf) := s_err_rett_per_ass_msg_ndf;
   s_error_table(s_err_get_inc_ndf_number) := s_err_get_inc_ndf_msg;
end gps_util;
/


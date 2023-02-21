CREATE OR REPLACE package body so4_util is
   /******************************************************************************
   NOME:        so4_util.
   DESCRIZIONE: Raggruppa le funzioni di supporto per altri applicativi.
   ANNOTAZIONI: .
   REVISIONI: .
   Rev.  Data        Autore  Descrizione.
   000   19/12/2006  VD      Prima emissione.
   001   16/02/2009  VD      Aggiunte funzione get_all_radici e get_all_componenti
   002   27/02/2009  VD      Aggiunta funzione get_allinea_unita
   003   16/03/2009  VD      Aggiunta funzione get_area_unita (CF4)
   004   17/03/2009  VD      Aggiunto parametro p_se_storico in ad4_utente_get_storico_unita
   005   24/03/2009  VD      Aggiunta funzione comp_get_responsabile_gdm
   006   06/04/2009  VD      Aggiunto nvl su revisione componenti
   007   15/07/2009  VD      Modificata funzione get_allinea_unita
   008   12/01/2010  VD      Aggiunta funzione get_utenti_aoo_ruolo_gruppo
   009   10/11/2009  VD      Aggiunta funzione unita_get_ramo
   010   10/01/2010  VD      Aggiunta funzione unita_get_radice
   011   21/01/2010  VD      Aggiunta funzione ruolo_get_componenti_id
   012   02/02/2010  VD      Modificata funzione codice_get_descrizione
   013   11/02/2010  VD      Corretta funzione ad4_utente_get_storico_unita
   014   17/02/2010  SC      Aggiunte funzioni get_ascendenti_sudd e
                             unita_get_ascendenti_sudd
   015   15/04/2010  VD      Modificata funzione get_allinea_unita per
                             ordinamento e vista implicita
                             Modificata ad4_utente_get_unita_storico per
                             selezione ruoli ultima unità chiusa
   016   28/04/2010  VD      Modificata funzione AD4_UTENTE_GET_STORICO_UNITA
                             per gestire correttamente ruoli validi in presenza
                             di revisione in modifica
   017   06/05/2010  VD      Aggiunte funzione AD4_GET_GRUPPO in overloading
                             con parametro progr. unita organizzativa (invece
                             di codice) e funzione DIPENDENTE_GET_APPROVATORE
                             (per gestione corsi CRV)
   018   18/06/2010  AP      Corrette funzioni AD4_UTENTE_GET_UNITA_PREV aggiungendo
                             nvl(c.revisione_assegnazione, 2)
   019   01/07/2010  AP      Aggiunta funzione GET_ORDINAMENTO_2 per estrarre la stringa
                             di ordinamento per la Stampa Struttura Organizzativa
   020   08/07/2010  AP      Aggiunto funzione UNITA_GET_STRINGA_ASCENDENTI per
                             trovare le uo ascendenti fino ad una certa suddivisione
   021   25/08/2010  AP      Modificato funzione GET_STRUTTURA per aggiungere le uo
                             che non contengono componenti (nel caso di esplosione completa)
   022   06/10/2010  AP      Modifica funzione GET_LIVELLO per ottimizzazione query
   023   15/10/2010  VD      Nuova funzione UNITA_GET_ULTIMA_DESCRIZIONE
   024   30/12/2010  VD      Nuova funzione RICERCA_DIPENDENTI (Altran -
                             regione Calabria)
   025   17/01/2011  VD      Aggiunte funzioni UNITA_GET_CODICE_VALIDO e
                             UNITA_GET_DESCR_VALIDA
   026   17/01/2011  VD      Aggiunta funzione GET_ALL_RESPONSABILI
   027   17/02/2011  VD      Ridefinita funzione UNITA_GET_COMPONENTI per
                             parametro progr. UO al posto di codice UO
   028   16/03/2011  VD      Ridefinite funzioni COMP_GET_RUOLI e
                             UNITA_GET_COMPONENTI_NRUOLO per parametro
                             progr. UO al posto di codice UO
   029   12/04/2011  MM      Nuova funzione REVISIONE_GET_DAL: determina la data
                             di attivazione della revisione
   030   23/05/2011  VD      Aggiunto parametro SE_STORICO nelle funzioni
                             unita_get_storico_figlie
                             unita_get_storico_discendenti
                             unita_get_storico_pari_livello
   031   31/08/2011  VD      Nuova funzione UNITA_GET_DAL_VALIDO    
   032   28/09/2011  VD      Nuova funzione GET_ASCENDENTI_CF 
   033   26/10/2011  VD      Corretto nvl(revisione_assegnazione,-2) nella
                             funzione COMP_GET_UNITA_PREV;
                             nuova funzione GET_ASCENDENZA_CF    
   034   13/12/2011  VD      Modifica funzione GET_ALLINEA_UNITA per utilizzo
                             tabella di appoggio     
   035   16/01/2012  VD      Nuove funzioni COMP_GET_ASS_PREV e COMP_GET_RESP_UNICO                                                                           
   036   07/02/2012  VD      Modificata RICERCA_DIPENDENTI: considera tutte le 
                             ottiche istituzionali presenti nella tabella ottiche  
   037   29/02/2012  VD      Nuova funzione IS_SOGGETTO_COMPONENTE   
   038   19/03/2012  VD      Modificate funzioni UNITA_GET_RAMO
                                                 UNITA_GET_UNITA_PADRE
                                                 GET_LIVELLO
                                                 GET_ORDINAMENTO
                                                 GET_ORDINAMENTO_2
                             per gestione parametro tipo data e aggiunte
                             nuove funzioni UNITA_GET_RAMO_EFF
                                            UNITA_GET_UNITA_PADRE_EFF
                                            GET_LIVELLO_EFF
                                            GET_ORDINAMENTO_EFF
                                            GET_ORDINAMENTO2_EFF                                                                                  
   039   02/04/2012  VD      Modificata funzione AD4_UTENTE_GET_STORICO_UNITA  
                             per se_storico = 'N'        
   040   01/10/2012  VD      Modificati test su assegnazione prevalente per
                             valori 11,12,ecc. bug #97
   041   19/11/2012  VD      Modificati test su assegnazione prevalente per
                             incarichi (interim) 
   042   20/11/2012  MM      Redmine bug #131
   043   08/01/2013  VD      Modificata funzione UNITA_GET_RAMO_EFF: ora
                             restituisce la stringa con gli id_elemento separati
                             dal carattere , 
   044   07/02/2013  MM      Redmine bug #182
   045   12/02/2013  AD      Redmine bug #26
   046   09/04/2013  VD      Aggiunte funzioni GET_UNITA_VALIDA e GET_CDR_UNITA
                             (per personalizzazioni contabilita' regione Marche)
   047   03/06/2013  AD      Correzione su controlli nella unita_get_resp_unico_descr 
                             Redmine bug #267  
   048   27/06/2013  VD      Modifica funzione AD4_UTENTE_GET_OTTICA: ora cerca
                             anche ottiche non istituzionali   
   049   09/09/2013  VD      Aggiunto parametro ottica (default null) nelle 
                             funzioni:
                             UTENTE_GET_UTILIZZ
                             UTENTE_GET_GERARCHIA_UNITA
                             UTENTE_GET_GESTIONE
         12/09/2013  AD      Aggiunti alias di colonna nei cursori di ritorno delle
                             funzioni per corretta usabilità a mezzo WS Bug#307
         03/10/2013  MM      Corretta dipendente_get_approvatore Bug#311
    050  27/03/2014  AD      Corretto datatype dei parametri della ricerca_dipendenti
    051  25/06/2014  AD      Corretta AD4_UTENTE_GET_STORICO_UNITA per Bug#460
    052  21/08/2014  MM/AD   Modificata clausola di order by nella funzione 
                             unita_get_componenti_ord per valutare l'incarico di 
                             responsabilita' alla data di riferimento (Bug#487)
    053  19/09/2014  VD      Eliminate condizioni di where non necessarie in
                             query su viste per data pubblicazione 
                     MM      #576, modifiche a unita_get_storico_discendenti
         19/02/2016  MM      #521: nuove funzioni unita_get_numero_componenti e
                             unita_get_numero_assegnazioni
                     MM      #711 - nuovi parametri su comp_get_unita_prev e 
                             dipendente_get_approvatore     
                     MM      #723 - modifiche a get_ordinamento per spezzare la union
    054  08/06/2016  AD      #731 - modifiche unita_get_resp_unico per gestire query
                             per date effettive    
         11/07/2016  MM      #734 - Correzione cursore ad4_utente_get_storico_unita              
    055  14/09/2017  MM      #704 - Correzione ad4_utente_get_unita_partenza              
         06/03/2018  MM      #801 - Import UO in altra ottica              
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '055';
   s_data_limite    constant date := to_date(3333333, 'j');

   function versione return varchar2 is
      /******************************************************************************
      NOME:        versione.
      DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
      RITORNA:     VARCHAR2 stringa contenente versione e revisione.
      NOTE:        Primo numero  : versione compatibilità del Package.
                   Secondo numero: revisione del Package specification.
                   Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;
   -------------------------------------------------------------------------------
   function set_ottica_default
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
   ) return ottiche.ottica%type is
      /******************************************************************************
      NOME:        set_ottica_default
      DESCRIZIONE: Se l'ottica non viene indicata, si assume l'ottica istituzionale
      PARAMETRI:   p_ottica                ottica da trattare
      RITORNA:     ottiche.ottica%type     ottica da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   02/01/2007  VD        Prima emissione.
      001   25/01/2012  VD        Corretta: devono essere presenti o l'ottica o
                                  l'amministrazione
      ******************************************************************************/
      d_result          ottiche.ottica%type;
      d_amministrazione amministrazioni.codice_amministrazione%type;
   begin
      if p_ottica is null and p_amministrazione is null then
         begin
            select codice_amministrazione
              into d_amministrazione
              from amministrazioni
             where ente = 'SI';
         exception
            when others then
               d_amministrazione := null;
               d_result          := null;
         end;
         if d_amministrazione is not null then
            d_result := ottica.get_ottica_per_amm(d_amministrazione);
         end if;
      else
         --
         -- Se l'ottica non è indicata, si assume l'ottica istituzionale
         --
         if p_ottica is null then
            begin
               d_result := ottica.get_ottica_per_amm(p_amministrazione);
            exception
               when others then
                  d_result := null;
            end;
         else
            d_result := p_ottica;
         end if;
      end if;
      --
      return d_result;
   end; -- so4_util.set_ottica_default
   -------------------------------------------------------------------------------
   function set_data_default(p_data unita_organizzative.dal%type)
      return unita_organizzative.dal%type is
      /******************************************************************************
      NOME:        set_data_default
      DESCRIZIONE: Se la data non viene indicata, si assume la data di sistema
      PARAMETRI:   p_data                data a cui eseguire le ricerche e/o
                                         i controlli
      RITORNA:     unita_organizzative.dal%type     data da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   02/01/2007  VD        Prima emissione.
      ******************************************************************************/
      d_result unita_organizzative.dal%type;
   begin
      --
      -- Se la data non è indicata, si assume la data di sistema
      --
      d_result := p_data;
      if d_result is null then
         d_result := trunc(sysdate);
      end if;
      --
      return d_result;
   end;
   -------------------------------------------------------------------------------
   function set_data_default(p_data varchar2) return unita_organizzative.dal%type is
      /******************************************************************************
      NOME:        set_data_default
      DESCRIZIONE: Se la data non viene indicata, si assume la data di sistema
      PARAMETRI:   p_data                data a cui eseguire le ricerche e/o
                                         i controlli
      RITORNA:     unita_organizzative.dal%type     data da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   02/01/2007  VD        Prima emissione.
      ******************************************************************************/
      d_result unita_organizzative.dal%type;
   begin
      --
      -- Se la data non è indicata, si assume la data di sistema
      --
      d_result := to_date(p_data, 'dd/mm/yyyy');
      if d_result is null then
         d_result := trunc(sysdate);
      end if;
      --
      return d_result;
   end;
   -------------------------------------------------------------------------------
   function set_separatore_default
   (
      p_separatore      varchar2
     ,p_tipo_separatore number
   ) return varchar2 is
      /******************************************************************************
      NOME:        set_separatore_default
      DESCRIZIONE: Se il separatore non viene indicato:
                   se tipo_separatore = 1 si assume #
                   se tipo_separatore = 2 si assume [
      PARAMETRI:   p_separatore          carattere separatore
      RITORNA:     varchar2              carattere separatore
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   02/01/2007  VD        Prima emissione.
      ******************************************************************************/
      d_result varchar2(1);
   begin
      --
      -- Se il separatore non è indicato, si assume #
      --
      d_result := p_separatore;
      if d_result is null then
         if p_tipo_separatore = 1 then
            d_result := '#';
         elsif p_tipo_separatore = 2 then
            d_result := '[';
         end if;
      end if;
      --
      return d_result;
   end;
   -------------------------------------------------------------------------------
   function exists_reference
   (
      p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.utente_ad4%type
     ,p_ruolo           ruoli_componente.ruolo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_data            anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return number is
      /******************************************************************************
      NOME:        exists_reference
      DESCRIZIONE: Verifica l'esistenza del ruolo del componente
                   nell'unità
      PARAMETRI:   p_utente                codice utente
                   p_codice_uo             codice gruppo di AD4 dell'unita' organizzativa
                   p_ruolo                 ruolo da ricercare
                   p_ottica                ottica da trattare (facoltativa - se non
                                           indicata si assume l'ottica istituzionale)
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione da trattare (facoltativa -
                                           alternativa all'ottica x la ricerca dell'ottica
                                           istituzionale)
      RITORNA:     number
                   1 : esiste
                   0 : non esiste
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2006  VD        Prima emissione.
      001   25/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     number;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_componente componenti.ni%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Si settano i parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona l'ni di anagrafe_soggetti associato all'utente
      --
      begin
         select soggetto
           into d_componente
           from ad4_utenti_soggetti
          where utente = p_utente;
      exception
         when others then
            d_componente := null;
      end;
      --
      -- Si seleziona il progressivo dell'unita' organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      if d_componente is not null and d_progr_unor is not null then
         begin
            select 1
              into d_result
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.progr_unita_organizzativa = d_progr_unor
               and c.ni = d_componente
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = r.id_componente(+)
               and d_data between nvl(r.dal(+), d_data) and nvl(r.al(+), s_data_limite)
               and nvl(r.ruolo, '*') = nvl(p_ruolo, nvl(r.ruolo, '*'));
         exception
            when others then
               d_result := 0;
         end;
      else
         d_result := 0;
      end if;
      --
      return d_result;
   end; -- so4.util.exists_reference
   -------------------------------------------------------------------------------
   function is_soggetto_componente(p_ni componenti.ni%type) return afc_error.t_error_number is
      /******************************************************************************
      NOME:        is_soggetto_componente
      DESCRIZIONE: Verifica se l'ni del soggetto e' utilizzato nella tabella COMPONENTI
      PARAMETRI:   p_ni                    ni di as4.anagrafe_soggetti
      RITORNA:     number
                   1 : esiste
                   0 : non esiste
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   29/02/2012  VD        Prima emissione.
      001   12/02/2013  AD        Spostato codice in so4ad4_pkg
      ******************************************************************************/
   begin
      return so4ad4_pkg.is_soggetto_componente(p_ni);
   end; -- so4_util.is_soggetto_componente
   -------------------------------------------------------------------------------
   function revisione_get_dal
   (
      p_revisione       revisioni_struttura.revisione%type
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return date is
      /******************************************************************************
      NOME:        revisione_get_dal
      DESCRIZIONE: la data di attivazione della revisione
      PARAMETRI:   p_revisione            numero della revisione da trattare
                   p_amministrazione      amministrazione di riferimento.
      RITORNA:     date                   data di attivazione della revisione
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   12/04/2011  MM        prima emissione.
      001   07/02/2012  VD        Restituisce data di pubblicazione    
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
            select min(data_pubblicazione)
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
         raise_application_error(-20999
                                ,'Impossibile determinare la data di validita'' della revisione');
      else
         return d_data;
      end if;
   end; -- so4_util.revisione_get_dal
   -------------------------------------------------------------------------------
   function ad4_utente_get_dati
   (
      p_utente     ad4_utenti.utente%type
     ,p_separatore varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        ad4_utente_get_dati
       DESCRIZIONE: Dato un utente di AD4, restituisce i dati anagrafici da
                    anagrafe_soggetti di AS4 separati da separatore indicato
       PARAMETRI:   p_utente       Codice utente di AD4
                    p_separatore   Carattere utilizzato come separatore dei dati
                                   nella stringa di output
       RITORNA:     varchar2       Stringa contenente i dati anagrafici
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0     14/12/2006  VD      Prima emissione.
      ******************************************************************************/
      d_result     varchar2(32767);
      d_ni         as4_anagrafe_soggetti.ni%type;
      d_separatore varchar2(1);
   begin
      --
      --    se il separatore non e indicato, si assume #
      --
      d_separatore := set_separatore_default(p_separatore, 1);
      d_result     := '';
      --
      --    si seleziona l'ni del soggetto dalla tabella utenti_soggetti di AD4
      --
      begin
         select min(soggetto) into d_ni from ad4_utenti_soggetti where utente = p_utente;
         if d_ni is null then
            d_result := '*Utente non presente in AD4_utenti_soggetti';
         end if;
      exception
         when others then
            d_ni     := null;
            d_result := '*Errore in lettura AD4_utenti_soggetti - ' || sqlerrm;
      end;
      --
      --    Se e stato trovato l'ni, si selezionano i dati dall'anagrafe soggetti di AS4
      --
      if d_ni is not null then
         begin
            select ni || d_separatore || cognome || d_separatore || nome || d_separatore ||
                   sesso || d_separatore || to_char(data_nas, 'dd/mm/yyyy') ||
                   d_separatore || codice_fiscale || d_separatore
              into d_result
              from as4_anagrafe_soggetti
             where ni = d_ni
               and trunc(sysdate) between dal and nvl(al, s_data_limite);
         exception
            when no_data_found then
               d_result := '*Utente non presente in anagrafe soggetti';
            when others then
               d_result := '*Errore in lettura anagrafe soggetti - ' || sqlerrm;
         end;
      end if;
      return d_result;
   end; -- so4_util.AD4_utente_get_dati
   -------------------------------------------------------------------------------
   function ad4_utente_get_unita_prev(p_utente ad4_utenti.utente%type) return varchar2 is
      /******************************************************************************
       NOME:        AD4_utente_get_unita_prev
       DESCRIZIONE: Dato un utente di AD4, restituisce il gruppo di AD4 abbinato
                    all'unita' di assegnazione prevalente
       PARAMETRI:   p_utente       Codice utente di AD4
       RITORNA:     varchar2       Stringa contenente i dati anagrafici
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione
       002   01/10/2012  VD      Modificato test su assegnazione_prevalente per valori
                                 11, 12, ecc.
      ******************************************************************************/
   begin
      return so4ad4_pkg.ad4_utente_get_unita_prev(p_utente);
   end; -- so4_util.AD4_utente_get_unita_prev
   -------------------------------------------------------------------------------
   function ad4_utente_get_unita_prev
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        AD4_utente_get_unita_prev
       DESCRIZIONE: Dato un utente di AD4 e una data, restituisce il progr. dell'unita'
                    organizzativa di assegnazione prevalente
       PARAMETRI:   p_utente       Codice utente di AD4
                    p_data         Data a cui effettuare la ricerca
       RITORNA:     number         Progr. dell'unita' organizzativa
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   21/10/2009  VD      Prima emissione.
       001   01/10/2012  VD      Modificato test su assegnazione_prevalente per valori
                                 11, 12, ecc.
       002   12/02/2013  AD      Spostato codice in so4ad4_pkg                                 
       003   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result componenti.progr_unita_organizzativa%type;
      d_ni     as4_anagrafe_soggetti.ni%type;
   begin
      --
      --    si seleziona l'ni del soggetto dalla tabella utenti_soggetti di AD4
      --
      begin
         select min(soggetto) into d_ni from ad4_utenti_soggetti where utente = p_utente;
      exception
         when others then
            d_ni := null;
      end;
      --
      --    Se e stato trovato l'ni, si seleziona il progressivo dell'unita'
      --    di assegnazione prevalente
      --
      if d_ni is not null then
         begin
            select progr_unita_organizzativa
              into d_result
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,ottiche         o
             where c.ottica = o.ottica
               and o.ottica_istituzionale = 'SI'
               and c.ni = d_ni
               and trunc(sysdate) between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and trunc(sysdate) between a.dal and nvl(a.al, s_data_limite)
                  --               and nvl(a.assegnazione_prevalente, 0) = 1
               and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%'
               and nvl(a.tipo_assegnazione, 'I') = 'I';
         exception
            when others then
               d_result := null;
         end;
      end if;
      return d_result;
   end; -- so4_util.AD4_utente_get_unita_prev
   -------------------------------------------------------------------------------
   function ad4_utente_get_unita
   (
      p_utente            ad4_utenti.utente%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ad4_utente_get_unita.
       DESCRIZIONE: Dato il codice ed eventualmente il ruolo di un utente, individua 
                    l'ni del componente collegato e restituisce l'elenco
                    (codice-descrizione) delle unita a cui appartiene.
       PARAMETRI:   p_utente             Codice utente di AD4
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo
                                         - se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_se_progr_unita     se valorizzato a SI, il ref_cursor in uscita
                                         contiene anche il progressivo dell'unità
                                         organizzativa
                    p_tipo_assegnazione  Tipo assegnazione da trattare (se non indicato
                                         si assume Istituzionale)                     
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     25/01/2007  SC        Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      --
      if substr(d_dati_utente, 1, 1) <> '*' then
         pos_sep  := instr(d_dati_utente, d_separatore);
         d_ni     := substr(d_dati_utente, 1, pos_sep - 1);
         d_result := comp_get_unita(p_ni                => d_ni
                                   ,p_ruolo             => p_ruolo
                                   ,p_ottica            => p_ottica
                                   ,p_data              => p_data
                                   ,p_se_progr_unita    => p_se_progr_unita
                                   ,p_tipo_assegnazione => p_tipo_assegnazione);
      else
         if p_se_progr_unita = 'SI' then
            open d_result for
               select to_number(null) progr_unita
                     ,null codice_unita
                     ,null descr_unita
                 from dual;
         else
            open d_result for
               select null codice_unita
                     ,null descr_unita
                 from dual;
         end if;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.AD4_utente_get_unita
   -------------------------------------------------------------------------------
   function ad4_utente_get_unita
   (
      p_utente            ad4_utenti.utente%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_se_ordinamento    number
     ,p_se_descrizione    number
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ad4_utente_get_unita.
       DESCRIZIONE: Dato il codice ed eventualmente il ruolo di un utente, individua 
                    l'ni del componente collegato e restituisce l'elenco delle unita 
                    a cui appartiene.
       PARAMETRI:   p_utente             Codice utente di AD4
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo
                                         - se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_se_progr_unita     se valorizzato a SI, il ref_cursor in uscita
                                         contiene anche il progressivo dell'unità
                                         organizzativa
                    p_se_ordinamento     se = 1 significa che il risultato va ordinato
                    p_se_descrizione     se = 1, il ref_cursor contiene anche la descrizione
                                         altrimenti no
                    p_tipo_assegnazione  Tipo assegnazione da trattare (se non indicato
                                         si assume Istituzionale)                     
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     25/01/2007  SC        Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      --
      if substr(d_dati_utente, 1, 1) <> '*' then
         pos_sep  := instr(d_dati_utente, d_separatore);
         d_ni     := substr(d_dati_utente, 1, pos_sep - 1);
         d_result := comp_get_unita(p_ni                => d_ni
                                   ,p_ruolo             => p_ruolo
                                   ,p_ottica            => p_ottica
                                   ,p_data              => p_data
                                   ,p_amministrazione   => null
                                   ,p_se_progr_unita    => p_se_progr_unita
                                   ,p_se_ordinamento    => p_se_ordinamento
                                   ,p_se_descrizione    => p_se_descrizione
                                   ,p_tipo_assegnazione => p_tipo_assegnazione);
      else
         if p_se_progr_unita = 'SI' then
            open d_result for
               select to_number(null) progr_unita
                     ,null codice_unita
                     ,to_date(null) dal
                 from dual;
         else
            open d_result for
               select null codice_unita
                     ,to_date(null) dal
                 from dual;
         end if;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.AD4_utente_get_unita
   -------------------------------------------------------------------------------
   function ad4_utente_get_ruoli
   (
      p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       nome:        ad4_utente_get_ruoli.
       descrizione: dato il codice di un utente, individua l'ni del componente
                    collegato e restituisce l'elenco (codice-descrizione) dei ruoli
                    del componente nell'eventuale unita indicata
       parametri:   p_utente             codice utente di ad4
                    p_codice_uo          codice dell'unita organizzativa (facoltativo -
                                         se non specificato si considerano tutte le unita)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
       ritorna:     afc.t_ref_cursor     ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       revisioni:
       rev.  data        autore    descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     25/01/2007  sc        prima emissione.
       1     26/01/2012  VD        Gestione del componente non identificato
       2     14/06/2012  VD        Gestione parametri ottica e amministrazione
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      --
      if substr(d_dati_utente, 1, 1) <> '*' then
         pos_sep  := instr(d_dati_utente, d_separatore);
         d_ni     := substr(d_dati_utente, 1, pos_sep - 1);
         d_result := comp_get_ruoli(d_ni
                                   ,p_codice_uo
                                   ,p_data
                                   ,p_ottica
                                   ,p_amministrazione);
      else
         open d_result for
            select null ruolo
                  ,null descrizione
              from dual;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.ad4_utente_get_ruoli
   -------------------------------------------------------------------------------
   function ad4_utente_get_ruoli
   (
      p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_se_ordinamento  number
     ,p_se_descrizione  number
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       nome:        ad4_utente_get_ruoli.
       descrizione: dato il codice di un utente, individua l'ni del componente
                    collegato e restituisce l'elenco (codice-descrizione) dei ruoli
                    del componente nell'eventuale unita indicata
       parametri:   p_utente             codice utente di ad4
                    p_codice_uo          codice dell'unita organizzativa (facoltativo -
                                         se non specificato si considerano tutte le unita)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_se_ordinamento     se = 1 significa che il risultato va ordinato
                    p_se_descrizione     se = 1, il ref_cursor contiene anche la descrizione
                                         altrimenti no
       ritorna:     afc.t_ref_cursor     ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       revisioni:
       rev.  data        autore    descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     25/01/2007  sc        prima emissione.
       1     26/01/2012  VD        Gestione del componente non identificato
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      --
      if substr(d_dati_utente, 1, 1) <> '*' then
         pos_sep  := instr(d_dati_utente, d_separatore);
         d_ni     := substr(d_dati_utente, 1, pos_sep - 1);
         d_result := comp_get_ruoli(d_ni
                                   ,p_codice_uo
                                   ,p_data
                                   ,p_ottica
                                   ,p_amministrazione
                                   ,p_se_ordinamento
                                   ,p_se_descrizione);
      else
         open d_result for
            select null ruolo
                  ,null descrizione
              from dual;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.ad4_utente_get_ruoli
   -------------------------------------------------------------------------------
   function ad4_get_gruppo
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return ad4_utenti.utente%type is
      /******************************************************************************
       NOME:        AD4_get_gruppo
       DESCRIZIONE: Dato il codice di una U.O., restituisce il relativo utente di AD4.
       PARAMETRI:   p_codice_UO               Codice della U.O. da trattare
                    p_ottica                  ottica (facoltativa, se non indicata si 
                                              assume l'ottica istituzionale)
                    p_amministrazione         codice amministrazione (falcoltativa, 
                                              se non indicata si assume l'ottica 
                                              istituzionale)
       RITORNA:     ad4_utenti.utente%type    utente AD4 associato alla U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   14/12/2006  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result ad4_utenti.utente%type;
      d_ottica componenti.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      begin
         select utente_ad4
           into d_result
           from vista_pubb_anuo
          where ottica = d_ottica
            and codice_uo = p_codice_uo
            and trunc(sysdate) between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.AD4_get_gruppo;
   -------------------------------------------------------------------------------
   function ad4_get_gruppo
   (
      p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return ad4_utenti.utente%type is
      /******************************************************************************
       NOME:        AD4_get_gruppo
       DESCRIZIONE: Dato il progressivo di una U.O., restituisce il relativo utente
                    di AD4.
       PARAMETRI:   p_progr_unor             Progr. della U.O. da trattare
                    p_ottica                 ottica (facoltativa, se non indicata si
                                             assume l'ottica istituzionale)
       RITORNA:     ad4_utenti.utente%type   utente AD4 associato alla U.O.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   06/05/2010  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result ad4_utenti.utente%type;
      d_ottica componenti.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      begin
         select utente_ad4
           into d_result
           from vista_pubb_anuo
          where ottica = d_ottica
            and progr_unita_organizzativa = p_progr_unor
            and trunc(sysdate) between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.AD4_get_gruppo;
   -------------------------------------------------------------------------------
   function ad4_get_ruolo
   (
      p_ruolo      ad4_ruoli.ruolo%type
     ,p_separatore varchar2 default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        AD4_get_ruolo
      DESCRIZIONE: Restituisce una stringa contenente codice, descrizione e gruppo
                   di AD4 associati al ruolo passato
      PARAMETRI:   p_ruolo                 Ruolo da trattare
                   p_separatore            carattere di separazione per concatenare i dati
      RITORNA:     varchar2                stringa contenente codice, descrizione e
                                           gruppo associati al ruolo
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2006  VD        Prima emissione.
      001   12/02/2013  AD        Spostato codice in so4ad4_pkg
      ******************************************************************************/
   begin
      return so4ad4_pkg.ad4_get_ruolo(p_ruolo, p_separatore);
   end; -- so4_util.AD4_get_ruolo
   -------------------------------------------------------------------------------
   function ad4_get_progr_unor
   (
      p_utente anagrafe_unita_organizzative.utente_ad4%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        AD4_get_progr_unor
       DESCRIZIONE: Restituisce il progressivo dell'unità organizzativa associata ad
                    un utente AD4
       PARAMETRI:   p_utente                Utente da trattare
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
       RITORNA:     progr_unita_organizzativa    progr. unità associato all'utente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   19/12/2006  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := set_data_default(p_data);
      begin
         select min(progr_unita_organizzativa)
           into d_result
           from vista_pubb_anuo
          where utente_ad4 = p_utente
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := to_number(null);
         when others then
            d_result := to_number(null);
      end;
      --
      return d_result;
   end; -- so4_util.AD4_get_progr_unor
   -------------------------------------------------------------------------------
   function ad4_get_codiceuo
   (
      p_codice_gruppo   ad4_utenti.utente%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /******************************************************************************
       NOME:        AD4_get_codiceuo
       DESCRIZIONE: Dato il codice di un gruppo (ad4_utenti.utente) restituisce il codice dell'uo
       di una U.O.
       PARAMETRI:   p_codice_gruppo    Codice del gruppo da trattare
                    p_ottica       ottica (facoltativa, se non indicata si assume
                                   l'ottica istituzionale)
       RITORNA:     ad4_utenti.utente%type    utente AD4 associato alla U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   20/07/2007  SC        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
      d_ottica componenti.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      begin
         select codice_uo
           into d_result
           from vista_pubb_anuo
          where ottica = d_ottica
            and utente_ad4 = p_codice_gruppo
            and trunc(sysdate) between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.AD4_get_codiceuo;
   -------------------------------------------------------------------------------
   function ad4_utente_get_ottica
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type default null
   ) return componenti.ottica%type is
      /******************************************************************************
       NOME:        AD4_utente_get_ottica
       DESCRIZIONE: Dato un utente di AD4, se tale utente è presente come componente
                    di struttura restituisce l'ottica istituzionale in cui è presente
       PARAMETRI:   p_utente            utente di AD4
       RITORNA:     VARCHAR2            ottica istituzionale
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   08/03/2007  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result      componenti.ottica%type;
      d_data        componenti.dal%type;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_data        := set_data_default(p_data);
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      if substr(d_dati_utente, 1, 1) <> '*' then
         pos_sep := instr(d_dati_utente, d_separatore);
         d_ni    := substr(d_dati_utente, 1, pos_sep - 1);
         begin
            select min(c.ottica)
              into d_result
              from vista_pubb_comp c
                  ,ottiche         o
             where c.ni = d_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.ottica = o.ottica
               and o.ottica_istituzionale = 'SI';
         end;
         --
         if d_result is null then
            begin
               select min(c.ottica)
                 into d_result
                 from vista_pubb_comp c
                     ,ottiche         o
                     ,amministrazioni a
                where c.ni = d_ni
                  and d_data between c.dal and nvl(c.al, s_data_limite)
                  and c.ottica = o.ottica
                  and a.codice_amministrazione = o.amministrazione
                  and a.ente = 'SI';
            end;
         end if;
      end if;
      return d_result;
   end; -- so4_util.ad4_utente_get_ottica
   -------------------------------------------------------------------------------
   function ad4_utente_get_unita_partenza
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type default null
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        AD4_utente_get_unita_partenza
       DESCRIZIONE: Dato un utente di AD4, ricerca la prima unita organizzativa
                    di tipo "giuridico" nella gerarchia di appartenenza
       PARAMETRI:   p_utente            utente di AD4
       RITORNA:     VARCHAR2            ottica istituzionale
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   08/03/2007  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione
       002   01/10/2012  VD      Modificato test su assegnazione_prevalente per valori
                                 11, 12, ecc.
       003   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
       004   14/09/2017  MM      #704 Selezione dell'UO di partenza per date effettive
      ******************************************************************************/
      d_result                  componenti.progr_unita_organizzativa%type;
      d_data                    componenti.dal%type;
      d_dati_utente             varchar2(32767);
      d_separatore              varchar2(1);
      d_ni                      number;
      d_pos_sep                 number;
      d_ottica                  ottiche.ottica%type;
      d_progr_unita             componenti.progr_unita_organizzativa%type;
      d_assegnazione_componenti anagrafe_unita_organizzative.assegnazione_componenti%type;
   begin
      d_data        := set_data_default(p_data);
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      if substr(d_dati_utente, 1, 1) = '*' then
         d_result := -1;
         return d_result;
      end if;
      --
      d_pos_sep := instr(d_dati_utente, d_separatore);
      d_ni      := substr(d_dati_utente, 1, d_pos_sep - 1);
      d_ottica  := ad4_utente_get_ottica(p_utente, d_data);
      if d_ottica is null then
         d_result := -1;
         return d_result;
      end if;
      --
      -- Si seleziona l'unita_organizzativa a cui l'utente e' assegnato
      -- con assegnazione istituzionale prevalente
      --
      begin
         select c.progr_unita_organizzativa
           into d_progr_unita
           from vista_pubb_comp c
               ,vista_pubb_atco a
          where c.ottica = d_ottica
            and c.ni = d_ni
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
            and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%'
            and nvl(a.tipo_assegnazione, 'I') = 'I';
      exception
         when too_many_rows then
            --#704
            select c.progr_unita_organizzativa
              into d_progr_unita
              from componenti           c
                  ,attributi_componente a
             where c.ottica = d_ottica
               and c.ni = d_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%'
               and nvl(a.tipo_assegnazione, 'I') = 'I';
      end;
      --      dbms_output.put_line('progr_uo ' || d_progr_unita || ' data ' || d_data);
      --
      -- Si controlla l'attributo assegnazione_componenti della U.O.:
      -- se = 'SI', significa che i componenti della U.O. possono essere
      -- assegnati ad altre unità anche non subordinate
      --
      if d_progr_unita is not null then
         d_assegnazione_componenti := so4_util.anuo_get_ass_comp(p_progr_unita_organizzativa => d_progr_unita
                                                                ,p_dal                       => d_data);
         if nvl(d_assegnazione_componenti, 'NO') = 'SI' then
            begin
               select id_elemento
                 into d_result
                 from vista_pubb_unor
                where ottica = d_ottica
                  and id_unita_padre is null
                  and d_data between dal and nvl(al, s_data_limite);
            end;
         else
            --
            -- Se i componenti della U.O. possono essere assegnati solo alle U.O.
            -- subordinate, si ricerca il record di struttura relativo alla prima
            -- U.O. "giuridica" nella gerarchia, in modo da far partire l'esplosione
            -- dell'albero da quel record
            d_result := so4_util.unita_get_gerarchia_giuridico(p_progr  => d_progr_unita
                                                              ,p_ottica => d_ottica
                                                              ,p_data   => d_data);
         end if;
      else
         d_result := -1;
      end if;
      return d_result;
   end; -- so4_util.ad4_utente_get_unita_partenza
   -------------------------------------------------------------------------------
   function ad4_utente_get_storico_unita
   (
      p_utente     ad4_utenti.utente%type
     ,p_ottica     componenti.ottica%type default null
     ,p_se_storico varchar2 default 'N'
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ad4_utente_get_storico_unita.
       DESCRIZIONE: Dato il codice di un utente, individua l'ni del componente
                    collegato e restituisce l'elenco delle unita a cui è appartenuto
                    anche in passato
       PARAMETRI:   p_utente             Codice utente di AD4
                    p_ottica             ottica di ricerca nella struttura (facoltativo
                                         - se non specificata si considera l'ottica
                                         istituzionale)
                    p_se_storico         se = 'Y', restituisce anche lo storico dei ruoli,
                                         se = 'N', restituisce solo i ruoli correnti
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente l'elenco di
                                         progr. U.O.
                                         codice U.O.
                                         descrizione U.O.
                                         dal
                                         al
                                         ruolo
                                         descr. ruolo
                                         delle unita organizzative a cui è appartenuto il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   28/09/2007  VD        Prima emissione.
       001   17/03/2009  VD        Aggiunto parametro p_se_storico
       002   15/04/2010  VD        Aggiunta gestione ruoli su ultima unita' chiusa
       003   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       004   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := so4_util.set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      if substr(d_dati_utente, 1, 1) = '*' then
         return d_result;
      end if;
      --
      pos_sep := instr(d_dati_utente, d_separatore);
      d_ni    := substr(d_dati_utente, 1, pos_sep - 1);
      --
      if p_se_storico = 'Y' then
         open d_result for
            select c.progr_unita_organizzativa
                  ,a.codice_uo
                  ,a.descrizione
                  ,greatest(a.dal, r.dal, c.dal) dal --#734
                  ,decode(least(nvl(a.al, s_data_limite), nvl(r.al, s_data_limite))
                         ,s_data_limite
                         ,to_date(null)
                         ,least(nvl(a.al, s_data_limite), nvl(r.al, s_data_limite))) al
                  ,r.ruolo
                  ,t.descrizione
              from vista_pubb_comp c
                  ,vista_pubb_anuo a
                  ,vista_pubb_ruco r
                  ,ad4_ruoli       t
             where a.ottica = p_ottica
               and c.ni = d_ni
               and c.progr_unita_organizzativa = a.progr_unita_organizzativa
               and a.dal <= nvl(r.al, s_data_limite)
                  --#734
               and a.dal <= nvl(c.al, s_data_limite)
               and nvl(a.al, s_data_limite) >= c.dal
                  --
               and c.id_componente = r.id_componente
               and r.ruolo = t.ruolo
             order by 4
                     ,5
                     ,2;
      else
         open d_result for
            select c.progr_unita_organizzativa
                  ,a.codice_uo
                  ,a.descrizione
                  ,a.dal
                  ,a.al
                  ,r.ruolo
                  ,t.descrizione
              from vista_pubb_comp c
                  ,vista_pubb_anuo a
                  ,vista_pubb_ruco r
                  ,ad4_ruoli       t
             where c.ottica = p_ottica
               and c.ni = d_ni
               and c.progr_unita_organizzativa = a.progr_unita_organizzativa
               and c.al =
                   (select max(al)
                      from vista_pubb_anuo x
                     where x.progr_unita_organizzativa = c.progr_unita_organizzativa)
               and not exists
             (select 'x'
                      from vista_pubb_anuo x
                     where x.progr_unita_organizzativa = c.progr_unita_organizzativa
                       and x.al is null)
               and c.id_componente = r.id_componente
               and r.ruolo = t.ruolo
            union
            select c.progr_unita_organizzativa
                  ,a.codice_uo
                  ,a.descrizione
                  ,a.dal
                  ,a.al
                  ,r.ruolo
                  ,t.descrizione
              from vista_pubb_comp c
                  ,vista_pubb_anuo a
                  ,vista_pubb_ruco r
                  ,ad4_ruoli       t
             where c.ottica = p_ottica
               and c.ni = d_ni
               and c.progr_unita_organizzativa = a.progr_unita_organizzativa
                  /*               and c.dal <=
                  nvl(decode(a.revisione_cessazione, d_revisione, to_date(null), a.al)
                     ,s_data_limite)*/
               and c.id_componente = r.id_componente
               and r.ruolo = t.ruolo
               and trunc(sysdate) between c.dal and nvl(c.al, s_data_limite)
             order by 4
                     ,5;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.AD4_utente_get_storico_unita
   -------------------------------------------------------------------------------
   function ad4_utente_get_gestioni
   (
      p_utente       ad4_utenti.utente%type
     ,p_ottica       ottiche.ottica%type
     ,p_suddivisione suddivisioni_struttura.suddivisione%type
     ,p_data         date
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ad4_utente_get_gestioni.
       DESCRIZIONE: Dato un utente, restituisce l'elenco delle U.O. di appartenenza
                    della suddivisione indicata
       PARAMETRI:   p_utente
                    p_ottica
                    p_suddivisione
                    p_data
       RITORNA:     t_ref_cursor
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   11/12/2009  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result          afc.t_ref_cursor;
      d_id_suddivisione suddivisioni_struttura.id_suddivisione%type;
      d_ni              componenti.ni%type;
      d_separatore      varchar2(1);
   begin
      begin
         select id_suddivisione
           into d_id_suddivisione
           from suddivisioni_struttura
          where ottica = p_ottica
            and suddivisione = p_suddivisione;
      exception
         when others then
            d_id_suddivisione := null;
      end;
      --
      if d_id_suddivisione is not null then
         d_separatore := '#';
         d_ni         := substr(ad4_utente_get_dati(p_utente, d_separatore)
                               ,1
                               ,instr(ad4_utente_get_dati(p_utente, d_separatore)
                                     ,d_separatore
                                     ,1
                                     ,1) - 1);
         --
         -- Si ricercano le unita' di appartenenza del componente e per ognuna
         -- si ricerca l'unita' della suddivisione indicata
         --
         open d_result for
            select so4_util.anuo_get_codice_uo(so4_util.get_area_unita(d_id_suddivisione
                                                                      ,progr_unita_organizzativa
                                                                      ,p_data)
                                              ,p_data) codice_uo
                  ,so4_util.anuo_get_descrizione(so4_util.get_area_unita(d_id_suddivisione
                                                                        ,progr_unita_organizzativa
                                                                        ,p_data)
                                                ,p_data) descr_uo
            
              from vista_pubb_comp
             where ni = d_ni
               and ottica = p_ottica
               and p_data between dal and nvl(al, s_data_limite)
             order by 1
                     ,2;
      else
         open d_result for
            select '***'
                  ,'Gestione non identificabile'
              from dual;
      end if;
      --
      return d_result;
      --
   end ad4_utente_get_gestioni;
   -------------------------------------------------------------------------------
   function comp_get_utente(p_ni componenti.ni%type) return varchar2 is
      /******************************************************************************
       NOME:        comp_get_utente.
       DESCRIZIONE: Dato l'ni di un componente, restituisce il codice utente 
                    corrispondente
       PARAMETRI:   p_ni               ni del componente
       RITORNA:     VARCHAR2  codice utente corrispondente
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0     01/02/2007  SC      Prima emissione.
      ******************************************************************************/
      d_result ad4_utenti.utente%type;
   begin
      select s.utente
        into d_result
        from ad4_utenti_soggetti s
            ,ad4_utenti          u
       where s.soggetto = p_ni
         and s.utente = u.utente
         and u.stato not in ('S', 'R');
      return d_result;
      --
   exception
      when others then
         return null;
   end; -- so4_util.comp_get_utente
   -------------------------------------------------------------------------------
   function comp_get_incarico
   (
      p_componente      componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        comp_get_incarico.
       DESCRIZIONE: Dato l'ni di un componente e il codice dell'unità restituisce
                    una stringa contenente il codice e la descrizione dell'incarico
       PARAMETRI:   p_ni               ni del componente
                    p_codice_uo        codice dell'unita organizzativa
                    p_data             data a cui eseguire la ricerca (facoltativa -
                                       se non specificata si considera la data di sistema)
                    p_ottica           ottica di ricerca nella struttura (facoltativa
                                       - alternativa all'amministrazione per la definizione
                                       dell'ottica istituzionale)
                    p_amministrazione  amministrazione di ricerca nella struttura (facoltativa
                                       - alternativa all'ottica per la definizione
                                       dell'ottica istituzionale)
       RITORNA:     varchar2           Stringa contenente il codice e la descrizione
                                       dell'incarico del componente
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   19/10/2007  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione          
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result        varchar2(2000);
      d_ottica        componenti.ottica%type;
      d_data          componenti.dal%type;
      d_progr_unor    componenti.progr_unita_organizzativa%type;
      d_id_componente componenti.id_componente%type;
      d_incarico      attributi_componente.incarico%type;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si seleziona il progressivo dell'unita organizzativa (se indicata)
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      -- Si seleziona l'id_componente associato all'ni
      --
      begin
         select id_componente
           into d_id_componente
           from vista_pubb_comp
          where ottica = d_ottica
            and progr_unita_organizzativa = d_progr_unor
            and ni = p_componente
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_id_componente := null;
         when others then
            raise_application_error(-20999, 'Errore in lettura componente - ' || sqlerrm);
      end;
      --
      -- Si seleziona l'incarico associato al componente
      --
      if d_id_componente is not null then
         begin
            select incarico
              into d_incarico
              from vista_pubb_atco
             where id_componente = d_id_componente
               and d_data between dal and nvl(al, s_data_limite);
         exception
            when others then
               d_incarico := '';
         end;
         d_result := d_incarico || '#' ||
                     tipo_incarico.get_descrizione(p_incarico => d_incarico);
      else
         d_result := null;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_incarico
   -------------------------------------------------------------------------------
   function comp_get_incarico
   (
      p_componente      componenti.ni%type
     ,p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_codice       varchar2 default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        comp_get_incarico.
       DESCRIZIONE: Dato l'ni di un componente e il progr. dell'unità restituisce
                    una stringa contenente il codice e la descrizione dell'incarico
       PARAMETRI:   p_ni               ni del componente
                    p_progr_unor       progressivo dell'unita organizzativa
                    p_data             data a cui eseguire la ricerca (facoltativa -
                                       se non specificata si considera la data di sistema)
                    p_ottica           ottica di ricerca nella struttura (facoltativa
                                       - alternativa all'amministrazione per la definizione
                                       dell'ottica istituzionale)
                    p_amministrazione  amministrazione di ricerca nella struttura (facoltativa
                                       - alternativa all'ottica per la definizione
                                       dell'ottica istituzionale)
                    p_se_codice        se 'SI' restituisce anche il codice incarico
       RITORNA:     varchar2           Stringa contenente il codice e la descrizione
                                       dell'incarico del componente
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   19/10/2007  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione               
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result        varchar2(2000);
      d_data          componenti.dal%type;
      d_ottica        componenti.ottica%type;
      d_id_componente componenti.id_componente%type;
      d_incarico      attributi_componente.incarico%type;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si seleziona l'id_componente associato all'ni
      --
      begin
         select id_componente
           into d_id_componente
           from vista_pubb_comp
          where ottica = d_ottica
            and progr_unita_organizzativa = p_progr_unor
            and ni = p_componente
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_id_componente := null;
         when others then
            raise_application_error(-20999, 'Errore in lettura componente - ' || sqlerrm);
      end;
      --
      -- Si seleziona l'incarico associato al componente
      --
      if d_id_componente is not null then
         begin
            select incarico
              into d_incarico
              from vista_pubb_atco
             where id_componente = d_id_componente
               and d_data between dal and nvl(al, s_data_limite);
         exception
            when others then
               d_incarico := '';
         end;
         if nvl(p_se_codice, 'SI') = 'SI' then
            d_result := d_incarico || '#' ||
                        tipo_incarico.get_descrizione(p_incarico => d_incarico);
         else
            d_result := tipo_incarico.get_descrizione(p_incarico => d_incarico);
         end if;
      else
         d_result := null;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_incarico
   -------------------------------------------------------------------------------
   function comp_get_se_resp
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.responsabile%type is
      /******************************************************************************
       NOME:        comp_get_se_resp
       DESCRIZIONE: Restituisce il campo "responsabile" dell'incarico del componente
      
       PARAMETRI:   p_id_componente
                    p_dal
       RITORNA:     tipi_incarico.responsabile%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       001   30/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione               
      ******************************************************************************/
      d_incarico attributi_componente.incarico%type;
      d_result   tipi_incarico.responsabile%type;
   begin
      begin
         select incarico
           into d_incarico
           from vista_pubb_atco
          where id_componente = p_id_componente
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_incarico := '';
      end;
      --
      if d_incarico is not null then
         d_result := tipo_incarico.get_responsabile(p_incarico => d_incarico);
      else
         d_result := null;
      end if;
      --  
      return d_result;
   
   end; -- so4_util.comp_get_se_resp
   -------------------------------------------------------------------------------
   function comp_get_unita_prev
   (
      p_ni              componenti.ni%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_modalita        varchar2 default 'N'
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        comp_get_unita_prev.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'unita' di assegnazione
                    istituzionale prevalente. Se il componente ha piu' assegnazioni
                    prevalenti o non ha nessuna assegnazione prevalente restituisce
                    un messaggio di errore.
       PARAMETRI:   p_ni                 ni del componente
                    p_ottica             ottica di ricerca nella struttura (facoltativo
                                         - se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
                    p_modalita           se attivato, cerca il soggetto per CI e non per NI
       RITORNA:     componenti.progr_unita_organizzativa%type
      
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   06/05/2010  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione    
       002   01/10/2012  VD        Modificato test su assegnazione_prevalente per valori
                                   11, 12, ecc.
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
       004   12/04/2016  MM        #711 , nuova modalita' per CI   
      ******************************************************************************/
      d_result componenti.progr_unita_organizzativa%type;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Se valorizzano i parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      begin
         select progr_unita_organizzativa
           into d_result
           from vista_pubb_comp c
               ,vista_pubb_atco a
          where c.ottica = d_ottica
            and ((c.ni = p_ni and (p_modalita = 'N' or p_modalita is null)) or --#711
                (c.ci = p_ni and p_modalita = 'C'))
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = a.id_componente
               --            and a.assegnazione_prevalente = 1
            and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%'
            and nvl(a.tipo_assegnazione, 'I') = 'I'
            and d_data between a.dal and nvl(a.al, s_data_limite);
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'Il componente ' || p_ni ||
                                    ' non risulta assegnato ad alcuna unita');
         when too_many_rows then
            raise_application_error(-20999
                                   ,'Il componente ' || p_ni ||
                                    ' risulta assegnato a piu'' unita');
      end;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_unita_prev
   -------------------------------------------------------------------------------
   function comp_get_ass_prev
   (
      p_ni              componenti.ni%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        comp_get_ass_prev.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'unita' di assegnazione
                    prevalente. Se il componente non e' assegnato ad alcuna unita' o
                    ha più assegnazioni prevalenti restituisce null
       PARAMETRI:   p_ni                 ni del componente
                    p_ottica             ottica di ricerca nella struttura (facoltativo
                                         - se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
       RITORNA:     componenti.progr_unita_organizzativa%type
      
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   06/05/2010  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione    
       002   01/10/2012  VD        Modificato test su assegnazione_prevalente per valori
                                   11, 12, ecc.
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result componenti.progr_unita_organizzativa%type;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Se valorizzano i parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      begin
         select progr_unita_organizzativa
           into d_result
           from vista_pubb_comp c
               ,vista_pubb_atco a
          where c.ottica = d_ottica
            and c.ni = p_ni
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = a.id_componente
               --            and a.assegnazione_prevalente = 1
            and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%'
            and nvl(a.tipo_assegnazione, 'I') = 'I'
            and d_data between a.dal and nvl(a.al, s_data_limite);
      exception
         when no_data_found then
            d_result := to_number(null);
         when too_many_rows then
            d_result := to_number(null);
      end;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_ass_prev
   -------------------------------------------------------------------------------
   function comp_get_unita
   (
      p_ni                componenti.ni%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_amministrazione   amministrazioni.codice_amministrazione%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
        NOME:        comp_get_unita.
        DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco
                     (codice-descrizione) delle unita a cui appartiene.
        PARAMETRI:   p_ni                 ni del componente
                     p_ruolo              ruolo del componente (facoltativo - se non
                                          specificato si considerano tutti i ruoli)
                     p_ottica             ottica di ricerca nella struttura (facoltativo
                                          - se non specificata si considera l'ottica
                                          istituzionale)
                     p_data               data a cui eseguire la ricerca (facoltativa -
                                          se non specificata si considera la data di sistema)
                     p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                          - alternativa all'ottica per la definizione
                                          dell'ottica istituzionale
                     p_se_progr_unita     se valorizzato a SI, il ref_cursor in uscita
                                          contiene anche il progressivo dell'unità
                                          organizzativa
                     p_tipo_assegnazione  tipo assegnazione da trattare (I/F) (facoltativa -
                                          se non indicata si trattano entrambe
        RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                          delle unita organizzative in cui e presente il
                                          componente
        REVISIONI:
        Rev.  Data        Autore    Descrizione
        ----  ----------  --------  ----------------------------------------------------
        000   14/12/2006  VD        Prima emissione.
        001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
        002   12/08/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                    del cursore    
        003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                    query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Se valorizzano i parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      if p_se_progr_unita = 'SI' then
         open d_result for
            select distinct c.progr_unita_organizzativa
                           ,so4_util.anuo_get_codice_uo(c.progr_unita_organizzativa
                                                       ,d_data) codice_uo
                           ,so4_util.anuo_get_descrizione(c.progr_unita_organizzativa
                                                         ,d_data) descrizione_uo
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.ni = p_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and nvl(a.tipo_assegnazione, 'I') =
                   nvl(p_tipo_assegnazione, nvl(a.tipo_assegnazione, 'I'))
               and c.id_componente = r.id_componente(+)
               and nvl(r.ruolo, '*') = nvl(p_ruolo, nvl(r.ruolo, '*'))
               and d_data between nvl(r.dal(+), d_data) and nvl(r.al(+), s_data_limite)
             order by 2
                     ,1;
      else
         open d_result for
            select distinct so4_util.anuo_get_codice_uo(c.progr_unita_organizzativa
                                                       ,d_data) codice_uo
                           ,so4_util.anuo_get_descrizione(c.progr_unita_organizzativa
                                                         ,d_data) descrizione_uo
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.ni = p_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and nvl(a.tipo_assegnazione, 'I') =
                   nvl(p_tipo_assegnazione, nvl(a.tipo_assegnazione, 'I'))
               and c.id_componente = r.id_componente(+)
               and nvl(r.ruolo, '*') = nvl(p_ruolo, nvl(r.ruolo, '*'))
               and d_data between nvl(r.dal(+), d_data) and nvl(r.al(+), s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_unita
   -------------------------------------------------------------------------------
   function comp_get_unita
   (
      p_ni                componenti.ni%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_amministrazione   amministrazioni.codice_amministrazione%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_se_ordinamento    number
     ,p_se_descrizione    number
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_unita.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco
                    (codice-descrizione) delle unita a cui appartiene.
       PARAMETRI:   p_ni                 ni del componente
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo
                                         - se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
                    p_se_progr_unita     se valorizzato a SI, il ref_cursor in uscita
                                         contiene anche il progressivo dell'unità
                                         organizzativa
                    p_se_ordinamento     
                    p_se_descrizione     
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   14/12/2006  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione    
       002   12/08/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                   del cursore
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Se valorizzano i parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      if p_se_progr_unita = 'SI' then
         open d_result for
            select distinct c.progr_unita_organizzativa
                           ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                                      ,d_data) codice_uo
                           ,null descrizione_uo
            --                , anagrafe_unita_organizzativa.get_descrizione ( c.progr_unita_organizzativa
            --                                                               , d_data )
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.ni = p_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and nvl(a.tipo_assegnazione, 'I') =
                   nvl(p_tipo_assegnazione, nvl(a.tipo_assegnazione, 'I'))
               and c.id_componente = r.id_componente(+)
               and nvl(r.ruolo, '*') = nvl(p_ruolo, nvl(r.ruolo, '*'))
               and d_data between nvl(r.dal(+), d_data) and nvl(r.al(+), s_data_limite);
         --            order by 2,1;
      else
         open d_result for
            select distinct anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                                      ,d_data) codice_uo
                           ,null descrizione_uo
            --                , anagrafe_unita_organizzativa.get_descrizione ( c.progr_unita_organizzativa
            --                                                               , d_data )
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.ni = p_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and nvl(a.tipo_assegnazione, 'I') =
                   nvl(p_tipo_assegnazione, nvl(a.tipo_assegnazione, 'I'))
               and c.id_componente = r.id_componente(+)
               and nvl(r.ruolo, '*') = nvl(p_ruolo, nvl(r.ruolo, '*'))
               and d_data between nvl(r.dal(+), d_data) and nvl(r.al(+), s_data_limite);
         --            order by 2,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_unita
   -------------------------------------------------------------------------------
   function comp_get_ruoli_progr
   (
      p_ni              componenti.ni%type
     ,p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_ruoli.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco
                    (codice-descrizione) dei ruoli del componente nell'eventuale
                    unita indicata
       PARAMETRI:   p_ni               ni del componente
                    p_progr_unor       progr. dell'unita organizzativa (facoltativo -
                                       se non specificato si considerano tutte le unita)
                    p_data             data a cui eseguire la ricerca (facoltativa -
                                       se non specificata si considera la data di sistema)
                    p_amministrazione  amministrazione di ricerca nella struttura (facoltativa
                                       - alternativa all'ottica per la definizione
                                       dell'ottica istituzionale
       RITORNA:     AFC.t_ref_cursor   Ref cursor contenente le coppie codice / descrizione
                                       dei ruoli del componente separati dal carattere
                                       separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   16/03/2011  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      open d_result for
         select ruolo
               ,ad4_ruoli_tpk.get_descrizione(ruolo) descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.ni = p_ni
            and c.ottica = d_ottica
            and c.progr_unita_organizzativa =
                nvl(d_progr_unor, c.progr_unita_organizzativa)
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_ruoli_progr
   -------------------------------------------------------------------------------
   function comp_get_ruoli
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_ruoli.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco
                    (codice-descrizione) dei ruoli del componente nell'eventuale
                    unita indicata
       PARAMETRI:   p_ni               ni del componente
                    p_codice_uo        codice dell'unita organizzativa (facoltativo -
                                       se non specificato si considerano tutte le unita)
                    p_data             data a cui eseguire la ricerca (facoltativa -
                                       se non specificata si considera la data di sistema)
                    p_ottica           ottica di ricerca nella struttura (facoltativa -
                                       alternativa all'amministrazione per la definizione
                                       dell'ottica istituzionale)
                    p_amministrazione  amministrazione di ricerca nella struttura (facoltativa
                                       - alternativa all'ottica per la definizione
                                       dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor   Ref cursor contenente le coppie codice / descrizione
                                       dei ruoli del componente separati dal carattere
                                       separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si seleziona il progressivo dell'unita organizzativa (se indicata)
      --
      if p_codice_uo is null then
         d_progr_unor := null;
      else
         d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      end if;
      --
      open d_result for
         select ruolo
               ,ad4_ruoli_tpk.get_descrizione(ruolo) descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.ni = p_ni
            and c.ottica = d_ottica
            and c.progr_unita_organizzativa =
                nvl(d_progr_unor, c.progr_unita_organizzativa)
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_ruoli
   -------------------------------------------------------------------------------
   function comp_get_ruoli
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_ordinamento  number
     ,p_se_descrizione  number
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_ruoli.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco
                    (codice-descrizione) dei ruoli del componente nell'eventuale
                    unita indicata
       PARAMETRI:   p_ni               ni del componente
                    p_codice_uo        codice dell'unita organizzativa (facoltativo -
                                       se non specificato si considerano tutte le unita)
                    p_data             data a cui eseguire la ricerca (facoltativa -
                                       se non specificata si considera la data di sistema)
                    p_amministrazione  amministrazione di ricerca nella struttura (facoltativa
                                       - alternativa all'ottica per la definizione
                                       dell'ottica istituzionale
                    p_se_ordinamento
                    p_se_descrizione                   
       RITORNA:     AFC.t_ref_cursor   Ref cursor contenente le coppie codice / descrizione
                                       dei ruoli del componente separati dal carattere
                                       separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       003   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si seleziona il progressivo dell'unita organizzativa (se indicata)
      --
      if p_codice_uo is null then
         d_progr_unor := null;
      else
         d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      end if;
      --
      open d_result for
         select ruolo
               ,null descrizione
         --             , ad4_ruoli_tpk.get_descrizione (ruolo) descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.ni = p_ni
            and c.ottica = d_ottica
            and c.progr_unita_organizzativa =
                nvl(d_progr_unor, c.progr_unita_organizzativa)
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and d_data between r.dal and nvl(r.al, s_data_limite);
      --         order by 2,1;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_ruoli
   -------------------------------------------------------------------------------
   function comp_get_responsabile
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_responsabile.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco (ni-cognome e nome)
                    dei componenti della sua unita aventi un incarico "responsabile" ed
                    eventualmente il ruolo indicato
       PARAMETRI:   p_ni                 ni del componente
                    p_codice_uo          codice della unita organizzativa
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
       RITORNA:     AFC.t_ref_cursor  Elenco delle coppie ni / cognome e nome
                                      dei componenti "responsabili" dell'unita a cui e
                                      associato il componente separati dal carattere
                                      separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      if p_ruolo is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_atco a
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.ni != p_ni
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
             order by 2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.ni != p_ni
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_responsabile
   -------------------------------------------------------------------------------
   function comp_get_responsabile_gdm
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_responsabile_gdm.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco (ni-cognome e nome)
                    dei componenti della sua unita aventi un incarico "responsabile" ed
                    eventualmente il ruolo indicato, compreso l'ni indicato
       PARAMETRI:   p_ni                 ni del componente
                    p_codice_uo          codice della unita organizzativa
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le coppie ni / cognome e nome
                                      dei componenti "responsabili" dell'unita a cui e
                                      associato il componente separati dal carattere
                                      separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      if p_ruolo is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_atco a
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
                  --              and c.ni != p_ni
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
             order by 2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
                  --              and c.ni != p_ni
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_responsabile_gdm
   -------------------------------------------------------------------------------
   function comp_get_resp_gerarchia
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_responsabile_gerarchia.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco dei
                    responsabili delle unita a livello superiore aventi
                    l'eventuale ruolo indicato
       PARAMETRI:   p_ni                 ni del componente
                    p_codice_uo          codice della unita organizzativa
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
                                         se non specificata si considera la data di sistema)
       RITORNA:     AFC.t_ref_cursor     Stringa contenente le coppie ni / cognome e nome dei
                                         componenti "responsabili" delle unita a livello
                                         superiore separati dal carattere separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   15/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      -- Si inseriscono le unità organizzative da trattare nella temporary table
      -- TEMP_SO4
      --
      begin
         insert into temp_so4
            (tipo_record
            ,livello
            ,progr_uo)
            select /*+ first_rows */
             'UO'
            ,level livello
            ,progr_unita_organizzativa
              from vista_pubb_unor
             where ottica = d_ottica
               and d_data between dal and nvl(al, s_data_limite)
            connect by prior id_unita_padre = progr_unita_organizzativa
                   and ottica = d_ottica
                   and d_data between dal and nvl(al, s_data_limite)
             start with ottica = d_ottica
                    and progr_unita_organizzativa = d_progr_unor
                    and d_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            raise_application_error(-20999
                                   ,'Errore in inserimento Temporary Table - ' ||
                                    sqlerrm);
      end;
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      if p_ruolo is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,temp_so4        t
             where c.ottica = d_ottica
               and t.tipo_record = 'UO'
               and t.livello > 1
               and c.progr_unita_organizzativa = t.progr_uo
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
             order by 2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
                  ,temp_so4        t
             where c.ottica = d_ottica
               and t.tipo_record = 'UO'
               and t.livello > 1
               and c.progr_unita_organizzativa = t.progr_uo
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_resp_gerarchia
   -------------------------------------------------------------------------------
   function comp_get_resp_unico
   (
      p_ni              componenti.ni%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.ni%type is
      /******************************************************************************
       NOME:        comp_get_resp_unico.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'ni del responsabile
                    della sua unita' organizzativa.
       PARAMETRI:   p_ni                 ni del componente
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
       RITORNA:     componenti.ni%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   16/01/2012  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   01/10/2012  VD      Modificato test su assegnazione_prevalente per valori
                                 11, 12, ecc.
       003   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     componenti.ni%type;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.comp_get_ass_prev(p_ni => p_ni, p_ottica => d_ottica);
      --
      if d_progr_unor is not null then
         select min(ni)
           into d_result
           from vista_pubb_comp c
               ,vista_pubb_atco a
          where c.progr_unita_organizzativa = d_progr_unor
            and c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.ni != p_ni
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
            and nvl(tipo_assegnazione, 'I') = 'I'
               --            and nvl(assegnazione_prevalente, 0) = 1
            and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%'
            and tipo_incarico.get_responsabile(a.incarico) = 'SI';
      else
         d_result := to_number(null);
      end if;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_responsabile
   -------------------------------------------------------------------------------
   function comp_get_subordinati
   (
      p_ni              componenti.ni%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        Comp_get_subordinati.
       DESCRIZIONE: Restituisce l'elenco dei componenti subordinati al componente
                    indicato nell'unita indicata (se presente) oppure nelle unita
                    di cui il componente e' responsabile
       PARAMETRI:   p_ni                 ni del componente da trattare
                    p_ruolo              ruolo (responsabile) del componente (se non
                                         indicato si considerano tutti i ruoli)
                    p_codice_uo          codice dell'unita organizzativa di cui il
                                         componente e' responsabile (se non indicato
                                         si cercano tutte le unita' di cui e' responsabile)
                    p_data               data a cui effettuare la ricerca (se non indicata
                                         si assume la data di sistema)
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco delle coppie ni / cognome e nome dei
                                      componenti appartenenti all'unita e non "responsabili"
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   18/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si inseriscono le unità organizzative da trattare nella temporary table
      -- TEMP_SO4
      --
      begin
         insert into temp_so4
            (tipo_record
            ,progr_uo)
            select 'UO'
                  ,so4_util.anuo_get_progr(d_ottica, '', p_codice_uo, d_data) progr_unor
              from dual
             where p_codice_uo is not null
            union
            select 'UO'
                  ,c.progr_unita_organizzativa progr_unor
              from vista_pubb_comp c
                  ,vista_pubb_atco a
             where c.ottica = d_ottica
               and c.ni = p_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and p_codice_uo is null
               and p_ruolo is null
            union
            select 'UO'
                  ,c.progr_unita_organizzativa progr_unor
              from vista_pubb_comp c
                  ,vista_pubb_atco a
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.ni = p_ni
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
               and p_codice_uo is null
               and p_ruolo is not null;
      exception
         when others then
            raise_application_error(-20999
                                   ,'Errore in inserimento Temporary Table - ' ||
                                    sqlerrm);
      end;
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select ni
               ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_atco a
               ,temp_so4        t
          where c.ottica = d_ottica
            and t.tipo_record = 'UO'
            and c.progr_unita_organizzativa = t.progr_uo
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
            and tipo_incarico.get_responsabile(a.incarico) = 'NO'
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_subordinati
   -------------------------------------------------------------------------------
   function comp_get_subord_gerarchia
   (
      p_componente      componenti.ni%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_subord_gerarchia.
       DESCRIZIONE: Dato un componente, restituisce l'elenco dei suoi subordinati in 
                    tutte le U.O. subordinate alla sua U.O. di appartenenza
       PARAMETRI:   p_componente         Ni del componente da trattare
                    p_ruolo              Ruolo del componente (facoltativo - se non
                                         indicato si trattano tutti i ruoli)
                    p_codice_uo          Codice dell'unita organizzativa del componente
                                         (facoltativo - se non indicato si trattano tutte
                                         le U.O. di appartenenza del componente)
                    p_ottica             Ottica in cui effettuare la ricerca (facoltativa -
                                         alternativa all'amministrazione per identificare 
                                         l'ottica istituzionale)
                    p_data               Data a cui eseguire la ricerca (facoltativa -
                                         se non indicata si assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura 
                                         (facoltativa - alternativa all'ottica per la 
                                         definizione dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor     Elenco contenente le coppie ni / cognome e nome dei
                                         componenti appartenenti subordinati al componente 
                                         dato
      
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   21/12/2006  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione    
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si selezionano le U.O. a cui e' associato il componente
      --
      for sel_unit in (select so4_util.anuo_get_progr(d_ottica, '', p_codice_uo, d_data) progr_unor
                         from dual
                        where p_codice_uo is not null
                       union
                       select c.progr_unita_organizzativa progr_unor
                         from vista_pubb_comp c
                             ,vista_pubb_atco a
                        where c.ottica = d_ottica
                          and c.ni = p_componente
                          and d_data between c.dal and nvl(c.al, s_data_limite)
                          and c.id_componente = a.id_componente
                          and d_data between a.dal and nvl(a.al, s_data_limite)
                          and tipo_incarico.get_responsabile(a.incarico) = 'SI'
                          and p_codice_uo is null
                          and p_ruolo is null
                       union
                       select c.progr_unita_organizzativa progr_unor
                         from vista_pubb_comp c
                             ,vista_pubb_atco a
                             ,vista_pubb_ruco r
                        where c.ottica = d_ottica
                          and c.ni = p_componente
                          and d_data between c.dal and nvl(c.al, s_data_limite)
                          and c.id_componente = a.id_componente
                          and d_data between a.dal and nvl(a.al, s_data_limite)
                          and tipo_incarico.get_responsabile(a.incarico) = 'SI'
                          and c.id_componente = r.id_componente
                          and r.ruolo = p_ruolo
                          and d_data between r.dal and nvl(r.al, s_data_limite)
                          and p_codice_uo is null
                          and p_ruolo is not null)
      loop
         --
         -- Si inseriscono le unità organizzative da trattare nella temporary table
         -- TEMP_SO4
         --
         begin
            insert into temp_so4
               (tipo_record
               ,livello
               ,progr_uo)
               select /*+ first_rows */
                'UO'
               ,level livello
               ,progr_unita_organizzativa
                 from vista_pubb_unor
                where ottica = d_ottica
                  and d_data between dal and nvl(al, s_data_limite)
               connect by prior progr_unita_organizzativa = id_unita_padre
                      and ottica = d_ottica
                      and d_data between dal and nvl(al, s_data_limite)
                start with ottica = d_ottica
                       and progr_unita_organizzativa = sel_unit.progr_unor
                       and d_data between dal and nvl(al, s_data_limite);
         exception
            when others then
               raise_application_error(-20999
                                      ,'Errore in inserimento Temporary Table - ' ||
                                       sqlerrm);
         end;
      end loop;
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select ni
               ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_atco a
               ,temp_so4        t
          where c.ottica = d_ottica
            and t.tipo_record = 'UO'
            and c.progr_unita_organizzativa = t.progr_uo
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and t.progr_uo = c.progr_unita_organizzativa
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
            and tipo_incarico.get_responsabile(a.incarico) = 'NO'
            and p_ruolo is null
         union
         select ni
               ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_atco a
               ,vista_pubb_ruco r
               ,temp_so4        t
          where c.ottica = d_ottica
            and t.tipo_record = 'UO'
            and c.progr_unita_organizzativa = t.progr_uo
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and t.progr_uo = c.progr_unita_organizzativa
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
            and tipo_incarico.get_responsabile(a.incarico) = 'NO'
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
            and p_ruolo is not null
          order by 2
                  ,1;
      --
      return d_result;
   end; -- so4_util.get_subord_gerarchia;
   -------------------------------------------------------------------------------
   function comp_get_subord_gerarchia_gdm
   (
      p_componente      componenti.ni%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_subord_gerarchia.
       DESCRIZIONE: Dato un componente, restituisce l'elenco dei suoi subordinati in tutte le U.O. subordinate.
       PARAMETRI:   p_componente         Ni del componente da trattare
                    p_ruolo              Ruolo del componente (facoltativo - se non
                                         indicato si trattano tutti i ruoli)
                    p_codice_uo          Codice dell'unita organizzativa del componente
                                         (facoltativo - se non indicato si trattano tutte
                                         le U.O. di appartenenza)
                    p_ottica             Ottica in cui effettuare la ricerca (facoltativa -
                                         alternativa all'amministrazione per la determinazione
                                         delll'ottica istituzionale)
                    p_data               Data a cui eseguire la ricerca (facoltativa -
                                         se non indicata si assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor    Elenco contenente le coppie ni / cognome e nome dei
                                        componenti appartenenti subordinati al componente 
                                        dato
      
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   21/12/2006  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione          
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si selezionano le U.O. a cui e' associato il componente
      --
      for sel_unit in (select so4_util.anuo_get_progr(d_ottica, '', p_codice_uo, d_data) progr_unor
                         from dual
                        where p_codice_uo is not null
                       union
                       select c.progr_unita_organizzativa progr_unor
                         from vista_pubb_comp c
                             ,vista_pubb_atco a
                        where c.ottica = d_ottica
                          and c.ni = p_componente
                          and d_data between c.dal and nvl(c.al, s_data_limite)
                          and c.id_componente = a.id_componente
                          and d_data between a.dal and nvl(a.al, s_data_limite)
                          and tipo_incarico.get_responsabile(a.incarico) = 'SI'
                          and p_codice_uo is null
                          and p_ruolo is null
                       union
                       select c.progr_unita_organizzativa progr_unor
                         from vista_pubb_comp c
                             ,vista_pubb_atco a
                             ,vista_pubb_ruco r
                        where c.ottica = d_ottica
                          and c.ni = p_componente
                          and d_data between c.dal and nvl(c.al, s_data_limite)
                          and c.id_componente = a.id_componente
                          and d_data between a.dal and nvl(a.al, s_data_limite)
                          and tipo_incarico.get_responsabile(a.incarico) = 'SI'
                          and c.id_componente = r.id_componente
                          and r.ruolo = p_ruolo
                          and d_data between r.dal and nvl(r.al, s_data_limite)
                          and p_codice_uo is null
                          and p_ruolo is not null)
      loop
         --
         -- Si inseriscono le unità organizzative da trattare nella temporary table
         -- TEMP_SO4
         --
         begin
            insert into temp_so4
               (tipo_record
               ,livello
               ,progr_uo)
               select /*+ first_rows */
                'UO'
               ,level livello
               ,progr_unita_organizzativa
                 from vista_pubb_unor
                where ottica = d_ottica
                  and d_data between dal and nvl(al, s_data_limite)
               connect by prior progr_unita_organizzativa = id_unita_padre
                      and ottica = d_ottica
                      and d_data between dal and nvl(al, s_data_limite)
                start with ottica = d_ottica
                       and progr_unita_organizzativa = sel_unit.progr_unor
                       and d_data between dal and nvl(al, s_data_limite);
         exception
            when others then
               raise_application_error(-20999
                                      ,'Errore in inserimento Temporary Table - ' ||
                                       sqlerrm);
         end;
      end loop;
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select ni
               ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_atco a
               ,temp_so4        t
          where c.ottica = d_ottica
            and t.tipo_record = 'UO'
            and c.progr_unita_organizzativa = t.progr_uo
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and t.progr_uo = c.progr_unita_organizzativa
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
               --           and tipo_incarico.get_responsabile (a.incarico) = 'NO'
            and p_ruolo is null
         union
         select ni
               ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_atco a
               ,vista_pubb_ruco r
               ,temp_so4        t
          where c.ottica = d_ottica
            and t.tipo_record = 'UO'
            and c.progr_unita_organizzativa = t.progr_uo
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and t.progr_uo = c.progr_unita_organizzativa
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
               --           and tipo_incarico.get_responsabile (a.incarico) = 'NO'
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
   end; -- so4_util.get_subord_gerarchia_gdm;
   -------------------------------------------------------------------------------
   function comp_get_approvatore
   (
      p_id_soggetto     componenti.ni%type
     ,p_progr_unor      componenti.progr_unita_organizzativa%type
     ,p_ruolo_appr      ruoli_componente.ruolo%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.ni%type is
      /******************************************************************************
       NOME:        comp_get_approvatore.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'ni del soggetto avente
                    ruolo di approvatore nella U.O. di appartenenza, escludendo
                    il soggetto indicato.
      
       PARAMETRI:   p_id_soggetto        ni del dipendente
                    p_progr_unor         progr. unita' organizzativa
                    p_ruolo_appr         codice ruolo approvatore
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_amministrazione    amministrazione di ricerca nella struttura 
                                         (facoltativa - alternativa all'ottica per la 
                                         definizione dell'ottica istituzionale)
       RITORNA:     id_soggetto          ni dell'approvatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   06/05/2010  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result componenti.ni%type;
      d_data   componenti.dal%type;
      d_ottica componenti.ottica%type;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      begin
         select ni
           into d_result
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.ottica = d_ottica
            and c.progr_unita_organizzativa = p_progr_unor
            and c.ni != p_id_soggetto
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo_appr
            and d_data between r.dal and nvl(r.al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
      end;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_approvatore
   -------------------------------------------------------------------------------
   function dipendente_get_approvatore
   (
      p_id_soggetto     componenti.ni%type
     ,p_ruolo_appr      ruoli_componente.ruolo%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_modalita        varchar2 default 'N'
   ) return componenti.ni%type is
      /******************************************************************************
       NOME:        dipendente_get_approvatore.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'ni del soggetto avente
                    ruolo di approvatore nella U.O. di appartenenza. Se il responsabile
                    coincide con l'ni indicato, si cerca il responsabile a livello
                    superiore.
       PARAMETRI:   p_id_soggetto        ni del dipendente
                    p_ruolo_appr         codice ruolo approvatore
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
                    p_modalita           se attivato, cerca il soggetto per CI e non per NI
       RITORNA:     id_soggetto          ni dell'approvatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   06/05/2010  VD      Prima emissione.
       001   27/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione     
       002   12/04/2016  MM      #711 , nuova modalita' per CI    
      ******************************************************************************/
      d_result      componenti.ni%type;
      d_data        componenti.dal%type;
      d_ottica      componenti.ottica%type;
      d_progr_unor  componenti.progr_unita_organizzativa%type;
      d_ref_cursor  afc.t_ref_cursor;
      d_ni          componenti.ni%type;
      d_progr_padre anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo   anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione anagrafe_unita_organizzative.descrizione%type;
      d_dal         date;
      d_al          date;
   begin
      --
      -- Si valorizzano i parametri di default
      --
      d_data   := set_data_default(p_data);
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
   
      if p_modalita = 'C' then
         --#711
         d_progr_unor := comp_get_unita_prev(p_id_soggetto
                                            ,d_ottica
                                            ,d_data
                                            ,p_amministrazione
                                            ,p_modalita);
      else
         d_progr_unor := comp_get_unita_prev(p_id_soggetto
                                            ,d_ottica
                                            ,d_data
                                            ,p_amministrazione);
      end if;
      d_ni := so4_util.comp_get_approvatore(p_id_soggetto
                                           ,d_progr_unor
                                           ,p_ruolo_appr
                                           ,d_data
                                           ,d_ottica
                                           ,p_amministrazione);
      --
      -- Se non si trova l'approvatore nell'unita' di appartenenza, si ricerca
      -- l'approvatore nelle unita' di livello superiore
      --
      if d_ni is null then
         d_ref_cursor := so4_util.get_ascendenti(d_progr_unor, d_data, d_ottica);
         loop
            fetch d_ref_cursor
               into d_progr_padre
                   ,d_codice_uo
                   ,d_descrizione
                   ,d_dal
                   ,d_al;
            exit when d_ref_cursor%notfound;
            d_ni := so4_util.comp_get_approvatore(p_id_soggetto
                                                 ,d_progr_padre
                                                 ,p_ruolo_appr
                                                 ,d_data
                                                 ,d_ottica
                                                 ,p_amministrazione);
            if d_ni is not null then
               exit;
            end if;
         end loop;
      end if;
      --
      d_result := d_ni;
      return d_result;
      --
   end; -- so4_util.dipendente_get_approvatore
   -------------------------------------------------------------------------------
   function resp_get_responsabile
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        resp_get_responsabile.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'elenco (ni-cognome e nome)
                    dei componenti della sua unita aventi un incarico "responsabile" ed
                    eventualmente il ruolo indicato. Se il responsabile coincide con
                    l'ni indicato, si cerca il responsabile a livello superiore.
       PARAMETRI:   p_ni                 ni del componente
                    p_codice_uo          codice della unita organizzativa
                    p_ruolo              ruolo del componente (facoltativo - se non
                                         specificato si considerano tutti i ruoli)
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica
                                         istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le coppie ni / cognome e nome
                                      dei componenti "responsabili" dell'unita a cui e
                                      associato il componente separati dal carattere
                                      separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione               
      ******************************************************************************/
      d_result        afc.t_ref_cursor;
      d_ottica        ottiche.ottica%type;
      d_ref_cursor    afc.t_ref_cursor;
      d_progr_unor    componenti.progr_unita_organizzativa%type;
      d_ni            componenti.ni%type;
      d_denominazione as4_anagrafe_soggetti.denominazione%type;
      d_contatore     number(2);
      d_unita_padre   varchar2(2000);
      d_progr_padre   anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_contatore  := 0;
      d_ottica     := set_ottica_default(p_ottica, p_amministrazione);
      d_ref_cursor := so4_util.comp_get_responsabile(p_ni
                                                    ,p_codice_uo
                                                    ,p_ruolo
                                                    ,p_ottica
                                                    ,p_data
                                                    ,p_amministrazione);
      loop
         fetch d_ref_cursor
            into d_ni
                ,d_denominazione;
         exit when d_ref_cursor%notfound;
         d_contatore := d_contatore + 1;
         if d_contatore = 1 then
            exit;
         end if;
      end loop;
      --
      -- Se il responsabile coincide con il parametro ni, si ricerca il
      -- responsabile dell'unita' di livello superiore
      --
      if d_ni = p_ni or d_ni is null then
         d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => p_data);
         if d_progr_unor is not null then
            d_unita_padre := so4_util.unita_get_unita_padre(p_progr           => d_progr_unor
                                                           ,p_ottica          => p_ottica
                                                           ,p_data            => p_data
                                                           ,p_amministrazione => p_amministrazione);
            d_progr_padre := to_number(substr(d_unita_padre
                                             ,1
                                             ,instr(d_unita_padre, '#', 1, 1) - 1));
            if nvl(d_progr_padre, 0) != 0 then
               d_contatore  := 0;
               d_ref_cursor := so4_util.unita_get_responsabile(d_progr_padre
                                                              ,null
                                                              ,p_ottica
                                                              ,p_data
                                                              ,p_amministrazione);
               loop
                  fetch d_ref_cursor
                     into d_ni
                         ,d_denominazione;
                  exit when d_ref_cursor%notfound;
                  d_contatore := d_contatore + 1;
                  if d_contatore = 1 then
                     exit;
                  end if;
               end loop;
            end if;
         end if;
      end if;
      --
      open d_result for
         select d_ni
               ,d_denominazione
           from dual;
      --
      return d_result;
      --
   end; -- so4_util.resp_get_responsabile
   -------------------------------------------------------------------------------
   function anuo_get_progr
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        anuo_get_progr.
       DESCRIZIONE: Dato un codice U.O., restituisce il progressivo relativo
                    all'ottica indicata valido alla data di pubblicazione
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   p_ottica             ottica da trattare
                    p_codice_uo          codice dell'unita' organizzativa
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    
       RITORNA:     progressivo dell'unita' organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_ottica ottiche.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      begin
         select progr_unita_organizzativa
           into d_result
           from vista_pubb_anuo
          where ottica = d_ottica
            and codice_uo = p_codice_uo
            and p_data between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := to_number(null);
      end;
      return d_result;
   end; -- so4_util.anuo_get_progr
   -------------------------------------------------------------------------------
   function anuo_get_dal_id
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal%type is
      /******************************************************************************
       NOME:        anuo_get_dal_id
       DESCRIZIONE: Attributo dal di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.dal%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.dal%type;
   begin
      begin
         select dal
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_dal_id
   -------------------------------------------------------------------------------
   function anuo_get_codice_uo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /******************************************************************************
       NOME:        anuo_get_codice_uo
       DESCRIZIONE: Attributo codice_uo di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.codice_uo%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
   begin
      begin
         select codice_uo
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_codice_uo
   -------------------------------------------------------------------------------
   function anuo_get_descrizione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        anuo_get_descrizione
       DESCRIZIONE: Attributo descrizione di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.descrizione%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
   begin
      begin
         select descrizione
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_descrizione
   -------------------------------------------------------------------------------
   function anuo_get_des_abb
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb%type is
      /******************************************************************************
       NOME:        anuo_get_des_abb
       DESCRIZIONE: Attributo des_abb di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.des_abb%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.des_abb%type;
   begin
      begin
         select des_abb
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_des_abb
   -------------------------------------------------------------------------------
   function anuo_get_id_suddivisione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.id_suddivisione%type is
      /******************************************************************************
       NOME:        anuo_get_id_suddivisione
       DESCRIZIONE: Attributo id_suddivisione di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.id_suddivisione%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     07/02/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.id_suddivisione%type;
   begin
      begin
         select id_suddivisione
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_id_suddivisione
   -------------------------------------------------------------------------------
   function anuo_get_ottica
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.ottica%type is
      /******************************************************************************
       NOME:        anuo_get_ottica
       DESCRIZIONE: Attributo ottica di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.ottica%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.ottica%type;
   begin
      begin
         select ottica
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_ottica
   -------------------------------------------------------------------------------
   function anuo_get_amministrazione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.amministrazione%type is
      /******************************************************************************
       NOME:        anuo_get_amministrazione
       DESCRIZIONE: Attributo amministrazione di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.amministrazione%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.amministrazione%type;
   begin
      begin
         select amministrazione
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_amministrazione
   -------------------------------------------------------------------------------
   function anuo_get_progr_aoo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_aoo%type is
      /******************************************************************************
       NOME:        anuo_get_progr_aoo
       DESCRIZIONE: Attributo progr_aoo di riga esistente valida alla data di 
                    pubblicazione.
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.progr_aoo%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     07/02/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_aoo%type;
   begin
      begin
         select progr_aoo
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_progr_aoo
   --------------------------------------------------------------------------------
   function anuo_get_ass_comp
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.assegnazione_componenti%type is
      /******************************************************************************
       NOME:        anuo_get_ass_comp
       DESCRIZIONE: Attributo assegnazione_componenti di riga esistente identificata 
                    dalla chiave valido alla data di pubblicazione
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.assegnazione_componenti%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.assegnazione_componenti%type;
   begin
      begin
         select assegnazione_componenti
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_ass_comp
   --------------------------------------------------------------------------------
   function anuo_get_utente_ad4 
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.utente_ad4%type is
      /******************************************************************************
       NOME:        anuo_get_utente_ad4
       DESCRIZIONE: Attributo utente_AD4 di riga esistente identificata dalla chiave
                    valido alla data di pubblicazione
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.utente_ad4%type.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     25/01/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.utente_ad4%type;
   begin
      begin
         select utente_ad4
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- so4_util.anuo_get_utente_ad4
   -------------------------------------------------------------------------------
   procedure registra_log_cgs
   (
      p_utente   in varchar2
     ,p_testo    in varchar2
     ,p_tipo_msg in varchar2 default 'ERROR'
   ) is
      dummy         varchar2(1);
      d_applicativo varchar2(8) := 'SO4';
      d_operazione  varchar2(10) := 'IMPORT_UO';
      d_statement   varchar2(2000);
   begin
      begin
         select 'x'
           into dummy
           from user_objects
          where object_name = 'CGS_REGISTRA_LOG'
            and object_type = 'SYNONYM';
         d_statement := 'begin CGS_REGISTRA_LOG(' || '''' || p_utente || '''' || ',' || '''' ||
                        d_applicativo || '''' || ',' || '''' || d_operazione || '''' || ',' || '''' ||
                        p_testo || '''' || ',' || '''' || p_tipo_msg || '''' ||
                        ') ; end;';
         dbms_output.put_line(d_statement);
         execute immediate d_statement;
      exception
         when no_data_found then
            null;
      end;
   end;
   -------------------------------------------------------------------------------
   procedure anuo_import_uo_cgs
   (
      p_progr_uo            in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica_destinazione in ottiche.ottica%type
     ,p_progr_padre         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                in anagrafe_unita_organizzative.dal%type default trunc(sysdate)
   ) is
      /******************************************************************************
       NOME:        anuo_import_uo_cgs.
       DESCRIZIONE: import di una UO per CGS da un'ottica ad un'altra
       
       PARAMETRI:   p_progr_uo               Progressivo UO da importare
                    p_ottica_destinazione    Codice Ottica di destinazione
                    p_progr_padre            Progresivo UO padre nella struttura di destinazione
                    p_data                   Data di cecorrenza della UO nell'ottica di destinazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
      d_data            date := nvl(p_data, trunc(sysdate));
      d_max_dal         revisioni_struttura.dal%type;
      d_tipo_revisione  revisioni_struttura.tipo_revisione%type;
      d_dummy           varchar2(1);
      d_anuo            anagrafe_unita_organizzative%rowtype;
      d_revisione       revisioni_struttura.revisione%type;
      d_progressivo     anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_amministrazione anagrafe_unita_organizzative.amministrazione%type;
      d_statement       varchar2(200);
   begin
      --verifica dei parametri di input
      begin
         select 'x'
           into d_dummy
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_uo;
         raise too_many_rows;
      exception
         when too_many_rows then
            null;
         when no_data_found then
            registra_log_cgs('Aut.SO4'
                            ,'Progressivo UO da importare inesistente'
                            ,'ERROR');
            raise;
         when others then
            registra_log_cgs('Aut.SO4', 'Errore in lettura UO - ' || sqlerrm, 'ERROR');
            raise;
      end;
      begin
         select amministrazione
           into d_amministrazione
           from ottiche
          where ottica = p_ottica_destinazione;
         raise too_many_rows;
      exception
         when too_many_rows then
            null;
         when no_data_found then
            registra_log_cgs('Aut.SO4', 'Ottica di destinazione inesistente', 'ERROR');
            raise;
         when others then
            registra_log_cgs('Aut.SO4'
                            ,'Errore in lettura Ottiche - ' || sqlerrm
                            ,'ERROR');
            raise;
      end;
      begin
         select 'x'
           into d_dummy
           from unita_organizzative
          where (progr_unita_organizzativa = p_progr_padre or p_progr_padre is null)
            and ottica = p_ottica_destinazione
            and d_data between dal and nvl(al, s_data_limite);
         raise too_many_rows;
      exception
         when too_many_rows then
            null;
         when no_data_found then
            registra_log_cgs('Aut.SO4', 'Struttura di destinazione inesistente', 'ERROR');
            raise;
         when others then
            registra_log_cgs('Aut.SO4'
                            ,'Errore in lettura Struttura di destinazione - ' || sqlerrm
                            ,'ERROR');
            raise;
      end;
      --Verifica della presenza di una revisione con decorrenza compatibile
      select min(revisione)
        into d_revisione
        from revisioni_struttura
       where ottica = p_ottica_destinazione
         and dal = d_data
         and stato = 'A';
      if d_revisione is not null then
         update revisioni_struttura
            set stato = 'M'
          where ottica = p_ottica_destinazione
            and dal = d_data
            and stato = 'A'
            and revisione = d_revisione;
      else
         --crea la nuova revisione con la decorrenza data
         --verifica la presenza di una revisione in modifica
         begin
            select 'x'
              into d_dummy
              from revisioni_struttura
             where ottica = p_ottica_destinazione
               and stato = 'M'
               and nvl(dal, s_data_limite) <> d_data;
            raise too_many_rows;
         exception
            when too_many_rows then
               registra_log_cgs('Aut.SO4'
                               ,'Esiste una altra revisione in modifica per la ottica di destinazione'
                               ,'ERROR');
               raise;
            when no_data_found then
               select max(dal)
                 into d_max_dal
                 from revisioni_struttura
                where ottica = p_ottica_destinazione
                  and stato = 'A';
               if d_data > d_max_dal then
                  d_tipo_revisione := 'N';
               else
                  d_tipo_revisione := 'R';
               end if;
               begin
                  d_revisione := revisione_struttura.get_id_revisione(p_ottica_destinazione);
                  revisione_struttura.ins(p_ottica               => p_ottica_destinazione
                                         ,p_revisione            => d_revisione
                                         ,p_descrizione          => 'Revisione automatica import CGS ' ||
                                                                    d_revisione
                                         ,p_tipo_registro        => ''
                                         ,p_anno                 => ''
                                         ,p_numero               => ''
                                         ,p_data                 => ''
                                         ,p_dal                  => d_data
                                         ,p_data_pubblicazione   => trunc(sysdate)
                                         ,p_tipo_revisione       => d_tipo_revisione
                                         ,p_stato                => 'M'
                                         ,p_provenienza          => 'CGS'
                                         ,p_utente_aggiornamento => 'SO4'
                                         ,p_data_aggiornamento   => trunc(sysdate));
               exception
                  when others then
                     registra_log_cgs('Aut.SO4'
                                     ,'Errore in creazione revisione in modifica - ' ||
                                      sqlerrm
                                     ,'ERROR');
                     raise;
               end;
         end;
      end if;
      --Preleva le caratteristiche della UO da importare
      begin
         select *
           into d_anuo
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_uo
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            select *
              into d_anuo
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_uo
               and dal = (select max(dal)
                            from anagrafe_unita_organizzative
                           where progr_unita_organizzativa = p_progr_uo);
      end;
      --Verifica che l'UO da replicare non sia gia' presente nell'ottica di destinazione
      begin
         select 'x'
           into d_dummy
           from anagrafe_unita_organizzative
          where codice_uo = d_anuo.codice_uo
            and amministrazione = d_amministrazione
         ;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            registra_log_cgs('Aut.SO4', 'UO attualmente presente nella amministrazione di destinazione', 'ERROR');
            raise;
         when others then
            registra_log_cgs('Aut.SO4'
                            ,'Errore in lettura amministrazione di destinazione - ' || sqlerrm
                            ,'ERROR');
            raise;
      end;
      --Crea l'anagrafe della UO da importare
      begin
         select anagrafe_unita_organizzativa.get_id_unita into d_progressivo from dual;
         anagrafe_unita_organizzativa.ins(p_progr_unita_organizzativa => d_progressivo
                                         ,p_dal                       => d_data
                                         ,p_codice_uo                 => d_anuo.codice_uo
                                         ,p_descrizione               => d_anuo.descrizione
                                         ,p_descrizione_al1           => d_anuo.descrizione_al1
                                         ,p_descrizione_al2           => d_anuo.descrizione_al2
                                         ,p_des_abb                   => d_anuo.des_abb
                                         ,p_des_abb_al1               => d_anuo.des_abb_al1
                                         ,p_des_abb_al2               => d_anuo.des_abb_al2
                                         ,p_id_suddivisione           => '' --d_anuo.id_suddivisione
                                         ,p_ottica                    => p_ottica_destinazione
                                         ,p_revisione_istituzione     => d_revisione
                                         ,p_revisione_cessazione      => ''
                                         ,p_tipologia_unita           => d_anuo.tipologia_unita
                                         ,p_se_giuridico              => d_anuo.se_giuridico
                                         ,p_assegnazione_componenti   => d_anuo.assegnazione_componenti
                                         ,p_amministrazione           => d_amministrazione
                                         ,p_progr_aoo                 => d_anuo.progr_aoo
                                         ,p_indirizzo                 => d_anuo.indirizzo
                                         ,p_cap                       => d_anuo.cap
                                         ,p_provincia                 => d_anuo.provincia
                                         ,p_comune                    => d_anuo.comune
                                         ,p_telefono                  => d_anuo.telefono
                                         ,p_fax                       => d_anuo.fax
                                         ,p_centro                    => d_anuo.centro
                                         ,p_centro_responsabilita     => d_anuo.centro_responsabilita
                                         ,p_al                        => ''
                                         ,p_utente_ad4                => ''
                                         ,p_utente_aggiornamento      => 'Imp.CGS'
                                         ,p_data_aggiornamento        => trunc(sysdate)
                                         ,p_note                      => d_anuo.note
                                         ,p_tipo_unita                => d_anuo.tipo_unita
                                         ,p_dal_pubb                  => d_data
                                         ,p_al_pubb                   => ''
                                         ,p_al_prec                   => ''
                                         ,p_incarico_resp             => d_anuo.incarico_resp
                                         ,p_etichetta                 => d_anuo.etichetta
                                         ,p_aggregatore               => d_anuo.aggregatore
                                         ,p_se_fattura_elettronica    => d_anuo.se_fattura_elettronica);
      exception
         when others then
            rollback;
            registra_log_cgs('Aut.SO4'
                            ,'Errore in creazione anagrafe UO - ' || sqlerrm
                            ,'ERROR');
            raise;
      end;
      --Inserisce la UO importata nella struttura dell'ottica di destinazione
      begin
         unita_organizzativa.ins(p_id_elemento               => ''
                                ,p_ottica                    => p_ottica_destinazione
                                ,p_revisione                 => d_revisione
                                ,p_sequenza                  => ''
                                ,p_progr_unita_organizzativa => d_progressivo
                                ,p_id_unita_padre            => p_progr_padre
                                ,p_revisione_cessazione      => ''
                                ,p_dal                       => d_data
                                ,p_al                        => ''
                                ,p_utente_aggiornamento      => 'Imp.CGS'
                                ,p_data_aggiornamento        => trunc(sysdate)
                                ,p_dal_pubb                  => d_data
                                ,p_al_pubb                   => ''
                                ,p_al_prec                   => ''
                                ,p_revisione_cess_prec       => '');
      exception
         when others then
            rollback;
            registra_log_cgs('Aut.SO4'
                            ,'Errore durante inserimento in struttura - ' || sqlerrm
                            ,'ERROR');
            raise;
      end;
      --attivazione della revisione
      begin
         d_statement := 'alter trigger revisioni_struttura_tiu disable';
         dbms_output.put_line(d_statement);
         execute immediate d_statement;
      
         update revisioni_struttura
            set stato = 'A'
          where stato = 'M'
            and revisione = d_revisione
            and ottica = p_ottica_destinazione;
      
         d_statement := 'alter trigger revisioni_struttura_tiu enable';
         dbms_output.put_line(d_statement);
         execute immediate d_statement;
      
      exception
         when others then
            rollback;
            registra_log_cgs('Aut.SO4'
                            ,'Errore durante l''attivazione della revisione - ' ||
                             sqlerrm
                            ,'ERROR');
            raise;
      end;
      registra_log_cgs('Aut.SO4', 'operazione eseguita', 'MSG');
   exception
      when others then
         rollback;
         registra_log_cgs('Aut.SO4'
                         ,'Errore inatteso durante la fase di importazione - ' ||
                          sqlerrm
                         ,'ERROR');
   end;
   -------------------------------------------------------------------------------
   function codice_get_descrizione
   (
      p_ottica ottiche.ottica%type
     ,p_codice anagrafe_unita_organizzative.codice_uo%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        codice_get_descrizione
       DESCRIZIONE: Dati ottica e codice di una unita' organizzativa
                    restituisce la descrizione
       PARAMETRI:   p_ottica
                    p_codice
                    p_data
       RITORNA:     anagrafe_unita_organizzative.descrizione%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   07/10/2009  VD      Prima emissione.
       001   02/02/2010  VD      Aggiunta selezione per data
       002   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
   begin
      begin
         select descrizione
           into d_result
           from vista_pubb_anuo
          where ottica = p_ottica
            and codice_uo = p_codice
            and p_data between dal and nvl(al, s_data_limite);
      exception
         when no_data_found then
            d_result := 'Unita'' non piu'' valida';
         when too_many_rows then
            d_result := 'Esistono piu'' unita'' con lo stesso codice';
      end;
      --
      return d_result;
      --
   end; -- so4_util.codice_get_descrizione
   -------------------------------------------------------------------------------
   function unita_get_descrizione
   (
      p_codice_gruppo in anagrafe_unita_organizzative.utente_ad4%type
     ,p_dal           in anagrafe_unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        unita_get_descrizione
       DESCRIZIONE: Dato un utente di AD4 di tipo "O" (Unità organizzativa),
                    restituisce la descrizione
       PARAMETRI:   p_codice_gruppo  utente AD4
                    p_data           data a cui effettuare la ricerca (facoltativa -
                                     se non indicata si assume la data di sistema)
       RITORNA:     anagrafe_unita_organizzative.descrizione%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   30/11/2006  AOLIVIERI  Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     anagrafe_unita_organizzative.descrizione%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_progr_unor := so4_util.ad4_get_progr_unor(p_codice_gruppo, p_dal);
      d_result     := so4_util.anuo_get_descrizione(d_progr_unor, p_dal);
      return d_result;
   end; -- so4_util.unita_get_descrizione
   -------------------------------------------------------------------------------
   function unita_get_descrizione
   (
      p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type
     ,p_dal             in anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type
   ) return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        unita_get_descrizione
       DESCRIZIONE: Dato un codice di U.O. restituisce la descrizione
       PARAMETRI:   p_codice_uo      codice U.O.
                    p_data           data a cui effettuare la ricerca (facoltativa -
                                     se non indicata si assume la data di sistema)
       RITORNA:     anagrafe_unita_organizzative.descrizione%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   30/11/2009  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     anagrafe_unita_organizzative.descrizione%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_progr_unor := so4_util.anuo_get_progr(p_amministrazione => p_amministrazione
                                             ,p_codice_uo       => p_codice_uo
                                             ,p_data            => p_dal);
      d_result     := so4_util.anuo_get_descrizione(d_progr_unor, p_dal);
      return d_result;
   end; -- so4_util. unita_get_descrizione
   -------------------------------------------------------------------------------
   function unita_get_ultima_descrizione(p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        unita_get_ultima_descrizione
       DESCRIZIONE: Dato il progr. di una U.O., restituisce l'ultima descrizione in
                    ordine di data validita'
       PARAMETRI:   p_progr_unor     Progr. unita' organizzativa
       RITORNA:     anagrafe_unita_organizzative.descrizione%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   15/10/2010  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
   begin
      begin
         select a.descrizione
           into d_result
           from vista_pubb_anuo a
          where a.progr_unita_organizzativa = p_progr_unor
            and a.dal = (select max(b.dal)
                           from vista_pubb_anuo b
                          where b.progr_unita_organizzativa = p_progr_unor);
      exception
         when others then
            d_result := 'Unita'' organizzativa non codificata';
      end;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_ultima_descrizione
   -------------------------------------------------------------------------------
   function unita_get_ultima_descrizione(p_codice_uo in anagrafe_unita_organizzative.codice_uo%type)
      return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        unita_get_ultima_descrizione
       DESCRIZIONE: Dato il codice di una U.O., restituisce l'ultima descrizione in
                    ordine di data validita'
       ATTENZIONE! Questa funzione potrebbe restituire dati errati se lo stesso
                   codice viene usato in amministrazioni / ottiche diverse.                    
       PARAMETRI:   p_codice_uo     Codice unita' organizzativa
       RITORNA:     anagrafe_unita_organizzative.descrizione%type
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   15/10/2010  VD      Prima emissione.
       001   26/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
   begin
      begin
         select a.descrizione
           into d_result
           from vista_pubb_anuo a
          where a.codice_uo = p_codice_uo
            and a.dal =
                (select max(b.dal) from vista_pubb_anuo b where b.codice_uo = p_codice_uo);
      exception
         when others then
            d_result := 'Unita'' organizzativa non codificata';
      end;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_ultima_descrizione
   -------------------------------------------------------------------------------
   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_codice_valido
      DESCRIZIONE: Restituisce una stringa contenente il codice dell'unita' alla
                   data indicata; se non esiste, restituisce l'ultimo codice valido
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
      RITORNA:     varchar2                codice dell'unita'; se non esiste, 16 asterischi
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   17/01/2011  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
      d_data   date;
   begin
      d_data := set_data_default(p_data);
      begin
         select codice_uo
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unor
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      --
      if d_result is null then
         begin
            select a.codice_uo
              into d_result
              from vista_pubb_anuo a
             where a.progr_unita_organizzativa = p_progr_unor
               and a.dal = (select max(b.dal)
                              from vista_pubb_anuo b
                             where b.progr_unita_organizzativa = p_progr_unor);
         exception
            when others then
               d_result := rpad('*', 16, '*');
         end;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_codice_valido
   -------------------------------------------------------------------------------
   function unita_get_dal_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return unita_organizzative.dal%type is
      /******************************************************************************
      NOME:        unita_get_dal_valido
      DESCRIZIONE: Restituisce il dal dell'unita' valido alla data indicata, 
                   altrimenti restituisce il max(dal)
                   Richiesta per universi BO procedura CIWEB
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
      RITORNA:     dal%type                dal dell'unita' organizzativa
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   31/08/2011  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.dal%type;
      d_data   date;
   begin
      d_data := set_data_default(p_data);
      begin
         select dal
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unor
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      --
      if d_result is null then
         select max(a.dal)
           into d_result
           from vista_pubb_anuo a
          where a.progr_unita_organizzativa = p_progr_unor;
      end if;
      --
      if d_result is null then
         d_result := trunc(sysdate);
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_dal_valido
   -------------------------------------------------------------------------------
   function unita_get_descr_valida
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_descr_valida
      DESCRIZIONE: Restituisce una stringa contenente la descrizione dell'unita' alla
                   data indicata; se non esiste, restituisce l'ultima descrizione valida
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
      RITORNA:     varchar2                descrizione dell'unita'; se non esiste,
                                           120 asterischi
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   17/01/2011  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
      d_data   date;
   begin
      d_data := set_data_default(p_data);
      begin
         select descrizione
           into d_result
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unor
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      --
      if d_result is null then
         begin
            select a.descrizione
              into d_result
              from vista_pubb_anuo a
             where a.progr_unita_organizzativa = p_progr_unor
               and a.dal = (select max(b.dal)
                              from vista_pubb_anuo b
                             where b.progr_unita_organizzativa = p_progr_unor);
         exception
            when others then
               d_result := rpad('*', 120, '*');
         end;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_descr_valida
   -------------------------------------------------------------------------------
   function unita_get_componenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_componenti.
       DESCRIZIONE: Dato un progr. U.O., restituisce l'elenco (ni - descrizione)
                    dei componenti dell'unita.
       PARAMETRI:   p_progr_uo           progressivo dell'unita organizzativa
                    p_ruolo              ruolo da selezionare (facoltativo)
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura
                                         (facoltativa - alternativa all'ottica per la
                                         definizione dell'ottica istituzionale
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei
                    componenti dell'unita organizzativa separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   17/02/2011  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      if p_ruolo is null then
         open d_result for
            select distinct ni
                           ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
             where c.progr_unita_organizzativa = p_progr_uo
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
             order by 2
                     ,1;
      else
         open d_result for
            select distinct ni
                           ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.progr_unita_organizzativa = p_progr_uo
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_componenti
   -------------------------------------------------------------------------------
   function unita_get_componenti
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_componenti.
       DESCRIZIONE: Dato un codice U.O., restituisce l'elenco (ni - descrizione)
                    dei componenti dell'unita.
       PARAMETRI:   p_codice_uo          codice dell'unita organizzativa
                    p_ruolo              ruolo da selezionare (facoltativo)
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura
                                         (facoltativa - alternativa all'ottica per la
                                         definizione dell'ottica istituzionale)
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei
                    componenti dell'unita organizzativa separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   15/12/2006  VD        Prima emissione.
       001   26/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      if p_ruolo is null then
         open d_result for
            select distinct ni
                           ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
             order by 2
                     ,1;
      else
         open d_result for
            select distinct ni
                           ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_componenti
   -------------------------------------------------------------------------------
   function unita_get_componenti_ord
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_componenti_ord.
       DESCRIZIONE: Dato un codice U.O., restituisce l'elenco (ni - descrizione)
                    dei componenti dell'unita.
       PARAMETRI:   p_codice_uo          codice dell'unita organizzativa
                    p_ruolo              ruolo da selezionare (facoltativo)
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura
                                         (facoltativa - alternativa all'ottica per la
                                         definizione dell'ottica istituzionale
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei
                    componenti dell'unita organizzativa separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   15/12/2006  VD        Prima emissione.
       001   27/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       002   21/08/2014  MM/AD     Modificata clausola di order by per valutare l'incarico
                                   di responsabilita' alla data di riferimento (Bug#487)                        
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica          => d_ottica
                                             ,p_amministrazione => p_amministrazione
                                             ,p_codice_uo       => p_codice_uo
                                             ,p_data            => d_data);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      if p_ruolo is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,comp_get_utente(ni) utente
              from vista_pubb_comp c
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
            --order by decode(so4_util.comp_get_se_resp(c.id_componente, c.dal)
             order by decode(so4_util.comp_get_se_resp(c.id_componente, d_data) --issue #487
                            ,'SI'
                            ,1
                            ,2)
                     ,2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,comp_get_utente(ni) utente
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
            --order by decode(so4_util.comp_get_se_resp(c.id_componente, c.dal)
             order by decode(so4_util.comp_get_se_resp(c.id_componente, d_data) --issue #487
                            ,'SI'
                            ,1
                            ,2)
                     ,2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_componenti_ord
   -------------------------------------------------------------------------------
   function unita_get_componenti_nruolo
   (
      p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_componenti_nruolo.
       DESCRIZIONE: Dato un progr. U.O., restituisce l'elenco (ni - descrizione)
                    dei componenti dell'unita che NON hanno il ruolo indicato.
       PARAMETRI:   p_progr_unor         progr. dell'unita organizzativa
                    p_ruolo              ruolo da selezionare
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura
                                         (facoltativa - alternativa all'ottica per la
                                         definizione dell'ottica istituzionale
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei
                    componenti dell'unita organizzativa separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   16/03/2011  VD        Prima emissione.
       001   30/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica componenti.ottica%type;
      d_data   componenti.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select distinct ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.progr_unita_organizzativa = p_progr_unor
            and c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo != p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- unita_get_componenti_nruolo
   -------------------------------------------------------------------------------
   function unita_get_componenti_nruolo
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ad4_ruoli.ruolo%type
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_componenti_nruolo.
       DESCRIZIONE: Dato un codice U.O., restituisce l'elenco (ni - descrizione)
                    dei componenti dell'unita che NON hanno il ruolo indicato.
       PARAMETRI:   p_codice_uo          codice dell'unita organizzativa
                    p_ruolo              ruolo da selezionare
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura
                                         (facoltativa - alternativa all'ottica per la
                                         definizione dell'ottica istituzionale)
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei
                    componenti dell'unita organizzativa separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   15/12/2006  VD        Prima emissione.
       001   17/01/2011  VD        Corretto confronto revisione cessazione con
                                   revisione in modifica (nvl)
       002   30/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica          => d_ottica
                                             ,p_amministrazione => p_amministrazione
                                             ,p_codice_uo       => p_codice_uo
                                             ,p_data            => d_data);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select distinct ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.progr_unita_organizzativa = d_progr_unor
            and c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo != p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_componenti_nruolo
   -------------------------------------------------------------------------------
   function unita_get_unita_figlie
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_figlie.
       DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                    (progressivo, codice e descrizione) delle unita figlie
       PARAMETRI:   p_progr           progressivo che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le righe progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   31/01/2007  SC      Prima emissione.
       001   14/01/2008  SC      Restituisco anche la data di fine validita' delle unita
       002   30/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica unita_organizzative.ottica%type;
      d_data   unita_organizzative.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
           from vista_pubb_unita v
          where v.ottica = d_ottica
            and v.progr_unita_padre = p_progr
            and d_data between v.dal and nvl(v.al, s_data_limite)
          order by 2
                  ,3;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_unita_figlie
   -------------------------------------------------------------------------------
   function unita_get_unita_figlie
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_figlie.
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco (progressivo, codice e descrizione)
                    delle unita figlie
       PARAMETRI:   p_codice_uo       codice che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Stringa contenente le righe progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   31/01/2007  SC      Prima emissione.
       001   30/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     unita_organizzative.ottica%type;
      d_data       unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      d_result     := unita_get_unita_figlie(d_progr_unor
                                            ,d_ottica
                                            ,d_data
                                            ,p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_util.unita_get_unita_figlie
   -------------------------------------------------------------------------------
   function unita_get_unita_figlie_ord
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_figlie_ord.
       DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                    (progressivo, codice e descrizione) delle unita figlie
                    ordinato per sequenza
       PARAMETRI:   p_progr           progressivo che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Stringa contenente le righe progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   19/12/2008  VD      Prima emissione.
       001   30/01/2012  VD      Sostituite tabelle con viste per date di pubblicazione
       002   12/09/2013  AD      Aggiunti alias codice_uo e descrizione_uo su colonne
                                 del cursore                              
       003   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     unita_organizzative.ottica%type;
      d_data       unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --                                             
      open d_result for
         select progr_unita_organizzativa
               ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
               ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione_uo
               ,dal
               ,al
           from vista_pubb_unor
          where id_unita_padre = d_progr_unor
            and ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
          order by sequenza
                  ,2;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_unita_figlie_ord
   -------------------------------------------------------------------------------
   function unita_get_unita_padre
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_unita_padre.
       DESCRIZIONE: Dato il progressivo di un'unita restituisce i dati
                    (progressivo, codice e descrizione) dell'unita padre
       PARAMETRI:   p_progr           progressivo che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
                    p_tipo_data       indica quale data utilizzare nella ricerca:
                                      null = data di pubblicazione
                                      1 = data effettiva
       RITORNA:     varchar2          Stringa contenente i dati progressivo, codice unita, descrizione
                                      dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   04/06/2007  VD        Prima emissione.
       001   30/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       002   19/03/2012  VD        Aggiunto parametro per gestione tipo data                  
       003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result       varchar2(2000);
      d_ottica       unita_organizzative.ottica%type;
      d_data         unita_organizzative.dal%type;
      d_revisione    unita_organizzative.revisione%type;
      d_progr_padre  unita_organizzative.progr_unita_organizzativa%type;
      d_codice_padre anagrafe_unita_organizzative.codice_uo%type;
      d_descr_padre  anagrafe_unita_organizzative.descrizione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      begin
         select id_unita_padre
           into d_progr_padre
           from vista_pubb_unor
          where ottica = d_ottica
            and progr_unita_organizzativa = p_progr
            and d_data between dal and nvl(al, s_data_limite)
            and p_tipo_data is null
         union
         select id_unita_padre
           from unita_organizzative
          where ottica = d_ottica
            and progr_unita_organizzativa = p_progr
            and revisione != d_revisione
            and d_data between dal and
                nvl(decode(nvl(revisione_cessazione, -2), d_revisione, to_date(null), al)
                   ,s_data_limite)
            and p_tipo_data = 1;
      exception
         when no_data_found then
            d_progr_padre := to_number(null);
         when too_many_rows then
            d_progr_padre := to_number(null);
      end;
      --
      d_codice_padre := so4_util.anuo_get_codice_uo(p_progr_unita_organizzativa => d_progr_padre
                                                   ,p_dal                       => d_data);
      d_descr_padre  := so4_util.anuo_get_descrizione(p_progr_unita_organizzativa => d_progr_padre
                                                     ,p_dal                       => d_data);
      d_result       := d_progr_padre || '#' || d_codice_padre || '#' || d_descr_padre;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_unita_padre
   -------------------------------------------------------------------------------
   function unita_get_unita_padre
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_unita_padre.
       DESCRIZIONE: Dato il codice di un'unita restituisce i dati
                    (progressivo, codice e descrizione) dell'unita padre
       PARAMETRI:   p_codice_uo       codice dell'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     varchar2          Stringa contenente i dati progressivo, codice unita, descrizione
                                      dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   04/06/2007  VD        Prima emissione.
       001   30/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     varchar2(2000);
      d_ottica     unita_organizzative.ottica%type;
      d_data       unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      d_result     := unita_get_unita_padre(p_progr           => d_progr_unor
                                           ,p_ottica          => d_ottica
                                           ,p_data            => d_data
                                           ,p_amministrazione => p_amministrazione);
      d_result     := substr(d_result, instr(d_result, '#', 1, 2) + 1, 200);
      return d_result;
      --
   end; -- so4_util.unita_get_unita_padre
   -------------------------------------------------------------------------------
   function unita_get_unita_padre_eff
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_unita_padre_eff.
       DESCRIZIONE: Dato il progressivo di un'unita restituisce i dati
                    (progressivo, codice e descrizione) dell'unita padre
                    effettuando la ricerca per date di validita' effettiva
       PARAMETRI:   p_progr           progressivo che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     varchar2          Stringa contenente i dati progressivo, codice unita, descrizione
                                      dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   19/03/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result varchar2(2000);
   begin
      d_result := so4_util.unita_get_unita_padre(p_progr           => p_progr
                                                ,p_ottica          => p_ottica
                                                ,p_data            => p_data
                                                ,p_amministrazione => p_amministrazione
                                                ,p_tipo_data       => 1);
      --
      return d_result;
   end; -- so4_util.unita_get_unita_padre_eff
   -------------------------------------------------------------------------------
   function unita_get_radice
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_radice.
       DESCRIZIONE: Dato il progressivo di un'unita restituisce i dati
                    (progressivo, codice e descrizione) dell'unita radice della struttura
       PARAMETRI:   p_progr           progressivo che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     varchar2          Stringa contenente i dati progressivo, codice unita, descrizione
                                      dell'unita radice.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   11/01/2009  VD        Prima emissione.
       001   30/01/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result        varchar2(2000);
      d_ottica        unita_organizzative.ottica%type;
      d_data          unita_organizzative.dal%type;
      d_progr_radice  unita_organizzative.progr_unita_organizzativa%type;
      d_codice_radice anagrafe_unita_organizzative.codice_uo%type;
      d_descr_radice  anagrafe_unita_organizzative.descrizione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      for sel_asc in (select /*+ first_rows */
                       progr_unita_organizzativa
                      ,id_unita_padre
                        from vista_pubb_unor
                       where ottica = d_ottica
                         and d_data between dal and nvl(al, s_data_limite)
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = d_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with progr_unita_organizzativa = p_progr
                              and ottica = d_ottica
                              and d_data between dal and nvl(al, s_data_limite)
                       order by level desc)
      loop
         if sel_asc.id_unita_padre is null then
            d_progr_radice := sel_asc.progr_unita_organizzativa;
         end if;
      end loop;
      d_codice_radice := anagrafe_unita_organizzativa.get_codice_uo(p_progr_unita_organizzativa => d_progr_radice
                                                                   ,p_dal                       => d_data);
      d_descr_radice  := anagrafe_unita_organizzativa.get_descrizione(p_progr_unita_organizzativa => d_progr_radice
                                                                     ,p_dal                       => d_data);
      d_result        := d_progr_radice || '#' || d_codice_radice || '#' ||
                         d_descr_radice;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_radice
   -------------------------------------------------------------------------------
   function unita_get_radice
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_radice.
       DESCRIZIONE: Dato il codice di un'unita restituisce i dati
                    (progressivo, codice e descrizione) dell'unita radice
       PARAMETRI:   p_codice_uo       codice dell'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     varchar2          Stringa contenente i dati progressivo, codice unita, descrizione
                                      dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   10/01/2009  VD        Prima emissione.
       001   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     varchar2(2000);
      d_ottica     unita_organizzative.ottica%type;
      d_data       unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      d_result     := so4_util.unita_get_radice(p_progr           => d_progr_unor
                                               ,p_ottica          => d_ottica
                                               ,p_data            => d_data
                                               ,p_amministrazione => p_amministrazione);
      return d_result;
      --
   end; -- so4_util.unita_get_radice
   -------------------------------------------------------------------------------
   function unita_get_pari_livello
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            anagrafe_unita_organizzative.dal%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_pari_livello.
       DESCRIZIONE: Dato il progr. di un'unita restituisce l'elenco (progressivo, 
                    codice e descrizione) delle unita "sorelle" (stesso padre, 
                    stesso livello)
       PARAMETRI:   p_progr_uo        progressivo dell'unita organizzativa
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le righe progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   31/01/2007  SC      Prima emissione.
       001   14/01/2008  SC      Restituisco anche la data di fine validita' delle unita
       002   03/02/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica unita_organizzative.ottica%type;
      d_data   unita_organizzative.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
           from vista_pubb_unita v
          where v.ottica = d_ottica
            and v.progr_unita_organizzativa != p_progr_uo
            and d_data between v.dal and nvl(v.al, s_data_limite)
            and nvl(v.progr_unita_padre, 0) in
                (select nvl(v2.progr_unita_padre, 0)
                   from vista_pubb_unita v2
                  where v2.ottica = d_ottica
                    and v2.progr_unita_organizzativa = p_progr_uo
                    and d_data between v2.dal and nvl(v2.al, s_data_limite))
          order by 2
                  ,3;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_unita_pari_livello
   -------------------------------------------------------------------------------
   function unita_get_pari_livello
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_pari_livello.
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco (progressivo, 
                    codice e descrizione) delle unita "sorelle" (stesso padre, 
                    stesso livello)
       PARAMETRI:   p_codice_uo       codice che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      se non specificata si considera l'ottica
                                      istituzionale)
                    p_data            data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                    p_amministrazione amministrazione di ricerca nella struttura 
                                      (facoltativa - alternativa all'ottica per la
                                      definizione dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le righe progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   31/01/2007  SC      Prima emissione.
       001   14/01/2008  SC      Restituisco anche la data di fine validita' delle unita
       002   03/02/2012  VD      Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     unita_organizzative.ottica%type;
      d_data       unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
      --      d_id_unita_padre unita_organizzative.id_unita_padre%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      --
      d_result := so4_util.unita_get_pari_livello(p_progr_uo        => d_progr_unor
                                                 ,p_data            => d_data
                                                 ,p_ottica          => d_ottica
                                                 ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_util.unita_get_unita_pari_livello
   -------------------------------------------------------------------------------
   function unita_get_storico_figlie
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_figlie
       DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                    (progressivo, codice, descrizione, dal e al) delle unita figlie
                    dell'unita' indicata.
       PARAMETRI:   p_progr_uo        progressivo dell'unita organizzativa
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      alternativa all'amministrazione)
                    p_amministrazione amministrazione di ricerca nella struttura
                                      (facoltativa - alternativa all'ottica)
       RITORNA:     Afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                            di appartenenza della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   06/05/2008  VD        Prima emissione.
       001   23/05/2011  VD        Modificata query per utilizzo vista_unita_organizzative
                                   al posto delle tabelle
       002   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      open d_result for
         select v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
           from vista_pubb_unita v
          where v.ottica = d_ottica
            and v.progr_unita_padre = p_progr_uo
          order by 2
                  ,3;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_storico_figlie
   -------------------------------------------------------------------------------
   function unita_get_storico_figlie
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_figlie
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco
                    (progressivo, codice, descrizione, dal e al) delle unita figlie
                    dell'unita' indicata.
       PARAMETRI:   p_codice_uo       codice che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      alternativa all'amministrazione)
                    p_amministrazione amministrazione di ricerca nella struttura
                                      (facoltativa - alternativa all'ottica)
       RITORNA:     Afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                            di appartenenza della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   06/05/2008  VD        Prima emissione.
       001   23/05/2011  VD        Modificata query per utilizzo vista_unita_organizzative
                                   al posto delle tabelle
       002   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si determina il progressivo associato al codice dell'unita' organizzativa
      --
      begin
         select min(progr_unita_organizzativa)
           into d_progr_unor
           from vista_pubb_anuo
          where ottica = d_ottica
            and codice_uo = p_codice_uo;
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'Codice Unita non piu'' utilizzato - ' ||
                                    p_codice_uo);
      end;
      --
      d_result := so4_util.unita_get_storico_figlie(p_progr_uo        => d_progr_unor
                                                   ,p_ottica          => d_ottica
                                                   ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_util.unita_get_storico_figlie
   -------------------------------------------------------------------------------
   function unita_get_storico_discendenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_discendenti
       DESCRIZIONE: dato il progressivo di un'unita restituisce l'elenco
                    (progressivo, codice, descrizione e dal) delle unita
                    discendenti.
       PARAMETRI:   p_progr_uo              progressivo dell'unita organizzativa
                    p_ottica                ottica di ricerca nella struttura (facoltativo -
                                            alternativa all'amministrazione)
                    p_amministrazione       amministrazione di ricerca nella struttura
                                            (facoltativa - alternativa all'ottica)
       RITORNA:     afc.t_ref_cursor        cursore contenente la gerarchia delle
                                            unita' figlie della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   06/08/2008  VD        prima emissione.
       001   23/05/2011  VD        Modificata query per utilizzo vista_unita_organizzative
                                   al posto delle tabelle
       002   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione   
       003   02/03/2015  MM        Nuova versione per #576                  
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --#576
      begin
         for unor in (select v.progr_unita_organizzativa
                            ,v.dal
                            ,v.al
                        from vista_pubb_unor v
                       where v.ottica = d_ottica
                      connect by prior v.progr_unita_organizzativa = v.id_unita_padre
                             and v.ottica = d_ottica
                       start with v.ottica = d_ottica
                              and v.progr_unita_organizzativa = p_progr_uo
                       order by progr_unita_organizzativa
                               ,dal)
         loop
            for anuo in (select codice_uo
                               ,descrizione
                               ,greatest(unor.dal, a.dal_pubb) dal
                               ,decode(least(nvl(unor.al, to_date(3333333, 'j'))
                                            ,nvl(a.al_pubb, to_date(3333333, 'j')))
                                      ,to_date(3333333, 'j')
                                      ,to_date(null)
                                      ,least(nvl(unor.al, to_date(3333333, 'j'))
                                            ,nvl(a.al_pubb, to_date(3333333, 'j')))) al
                           from anagrafe_unita_organizzative a
                          where progr_unita_organizzativa = unor.progr_unita_organizzativa
                            and a.dal_pubb <= nvl(unor.al, to_date(3333333, 'j'))
                            and nvl(a.al_pubb, to_date(3333333, 'j')) >= unor.dal
                          order by 3)
            loop
               insert into temp_struttura_so4
                  (progr_unita_organizzativa
                  ,codice_uo
                  ,descrizione_uo
                  ,dal
                  ,al)
               values
                  (unor.progr_unita_organizzativa
                  ,anuo.codice_uo
                  ,anuo.descrizione
                  ,anuo.dal
                  ,anuo.al);
            end loop;
         end loop;
      end;
      --
      open d_result for
         select t.progr_unita_organizzativa
               ,t.codice_uo
               ,t.descrizione_uo
               ,t.dal
               ,t.al
           from temp_struttura_so4 t;
      /*       --versione precedente la #576
               open d_result for
               select \*+ first_rows *\
                v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
                 from vista_pubb_unita v
                where v.ottica = d_ottica
               connect by prior v.progr_unita_organizzativa = v.progr_unita_padre
                      and v.ottica = d_ottica
                start with v.ottica = d_ottica
                       and v.progr_unita_organizzativa = p_progr_uo;
      */ --
      return d_result;
      --
   end; -- so4_util.unita_get_storico_discendenti
   -------------------------------------------------------------------------------
   function unita_get_storico_discendenti
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_discendenti
       DESCRIZIONE: dato il codice di un'unita restituisce l'elenco
                    (progressivo, codice, descrizione e dal) delle unita
                    discendenti.
       PARAMETRI:   p_codice_uo             codice che identifica l'unita
                    p_ottica                ottica di ricerca nella struttura (facoltativo -
                                            alternativa all'amministrazione)
                    p_amministrazione       amministrazione di ricerca nella struttura
                                            (facoltativa - alternativa all'ottica)
       RITORNA:     afc.t_ref_cursor        cursore contenente la gerarchia delle
                                            unita' figlie della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   06/08/2008  VD        prima emissione.
       001   23/05/2011  VD        Modificata query per utilizzo vista_unita_organizzative
                                   al posto delle tabelle
       002   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si determina il progressivo associato al codice dell'unita' organizzativa
      --
      begin
         select min(progr_unita_organizzativa)
           into d_progr_unor
           from vista_pubb_anuo
          where ottica = d_ottica
            and codice_uo = p_codice_uo;
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'Codice Unita non piu'' utilizzato - ' ||
                                    p_codice_uo);
      end;
      --
      d_result := so4_util.unita_get_storico_discendenti(p_progr_uo        => d_progr_unor
                                                        ,p_ottica          => d_ottica
                                                        ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_util.unita_get_storico_discendenti
   -------------------------------------------------------------------------------
   function unita_get_storico_pari_livello
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_pari_livello.
       DESCRIZIONE: Dato il progr. di un'unita restituisce l'elenco (progressivo,
                    codice, descrizione, dal e al) delle unita' di pari livello.
       PARAMETRI:   p_codice_uo       progressivo dell'unita organizzativa
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      alternativa all'amministrazione)
                    p_amministrazione amministrazione di ricerca nella struttura
                                      (facoltativa - alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor  Stringa contenente le righe con progressivo,
                                      codice unita, descrizione, dal e al delle
                                      unita di pari livello.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       0     06/05/2008  VD        Prima emissione.
       001   23/05/2011  VD        Modificata query per utilizzo vista_unita_organizzative
                                   al posto delle tabelle
       002   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica unita_organizzative.ottica%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      open d_result for
         select v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
           from vista_pubb_unita v
          where v.ottica = d_ottica
            and v.progr_unita_organizzativa != p_progr_uo
            and nvl(v.progr_unita_padre, 0) in
                (select nvl(v2.progr_unita_padre, 0)
                   from vista_unita_organizzative v2
                  where v2.ottica = d_ottica
                    and v2.progr_unita_organizzativa = p_progr_uo)
          order by 2
                  ,3;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_storico_pari_livello
   -------------------------------------------------------------------------------
   function unita_get_storico_pari_livello
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_pari_livello.
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco (progressivo,
                    codice, descrizione, dal e al) delle unita' di pari livello.
       PARAMETRI:   p_codice_uo       codice che identifica l'unita
                    p_ottica          ottica di ricerca nella struttura (facoltativo -
                                      alternativa all'amministrazione)
                    p_amministrazione amministrazione di ricerca nella struttura
                                      (facoltativa - alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor  Stringa contenente le righe con progressivo,
                                      codice unita, descrizione, dal e al delle
                                      unita di pari livello.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       0     06/05/2008  VD        Prima emissione.
       001   23/05/2011  VD        Modificata query per utilizzo vista_unita_organizzative
                                   al posto delle tabelle
       002   03/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     unita_organizzative.ottica%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      --
      -- Si determina il progressivo associato al codice dell'unita' organizzativa
      --
      begin
         select min(progr_unita_organizzativa)
           into d_progr_unor
           from anagrafe_unita_organizzative
          where ottica = d_ottica
            and codice_uo = p_codice_uo;
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'Codice Unita non piu'' utilizzato - ' ||
                                    p_codice_uo);
      end;
      --
      d_result := so4_util.unita_get_storico_pari_livello(p_progr_uo        => d_progr_unor
                                                         ,p_ottica          => d_ottica
                                                         ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_util.unita_get_storico_pari_livello
   -------------------------------------------------------------------------------
   function unita_get_ruoli
   (
      p_utente_ad4 anagrafe_unita_organizzative.utente_ad4%type
     ,p_filtro     varchar2 default null
     ,p_data       anagrafe_unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_ruoli
       DESCRIZIONE: Dato un utente di AD4 di tipo "O" (= unità organizzativa),
                    restituisce l'elenco (codice - descrizione) dei ruoli assegnati
                    ai componenti dell'unita.
       PARAMETRI:   p_utente_ad4         utente AD4 associato all'unita organizzativa
                    p_filtro             ruolo da selezionare (facoltativo)
                    p_data               data a cui effettuare la ricerca
       RITORNA:     ref cursor contenente le coppie codice / descrizione dei ruoli
                    assegnati ai componenti dell'unita organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   09/05/2007  VD        Prima emissione.
       001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result          afc.t_ref_cursor;
      d_data            ruoli_componente.dal%type;
      d_progr_unita     componenti.progr_unita_organizzativa%type;
      d_amministrazione anagrafe_unita_organizzative.amministrazione%type;
      d_ottica          ottiche.ottica%type;
   begin
      d_data            := set_data_default(p_data => p_data);
      d_progr_unita     := ad4_get_progr_unor(p_utente => p_utente_ad4, p_data => d_data);
      d_amministrazione := so4_util.anuo_get_amministrazione(p_progr_unita_organizzativa => d_progr_unita
                                                            ,p_dal                       => d_data);
      d_ottica          := set_ottica_default(p_ottica          => d_ottica
                                             ,p_amministrazione => d_amministrazione);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select distinct t.ruolo
                        ,descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
               ,ad4_ruoli       t
          where c.progr_unita_organizzativa = d_progr_unita
            and c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and d_data between r.dal and nvl(r.al, s_data_limite)
            and r.ruolo = t.ruolo
            and upper(descrizione) like upper('%' || p_filtro || '%')
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- unita_get_ruoli
   -------------------------------------------------------------------------------
   function unita_get_ruoli_asc
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data       anagrafe_unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_ruoli_asc
       DESCRIZIONE: Dato il progr. di una unita' organizzativa, restituisce l'elenco
                    dei componenti aventi il ruolo indicato, sia diretti sia appartenenti
                    alle unita' gerarchicamente superiori
       PARAMETRI:   p_ruolo               ruoli_componente.ruolo%type
                    p_progr_unor          anagrafe_unita_organizzative.progr_unita_organizzativa%type
                    p_data                facoltativa - se non indicata si assume
                                          la data di sistema
       RITORNA:     ref cursor contenente l'elenco (ni / cognome - nome) dei componenti
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   06/12/2010  VD        Prima emissione.
       001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   ruoli_componente.dal%type;
      d_ottica ottiche.ottica%type;
   begin
      d_data   := set_data_default(p_data => p_data);
      d_ottica := anagrafe_unita_organizzativa.get_ottica(p_progr_unor, d_data);
      --
      -- Si inseriscono le unità organizzative da trattare nella temporary table
      -- TEMP_SO4
      --
      begin
         insert into temp_so4
            (tipo_record
            ,livello
            ,progr_uo)
            select /*+ first_rows */
             'UO'
            ,level livello
            ,progr_unita_organizzativa
              from vista_pubb_unor
             where ottica = d_ottica
               and d_data between dal and nvl(al, s_data_limite)
            connect by prior id_unita_padre = progr_unita_organizzativa
                   and ottica = d_ottica
                   and d_data between dal and nvl(al, s_data_limite)
             start with progr_unita_organizzativa = p_progr_unor
                    and ottica = d_ottica
                    and d_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            raise_application_error(-20999
                                   ,'Errore in inserimento Temporary Table - ' ||
                                    sqlerrm);
      end;
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select ni
               ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
               ,temp_so4        t
          where c.ottica = d_ottica
            and t.tipo_record = 'UO'
            and c.progr_unita_organizzativa = t.progr_uo
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- unita_get_ruoli_asc
   -------------------------------------------------------------------------------
   function unita_get_responsabile
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       varchar2 default 'P'
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_responsabile
       DESCRIZIONE: Data una unità organizzativa (codice o progressivo),
                    restituisce l'elenco (ni - cognome e nome) dei componenti aventi
                    incarico di "responsabile".
       PARAMETRI:   p_progr_unita        progressivo numerico dell'unita organizzativa
                                         (alternativa al codice)
                    p_codice_uo          codice dell'unita organizzativa
                                         (alternativo al progressivo)
                    p_ottica             ottica in cui eseguire la ricerca
                                         (alternativa all'amministrazione)
                    p_data               data a cui eseguire la ricerca
                                         (null = data di sistema)
                    p_amministrazione    amministrazione in cui eseguire la ricerca
                                         (alternativa all'ottica - se indicata si
                                         utilizza l'ottica istituzionale dell'amministrazione)
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei componenti
                    dell'unita organizzativa aventi incarico di responsabile
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   09/05/2007  VD        Prima emissione.
       001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                     
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione 
       003   08/06/2016  AD        Gestita possibilità di interrogare per date effettive
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     unita_organizzative.ottica%type;
      d_data       unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      if p_progr_unita is null and p_codice_uo is null then
         raise_application_error(-20999
                                ,'Impossibile determinare l''unita'' organizzativa di riferimento');
      end if;
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      -- Si seleziona il progressivo dell'unita organizzativa
      --
      if p_progr_unita is null then
         d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      else
         d_progr_unor := p_progr_unita;
      end if;
      if p_tipo_data = 'P' then
         -- vado per date di pubblicazione
         open d_result for
            select c.ni
                   --,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,anso.cognome || ' ' || anso.nome descrizione
              from vista_pubb_comp       c
                  ,vista_pubb_atco       a
                  ,as4_anagrafe_soggetti anso
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = a.id_componente
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and d_data between anso.dal and nvl(anso.al, s_data_limite)
               and anso.ni = c.ni
             order by 2
                     ,1;
      else
         open d_result for
            select c.ni
                  ,anso.cognome || ' ' || anso.nome descrizione
              from vista_componenti      c
                  ,as4_anagrafe_soggetti anso
             where c.progr_unita_organizzativa = d_progr_unor
               and c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and tipo_incarico.get_responsabile(c.incarico) = 'SI'
               and d_data between anso.dal and nvl(anso.al, s_data_limite)
               and anso.ni = c.ni
             order by 2
                     ,1;
      end if;
      return d_result;
      --
   end; -- so4_util.unita_get_responsabile
   -------------------------------------------------------------------------------
   function unita_get_resp_unico
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       varchar2 default 'P'
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_responsabile
       DESCRIZIONE: Data una unità organizzativa (codice o progressivo),
                    restituisce il nominativo del primo dei componenti aventi
                    incarico di "responsabile".
       PARAMETRI:   p_progr_unita        progressivo numerico dell'unita organizzativa
                                         (alternativa al codice)
                    p_codice_uo          codice dell'unita organizzativa
                                         (alternativo al progressivo)
                    p_ottica             ottica in cui eseguire la ricerca
                                         (alternativa all'amministrazione)
                    p_data               data a cui eseguire la ricerca
                                         (null = data di sistema)
                    p_amministrazione    amministrazione in cui eseguire la ricerca
                                         (alternativa all'ottica - se indicata si
                                         utilizza l'ottica istituzionale dell'amministrazione)
       RITORNA:     ref cursor contenente le coppie ni / cognome e nome dei componenti
                    dell'unita organizzativa aventi incarico di responsabile
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   09/05/2007  VD        Prima emissione.
      ******************************************************************************/
      d_result        varchar2(200);
      d_ref_cursor    afc.t_ref_cursor;
      d_ni            componenti.ni%type;
      d_denominazione as4_anagrafe_soggetti.denominazione%type;
      d_contatore     number(2);
   begin
      d_contatore  := 0;
      d_ref_cursor := so4_util.unita_get_responsabile(p_progr_unita
                                                     ,p_codice_uo
                                                     ,p_ottica
                                                     ,p_data
                                                     ,p_amministrazione
                                                     ,p_tipo_data);
      loop
         fetch d_ref_cursor
            into d_ni
                ,d_denominazione;
         exit when d_ref_cursor%notfound;
         d_contatore := d_contatore + 1;
         if d_contatore = 1 then
            d_result := d_denominazione;
         end if;
      end loop;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_resp_unico
   -------------------------------------------------------------------------------
   function unita_get_resp_unico_descr
   (
      p_progr_unita        anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_data               componenti.dal%type default trunc(sysdate)
     ,p_revisione_modifica revisioni_struttura.revisione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_resp_unico_descr
       DESCRIZIONE: Data una unità organizzativa (progressivo),
                    restituisce il descrittore del responsabile
                    e dell'eventuale assegnazione prevalente = 2 (interim Marche)
       PARAMETRI:   p_progr_unita        progressivo numerico dell'unita organizzativa
                    p_data               data a cui eseguire la ricerca
                                         (null = data di sistema)
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       0     01/02/2012  MMONARI  Prima emissione.
      ******************************************************************************/
      d_result        varchar2(200);
      d_id_componente componenti.id_componente%type;
   begin
      select min(id_componente)
        into d_id_componente
        from componenti c
       where progr_unita_organizzativa = p_progr_unita
         and p_data between nvl(c.dal, to_date(2222222, 'j')) and
             nvl(al, to_date(3333333, 'j'))
         and nvl(c.revisione_cessazione, -1) <> nvl(p_revisione_modifica, -2)
         and exists (select 'x'
                from attributi_componente a
               where id_componente = c.id_componente
                 and exists (select 'x'
                        from tipi_incarico
                       where incarico = a.incarico
                         and responsabile = 'SI'));
      if d_id_componente is not null and p_revisione_modifica is null then
         select '( ' || des_incarico || ' : ' || nominativo || ' ) ' ||
                decode(substr(c.assegnazione_prevalente, 1, 1), 2, 'Interim', '')
           into d_result
           from vista_componenti c
          where id_componente = d_id_componente
            and p_data between dal and nvl(al, to_date(3333333, 'j'))
            and nvl(c.revisione_assegnazione, -2) <>
                revisione_struttura.get_revisione_mod(c.ottica)
            and nvl(c.rev_asse_attr, -2) <>
                revisione_struttura.get_revisione_mod(c.ottica);
      elsif d_id_componente is not null and p_revisione_modifica is not null then
         select '( ' || tipo_incarico.get_descrizione(a.incarico) || ' : ' ||
                soggetti_get_descr(c.ni, p_data, 'COGNOME E NOME') || ' ) ' ||
                decode(substr(a.assegnazione_prevalente, 1, 1), 2, 'Interim', '')
           into d_result
           from componenti           c
               ,attributi_componente a
          where a.id_componente = c.id_componente
            and c.id_componente = d_id_componente
            and p_data between nvl(c.dal, to_date(2222222, 'j')) and
                nvl(c.al, to_date(3333333, 'j'))
            and p_data between nvl(a.dal, to_date(2222222, 'j')) and
                nvl(a.al, to_date(3333333, 'j'))
            and ((p_revisione_modifica = nvl(c.revisione_assegnazione, -2) or
                p_revisione_modifica = nvl(a.revisione_assegnazione, -2)) or
                (not (p_revisione_modifica = nvl(c.revisione_assegnazione, -2) or
                 p_revisione_modifica = nvl(a.revisione_assegnazione, -2)) and
                not exists (select 'x'
                               from componenti c1
                              where c1.id_componente <> d_id_componente
                                and c1.ni = c.ni
                                and c1.revisione_assegnazione = p_revisione_modifica
                                and p_data between nvl(c1.dal, to_date(2222222, 'j')) and
                                    nvl(c1.al, to_date(3333333, 'j'))
                                   -- integrazione controllo su assegnazione prevalenti                                     
                                and a.assegnazione_prevalente like '1%'
                                and exists
                              (select 'x'
                                       from attributi_componente
                                      where id_componente = c1.id_componente
                                        and assegnazione_prevalente like '1%'
                                        and p_data between nvl(dal, to_date(2222222, 'j')) and
                                            nvl(al, to_date(3333333, 'j')))
                             -- fine controllo aggiunto 03/06/2013                                          
                             union
                             select 'x'
                               from attributi_componente a1
                              where a1.id_componente = d_id_componente
                                and a1.id_attr_componente <> a.id_attr_componente
                                and a1.revisione_assegnazione = p_revisione_modifica
                                and p_data between nvl(a1.dal, to_date(2222222, 'j')) and
                                    nvl(a1.al, to_date(3333333, 'j')))));
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_resp_unico_descr
   -------------------------------------------------------------------------------
   function unita_get_gerarchia_giuridico
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return unita_organizzative.id_elemento%type is
      /******************************************************************************
       NOME:        unita_get_gerarchia_giuridico
       DESCRIZIONE: Dato il progressivo di una U.O., restituisce il progressivo
                    della prima U.O. avente se_giuridico = SI
       PARAMETRI:   p_progr             progr. dell'unita' organizzativa
                    p_ottica            ottica da trattare (facoltativa - alternativa
                                        all'amministrazione)
                    p_data              data a cui effettuare la ricerca (facoltativa -
                                        se non indicata si assume la data di sistema)
                    p_amministrazione   amministrazione da trattare (facoltativa -
                                        alternativa all'amministrazione)
       RITORNA:     afc.t_ref_cursor
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   22/09/2008  VD        Prima emissione.
       
       ATTENZIONE! Non bisogna usare le viste per data di pubblicazione, perché
                   questa funzione è usata dall'applicativo SI4SOWEB, funzione
                   "Spostamento componenti" (quindi deve utilizzare i dati validi
                   alle date effettive).
      ******************************************************************************/
      d_result         unita_organizzative.id_elemento%type;
      d_ottica         unita_organizzative.ottica%type;
      d_data           unita_organizzative.dal%type;
      d_revisione      componenti.revisione_assegnazione%type;
      d_id_elemento    unita_organizzative.id_elemento%type;
      d_id_unita_padre unita_organizzative.id_unita_padre%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica         := set_ottica_default(p_ottica, p_amministrazione);
      d_data           := set_data_default(p_data);
      d_revisione      := revisione_struttura.get_revisione_mod(d_ottica);
      d_id_elemento    := unita_organizzativa.get_id_progr_unita(p_progr
                                                                ,d_ottica
                                                                ,d_data);
      d_id_unita_padre := unita_organizzativa.get_id_unita_padre(p_id_elemento => d_id_elemento);
      if d_id_unita_padre is null then
         d_result := d_id_elemento;
      else
         for giur in (select /*+ first_rows */
                       id_elemento
                      ,anagrafe_unita_organizzativa.get_se_giuridico(progr_unita_organizzativa
                                                                    ,d_data) se_giuridico
                        from unita_organizzative
                       where ottica = d_ottica
                         and revisione != d_revisione
                         and d_data between dal and
                             nvl(decode(revisione_cessazione
                                       ,d_revisione
                                       ,to_date(null)
                                       ,al)
                                ,s_data_limite)
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = p_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with ottica = p_ottica
                              and progr_unita_organizzativa = p_progr
                              and d_data between dal and nvl(al, s_data_limite)
                       order by level --desc
                      )
         loop
            if giur.se_giuridico = 'SI' then
               d_result := giur.id_elemento;
               exit;
            end if;
         end loop;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_gerarchia_giuridico
   -------------------------------------------------------------------------------
   function unita_get_padre_giuridico
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        unita_get_padre_giuridico
       DESCRIZIONE: Dato il progressivo di una U.O., restituisce il progressivo
                    della prima U.O. avente se_giuridico = SI
       PARAMETRI:   p_progr             progr. dell'unita' organizzativa
                    p_ottica            ottica da trattare (facoltativa - alternativa
                                        all'amministrazione)
                    p_data              data a cui effettuare la ricerca (facoltativa -
                                        se non indicata si assume la data di sistema)
                    p_amministrazione   amministrazione da trattare (facoltativa -
                                        alternativa all'amministrazione)
       RITORNA:     progr_unita_organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       0     22/09/2008  VD  Prima emissione.
       
       ATTENZIONE! Non bisogna usare le viste per data di pubblicazione, perché
                   questa funzione è usata dall'applicativo SI4SOWEB, funzione
                   "Spostamento componenti" (quindi deve utilizzare i dati validi
                   alle date effettive).
      ******************************************************************************/
      d_result         unita_organizzative.id_elemento%type;
      d_ottica         unita_organizzative.ottica%type;
      d_data           unita_organizzative.dal%type;
      d_revisione      componenti.revisione_assegnazione%type;
      d_id_elemento    unita_organizzative.id_elemento%type;
      d_id_unita_padre unita_organizzative.id_unita_padre%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica         := set_ottica_default(p_ottica, p_amministrazione);
      d_data           := set_data_default(p_data);
      d_revisione      := revisione_struttura.get_revisione_mod(d_ottica);
      d_id_elemento    := unita_organizzativa.get_id_progr_unita(p_progr
                                                                ,d_ottica
                                                                ,d_data);
      d_id_unita_padre := unita_organizzativa.get_id_unita_padre(p_id_elemento => d_id_elemento);
      if d_id_unita_padre is null then
         d_result := p_progr;
      else
         for giur in (select /*+ first_rows */
                       progr_unita_organizzativa
                      ,anagrafe_unita_organizzativa.get_se_giuridico(progr_unita_organizzativa
                                                                    ,d_data) se_giuridico
                        from unita_organizzative
                       where ottica = d_ottica
                         and revisione != d_revisione
                         and d_data between dal and
                             nvl(decode(revisione_cessazione
                                       ,d_revisione
                                       ,to_date(null)
                                       ,al)
                                ,s_data_limite)
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = p_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with ottica = p_ottica
                              and progr_unita_organizzativa = p_progr
                              and d_data between dal and nvl(al, s_data_limite)
                       order by level desc)
         loop
            if giur.se_giuridico = 'SI' then
               d_result := giur.progr_unita_organizzativa;
               exit;
            end if;
         end loop;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.unita_get_gerarchia_giuridico
   -------------------------------------------------------------------------------
   function unita_get_ramo
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica     unita_organizzative.ottica%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_tipo_data  number default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_ramo
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_ottica                Ottica a cui appartiene l'unita'
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_tipo_data             indica quale data utilizzare nella ricerca:
                                           null = data di pubblicazione
                                           1 = data effettiva
      RITORNA:     varchar2                stringa contenente i campi id_elemento della
                                           gerarchia del ramo di appartenenza della U.O.
                                           concatenati con il carattere @
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   10/11/2009  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   19/03/2012  VD        Aggiunto parametro per gestione tipo data
      ******************************************************************************/
      d_result    varchar2(32767);
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
      d_result    := '';
      for sel_asc in (select /*+ first_rows */
                       id_elemento
                        from vista_pubb_unor
                       where ottica = p_ottica
                         and d_data between dal and nvl(al, s_data_limite)
                         and p_tipo_data is null
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = p_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with ottica = p_ottica
                              and progr_unita_organizzativa = p_progr_unor
                              and d_data between dal and nvl(al, s_data_limite)
                      union
                      select /*+ first_rows */
                       id_elemento
                        from unita_organizzative
                       where ottica = p_ottica
                         and revisione != d_revisione
                         and d_data between dal and
                             nvl(decode(revisione_cessazione
                                       ,d_revisione
                                       ,to_date(null)
                                       ,al)
                                ,s_data_limite)
                         and p_tipo_data = 1
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = p_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with ottica = p_ottica
                              and progr_unita_organizzativa = p_progr_unor
                              and d_data between dal and nvl(al, s_data_limite)
                       order by 1 desc)
      loop
         d_result := lpad(sel_asc.id_elemento, 8, '0') || d_result;
      end loop;
      --
      return d_result;
   end; -- so4_util.unita_get_ramo
   -------------------------------------------------------------------------------
   function unita_get_ramo_eff
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica     unita_organizzative.ottica%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_ramo_eff
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa, ciascun id_elemento sarà
                   separato dal carattere ;
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_ottica                Ottica a cui appartiene l'unita'
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
      RITORNA:     varchar2                stringa contenente i campi id_elemento della
                                           gerarchia del ramo di appartenenza della U.O.
                                           concatenati con il carattere ;
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/03/2012  VD        Prima emissione.
      001   09/01/2013  AD        Aggiunto separatore tra i vari id_elemento
      ******************************************************************************/
      d_result           varchar2(32767);
      d_stringa_elementi varchar2(32767);
   begin
      d_stringa_elementi := so4_util.unita_get_ramo(p_progr_unor => p_progr_unor
                                                   ,p_ottica     => p_ottica
                                                   ,p_data       => p_data
                                                   ,p_tipo_data  => 1);
      --
      while d_stringa_elementi is not null
      loop
         d_result           := d_result || substr(d_stringa_elementi, 1, 8) || ';';
         d_stringa_elementi := substr(d_stringa_elementi, 9);
      end loop;
      return d_result;
   end; -- so4_util.unita_get_ramo_eff

   -------------------------------------------------------------------------------
   function unita_get_numero_componenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
     ,p_tipo            varchar2 default 'E'
     ,p_ass_prev        varchar2 default 'E'
     ,p_resp            varchar2 default 'E'
   ) return number is
      /******************************************************************************
       NOME:        unita_get_numero_componenti. #521
       DESCRIZIONE: Dato un progr. U.O. e una data, restituisce il riepilogo numerico delle assegnazioni
       PARAMETRI:   p_progr_uo           progressivo dell'unita organizzativa
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_tipo               definisce il tipo di assegnazione da contare:
                                         I         Istituzionali
                                         F         Funzionali
                                         E         Entrambe
                    p_ass_prev           definisce il tipo di prevalenza da contare:
                                         SI        assegnazioni prevalenti
                                         NO        assegnazioni non prevalenti
                                         E         Entrambe
                    p_resp               definisce il tipo di responsabilita' da contare:
                                         SI        incarichi di responsabile
                                         NO        incarichi non responsabili
                                         E         Entrambi
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_amministrazione    amministrazione da trattare (facoltativa - se assente si
                                         assume l'amministrazione dell'ottica)
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   17/02/2016  MM        Prima emissione.
      ******************************************************************************/
      d_result   number(8);
      d_ottica   componenti.ottica%type;
      d_data     componenti.dal%type;
      d_tipo     varchar2(2) := nvl(p_tipo, 'E');
      d_ass_prev varchar2(2) := nvl(p_ass_prev, 'E');
      d_resp     varchar2(2) := nvl(p_resp, 'E');
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      if d_ottica is null then
         select ottica
           into d_ottica
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_uo
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
      end if;
      if d_tipo || d_ass_prev || d_resp = 'EEE' then
         --tutte le assegnazioni
         select count(*)
           into d_result
           from vista_componenti
          where ottica = d_ottica
            and d_data between dal and nvl(al, to_date(3333333, 'j'))
            and progr_unita_organizzativa = p_progr_uo;
      else
         -- determiniamo il numero delle assegnazioni del tipo_richiesto
         select count(*)
           into d_result
           from vista_componenti
          where ottica = d_ottica
            and d_data between dal and nvl(al, to_date(3333333, 'j'))
               --
            and (nvl(tipo_assegnazione, 'I') = d_tipo or d_tipo = 'E')
            and (decode(nvl(substr(assegnazione_prevalente, 1, 1), '2'), '1', 'SI', 'NO') =
                d_ass_prev or d_ass_prev = 'E')
            and (nvl(responsabile, 'NO') = d_resp or d_resp = 'E')
               --
            and progr_unita_organizzativa = p_progr_uo;
      end if;
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   function unita_get_assegnazioni
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            componenti.dal%type default null
     ,p_separatore      varchar2 default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_numero_componenti. #521
       DESCRIZIONE: Dato un progr. U.O. e una data, restituisce il riepilogo numerico delle assegnazioni
       PARAMETRI:   p_progr_uo           progressivo dell'unita organizzativa
                    p_data               data di confronto (facoltativa - se assente si
                                         assume la data di sistema)
                    p_ottica             ottica da trattare (facoltativa - se assente si
                                         assume l'ottica istituzionale)
                    p_amministrazione    amministrazione da trattare (facoltativa - se assente si
                                         assume l'amministrazione dell'ottica)
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   17/02/2016  MM        Prima emissione.
      ******************************************************************************/
      d_result         varchar2(2000);
      d_ottica         componenti.ottica%type;
      d_data           componenti.dal%type := nvl(p_data, trunc(sysdate));
      d_assegnazioni   number(8);
      d_istituzionali  number(8);
      d_non_prevalenti number(8);
      d_funzionali     number(8);
      d_responsabili   number(8);
      d_separatore     varchar2(2) := p_separatore;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
   
      if d_ottica is null then
         select ottica
           into d_ottica
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_uo
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
      end if;
   
      if d_separatore is null then
         d_separatore := chr(13);
      else
         d_separatore := d_separatore || ' ';
      end if;
   
      d_assegnazioni   := unita_get_numero_componenti(p_progr_uo, d_data);
      d_istituzionali  := unita_get_numero_componenti(p_progr_uo
                                                     ,d_data
                                                     ,d_ottica
                                                     ,''
                                                     ,'I');
      d_funzionali     := unita_get_numero_componenti(p_progr_uo
                                                     ,d_data
                                                     ,d_ottica
                                                     ,''
                                                     ,'F');
      d_non_prevalenti := unita_get_numero_componenti(p_progr_uo
                                                     ,d_data
                                                     ,d_ottica
                                                     ,''
                                                     ,''
                                                     ,'NO');
      d_responsabili   := unita_get_numero_componenti(p_progr_uo
                                                     ,d_data
                                                     ,d_ottica
                                                     ,''
                                                     ,''
                                                     ,''
                                                     ,'SI');
   
      dbms_output.put_line(p_progr_uo || ' : ' || d_data || '   -   ' || d_assegnazioni || ' ' ||
                           d_istituzionali || ' ' || d_funzionali || ' ' ||
                           d_non_prevalenti);
      if d_assegnazioni = 0 then
         d_result := 'Nessuna assegnazione';
      else
         if d_istituzionali <> 0 then
            if d_istituzionali > 1 then
               d_result := d_istituzionali || '   Assegnazioni istituzionali' ||
                           d_separatore;
            else
               d_result := 'Una Assegnazioni istituzionale' || d_separatore;
            end if;
            if d_non_prevalenti <> 0 then
               if d_non_prevalenti > 1 then
                  d_result := d_result || ' di cui ' || d_non_prevalenti ||
                              '   Assegnazioni istituzionali non prevalenti' ||
                              d_separatore;
               else
                  d_result := d_result ||
                              ' di cui una Assegnazioni istituzionale non prevalente' ||
                              d_separatore;
               end if;
            end if;
         end if;
         if d_funzionali <> 0 then
            if d_funzionali > 1 then
               d_result := d_result || d_funzionali || '   Assegnazioni funzionali' ||
                           d_separatore;
            else
               d_result := d_result || 'Una Assegnazioni funzionale;' || chr(13);
            end if;
         end if;
         if d_responsabili <> 0 then
            if d_responsabili > 1 then
               d_result := d_result || d_responsabili || '   Incarichi di responsabile' ||
                           d_separatore;
            else
               d_result := d_result || 'Un Incarico di responsabile' || d_separatore;
            end if;
         else
            d_result := d_result || 'Non esiste un responsabile' || d_separatore;
         end if;
      end if;
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   function ruolo_get_componenti
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ruolo_get_componenti.
       DESCRIZIONE: Dato un ruolo, restituisce l'elenco (ni - cognome e nome) dei
                    componenti aventi il ruolo indicato.
       PARAMETRI:   p_ruolo          ruolo da ricercare
                    p_data           data a cui effettuare la ricerca (facoltativa -
                                     se non indicata si assume la data di sistema)
                    p_ottica         ottica di riferimento (facoltativa, alternativa
                                     all'amministrazione - se non indicata si assume
                                     l'ottica istituzionale dell'amministrazione)
                    p_amministrazione amministrazione di riferimento (facoltativa,
                                      alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor Stringa contenente le coppie ni / cognome e nome
                                     dei componenti aventi il ruolo indicato
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   15/12/2006  VD      Prima emissione.
       001   17/01/2011  VD      Corretto confronto revisione cessazione con
                                 revisione in modifica (nvl)
       002   27/04/2011  VD      Aggiunta "distinct" per evitare di estrapolare
                                 piu' volte la stessa persona se ha il ruolo
                                 indicato su piu' unita'
       003   07/02/2012  VD      Sostituite tabelle con viste per date di pubblicazione
       004   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica ottiche.ottica%type;
      d_data   ruoli_componente.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select distinct ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.ruolo_get_componenti
   -------------------------------------------------------------------------------
   function ruolo_get_componenti_id
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_progr_unor      unita_organizzative.progr_unita_organizzativa%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ruolo_get_componenti_id.
       DESCRIZIONE: Dato un ruolo, restituisce l'elenco (ni - cognome e nome +
                    id componente) dei componenti aventi il ruolo indicato. Se viene
                    indicato il progr. dell'unita' organizzativa, la ricerca viene 
                    effettuata solo per l'unita' indicata
       PARAMETRI:   p_ruolo           ruolo da ricercare
                    p_data            data a cui effettuare la ricerca (facoltativa -
                                      se non indicata si assume la data di sistema)
                    p_ottica          facoltativa - alternativa all'amministrazione
                    p_amministrazione facoltativa - alternativa all'ottica
                    p_progr_unor      facoltativa - progr. unita' organizzativa
       RITORNA:     AFC.t_ref_cursor Stringa contenente ni / cognome e nome / id_componente
                                     dei componenti aventi il ruolo indicato
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   15/12/2006  VD      Prima emissione.
       001   17/01/2011  VD      Corretto confronto revisione cessazione con
                                 revisione in modifica (nvl)
       002   07/02/2012  VD      Sostituite tabelle con viste per date di pubblicazione                                                                 
       003   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica ottiche.ottica%type;
      d_data   ruoli_componente.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      if p_progr_unor is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,c.id_componente
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,c.id_componente
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.ottica = d_ottica
               and c.progr_unita_organizzativa = p_progr_unor
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_util.ruolo_get_componenti_id
   -------------------------------------------------------------------------------
   function ruolo_get_unita
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ruolo_get_unita.
       DESCRIZIONE: Dato un ruolo, restituisce l'elenco (codice - descrizione) delle
                    unita' contenenti componenti con il ruolo indicato.
       PARAMETRI:   p_ruolo          ruolo da ricercare
                    p_data           data a cui effettuare la ricerca (facoltativa -
                                     se non indicata si assume la data di sistema)
                    p_ottica         ottica di riferimento (facoltativa, alternativa
                                     all'amministrazione - se non indicata si assume
                                     l'ottica istituzionale dell'amministrazione)
                    p_amministrazione amministrazione di riferimento (facoltativa,
                                      alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor Elenco contenente le coppie codice / descrizione
                                     delle unità aventi componenti con il ruolo indicato
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   15/12/2006  VD      Prima emissione.
       001   07/02/2012  VD      Sostituite tabelle con viste per date di pubblicazione                                                                 
       002   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                 query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica ottiche.ottica%type;
      d_data   ruoli_componente.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select distinct so4_util.anuo_get_codice_uo(c.progr_unita_organizzativa, d_data) codice_uo
                        ,so4_util.anuo_get_descrizione(c.progr_unita_organizzativa
                                                      ,d_data) descrizione
           from vista_pubb_comp c
               ,vista_pubb_ruco r
          where c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.ruolo_get_unita
   -------------------------------------------------------------------------------
   function get_ordinamento
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ordinamento
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facoltativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
                   p_tipo_data             indica quale data utilizzare nella ricerca:
                                           null = data di pubblicazione
                                           1 = data effettiva
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2006  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione  
      002   19/03/2012  VD        Aggiunto parametro per gestione tipo data                                                               
      003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      004   01/06/2016  MM        #723 : spezzata la union per problemi di prestazioni CIWEB
      ******************************************************************************/
      d_result    varchar2(32767);
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      d_result := '';
      --#723
      if p_tipo_data is null then
         for sel_asc in (select /*+ first_rows */
                          level
                         ,sequenza
                         ,so4_util.unita_get_codice_valido(progr_unita_organizzativa
                                                          ,d_data) codice_uo
                           from vista_pubb_unor
                          where ottica = d_ottica
                            and d_data between dal and nvl(al, s_data_limite)
                         connect by prior id_unita_padre = progr_unita_organizzativa
                                and ottica = d_ottica
                                and d_data between dal and nvl(al, s_data_limite)
                          start with ottica = d_ottica
                                 and progr_unita_organizzativa = p_progr_unor
                                 and d_data between dal and nvl(al, s_data_limite)
                          order by 1 desc)
         loop
            d_result := d_result || lpad(sel_asc.sequenza, 6, '0') ||
                        rpad(sel_asc.codice_uo, 50);
         end loop;
      elsif p_tipo_data = 1 then
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
         for sel_asc in (select /*+ first_rows */
                          level
                         ,sequenza
                         ,so4_util.unita_get_codice_valido(progr_unita_organizzativa
                                                          ,d_data) codice_uo
                           from unita_organizzative
                          where ottica = d_ottica
                            and revisione != d_revisione
                            and d_data between dal and
                                nvl(decode(revisione_cessazione
                                          ,d_revisione
                                          ,to_date(null)
                                          ,al)
                                   ,s_data_limite)
                         connect by prior id_unita_padre = progr_unita_organizzativa
                                and ottica = d_ottica
                                and d_data between dal and nvl(al, s_data_limite)
                          start with ottica = d_ottica
                                 and progr_unita_organizzativa = p_progr_unor
                                 and d_data between dal and nvl(al, s_data_limite)
                          order by 1 desc)
         loop
            d_result := d_result || lpad(sel_asc.sequenza, 6, '0') ||
                        rpad(sel_asc.codice_uo, 50);
         end loop;
      end if;
      --
      return d_result;
   end; -- so4_util.get_ordinamento
   -------------------------------------------------------------------------------
   function get_ordinamento_eff
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ordinamento
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa effettuando la ricerca
                   per date di validita' effettiva
      
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facoltativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/03/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result varchar2(32767);
   begin
      d_result := so4_util.get_ordinamento(p_progr_unor      => p_progr_unor
                                          ,p_data            => p_data
                                          ,p_ottica          => p_ottica
                                          ,p_amministrazione => p_amministrazione
                                          ,p_tipo_data       => 1);
      --
      return d_result;
   end; -- so4_util.get_ordinamento_eff
   -------------------------------------------------------------------------------
   function get_ordinamento_2
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ordinamento_2
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa ordinata per
                   ordinamento interno alla suddivisione, sequenza, e descrizione
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facolatativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
                   p_tipo_data             indica quale data utilizzare nella ricerca:
                                           null = data di pubblicazione
                                           1 = data effettiva
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   XX/XX/XXXX  XX        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                                                                 
      002   19/03/2012  VD        Aggiunto parametro per gestione tipo data                                                               
      003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      004   01/06/2016  MM        #723 : spezzata la union per problemi di prestazioni
      ******************************************************************************/
      d_result    varchar2(32767);
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      d_ottica := so4_util.set_ottica_default(p_ottica, p_amministrazione);
      d_data   := so4_util.set_data_default(p_data);
      d_result := '';
      --#723
      if p_tipo_data is null then
         for sel_asc in (select /*+ first_rows */
                          level
                         ,suddivisione_struttura.get_ordinamento(so4_util.anuo_get_id_suddivisione(progr_unita_organizzativa
                                                                                                  ,trunc(sysdate))) as ordinamento_suddivisione
                         ,sequenza
                         ,so4_util.unita_get_codice_valido(progr_unita_organizzativa
                                                          ,d_data) codice_uo
                           from vista_pubb_unor
                          where ottica = d_ottica
                            and d_data between dal and nvl(al, s_data_limite)
                         connect by prior id_unita_padre = progr_unita_organizzativa
                                and ottica = d_ottica
                                and d_data between dal and nvl(al, s_data_limite)
                          start with ottica = d_ottica
                                 and progr_unita_organizzativa = p_progr_unor
                                 and d_data between dal and nvl(al, s_data_limite)
                          order by 1 desc)
         loop
            d_result := d_result || lpad(sel_asc.ordinamento_suddivisione, 2, '0') ||
                        lpad(sel_asc.sequenza, 6, '0') || rpad(sel_asc.codice_uo, 50);
         end loop;
      elsif p_tipo_data = 1 then
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
         for sel_asc in (select /*+ first_rows */
                          level
                         ,suddivisione_struttura.get_ordinamento(so4_util.anuo_get_id_suddivisione(progr_unita_organizzativa
                                                                                                  ,trunc(sysdate))) as ordinamento_suddivisione
                         ,sequenza
                         ,so4_util.unita_get_codice_valido(progr_unita_organizzativa
                                                          ,d_data) codice_uo
                           from unita_organizzative
                          where ottica = d_ottica
                            and revisione != d_revisione
                            and d_data between dal and
                                nvl(decode(revisione_cessazione
                                          ,d_revisione
                                          ,to_date(null)
                                          ,al)
                                   ,s_data_limite)
                         connect by prior id_unita_padre = progr_unita_organizzativa
                                and ottica = d_ottica
                                and d_data between dal and nvl(al, s_data_limite)
                          start with ottica = d_ottica
                                 and progr_unita_organizzativa = p_progr_unor
                                 and d_data between dal and nvl(al, s_data_limite)
                          order by 1 desc)
         loop
            d_result := d_result || lpad(sel_asc.ordinamento_suddivisione, 2, '0') ||
                        lpad(sel_asc.sequenza, 6, '0') || rpad(sel_asc.codice_uo, 50);
         end loop;
      end if;
      --
      return d_result;
   end; -- so4_util.get_ordinamento_2
   -------------------------------------------------------------------------------
   function get_ordinamento2_eff
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ordinamento2_eff
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa ordinata per
                   ordinamento interno alla suddivisione, sequenza, e descrizione
                   effettuando la ricerca per date di validita' effettiva
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facolatativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/03/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result varchar2(32767);
   begin
      d_result := so4_util.get_ordinamento_2(p_progr_unor      => p_progr_unor
                                            ,p_data            => p_data
                                            ,p_ottica          => p_ottica
                                            ,p_amministrazione => p_amministrazione
                                            ,p_tipo_data       => 1);
      --
      return d_result;
   end; -- so4_util.get_ordinamento2_eff
   -------------------------------------------------------------------------------
   --   function get_livello
   --   (
   --      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
   --     ,p_data            unita_organizzative.dal%type default null
   --     ,p_ottica          unita_organizzative.ottica%type default null
   --     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   --     ,p_tipo_data       number default null
   --   ) return number is
   --      /******************************************************************************
   --      NOME:        get_livello
   --      DESCRIZIONE: Restituisce il livello gerarchico di una unità organizzativa
   --      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
   --                   p_data                  data a cui eseguire la ricerca (facoltativa
   --                                           . se non indicata si assume la data di sistema)
   --                   p_ottica                Ottica di ricerca nella struttura (facolatativa
   --                                           - alternativa all'amministrazione)
   --                   p_amministrazione       amministrazione di ricerca nella struttura
   --                                           (facoltativa - alternativa all'ottica per la
   --                                           definizione dell'ottica istituzionale)
   --                   p_tipo_data             indica quale data utilizzare nella ricerca:
   --                                           null = data di pubblicazione
   --                                           1 = data effettiva
   --      RITORNA:     livello                 livello gerarchico della U.O.
   --      REVISIONI:
   --      Rev.  Data        Autore    Descrizione
   --      ----  ----------  --------  ----------------------------------------------------
   --      000   26/10/2009  VD        Prima emissione.
   --      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione  
   --      002   19/03/2012  VD        Aggiunto parametro per gestione tipo data                                                               
   --      ******************************************************************************/
   --      d_result    number;
   --      d_ottica    anagrafe_unita_organizzative.ottica%type;
   --      d_data      anagrafe_unita_organizzative.dal%type;
   --      d_revisione revisioni_struttura.revisione%type;
   --   begin
   --      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
   --      d_data      := set_data_default(p_data);
   --      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
   --      begin
   --         select /*+ first_rows */
   --          level
   --           into d_result
   --           from unita_organizzative
   --          where ottica = d_ottica
   --            and revisione != d_revisione
   --            and progr_unita_organizzativa = p_progr_unor
   --            and d_data between dal and
   --                nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
   --                   ,s_data_limite)
   --            and p_tipo_data = 1
   --         connect by progr_unita_organizzativa = prior id_unita_padre
   --                and ottica = d_ottica
   --                and d_data between dal and
   --                    nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
   --                       ,s_data_limite)
   --          start with ottica = d_ottica
   --                 and progr_unita_organizzativa = p_progr_unor
   --                 and d_data between dal and
   --                     nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
   --                        ,s_data_limite)
   --         union
   --         select /*+ first_rows */
   --          level
   --           from vista_pubb_unor
   --          where id_unita_padre is null
   --            and p_tipo_data is null
   --         connect by progr_unita_organizzativa = prior id_unita_padre
   --                and ottica = d_ottica
   --                and d_data between dal and nvl(al, s_data_limite)
   --          start with ottica = d_ottica
   --                 and progr_unita_organizzativa = p_progr_unor
   --                 and d_data between dal and nvl(al, s_data_limite);
   --      exception
   --         when no_data_found then
   --            d_result := 0;
   --         when too_many_rows then
   --            d_result := 0;
   --      end;
   --
   --      return d_result;
   --   end; -- so4_util.get_livello
   -------------------------------------------------------------------------------
   function get_livello
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return number is
      /******************************************************************************
      NOME:        get_livello
      DESCRIZIONE: Restituisce il livello gerarchico di una unità organizzativa
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facolatativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
                   p_tipo_data             indica quale data utilizzare nella ricerca:
                                           null = data di pubblicazione
                                           1 = data effettiva
      RITORNA:     livello                 livello gerarchico della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      --  ----------  --------  ----------------------------------------------------
      000   26/10/2009  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione  
      002   19/03/2012  VD        Aggiunto parametro per gestione tipo data                                                               
      ******************************************************************************/
      d_result      number;
      d_ottica      anagrafe_unita_organizzative.ottica%type;
      d_data        anagrafe_unita_organizzative.dal%type;
      d_revisione   revisioni_struttura.revisione%type;
      s_data_limite date := to_date(3333333, 'j');
   begin
      d_ottica    := so4_util.set_ottica_default(p_ottica, p_amministrazione);
      d_data      := so4_util.set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      begin
         if p_tipo_data = 1 then
            select /*+ first_rows */
             level
              into d_result
              from unita_organizzative
             where id_unita_padre is null
               and ottica = d_ottica
               and d_data between dal and nvl(al, to_date(3333333, 'j'))
            connect by progr_unita_organizzativa = prior id_unita_padre
                   and d_data between prior dal and
                       nvl(prior al, to_date('3333333', 'j'))
             start with ottica = d_ottica
                    and progr_unita_organizzativa = p_progr_unor
                    and revisione != d_revisione
                    and d_data between dal and
                        nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                           ,s_data_limite);
         else
            select /*+ first_rows */
             level
              into d_result
              from vista_pubb_unor
             where id_unita_padre is null
               and ottica = d_ottica
               and d_data between dal and nvl(al, to_date(3333333, 'j'))
            connect by progr_unita_organizzativa = prior id_unita_padre
                   and d_data between prior dal and nvl(prior al, s_data_limite)
             start with ottica = d_ottica
                    and progr_unita_organizzativa = p_progr_unor
                    and d_data between dal and nvl(al, s_data_limite);
         end if;
      exception
         when no_data_found then
            d_result := 0;
         when too_many_rows then
            d_result := 0;
      end;
   
      return d_result;
   end; -- so4_util.get_livello
   -------------------------------------------------------------------------------
   function get_livello_eff
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return number is
      /******************************************************************************
      NOME:        get_livello_eff
      DESCRIZIONE: Restituisce il livello gerarchico di una unità organizzativa
                   effettuando la ricerca per date di validita' effettiva
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facolatativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
      RITORNA:     livello                 livello gerarchico della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/03/2012  VD        Prima emissione.
      ******************************************************************************/
      d_result number;
   begin
      d_result := so4_util.get_livello(p_progr_unor      => p_progr_unor
                                      ,p_data            => p_data
                                      ,p_ottica          => p_ottica
                                      ,p_amministrazione => p_amministrazione
                                      ,p_tipo_data       => 1);
      return d_result;
   end; -- so4_util.get_livello_eff
   -------------------------------------------------------------------------------
   function get_ascendenza
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_tipo         varchar2 default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ascendenza
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facolatativa
                                           - alternativa all'amministrazione)
                   p_separatore_1          carattere di separazione per concatenare i dati
                   p_separatore_2          carattere di separazione per concatenare i dati
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
                   p_se_tipo               Indica se nella stringa deve apparire anche il
                                           tipo "O" (per AD4 ?) - default null                                           
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O. concatenata con
                                           il carattere separatore
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2006  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                                                                 
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result       varchar2(32767);
      d_ottica       anagrafe_unita_organizzative.ottica%type;
      d_data         anagrafe_unita_organizzative.dal%type;
      d_separatore_1 varchar2(1);
      d_separatore_2 varchar2(1);
      d_contatore    number(8);
   begin
      d_ottica       := set_ottica_default(p_ottica, p_amministrazione);
      d_data         := set_data_default(p_data);
      d_separatore_1 := set_separatore_default(p_separatore_1, 1);
      d_separatore_2 := set_separatore_default(p_separatore_2, 2);
      d_contatore    := 0;
      d_result       := '';
      for sel_asc in (select /*+ first_rows */
                       so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
                      ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione
                        from vista_pubb_unor
                       where ottica = d_ottica
                         and d_data between dal and nvl(al, s_data_limite)
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = d_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with ottica = d_ottica
                              and progr_unita_organizzativa = p_progr_unor
                              and d_data between dal and nvl(al, s_data_limite)
                       order by level desc)
      loop
         if nvl(p_se_tipo, 'S') = 'S' then
            d_result := d_result || 'O' || d_separatore_1 || sel_asc.codice_uo ||
                        d_separatore_1 || sel_asc.descrizione || d_separatore_2;
         else
            if d_contatore = 0 then
               d_result    := sel_asc.codice_uo || d_separatore_1 || sel_asc.descrizione;
               d_contatore := 1;
            else
               d_result := d_result || d_separatore_2 || sel_asc.codice_uo ||
                           d_separatore_1 || sel_asc.descrizione;
            end if;
         end if;
      end loop;
      --
      return d_result;
   end; -- so4_util.get_ascendenza
   -------------------------------------------------------------------------------
   function get_ascendenza_cf
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_tipo         varchar2 default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ascendenza_cf
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa
                   Versione per CFEP: con la descrizione abbreviata al posto del
                   codice
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facolatativa
                                           - alternativa all'amministrazione)
                   p_separatore_1          carattere di separazione per concatenare i dati
                   p_separatore_2          carattere di separazione per concatenare i dati
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O. concatenata con
                                           il carattere separatore
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   25/10/2011  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                                                                 
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result       varchar2(32767);
      d_ottica       anagrafe_unita_organizzative.ottica%type;
      d_data         anagrafe_unita_organizzative.dal%type;
      d_separatore_1 varchar2(1);
      d_separatore_2 varchar2(1);
      d_contatore    number(8);
   begin
      d_ottica       := set_ottica_default(p_ottica, p_amministrazione);
      d_data         := set_data_default(p_data);
      d_separatore_1 := set_separatore_default(p_separatore_1, 1);
      d_separatore_2 := set_separatore_default(p_separatore_2, 2);
      d_contatore    := 0;
      d_result       := '';
      for sel_asc in (select /*+ first_rows */
                       so4_util.anuo_get_des_abb(progr_unita_organizzativa, d_data) des_abb
                      ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione
                        from vista_pubb_unor
                       where ottica = d_ottica
                         and d_data between dal and nvl(al, s_data_limite)
                      connect by prior id_unita_padre = progr_unita_organizzativa
                             and ottica = d_ottica
                             and d_data between dal and nvl(al, s_data_limite)
                       start with ottica = d_ottica
                              and progr_unita_organizzativa = p_progr_unor
                              and d_data between dal and nvl(al, s_data_limite)
                       order by level desc)
      loop
         if nvl(p_se_tipo, 'S') = 'S' then
            d_result := d_result || 'O' || d_separatore_1 || sel_asc.des_abb ||
                        d_separatore_1 || sel_asc.descrizione || d_separatore_2;
         else
            if d_contatore = 0 then
               d_result    := sel_asc.des_abb || d_separatore_1 || sel_asc.descrizione;
               d_contatore := 1;
            else
               d_result := d_result || d_separatore_2 || sel_asc.des_abb ||
                           d_separatore_1 || sel_asc.descrizione;
            end if;
         end if;
      end loop;
      --
      return d_result;
   end; -- so4_util.get_ascendenza_cf
   -------------------------------------------------------------------------------
   function get_ascendenza_ad4
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_ascendenza_ad4
       DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                    appartenenza di una unità organizzativa, composta da codice
                    utente e nominativo
       PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                    p_data                  data a cui eseguire la ricerca (facoltativa
                                            . se non indicata si assume la data di sistema)
                    p_ottica                Ottica di ricerca nella struttura (facolatativa
                                            - alternativa all'amministrazione)
                    p_separatore_1          carattere di separazione per concatenare i dati
                    p_separatore_2          carattere di separazione per concatenare i dati
                    p_amministrazione       amministrazione di ricerca nella struttura
                                            (facoltativa - alternativa all'ottica per la
                                            definizione dell'ottica istituzionale)
       RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                            di appartenenza della U.O. concatenata con
                                            il carattere separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   19/12/2006  VD        Prima emissione.
       001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       002   12/02/2013  AD        Spostato il codice in so4ad4_pkg                                                                 
      ******************************************************************************/
   begin
      return so4ad4_pkg.get_ascendenza_ad4(p_progr_unor
                                          ,p_data
                                          ,p_ottica
                                          ,p_separatore_1
                                          ,p_separatore_2
                                          ,p_amministrazione);
   end; -- so4_util.get_ascendenza_ad4
   -------------------------------------------------------------------------------
   function unita_get_ascendenza
   (
      p_codice_uo    anagrafe_unita_organizzative.codice_uo%type
     ,p_data         unita_organizzative.dal%type default null
     ,p_ottica       unita_organizzative.ottica%type default null
     ,p_separatore_1 varchar2 default null
     ,p_separatore_2 varchar2 default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_ascendenza
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa.
      PARAMETRI:   p_codice_uo            Codice Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                Ottica di ricerca nella struttura (facoltativa
                                           - alternativa all'amministrazione)
                   p_separatore_1          carattere di separazione per concatenare i dati
                   p_separatore_2          carattere di separazione per concatenare i dati
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O. concatenata con
                                           il carattere separatore
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   14/02/2007  SC        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione                                                                 
      ******************************************************************************/
      d_result     varchar2(32767);
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      d_result     := get_ascendenza(p_progr_unor   => d_progr_unor
                                    ,p_data         => d_data
                                    ,p_ottica       => d_ottica
                                    ,p_separatore_1 => p_separatore_1
                                    ,p_separatore_2 => p_separatore_2);
      --
      return d_result;
   end; -- so4_util.unita_get_ascendenza
   -------------------------------------------------------------------------------
   function get_ascendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_ascendenti
      DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione e dal) delle unita ascendenti.
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_separatore            carattere di separazione per concatenare i dati
      RITORNA:     Afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/03/2007  SC        Prima emissione.
      001   14/01/2008  SC        Restituisco anche la data di fine validita' delle unita
      002   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      003   12/09/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                  del cursore           
      004   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select /*+ first_rows */
          progr_unita_organizzativa
         ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
         ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione_uo
         ,dal
         ,al
           from vista_pubb_unor
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
         connect by prior id_unita_padre = progr_unita_organizzativa
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and progr_unita_organizzativa = p_progr_unor
                 and d_data between dal and nvl(al, s_data_limite);
      --
      return d_result;
   end; -- so4_util.get_ascendenti
   -------------------------------------------------------------------------------
   function get_ascendenti_cf
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_ascendenti_cf
      DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione e dal) delle unita ascendenti.
                   Se l'unità non ha ascendenti, restituisce l'unità stessa.
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_separatore            carattere di separazione per concatenare i dati
      RITORNA:     Afc.t_ref_cursor         cursore contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   28/09/2011  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   12/09/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                  del cursore           
      003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   anagrafe_unita_organizzative.dal%type;
      d_conta  number(1);
   begin
      d_data := set_data_default(p_data);
      --   
      select count(*)
        into d_conta
        from vista_pubb_unor
       where ottica = p_ottica
         and progr_unita_organizzativa = p_progr_unor
         and d_data between dal and nvl(al, s_data_limite);
      --
      if d_conta = 0 then
         open d_result for
            select progr_unita_organizzativa
                  ,codice_uo
                  ,descrizione
                  ,dal
                  ,al
              from vista_pubb_anuo
             where progr_unita_organizzativa = p_progr_unor
               and d_data between dal and nvl(al, s_data_limite);
      else
         open d_result for
            select /*+ first_rows */
             progr_unita_organizzativa
            ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
            ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione
            ,dal
            ,al
              from vista_pubb_unor
             where ottica = p_ottica
               and d_data between dal and nvl(al, s_data_limite)
            connect by prior id_unita_padre = progr_unita_organizzativa
                   and ottica = p_ottica
                   and d_data between dal and nvl(al, s_data_limite)
             start with ottica = p_ottica
                    and progr_unita_organizzativa = p_progr_unor
                    and d_data between dal and nvl(al, s_data_limite);
      end if;
      --
      return d_result;
   end; -- so4_util.get_ascendenti_cf
   -------------------------------------------------------------------------------
   function unita_get_ascendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      nome:        unita_get_ascendenza
      descrizione: restituisce un ref cursor contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa.
      parametri:   p_codice_uo            codice unità organizzativa da trattare
                   p_data                 data a cui eseguire la ricerca (facoltativa,
                                          se non indicata si assume la data di sistema)
                   p_ottica               ottica di riferimento
      ritorna:     varchar2               ref cursor contenente la gerarchia del ramo
                                          di appartenenza della u.o.
      revisioni:
      rev.  data        autore    descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/03/2007  sc        prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      -- dbms_output.put_line('progressivo '||d_progr_unor||' per unita '||p_codice_uo);
      d_result := get_ascendenti(p_progr_unor => d_progr_unor
                                ,p_data       => d_data
                                ,p_ottica     => d_ottica);
      --
      return d_result;
   end; -- so4_util.unita_get_ascendenti
   -------------------------------------------------------------------------------
   function get_ascendenti_sudd
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_ascendenti_sudd
      DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione, dal e suddivisione) delle
                   unita ascendenti.
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                Ottica per cui eseguire la ricerca
      RITORNA:     Afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   17/02/2010  SC        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   12/09/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                  del cursore           
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica);
      d_data   := set_data_default(p_data);
      open d_result for
         select /*+ first_rows */
          progr_unita_organizzativa
         ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
         ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione_uo
         ,dal
         ,al
         ,so4_util.anuo_get_id_suddivisione(progr_unita_organizzativa, d_data) id_suddivisione
           from vista_pubb_unor
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
         connect by prior id_unita_padre = progr_unita_organizzativa
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and progr_unita_organizzativa = p_progr_unor
                 and d_data between dal and nvl(al, s_data_limite);
      --
      return d_result;
   end; -- so4_util.get_ascendenti_sudd
   -------------------------------------------------------------------------------
   function unita_get_ascendenti_sudd
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      nome:        unita_get_ascendenti_sudd
      descrizione: restituisce un ref cursor contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa.
      parametri:   p_codice_uo            codice unità organizzativa da trattare
                   p_data                 data a cui eseguire la ricerca (facoltativa,
                                          se non indicata si assume la data di sistema)
                   p_ottica               Ottica per cui effettuare la ricerca
      ritorna:     ref_cursor             ref cursor contenente la gerarchia del ramo
                                          di appartenenza della u.o.
      revisioni:
      rev.  data        autore    descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   17/02/2010  SC        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      -- dbms_output.put_line('progressivo '||d_progr_unor||' per unita '||p_codice_uo);
      d_result := get_ascendenti_sudd(p_progr_unor => d_progr_unor
                                     ,p_data       => d_data
                                     ,p_ottica     => d_ottica);
      --
      return d_result;
   end; -- so4_util.unita_get_ascendenti_sudd
   -------------------------------------------------------------------------------
   function get_discendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      nome:        get_discendenti
      descrizione: dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione e dal) delle unita
                   discendenti.
      parametri:   p_progr_unor            unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                ottica di riferimento
      ritorna:     afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                           di appartenenza della u.o.
      revisioni:
      rev.  data        autore    descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/03/2007  sc        prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
      002   12/09/2013  AD      Aggiunti alias codice_uo e descrizione_uo su colonne
                                 del cursore             
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica);
      d_data   := set_data_default(p_data);
      open d_result for
         select /*+ first_rows */
          progr_unita_organizzativa
         ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
         ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione_uo
         ,dal
         ,al
           from vista_pubb_unor
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
         connect by prior progr_unita_organizzativa = id_unita_padre
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and progr_unita_organizzativa = p_progr_unor
                 and d_data between dal and nvl(al, s_data_limite);
      --
      return d_result;
   end; -- so4_util.get_discendenti
   -------------------------------------------------------------------------------
   function unita_get_discendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        unita_get_discendenti
      DESCRIZIONE: Restituisce un ref cursor contenente la gerarchia sottostante il ramo di
                   appartenenza di una unità organizzativa.
      PARAMETRI:   p_codice_uo             Codice Unità organizzativa da trattare
                   p_data                  Data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                Ottica di riferimento.
      RITORNA:     varchar2                ref cursor contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/03/2007  SC        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_util.anuo_get_progr(p_ottica    => d_ottica
                                             ,p_codice_uo => p_codice_uo
                                             ,p_data      => d_data);
      -- dbms_output.put_line('progressivo '||d_progr_unor||' per unita '||p_codice_uo);
      d_result := get_discendenti(p_progr_unor => d_progr_unor
                                 ,p_data       => d_data
                                 ,p_ottica     => d_ottica);
      --
      return d_result;
   end; -- so4_util.unita_get_discendenti
   -------------------------------------------------------------------------------
   function get_struttura
   (
      p_utente          ad4_utenti.utente%type
     ,p_data            varchar2 default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_struttura
      DESCRIZIONE: Restituisce la struttura di tutti i ruoli ed i gruppi di tipo "O"
                   corrispondenti alle unita' organizzative a cui l'utente/gruppo
                   appartiene alla data specificata
      PARAMETRI:   p_utente                codice utente da controllare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                ottica di riferimento (facoltativa, alternativa
                                           all'amministrazione - se non indicata si assume
                                           l'ottica istituzionale dell'amministrazione
                                           di riferimento)
                   p_separatore_1
                   p_separatore_2
                   p_amministrazione       amministrazione di riferimento (facoltativa,
                                           alternativa all'ottica)
      RITORNA:     AFC.t_ref_cursor        ref_cursor contenente la struttura di tutti
                                           i ruoli ed i gruppi di tipo "O" alle unità
                                           organizzative a cui l'utente appartiene alla
                                           data specificata
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2006  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
      d_result afc.t_ref_cursor;
   begin
      --
      -- Si valorizzano i parametri di default se nulli
      --
      d_result := so4ad4_pkg.get_struttura(p_utente
                                          ,p_data
                                          ,p_ottica
                                          ,p_separatore_1
                                          ,p_separatore_2
                                          ,p_amministrazione);
      /*    d_ottica := p_ottica;
      if p_ottica is null then
         if p_amministrazione is not null then
            d_ottica := set_ottica_default(p_ottica, p_amministrazione);
         end if;
      end if;
      d_data         := set_data_default(p_data);
      d_separatore_1 := set_separatore_default(p_separatore_1, 1);
      d_separatore_2 := set_separatore_default(p_separatore_2, 2);
      --
      -- Se l'utente è '%', si esegue l'esplosione completa
      --
      if p_utente = '%' then
         open d_result for
            select get_ascendenza_ad4(c.progr_unita_organizzativa
                                     ,d_data
                                     ,c.ottica
                                     ,d_separatore_1
                                     ,d_separatore_2) || 'U' || d_separatore_1 ||
                   u.utente || d_separatore_1 || u.nominativo
              from vista_pubb_comp     c
                  ,ad4_utenti          u
                  ,ad4_utenti_soggetti s
             where ottica = nvl(d_ottica, ottica)
               and ottica.get_ottica_istituzionale(ottica) = 'SI'
               and nvl(c.revisione_assegnazione, -2) !=
                   revisione_struttura.get_revisione_mod(c.ottica)
               and d_data between c.dal and nvl(decode(c.revisione_cessazione
                                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                                      ,to_date(null)
                                                      ,c.al)
                                               ,s_data_limite)
               and c.ni = s.soggetto
               and s.utente = u.utente
            union
            select ad4_get_ruolo(r.ruolo) || d_separatore_2 || 'U' || d_separatore_1 ||
                   u.utente || d_separatore_1 || u.nominativo
              from vista_pubb_comp     c
                  ,vista_pubb_ruco     r
                  ,ad4_utenti          u
                  ,ad4_utenti_soggetti s
             where c.ottica = nvl(d_ottica, ottica)
               and c.id_componente = r.id_componente
               and nvl(c.revisione_assegnazione, -2) !=
                   revisione_struttura.get_revisione_mod(c.ottica)
               and d_data between c.dal and nvl(decode(c.revisione_cessazione
                                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                                      ,to_date(null)
                                                      ,c.al)
                                               ,s_data_limite)
               and d_data between r.dal and nvl(r.al, s_data_limite)
               and c.ni = s.soggetto
               and s.utente = u.utente
               and ad4_get_ruolo(r.ruolo) is not null
            union -- unità che non contengono componenti
            select so4_util.get_ascendenza_ad4(a.progr_unita_organizzativa
                                              ,d_data
                                              ,a.ottica
                                              ,d_separatore_1
                                              ,d_separatore_2)
              from vista_pubb_anuo a
             where a.ottica = nvl(d_ottica, ottica)
               and ottica.get_ottica_istituzionale(ottica) = 'SI'
               and a.revisione_istituzione !=
                   revisione_struttura.get_revisione_mod(a.ottica)
               and d_data between a.dal and nvl(decode(a.revisione_cessazione
                                                      ,revisione_struttura.get_revisione_mod(a.ottica)
                                                      ,to_date(null)
                                                      ,a.al)
                                               ,s_data_limite)
               and a.progr_unita_organizzativa not in
                   (select c.progr_unita_organizzativa
                      from vista_pubb_comp c
                     where ottica = nvl(d_ottica, ottica)
                       and ottica.get_ottica_istituzionale(ottica) = 'SI'
                       and nvl(c.revisione_assegnazione, -2) !=
                           revisione_struttura.get_revisione_mod(c.ottica)
                       and d_data between c.dal and
                           nvl(decode(c.revisione_cessazione
                                     ,revisione_struttura.get_revisione_mod(c.ottica)
                                     ,to_date(null)
                                     ,c.al)
                              ,s_data_limite));
         --
         return d_result;
         --
      end if;
      --
      -- Si verifica il tipo di utente da trattare
      --
      begin
         select nominativo
               ,tipo_utente
               ,gruppo_lavoro
           into d_nominativo
               ,d_tipo_utente
               ,d_gruppo_lavoro
           from ad4_utenti
          where utente = p_utente
            and tipo_utente in ('U', 'O');
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'Utente non codificato o di tipo non previsto');
         when others then
            raise_application_error(-20999, 'Errore in ricerca utente - ' || sqlerrm);
      end;
      --
      if d_tipo_utente = 'U' then
         d_stringa_utente := 'U' || d_separatore_1 || p_utente || d_separatore_1 ||
                             d_nominativo;
         d_componente     := substr(ad4_utente_get_dati(p_utente, d_separatore_1)
                                   ,1
                                   ,instr(ad4_utente_get_dati(p_utente, d_separatore_1)
                                         ,d_separatore_1
                                         ,1
                                         ,1) - 1);
         if d_componente is null then
            raise_application_error(-20999
                                   ,'L''utente indicato non e'' un componente della struttura organizzativa');
         end if;
         open d_result for
            select get_ascendenza_ad4(progr_unita_organizzativa
                                     ,d_data
                                     ,ottica
                                     ,d_separatore_1
                                     ,d_separatore_2) || d_stringa_utente
              from vista_pubb_comp
             where ottica = nvl(d_ottica, ottica)
               and ottica.get_ottica_istituzionale(ottica) = 'SI'
               and ni = d_componente
               and nvl(revisione_assegnazione, -2) !=
                   revisione_struttura.get_revisione_mod(ottica)
               and d_data between dal and nvl(decode(revisione_cessazione
                                                    ,revisione_struttura.get_revisione_mod(ottica)
                                                    ,to_date(null)
                                                    ,al)
                                             ,s_data_limite)
            union
            select ad4_get_ruolo(r.ruolo) || d_separatore_2 || d_stringa_utente
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.ottica = nvl(d_ottica, ottica)
               and c.ni = d_componente
               and c.id_componente = r.id_componente
               and nvl(c.revisione_assegnazione, -2) !=
                   revisione_struttura.get_revisione_mod(c.ottica)
               and d_data between c.dal and nvl(decode(c.revisione_cessazione
                                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                                      ,to_date(null)
                                                      ,c.al)
                                               ,s_data_limite)
               and d_data between r.dal and nvl(r.al, s_data_limite)
               and ad4_get_ruolo(r.ruolo) is not null;
      else
         if nvl(d_gruppo_lavoro, 'def') = 'def' then
            open d_result for
               select get_ascendenza_ad4(progr_unita_organizzativa
                                        ,d_data
                                        ,ottica
                                        ,d_separatore_1
                                        ,d_separatore_2)
                 from vista_pubb_anuo
                where utente_ad4 = p_utente
                  and nvl(revisione_istituzione, -2) !=
                      revisione_struttura.get_revisione_mod(ottica)
                  and d_data between dal and nvl(decode(revisione_cessazione
                                                       ,revisione_struttura.get_revisione_mod(ottica)
                                                       ,to_date(null)
                                                       ,al)
                                                ,s_data_limite);
         end if;
      end if;
            --*/
      return d_result;
   
   end get_struttura;
   -------------------------------------------------------------------------------
   function get_struttura_completa(p_ottica unita_organizzative.ottica%type default null)
      return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_struttura_completa
      DESCRIZIONE: Restituisce un cursore contenente la struttura completa delle unita per una
                   certa ottica.
                   I campi del cursore sono, nell'ordine:
                   codice_uo
                   descrizione_uo
                   dal
                   al
                   codice_uo_padre.
      PARAMETRI:   p_ottica                  ottica di riferimento
      RITORNA:     Afc.t_ref_cursor          cursore contenente la gerarchia.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   16/03/2007  SC        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica);
      d_result := get_struttura_completa(p_ottica          => d_ottica
                                        ,p_amministrazione => null
                                        ,p_data            => trunc(sysdate));
      --
      return d_result;
   end; -- so4_util.get_struttura_completa
   -------------------------------------------------------------------------------
   function get_struttura_completa
   (
      p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_data            unita_organizzative.dal%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_struttura_completa
      DESCRIZIONE: Restituisce un cursore contenente la struttura completa delle unita per una
                   certa ottica.
                   I campi del cursore sono, nell'ordine:
                   codice_uo
                   descrizione_uo
                   dal
                   al
                   codice_uo_padre.
      PARAMETRI:   p_ottica                  ottica di riferimento
                   p_amministrazione         amministrazione di riferimento
                   p_data                    data di riferimento
      RITORNA:     Afc.t_ref_cursor          cursore contenente la gerarchia.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   16/03/2007  SC        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select /*+ first_rows */
          so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
         ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione_uo
         ,dal
         ,al
         ,so4_util.anuo_get_codice_uo(id_unita_padre, d_data) codice_uo_padre
         ,so4_util.anuo_get_dal_id(id_unita_padre, d_data) dal_padre
           from vista_pubb_unor
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
         connect by prior progr_unita_organizzativa = id_unita_padre
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and id_unita_padre is null
                 and d_data between dal and nvl(al, s_data_limite)
          order by get_ordinamento(progr_unita_organizzativa, d_data, d_ottica);
      --
      return d_result;
   end; -- so4_util.get_struttura_completa
   -------------------------------------------------------------------------------
   function controllo_unita_temp(p_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return afc_error.t_error_number is
      /******************************************************************************
      NOME:        controllo_unita_temp
      DESCRIZIONE: Verifica l'esistenza dell'unita' passata nella tabella
                   temporanea (x CF4)
      PARAMETRI:   p_progr_unor              progr. unità da controllare
      RITORNA:     Afc.t_error_number        Vale 1 se l'unità esiste, altrimenti 0
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   31/05/2007  VD        Prima emissione.
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      begin
         select afc_error.ok
           into d_result
           from temp_cf4_unita_previste
          where progr_unita_org = p_progr_unor;
      exception
         when others then
            d_result := 0;
      end;
      if d_result <> afc_error.ok then
         begin
            select afc_error.ok
              into d_result
              from temp_cf4_unita_agg
             where progr_unita_org = p_progr_unor;
         exception
            when others then
               d_result := 0;
         end;
         if d_result = afc_error.ok then
            update temp_cf4_unita_agg
               set se_trattata = 'S'
             where progr_unita_org = p_progr_unor;
         end if;
      end if;
      return d_result;
   end;
   -------------------------------------------------------------------------------
   function utente_get_utilizzo
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        utente_get_struttura
      DESCRIZIONE: Restituisce un cursore contenente la struttura associata
                   all'utente (per procedure CF4)
                   I campi del cursore sono, nell'ordine:
                   codice_uo
                   descrizione_uo
                   progr_uo
                   progr_uo_padre.
      PARAMETRI:   p_utente                  utente di riferimento
                   p_lista_uo                lista della u.o. di riferimento
                   p_ottica                  ottica di riferimento; se non
                                             indicata si determina un'ottica di 
                                             default
      RITORNA:     Afc.t_ref_cursor          cursore contenente la gerarchia.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   05/06/2007  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione 
      002   09/09/2013  VD        Aggiunto parametro ottica con default null    
      ******************************************************************************/
      d_result       afc.t_ref_cursor;
      d_ottica       ottiche.ottica%type;
      d_data         unita_organizzative.dal%type;
      d_lista_utente afc.t_ref_cursor;
      d_progr_unor   anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo    anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione  anagrafe_unita_organizzative.descrizione%type;
      d_esiste_unita afc_error.t_error_number;
      d_progressivo  number;
      d_progr_padre  anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      type vettorepadre is table of number index by binary_integer;
      progrpadre vettorepadre;
      indice     binary_integer;
   begin
      delete from temp_cf4_unita_utente;
      d_progressivo := 0;
      d_data        := set_data_default(p_data => to_date(null));
      d_ottica      := nvl(p_ottica
                          ,ad4_utente_get_ottica(p_utente => p_utente, p_data => d_data));
      --
      if p_lista_uo%isopen then
         fetch p_lista_uo
            into d_progr_unor;
         while p_lista_uo%found
         loop
            insert into temp_cf4_unita_previste
               (progr_unita_org)
               select d_progr_unor
                 from dual
                where not exists (select 'x'
                         from temp_cf4_unita_previste t
                        where t.progr_unita_org = d_progr_unor);
            fetch p_lista_uo
               into d_progr_unor;
         end loop;
      end if;
      --
      /*  if p_lista_agg%isopen
      then
         fetch p_lista_agg into d_progr_unor;
         while p_lista_agg%found
         loop
           insert into temp_cf4_unita_agg (progr_unita_org )
           select d_progr_unor
             from dual
            where not exists (select 'x' from temp_cf4_unita_agg t
                               where t.progr_unita_org = d_progr_unor);
         fetch p_lista_agg into d_progr_unor;
         end loop;
      end if;*/
      --
      d_lista_utente := ad4_utente_get_unita(p_utente         => p_utente
                                            ,p_ottica         => d_ottica
                                            ,p_data           => d_data
                                            ,p_se_progr_unita => 'SI');
      --
      if d_lista_utente%isopen then
         fetch d_lista_utente
            into d_progr_unor
                ,d_codice_uo
                ,d_descrizione;
         while d_lista_utente%found
         loop
            progrpadre.delete;
            for legame in (select /*+ first_rows */
                            level
                           ,progr_unita_organizzativa
                           ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
                           ,so4_util.anuo_get_descrizione(progr_unita_organizzativa
                                                         ,d_data) descr_uo
                           ,id_unita_padre progr_uo_padre
                           ,suddivisione_struttura.get_icona_standard(so4_util.anuo_get_id_suddivisione(progr_unita_organizzativa
                                                                                                       ,d_data)) icona
                             from vista_pubb_unor
                            where ottica = d_ottica
                              and d_data between dal and nvl(al, s_data_limite)
                           connect by prior progr_unita_organizzativa = id_unita_padre
                                  and ottica = d_ottica
                                  and d_data between dal and nvl(al, s_data_limite)
                            start with ottica = d_ottica
                                   and progr_unita_organizzativa = d_progr_unor
                                   and d_data between dal and nvl(al, s_data_limite))
            loop
               d_esiste_unita := controllo_unita_temp(p_progr_unor => legame.progr_unita_organizzativa);
               if d_esiste_unita = afc_error.ok then
                  indice := legame.level;
                  progrpadre(indice) := legame.progr_unita_organizzativa;
                  d_progressivo := d_progressivo + 1;
                  if legame.level = 1 then
                     d_progr_padre := to_number(null);
                  else
                     d_progr_padre := progrpadre(legame.level - 1);
                  end if;
                  begin
                     insert into temp_cf4_unita_utente
                        (id_record
                        ,progr_unita_org
                        ,codice_uo
                        ,descrizione_uo
                        ,progr_uo_padre
                        ,icona)
                     values
                        (d_progressivo
                        ,legame.progr_unita_organizzativa
                        ,legame.codice_uo
                        ,legame.descr_uo
                        ,d_progr_padre
                        ,legame.icona);
                  exception
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in inserimento tabella temporanea - ' ||
                                                sqlerrm);
                  end;
               else
                  indice := legame.level;
                  if indice > 1 then
                     progrpadre(indice) := progrpadre(legame.level - 1);
                  else
                     progrpadre(indice) := to_number(null);
                  end if;
               end if;
            end loop;
            fetch d_lista_utente
               into d_progr_unor
                   ,d_codice_uo
                   ,d_descrizione;
         end loop;
      end if;
      --
      open d_result for
         select codice_uo
               ,descrizione_uo
               ,progr_unita_org
               ,progr_uo_padre
               ,icona
           from temp_cf4_unita_utente
          order by id_record;
      --
      return d_result;
   end; -- so4_util.utente_get_struttura
   -------------------------------------------------------------------------------
   function utente_get_gerarchia_unita
   (
      p_utente ad4_utenti.utente%type
     ,p_ottica ottiche.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        utente_get_gerarchia_unita
      DESCRIZIONE: Restituisce un cursore contenente la struttura associata
                   all'utente (per procedure CF4)
                   I campi del cursore sono, nell'ordine:
                   codice_uo
                   descrizione_uo
                   progr_uo
                   progr_uo_padre.
      PARAMETRI:   p_utente                  utente di riferimento
      RITORNA:     Afc.t_ref_cursor          cursore contenente la gerarchia.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   05/06/2007  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      002   09/09/2013  VD        Aggiunto parametro ottica con default null    
      ******************************************************************************/
      d_result       afc.t_ref_cursor;
      d_ottica       ottiche.ottica%type;
      d_data         unita_organizzative.dal%type;
      d_lista_utente afc.t_ref_cursor;
      d_progr_unor   anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo    anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione  anagrafe_unita_organizzative.descrizione%type;
      d_progressivo  number(8);
      d_progr_ramo   number(8);
   begin
      delete from temp_cf4_unita_utente;
      d_data         := set_data_default(p_data => to_date(null));
      d_ottica       := nvl(p_ottica
                           ,ad4_utente_get_ottica(p_utente => p_utente, p_data => d_data));
      d_lista_utente := ad4_utente_get_unita(p_utente         => p_utente
                                            ,p_ottica         => d_ottica
                                            ,p_data           => d_data
                                            ,p_se_progr_unita => 'SI');
      d_progressivo  := 0;
      d_progr_ramo   := 0;
      if d_lista_utente%isopen then
         fetch d_lista_utente
            into d_progr_unor
                ,d_codice_uo
                ,d_descrizione;
         while d_lista_utente%found
         loop
            d_progr_ramo := d_progr_ramo + 1;
            for legame in (select /*+ first_rows */
                            progr_unita_organizzativa
                             from vista_pubb_unor
                            where ottica = d_ottica
                              and d_data between dal and nvl(al, s_data_limite)
                           connect by prior id_unita_padre = progr_unita_organizzativa
                                  and ottica = d_ottica
                                  and d_data between dal and nvl(al, s_data_limite)
                            start with ottica = d_ottica
                                   and progr_unita_organizzativa = d_progr_unor
                                   and d_data between dal and nvl(al, s_data_limite))
            loop
               d_progressivo := d_progressivo + 1;
               begin
                  insert into temp_cf4_unita_utente
                     (id_record
                     ,progr_ramo
                     ,progr_unita_org)
                  values
                     (d_progressivo
                     ,d_progr_ramo
                     ,legame.progr_unita_organizzativa);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento tabella temporanea - ' ||
                                             sqlerrm);
               end;
            end loop;
            fetch d_lista_utente
               into d_progr_unor
                   ,d_codice_uo
                   ,d_descrizione;
         end loop;
      end if;
      --
      open d_result for
         select progr_ramo
               ,progr_unita_org
           from temp_cf4_unita_utente
          order by 1;
      --
      return d_result;
   end; -- so4_util.utente_get_gerarchia_unita
   -------------------------------------------------------------------------------
   function utente_get_gestione
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        utente_get_gestione
      DESCRIZIONE: Restituisce un cursore contenente i legami di struttura relativi
                   a unità previste in CF4
                   I campi del cursore sono, nell'ordine:
                   codice_uo
                   descrizione_uo
                   progr_uo
                   progr_uo_padre.
      PARAMETRI:
      RITORNA:     Afc.t_ref_cursor          cursore contenente i legami
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   05/06/2007  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      002   09/09/2013  VD        Aggiunto parametro ottica con default null    
      ******************************************************************************/
      d_result       afc.t_ref_cursor;
      d_ottica       ottiche.ottica%type;
      d_data         unita_organizzative.dal%type;
      d_progr_unor   anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_esiste_unita afc_error.t_error_number;
      d_progressivo  number;
      d_progr_padre  anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      type vettorepadre is table of number index by binary_integer;
      progrpadre vettorepadre;
      indice     binary_integer;
   begin
      delete from temp_cf4_unita_utente;
      d_progressivo := 0;
      d_data        := set_data_default(p_data => to_date(null));
      d_ottica      := nvl(p_ottica
                          ,ad4_utente_get_ottica(p_utente => p_utente, p_data => d_data));
      --
      if p_lista_uo%isopen then
         fetch p_lista_uo
            into d_progr_unor;
         while p_lista_uo%found
         loop
            insert into temp_cf4_unita_previste
               (progr_unita_org)
               select d_progr_unor
                 from dual
                where not exists (select 'x'
                         from temp_cf4_unita_previste t
                        where t.progr_unita_org = d_progr_unor);
            fetch p_lista_uo
               into d_progr_unor;
         end loop;
      end if;
      --
      progrpadre.delete;
      for legame in (select /*+ first_rows */
                      level
                     ,progr_unita_organizzativa
                     ,so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
                     ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descr_uo
                     ,id_unita_padre progr_uo_padre
                     ,suddivisione_struttura.get_icona_standard(so4_util.anuo_get_id_suddivisione(progr_unita_organizzativa
                                                                                                 ,d_data)) icona
                       from vista_pubb_unor
                      where ottica = d_ottica
                        and d_data between dal and nvl(al, s_data_limite)
                     connect by prior progr_unita_organizzativa = id_unita_padre
                            and ottica = d_ottica
                            and d_data between dal and nvl(al, s_data_limite)
                      start with ottica = d_ottica
                             and id_unita_padre is null
                             and d_data between dal and nvl(al, s_data_limite))
      loop
         d_esiste_unita := controllo_unita_temp(p_progr_unor => legame.progr_unita_organizzativa);
         if d_esiste_unita = afc_error.ok then
            indice := legame.level;
            progrpadre(indice) := legame.progr_unita_organizzativa;
            d_progressivo := d_progressivo + 1;
            if legame.level = 1 then
               d_progr_padre := to_number(null);
            else
               d_progr_padre := progrpadre(legame.level - 1);
            end if;
            begin
               insert into temp_cf4_unita_utente
                  (id_record
                  ,progr_unita_org
                  ,codice_uo
                  ,descrizione_uo
                  ,progr_uo_padre
                  ,icona)
               values
                  (d_progressivo
                  ,legame.progr_unita_organizzativa
                  ,legame.codice_uo
                  ,legame.descr_uo
                  ,d_progr_padre
                  ,legame.icona);
            exception
               when others then
                  raise_application_error(-20999
                                         ,'Errore in inserimento tabella temporanea - ' ||
                                          sqlerrm);
            end;
         else
            indice := legame.level;
            if indice > 1 then
               progrpadre(indice) := progrpadre(legame.level - 1);
            else
               progrpadre(indice) := to_number(null);
            end if;
         end if;
      end loop;
      --
      open d_result for
         select codice_uo
               ,descrizione_uo
               ,progr_unita_org
               ,progr_uo_padre
               ,icona
           from temp_cf4_unita_utente
          order by id_record;
      return d_result;
   end; -- so4_util.utente_get_gestione
   -------------------------------------------------------------------------------
   function get_ascendenza_padre
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ascendenza_padre
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità organizzativa
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                ottica di riferimento (facoltativa, alternativa
                                           all'amministrazione - se non indicata si assume
                                           l'ottica istituzionale dell'amministrazione
                                           indicata)
                   p_separatore_1          carattere di separazione per concatenare i dati
                   p_separatore_2          carattere di separazione per concatenare i dati
                   p_amministrazione       amministrazione di riferimento (facoltativa,
                                           alternativa all'ottica per la definizione 
                                           dell'ottica istituzionale)
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O. concatenata con
                                           il carattere separatore
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2006  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result       varchar2(32767);
      d_ottica       anagrafe_unita_organizzative.ottica%type;
      d_data         anagrafe_unita_organizzative.dal%type;
      d_separatore_1 varchar2(1);
      d_separatore_2 varchar2(1);
   begin
      d_ottica       := set_ottica_default(p_ottica, p_amministrazione);
      d_data         := set_data_default(p_data);
      d_separatore_1 := set_separatore_default(p_separatore_1, 1);
      d_separatore_2 := set_separatore_default(p_separatore_2, 2);
      d_result       := '';
      --
      for sel_asc in (select /*+ first_rows */
                       so4_util.anuo_get_codice_uo(u.progr_unita_organizzativa, d_data) codice_uo
                      ,s.descrizione || ' ' ||
                       so4_util.anuo_get_descrizione(u.progr_unita_organizzativa, d_data) descrizione
                        from vista_pubb_unor        u
                            ,suddivisioni_struttura s
                            ,vista_pubb_anuo        a
                       where u.ottica = d_ottica
                         and a.progr_unita_organizzativa = u.progr_unita_organizzativa
                         and s.id_suddivisione = a.id_suddivisione
                         and a.id_suddivisione in (1, 2)
                         and d_data between u.dal and nvl(u.al, s_data_limite)
                      connect by prior u.id_unita_padre = u.progr_unita_organizzativa
                             and u.ottica = d_ottica
                             and d_data between u.dal and nvl(u.al, s_data_limite)
                       start with u.ottica = d_ottica
                              and u.progr_unita_organizzativa = p_progr_unor
                              and d_data between u.dal and nvl(u.al, s_data_limite)
                       order by 1 desc)
      loop
         d_result := d_result || 'O' || d_separatore_1 || sel_asc.codice_uo ||
                     d_separatore_1 || sel_asc.descrizione || d_separatore_2;
      end loop;
      --
      return d_result;
   end get_ascendenza_padre; -- so4_util.get_ascendenza_padre
   -------------------------------------------------------------------------------
   function get_all_unita_radici
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_all_unita_radici
      DESCRIZIONE: Restituisce un ref_cursor contenente l'elenco delle unita' padre,
                   ordinate per sequenza
      PARAMETRI:   p_ottica                ottica di cui ricercare i dati (facoltativa
                                           - alternativa all'amministrazione)
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale
      RITORNA:     Ref_cursor              contiene l'elenco delle unita' radice
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2008  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   anagrafe_unita_organizzative.dal%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select so4_util.anuo_get_codice_uo(progr_unita_organizzativa, d_data) codice_uo
               ,so4_util.anuo_get_descrizione(progr_unita_organizzativa, d_data) descrizione_uo
               ,dal
               ,al
           from vista_pubb_unor
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
            and id_unita_padre is null
          order by sequenza;
      return d_result;
   end; -- so4_util.get_all_unita_radici
   -------------------------------------------------------------------------------
   function get_all_componenti
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_all_componenti
      DESCRIZIONE: Restituisce un ref_cursor contenente l'elenco dei componenti di
                   tutte le unità organizzative valide alla data (nominativo)
      PARAMETRI:   p_ottica                ottica di cui ricercare i dati (facoltativa
                                           - alternativa all'amministrazione)
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale)
      RITORNA:     Ref_cursor              contiene l'elenco dei componenti
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   19/12/2008  VD        Prima emissione.
      001   17/01/2011  VD        Corretto confronto revisione cessazione con
                                  revisione in modifica
      002   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   anagrafe_unita_organizzative.dal%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select soggetti_get_descr(c.ni, d_data, 'COGNOME E NOME') cognome_nome
           from vista_pubb_comp c
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
          order by 1;
      return d_result;
   end; -- so4_util.get_all_componenti
   -------------------------------------------------------------------------------
   function get_all_componenti_ni
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_all_componenti_ni
      DESCRIZIONE: Restituisce un ref_cursor contenente l'elenco dei componenti di
                   tutte le unità organizzative valide alla data (nominativo - ni)
      PARAMETRI:   p_ottica                ottica di cui ricercare i dati (facoltativa
                                           - alternativa all'amministrazione)
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale
      RITORNA:     Ref_cursor              contiene l'elenco dei componenti
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/10/2010  VD        Prima emissione.
      001   17/01/2011  VD        Corretto confronto revisione cessazione con
                                  revisione in modifica (nvl)
      002   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      003   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   anagrafe_unita_organizzative.dal%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select distinct ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from vista_pubb_comp c
          where c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
          order by 2
                  ,1;
      return d_result;
   end; -- get_all_componenti
   -------------------------------------------------------------------------------
   function get_all_responsabili
   (
      p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_all_responsabili
      DESCRIZIONE: Restituisce un ref_cursor contenente l'elenco dei responsabili di
                   tutte le unità organizzative valide alla data
      
      PARAMETRI:   p_ottica                ottica di cui ricercare i dati (facoltativa
                                           - alternativa all'amministrazione)
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           - se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale
      RITORNA:     Ref_cursor              contiene l'elenco dei responsabili
                                           (utente - ni - nominativo - incarico)
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/10/2010  VD        Prima emissione.
      001   17/01/2011  VD        Corretto confronto revisione cessazione con
                                  revisione in modifica (nvl)
      002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione 
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   anagrafe_unita_organizzative.dal%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select distinct soggetti_get_descr(ni, d_data, 'UTENTE') utente
                        ,ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME') cognome
                        ,soggetti_get_descr(ni, d_data, 'NOME') nome
                        ,a.incarico
           from vista_pubb_comp c
               ,vista_pubb_atco a
          where c.ottica = d_ottica
            and d_data between c.dal and nvl(c.al, s_data_limite)
            and c.id_componente = a.id_componente
            and d_data between a.dal and nvl(a.al, s_data_limite)
            and tipo_incarico.get_responsabile(a.incarico) = 'SI'
          order by cognome
                  ,nome;
      return d_result;
   end; -- get_all_componenti
   -------------------------------------------------------------------------------
   function get_allinea_unita
   (
      p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_data            unita_organizzative.dal%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        GET_ALLINEA_UNITA
      DESCRIZIONE: Restituisce un ref_cursor contenente l'elenco delle unita'
                   modificate alla data indicata
      
      PARAMETRI:   p_ottica                ottica di cui ricercare i dati (facoltativa
                                           - alternativa all'amministrazione)
                   p_amministrazione       amministrazione di ricerca nella struttura
                                           (facoltativa - alternativa all'ottica per la
                                           definizione dell'ottica istituzionale
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           - se non indicata si assume la data di sistema)
      
      RITORNA:     Ref_cursor              contiene l'elenco delle unita' modificate
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/07/2009  VD  Prima emissione.
      001   15/09/2009  VD  Aggiunta estrazione unità modificate senza
                                  revisione.
      002   19/01/2010  VD  Rivista select per gestione cambio padre
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica := so4_util.set_ottica_default(p_ottica, p_amministrazione);
      --
      open d_result for
         select codice_figlio
               ,descr_figlio
               ,dal
               ,al
               ,codice_padre
               ,dal_padre
           from work_allinea_unita
          where ottica = d_ottica
          order by al
                  ,livello;
      --
      return d_result;
      --
   end; -- get_allinea_unita
   -------------------------------------------------------------------------------
   function get_area_unita
   (
      p_id_suddivisione           in suddivisioni_struttura.id_suddivisione%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
     ,p_ottica                    in ottiche.ottica%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
      NOME:        get_area_unita
      DESCRIZIONE: Restituisce il progressivo dell'unita' organizzativa avente la
                   suddivisione indicata
      
      PARAMETRI:   p_id_suddivisione                suddivisione da ricercare
                   p_progr_unita_organizzativa      unita' organizzativa di partenza
                   p_data                           data a cui eseguire la ricerca 
                                                    (facoltativa - se non indicata 
                                                    si assume la data di sistema)
                   p_ottica                         ottica di riferimento - se non 
                                                    indicata si assume l'ottica 
                                                    istituzionale dell'unita'
      
      RITORNA:     progr. unita organizzativa
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   15/07/2009  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
      d_result          anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_ref_cursor      afc.t_ref_cursor;
      d_amministrazione anagrafe_unita_organizzative.amministrazione%type;
      d_ottica          ottiche.ottica%type;
      d_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo       anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione     anagrafe_unita_organizzative.descrizione%type;
      d_dal             anagrafe_unita_organizzative.dal%type;
      d_al              anagrafe_unita_organizzative.al%type;
      d_id_suddivisione anagrafe_unita_organizzative.id_suddivisione%type;
   begin
      if p_ottica is null then
         d_amministrazione := anagrafe_unita_organizzativa.get_amministrazione(p_progr_unita_organizzativa
                                                                              ,p_data);
         d_ottica          := ottica.get_ottica_per_amm(d_amministrazione);
      else
         d_ottica := p_ottica;
      end if;
      --
      d_ref_cursor := so4_util.get_ascendenti(p_progr_unita_organizzativa
                                             ,p_data
                                             ,d_ottica);
      loop
         fetch d_ref_cursor
            into d_progr_unor
                ,d_codice_uo
                ,d_descrizione
                ,d_dal
                ,d_al;
         exit when d_ref_cursor%notfound;
         d_id_suddivisione := so4_util.anuo_get_id_suddivisione(d_progr_unor, p_data);
         if d_id_suddivisione = p_id_suddivisione then
            d_result := d_progr_unor;
         end if;
      end loop;
      --
      return d_result;
      --
   end get_area_unita;
   -------------------------------------------------------------------------------
   function get_des_amministrazione(p_amministrazione amministrazioni.codice_amministrazione%type)
      return as4_anagrafe_soggetti.denominazione%type is
      /******************************************************************************
      NOME:        get_des_amministrazione
      DESCRIZIONE: Restituisce la descrizione dell'amministrazione indicate
      
      PARAMETRI:   p_amministrazione
      
      RITORNA:     as4_anagrafe_soggetti.denominazione%type
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   11/12/2009  VD        Prima emissione.
      ******************************************************************************/
   
      d_result as4_anagrafe_soggetti.denominazione%type;
   begin
      begin
         select denominazione
           into d_result
           from so_amministrazioni
          where codice_amministrazione = p_amministrazione;
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
      --
   end get_des_amministrazione;
   -------------------------------------------------------------------------------
   function get_des_suddivisione
   (
      p_ottica       suddivisioni_struttura.ottica%type
     ,p_suddivisione suddivisioni_struttura.suddivisione%type
   ) return suddivisioni_struttura.descrizione%type is
      /******************************************************************************
      NOME:        get_des_suddivisione
      DESCRIZIONE: Restituisce la descrizione della suddivisione indicate
      
      PARAMETRI:   p_ottica
                   p_suddivisione
      
      RITORNA:     suddivisioni_struttura.descrizione%type
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   11/12/2009  VD  Prima emissione.
      ******************************************************************************/
   
      d_result suddivisioni_struttura.descrizione%type;
   begin
      begin
         select descrizione
           into d_result
           from suddivisioni_struttura
          where ottica = p_ottica
            and suddivisione = p_suddivisione;
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
      --
   end get_des_suddivisione;
   -------------------------------------------------------------------------------
   function unita_get_stringa_ascendenti
   (
      p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_id_suddivisone            suddivisioni_struttura.id_suddivisione%type
     ,p_data                      anagrafe_unita_organizzative.dal%type default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_stringa_ascendenti
      DESCRIZIONE: Dato il progressivo di una unità sale nei vari livelli (max 5
                   livelli) delle unità ascendenti fino a trovare, se esiste, una
                   unità con id_suddivisione pari al parametro. Ritorna una stringa
                   di 40 char contenente i progressivi delle unità ascendenti partendo
                   da quella con suddivisione ricercata fino ad arrivare alla uo padre
                   della uo di partenza.
      PARAMETRI:   p_progr_unita_organizzativa     Progressivo dell'unità di partenza
                   p_id_suddivisone                Id della suddivisione da ricercare
                   p_data                          Data di riferimento per la ricerca
      RITORNA:     Stringa contenente la gerarchia dei progressivi delle unità ascendenti
                   (40 caratteri)
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   XX/XX/XXXX  XX        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione     
      ******************************************************************************/
   
      d_data      anagrafe_unita_organizzative.dal%type;
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_uo_ascend afc.t_ref_cursor;
   
      d_puo         anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice      anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione anagrafe_unita_organizzative.descrizione%type;
      d_dal         anagrafe_unita_organizzative.dal%type;
      d_al          anagrafe_unita_organizzative.al%type;
      d_id_sudd     anagrafe_unita_organizzative.id_suddivisione%type;
   
      d_livelli integer;
   
      d_result varchar2(40) := rpad('0', 40, '0');
   
   begin
   
      d_data := so4_util.set_data_default(p_data);
   
      d_ottica := so4_util.anuo_get_ottica(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                          ,p_dal                       => d_data);
   
      d_uo_ascend := so4_util.get_ascendenti_sudd(p_progr_unor => p_progr_unita_organizzativa
                                                 ,p_data       => d_data
                                                 ,p_ottica     => d_ottica);
   
      d_livelli := 0;
   
      loop
         fetch d_uo_ascend
            into d_puo
                ,d_codice
                ,d_descrizione
                ,d_dal
                ,d_al
                ,d_id_sudd;
         exit when d_uo_ascend%notfound or d_livelli > 5;
      
         d_livelli := d_livelli + 1;
      
         -- nel caso l'uo stessa è della stessa suddivisione ricercata concatena il progressivo a 32 zeri e termina
         if d_puo = p_progr_unita_organizzativa then
            if d_id_sudd = p_id_suddivisone then
               d_result := lpad(d_puo, 8, '0') || substr(d_result, 9, 32);
               return(d_result);
            end if;
         else
            -- concatena sempre il progressivo a sx della stringa già calcolata
            d_result := lpad(d_puo, 8, '0') || substr(d_result, 1, 32);
            -- esce nel caso abbia trovato la suddivisione cercata
            if d_id_sudd = p_id_suddivisone then
               return(d_result);
            end if;
         end if;
      
      end loop;
   
      -- se supera i 5 livelli torna una stringa di 40 zeri
      if d_livelli > 5 then
         d_result := rpad('0', 40, '0');
      end if;
   
      return(d_result);
   
   end; --so4_util.unita_get_stringa_ascendenti
   -------------------------------------------------------------------------------
   function get_unita_valida
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_unita_valida
      DESCRIZIONE: Dato il progressivo di un'unita restituisce un elenco
                   contenente l'unita' stessa se valida alla data indicata.
                   SOLO PER PERSONALIZZAZIONE CONTABILITA' REGIONE MARCHE.
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_separatore            carattere di separazione per concatenare i dati
      RITORNA:     Afc.t_ref_cursor        
      
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   09/04/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      d_ottica    := set_ottica_default(p_ottica);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
      -- 
      open d_result for
         select progr_unita_organizzativa
               ,codice_uo
               ,descrizione
               ,dal
               ,al
           from anagrafe_unita_organizzative
          where ottica = d_ottica
            and revisione_istituzione != d_revisione
            and d_data between dal and
                nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                   ,s_data_limite)
            and progr_unita_organizzativa = p_progr_unor;
      --
      return d_result;
   end; -- so4_util.get_unita_valida
   -------------------------------------------------------------------------------
   function get_cdr_unita
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
     ,p_ottica                    in ottiche.ottica%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
      NOME:        get_cdr_unita
      DESCRIZIONE: Restituisce il progressivo dell'unita' organizzativa avente il
                   flag "centro di responsabilita'" attivo
      
      PARAMETRI:   p_progr_unita_organizzativa      unita' organizzativa di partenza
                   p_data                           data a cui eseguire la ricerca 
                                                    (facoltativa - se non indicata 
                                                    si assume la data di sistema)
                   p_ottica                         ottica di riferimento - se non 
                                                    indicata si assume l'ottica 
                                                    istituzionale dell'unita'
      
      RITORNA:     progr. unita organizzativa
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   09/04/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result          anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_amministrazione anagrafe_unita_organizzative.amministrazione%type;
      d_ottica          ottiche.ottica%type;
      d_data            revisioni_struttura.dal%type;
      d_revisione       revisioni_struttura.revisione%type;
      d_cdr             anagrafe_unita_organizzative.centro_responsabilita%type;
   begin
      if p_ottica is null then
         d_amministrazione := anagrafe_unita_organizzativa.get_amministrazione(p_progr_unita_organizzativa
                                                                              ,p_data);
         d_ottica          := ottica.get_ottica_per_amm(d_amministrazione);
      else
         d_ottica := p_ottica;
      end if;
      --
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      for unor in (select /*+ first_rows */
                    progr_unita_organizzativa
                     from unita_organizzative
                    where ottica = d_ottica
                      and revisione != d_revisione
                      and d_data between dal and
                          nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                             ,s_data_limite)
                   connect by prior id_unita_padre = progr_unita_organizzativa
                          and ottica = d_ottica
                          and d_data between dal and nvl(al, s_data_limite)
                    start with ottica = d_ottica
                           and progr_unita_organizzativa = p_progr_unita_organizzativa
                           and revisione != d_revisione
                           and d_data between dal and
                               nvl(decode(revisione_cessazione
                                         ,d_revisione
                                         ,to_date(null)
                                         ,al)
                                  ,s_data_limite))
      loop
         d_cdr := anagrafe_unita_organizzativa.get_centro_responsabilita(unor.progr_unita_organizzativa
                                                                        ,d_data);
         if d_cdr = 'SI' then
            d_result := unor.progr_unita_organizzativa;
         end if;
      end loop;
      --
      return d_result;
      --
   end; -- so4_util.get_cdr_unita
   -------------------------------------------------------------------------------
   function ricerca_dipendenti
   (
      p_codice_fiscale in componenti.codice_fiscale%type default null
     ,p_cognome        in varchar2 default null
     ,p_nome           in varchar2 default null
     ,p_data           in componenti.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        ricerca_dipendenti
      DESCRIZIONE: Dato il codice fiscale o il cognome (anche parziale) o il nome di
                   un dipendente, restituisce un ref_cursor i cui elementi sono composti
                   da:
                   cognome
                   nome
                   codice fiscale
                   U.O di appartenenza             (completa delle unita' ascendenti
                                                   concatenate in una stringa)
      PARAMETRI:   p_codice_fiscale
                   p_cognome
                   p_nome
                   Tutti i parametri sono facoltativi, ne deve esistere almeno uno.
                   Per cognome e nome e' ammessa la ricerca parziale.
      RITORNA:     ref_corsor (come sopra)
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   31/12/2011  VD        Prima emissione.
      001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione  
      002   07/02/2012  VD        Esegue la ricerca per tutte le ottiche istituzionali
                                  previste nella tabella ottiche 
      003   12/03/2012  VD        La ricerca viene eseguita sulla vista 
                                  anagrafica_componenti, per avere la certezza
                                  di selezionare i dati di un soggetto inserito
                                  come componente.                                    
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_data      componenti.dal%type;
      d_messaggio varchar2(2000);
      errore exception;
   begin
      if p_codice_fiscale is null and p_cognome is null and p_nome is null then
         d_messaggio := 'Parametri non valorizzati - impossibile procedere';
         raise errore;
      end if;
      --
      if (p_codice_fiscale is not null and (p_cognome is not null or p_nome is not null)) or
         (p_codice_fiscale is null and p_cognome is null and p_nome is not null) then
         d_messaggio := 'Ricerca consentita per codice fiscale o cognome/nome';
         raise errore;
      end if;
      --
      d_data := so4_util.set_data_default(p_data);
      --
      if p_codice_fiscale is not null then
         open d_result for
            select a.cognome
                  ,a.nome
                  ,a.codice_fiscale
                  ,so4_util.get_ascendenza_cf(so4_util.comp_get_unita_prev(a.ni -- ni anagrafe
                                                                          ,o.ottica -- ottica
                                                                          ,d_data -- data
                                                                          ,null -- amministrazione
                                                                           ) -- progr. U.O.
                                             ,d_data -- data
                                             ,o.ottica -- ottica
                                             ,'$' -- separatore 1
                                             ,'|' -- separatore 2
                                             ,null -- amministrazione
                                             ,'N' -- se estrazione tipo
                                              ) uo_appartenenza
                  ,so4_util.comp_get_incarico(a.ni -- ni anagrafe
                                             ,so4_util.comp_get_unita_prev(a.ni
                                                                          ,o.ottica
                                                                          ,d_data
                                                                          ,null) -- progr. U.O.
                                             ,d_data -- data
                                             ,o.ottica -- ottica
                                             ,null -- amministrazione
                                             ,'NO' -- se estrazione codice
                                              ) incarico
                  ,soggetti_rubrica_pkg.get_telefono_fisso(a.ni) telefono
                  ,soggetti_rubrica_pkg.get_cellulare(a.ni) cellulare
                  ,soggetti_rubrica_pkg.get_email(a.ni) mail
              from anagrafica_componenti a
                  ,ottiche               o
             where a.codice_fiscale = p_codice_fiscale
                  --            and d_data between a.dal and nvl(a.al, d_data)
               and o.ottica_istituzionale = 'SI'
             order by cognome
                     ,nome;
      else
         open d_result for
            select a.cognome
                  ,a.nome
                  ,a.codice_fiscale
                  ,so4_util.get_ascendenza_cf(so4_util.comp_get_unita_prev(a.ni -- ni anagrafe
                                                                          ,o.ottica -- ottica
                                                                          ,d_data -- data
                                                                          ,null -- amministrazione
                                                                           ) -- progr. U.O.
                                             ,d_data -- data
                                             ,o.ottica -- ottica
                                             ,'$' -- separatore 1
                                             ,'|' -- separatore 2
                                             ,null -- amministrazione
                                             ,'N' -- se estrazione tipo
                                              ) uo_appartenenza
                  ,so4_util.comp_get_incarico(a.ni -- ni anagrafe
                                             ,so4_util.comp_get_unita_prev(a.ni
                                                                          ,o.ottica
                                                                          ,d_data
                                                                          ,null) -- progr. U.O.
                                             ,d_data -- data
                                             ,o.ottica -- ottica
                                             ,null -- amministrazione
                                             ,'NO' -- se estrazione codice
                                              ) incarico
                  ,soggetti_rubrica_pkg.get_telefono_fisso(a.ni) telefono
                  ,soggetti_rubrica_pkg.get_cellulare(a.ni) cellulare
                  ,soggetti_rubrica_pkg.get_email(a.ni) mail
              from anagrafica_componenti a
                  ,ottiche               o
             where a.cognome like p_cognome
               and a.nome like nvl(p_nome, nome)
                  --            and d_data between a.dal and nvl(a.al, d_data)
               and o.ottica_istituzionale = 'SI'
             order by cognome
                     ,nome;
      end if;
      --
      return d_result;
      --
   exception
      when others then
         raise_application_error(-20999, d_messaggio);
   end; --so4_util.ricerca_dipendenti
-------------------------------------------------------------------------------
end so4_util;
/


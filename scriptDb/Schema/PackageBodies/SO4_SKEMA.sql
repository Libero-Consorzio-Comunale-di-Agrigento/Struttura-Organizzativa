CREATE OR REPLACE package body so4_skema is
   /******************************************************************************
    NOME:        SO4_SKEMA.
    DESCRIZIONE: Raggruppa le funzioni di supporto per l'applicativo SKEMA
    ANNOTAZIONI: Contiene la replica di alcuni metodi del package SO4_UTIL che
                 devono accedere ai dati mediante data effettiva di validita'
                 (e non data di pubblicazione)
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   04/01/2013  VD      Prima emissione.
    001   07/11/2016  MM      #744 Metodi aggiuntivi
          08/09/2017  MM      #785
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '001';
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
                   dell'amministrazione passata come parametro
                   Uno dei due parametri deve essere presente
      PARAMETRI:   p_ottica                ottica da trattare
                   p_amministrazione       amministrazione da trattare
      RITORNA:     ottiche.ottica%type     ottica da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/01/2013  VD        Prima emissione.
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
   end; -- so4_skema.set_ottica_default
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
      000   04/01/2013  VD        Prima emissione.
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
      000   04/01/2013  VD        Prima emissione.
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
      000   02/01/2007  VDAVALLI  Prima emissione.
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
       000   04/01/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result     number;
      d_ottica     componenti.ottica%type;
      d_revisione  componenti.revisione_assegnazione%type;
      d_data       componenti.dal%type;
      d_componente componenti.ni%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Si settano i parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      d_data      := set_data_default(p_data);
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
      d_progr_unor := anagrafe_unita_organizzativa.get_progr_unor(p_ottica    => d_ottica
                                                                 ,p_codice_uo => p_codice_uo
                                                                 ,p_data      => d_data);
      --
      if d_componente is not null and d_progr_unor is not null then
         if p_ruolo is null then
            begin
               select 1
                 into d_result
                 from componenti c
                where c.ottica = d_ottica
                  and c.progr_unita_organizzativa = d_progr_unor
                  and c.ni = d_componente
                  and nvl(c.revisione_assegnazione, -2) != d_revisione
                  and d_data between c.dal and
                      nvl(decode(nvl(c.revisione_cessazione, -2)
                                ,d_revisione
                                ,to_date(null)
                                ,c.al)
                         ,to_date('3333333', 'j'));
            exception
               when too_many_rows then
                  d_result := 1;
               when others then
                  d_result := 0;
            end;
         else
            begin
               select 1
                 into d_result
                 from componenti       c
                     ,ruoli_componente r
                where c.ottica = d_ottica
                  and c.progr_unita_organizzativa = d_progr_unor
                  and c.ni = d_componente
                  and nvl(c.revisione_assegnazione, -2) != d_revisione
                  and d_data between c.dal and
                      nvl(decode(nvl(c.revisione_cessazione, -2)
                                ,d_revisione
                                ,to_date(null)
                                ,c.al)
                         ,to_date('3333333', 'j'))
                  and c.id_componente = r.id_componente
                  and d_data between r.dal and nvl(r.al, to_date('3333333', 'j'))
                  and r.ruolo = p_ruolo;
            exception
               when too_many_rows then
                  d_result := 1;
               when others then
                  d_result := 0;
            end;
         end if;
      else
         d_result := 0;
      end if;
      --
      return d_result;
   end; -- so4.util.exists_reference
   -------------------------------------------------------------------------------
   function ad4_utente_get_dati
   (
      p_utente     ad4_utenti.utente%type
     ,p_separatore varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        ad4_utente_get_dati
       DESCRIZIONE: Dato un utente di AD4, restituisce i dati anagrafici da
                    anagrafe_soggetti di AS4.
       PARAMETRI:   p_utente       Codice utente di AD4
                    p_separatore   Carattere utilizzato come separatore dei dati
                                   nella stringa di output
       RITORNA:     varchar2       Stringa contenente i dati anagrafici
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0     04/01/2013  VD      Prima emissione.
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
               and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
         exception
            when no_data_found then
               d_result := '*Utente non presente in anagrafe soggetti';
            when others then
               d_result := '*Errore in lettura anagrafe soggetti - ' || sqlerrm;
         end;
      end if;
      --
      return d_result;
   end; -- so4_skema.AD4_utente_get_dati
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
       DESCRIZIONE: Dato il codice di un utente, individua l'ni del componente
                    collegato e restituisce l'elenco (codice-descrizione) delle
                    unita a cui appartiene.
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
                    p_tipo_assegnazione  I - Istituzionale, F - Funzionale; se non indicato
                                         si considerano tutti i tipi di assegnazione
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     04/01/2013  VD        Prima emissione.
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
      end if;
      --
      return d_result;
      --
   end; -- so4_skema.AD4_utente_get_unita
   -------------------------------------------------------------------------------
   function ad4_get_progr_unor
   (
      p_utente anagrafe_unita_organizzative.utente_ad4%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
      NOME:        AD4_get_progr_unor
      DESCRIZIONE: Restituisce il progressivo dell'unità organizzativa associata ad
                   un utente AD4 (di tipo "O")
      PARAMETRI:   p_utente                Utente da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
      RITORNA:     progr_unita_organizzativa    progr. unità associato all'utente
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/01/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := set_data_default(p_data);
      begin
         select min(progr_unita_organizzativa)
           into d_result
           from anagrafe_unita_organizzative
          where utente_ad4 = p_utente
            and d_data between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'L''utente non e'' associato a nessuna unita'' organizzativa');
         when others then
            raise_application_error(-20999
                                   ,'Errore in ricerca unita'' organizzativa - ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
   end; -- so4_skema.AD4_get_progr_unor
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
                    dei componenti dell'unita. Se viene specificato il ruolo,
                    l'elenco comprendera' solo i componenti con il ruolo indicato.
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
       0     04/01/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    componenti.ottica%type;
      d_data      componenti.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      if p_ruolo is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from componenti c
             where c.progr_unita_organizzativa = p_progr_uo
               and c.ottica = d_ottica
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and
                   nvl(decode(nvl(c.revisione_cessazione, -2)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,to_date('3333333', 'j'))
             order by 2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
              from componenti       c
                  ,ruoli_componente r
             where c.progr_unita_organizzativa = p_progr_uo
               and c.ottica = d_ottica
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and
                   nvl(decode(nvl(c.revisione_cessazione, -2)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,to_date('3333333', 'j'))
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, to_date('3333333', 'j'))
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end; -- so4_skema.unita_get_componenti
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
                    p_ruolo              ruolo da trattare
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
       0     04/01/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    componenti.ottica%type;
      d_data      componenti.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      -- Si valorizza il ref cursor con il risultato della select
      --
      open d_result for
         select distinct ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from componenti       c
               ,ruoli_componente r
          where c.progr_unita_organizzativa = p_progr_unor
            and c.ottica = d_ottica
            and c.revisione_assegnazione != d_revisione
            and d_data between c.dal and
                nvl(decode(nvl(c.revisione_cessazione, -2)
                          ,d_revisione
                          ,to_date(null)
                          ,c.al)
                   ,to_date(3333333, 'j'))
            and c.id_componente = r.id_componente
            and r.ruolo != p_ruolo
            and d_data between r.dal and nvl(r.al, to_date(3333333, 'j'))
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_skema.unita_get_componenti_nruolo
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
       DESCRIZIONE: Dato il progressivo di un'unita' restituisce l'elenco
                    (progressivo, codice e descrizione) delle unita' figlie
       PARAMETRI:   p_progr           progressivo dell'unita organizzativa
                          p_ottica             ottica da trattare (facoltativa - se assente si
                                               assume l'ottica istituzionale)
                          p_data               data di confronto (facoltativa - se assente si
                                               assume la data di sistema)
                          p_amministrazione    amministrazione di ricerca nella struttura
                                               (facoltativa - alternativa all'ottica per la
                                               definizione dell'ottica istituzionale
       RITORNA:     AFC.t_ref_cursor  Ref_cursor contenente le righe con progressivo,
                                      codice unita, descrizione e date di validita'
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0     04/01/2013  VD      Prima emissione.
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
           from vista_unita_organizzative v
          where v.ottica = d_ottica
            and v.progr_unita_padre = p_progr
            and d_data between v.dal and nvl(v.al, to_date(3333333, 'j'))
            and p_progr is not null
         union
         select v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
           from vista_unita_organizzative v
          where v.ottica = d_ottica
            and d_data between v.dal and nvl(v.al, to_date(3333333, 'j'))
            and p_progr is null
          order by 2
                  ,3;
      --
      return d_result;
      --
   end; -- so4_skema.unita_get_unita_figlie
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
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
      d_data   date;
   begin
      d_data := set_data_default(p_data);
      begin
         select codice_uo
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unor
            and revisione_istituzione != revisione_struttura.get_revisione_mod(ottica)
            and d_data between dal and nvl(decode(revisione_cessazione
                                                 ,revisione_struttura.get_revisione_mod(ottica)
                                                 ,to_date(null)
                                                 ,al)
                                          ,s_data_limite);
      exception
         when others then
            d_result := null;
      end;
      --
      if d_result is null then
         begin
            select a.codice_uo
              into d_result
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = p_progr_unor
               and a.revisione_istituzione !=
                   revisione_struttura.get_revisione_mod(ottica)
               and a.dal = (select max(b.dal)
                              from anagrafe_unita_organizzative b
                             where b.progr_unita_organizzativa = p_progr_unor
                               and b.revisione_istituzione !=
                                   revisione_struttura.get_revisione_mod(ottica));
         exception
            when others then
               d_result := rpad('*', 16, '*');
         end;
      end if;
      --
      return d_result;
      --
   end; -- so4_skema.unita_get_codice_valido
   -------------------------------------------------------------------------------
   function unita_get_progressivo --#744
   (
      p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type
     ,p_dal             in anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
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
       0     30/11/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin

      d_result := anagrafe_unita_organizzativa.get_progr_unor(p_amministrazione => p_amministrazione
                                                             ,p_codice_uo       => p_codice_uo
                                                             ,p_data            => p_dal);
      --
      return d_result;
   end; -- so4_skema.unita_get_descrizione

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
       0     30/11/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result     anagrafe_unita_organizzative.descrizione%type;
      d_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_progr_unor := anagrafe_unita_organizzativa.get_progr_unor(p_amministrazione => p_amministrazione
                                                                 ,p_codice_uo       => p_codice_uo
                                                                 ,p_data            => p_dal);
      d_result     := anagrafe_unita_organizzativa.get_descrizione(d_progr_unor, p_dal);
      --
      return d_result;
   end; -- so4_skema.unita_get_descrizione
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
       0     04/01/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
   begin
      begin
         select a.descrizione
           into d_result
           from anagrafe_unita_organizzative a
          where a.progr_unita_organizzativa = p_progr_unor
            and nvl(a.revisione_istituzione, -2) !=
                revisione_struttura.get_revisione_mod(ottica)
            and a.dal = (select max(b.dal)
                           from anagrafe_unita_organizzative b
                          where b.progr_unita_organizzativa = p_progr_unor
                            and nvl(b.revisione_istituzione, -2) !=
                                revisione_struttura.get_revisione_mod(ottica));
      exception
         when others then
            d_result := 'Unita'' organizzativa non codificata';
      end;
      --
      return d_result;
   end; -- so4_skema.unita_get_ultima_descrizione
   -------------------------------------------------------------------------------
   function unita_get_ultima_descrizione(p_codice_uo in anagrafe_unita_organizzative.codice_uo%type)
      return anagrafe_unita_organizzative.descrizione%type is
      /******************************************************************************
       NOME:        unita_get_ultima_descrizione
       DESCRIZIONE: Dato il codice di una U.O., restituisce l'ultima descrizione in
                    ordine di data validita'
       ATTENZIONE! Questa funzione potrebbe restituire dati errati se lo stesso
                   codice viene usato in amministrazioni / ottiche diverse.
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
           from anagrafe_unita_organizzative a
          where a.codice_uo = p_codice_uo
            and nvl(a.revisione_istituzione, -2) !=
                revisione_struttura.get_revisione_mod(ottica)
            and a.dal = (select max(b.dal)
                           from anagrafe_unita_organizzative b
                          where b.codice_uo = p_codice_uo
                            and nvl(b.revisione_istituzione, -2) !=
                                revisione_struttura.get_revisione_mod(ottica));
      exception
         when others then
            d_result := 'Unita'' organizzativa non codificata';
      end;
      --
      return d_result;
      --
   end; -- so4_skema.unita_get_ultima_descrizione
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
      000   04/01/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
      d_data   date;
   begin
      d_data := set_data_default(p_data);
      begin
         select descrizione
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unor
            and revisione_istituzione != revisione_struttura.get_revisione_mod(ottica)
            and d_data between dal and nvl(decode(revisione_cessazione
                                                 ,revisione_struttura.get_revisione_mod(ottica)
                                                 ,to_date(null)
                                                 ,al)
                                          ,to_date(3333333, 'j'));
      exception
         when others then
            d_result := null;
      end;
      --
      if d_result is null then
         begin
            select a.descrizione
              into d_result
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = p_progr_unor
               and a.revisione_istituzione !=
                   revisione_struttura.get_revisione_mod(ottica)
               and a.dal = (select max(b.dal)
                              from anagrafe_unita_organizzative b
                             where b.progr_unita_organizzativa = p_progr_unor
                               and b.revisione_istituzione !=
                                   revisione_struttura.get_revisione_mod(ottica));
         exception
            when others then
               d_result := rpad('*', 120, '*');
         end;
      end if;
      --
      return d_result;
   end; -- so4_skema.unita_get_descr_valida
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
                   (progressivo, codice, descrizione, dal e al) delle unita ascendenti.
      PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                Ottica di riferimento
      RITORNA:     Afc.t_ref_cursor        Cursore contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/01/2013  VD        Prima emissione.
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
         select /*+ first_rows */
          progr_unita_organizzativa
         ,anagrafe_unita_organizzativa.get_codice_uo(progr_unita_organizzativa, d_data)
         ,anagrafe_unita_organizzativa.get_descrizione(progr_unita_organizzativa, d_data)
         ,dal
         ,al
           from unita_organizzative
          where ottica = d_ottica
            and revisione != d_revisione
            and d_data between dal and
                nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                   ,s_data_limite)
         --            and progr_unita_organizzativa != p_progr_unor
         connect by prior id_unita_padre = progr_unita_organizzativa
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and progr_unita_organizzativa = p_progr_unor
                 and revisione != d_revisione
                 and d_data between dal and
                     nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                        ,s_data_limite);
      --
      return d_result;
   end; -- so4_skema.get_ascendenti
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
       000   05/03/2014  VD      Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    ottiche.ottica%type;
      d_data      ruoli_componente.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      open d_result for
         select distinct ni
                        ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
           from componenti       c
               ,ruoli_componente r
          where c.ottica = d_ottica
            and nvl(c.revisione_assegnazione, -2) != d_revisione
            and d_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                   ,d_revisione
                                                   ,to_date(null)
                                                   ,c.al)
                                            ,s_data_limite)
            and c.id_componente = r.id_componente
            and r.ruolo = p_ruolo
            and d_data between r.dal and nvl(r.al, s_data_limite)
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_skema.ruolo_get_componenti
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
                    p_progr_unor      facoltativa - se non indicata si trattano tutte
                                      le unita' organizzative
       RITORNA:     AFC.t_ref_cursor Stringa contenente ni / cognome e nome / id_componente
                                     dei componenti aventi il ruolo indicato
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   04/01/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    ottiche.ottica%type;
      d_data      ruoli_componente.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      if p_progr_unor is null then
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,c.id_componente
              from componenti       c
                  ,ruoli_componente r
             where c.ottica = d_ottica
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and
                   nvl(decode(nvl(c.revisione_cessazione, -2)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,to_date(3333333, 'j'))
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, to_date(3333333, 'j'))
             order by 2
                     ,1;
      else
         open d_result for
            select ni
                  ,soggetti_get_descr(ni, d_data, 'COGNOME E NOME') descrizione
                  ,c.id_componente
              from componenti       c
                  ,ruoli_componente r
             where c.ottica = d_ottica
               and c.progr_unita_organizzativa = p_progr_unor
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and
                   nvl(decode(nvl(c.revisione_cessazione, -2)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,to_date(3333333, 'j'))
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, to_date(3333333, 'j'))
             order by 2
                     ,1;
      end if;
      --
      return d_result;
   end; -- so4_skema.ruolo_get_componenti_id
   -------------------------------------------------------------------------------
   function comp_get_utente(p_ni componenti.ni%type) return varchar2 is
      /******************************************************************************
       NOME:        comp_get_utente.
       DESCRIZIONE: Dato l'ni di un componente, restituisce il codice utente corrispondente
       PARAMETRI:   p_ni               ni del componente
       RITORNA:     VARCHAR2  codice utente corrispondente
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0     04/01/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result ad4_utenti.utente%type;
   begin
      begin
         select s.utente
           into d_result
           from ad4_utenti_soggetti s
               ,ad4_utenti          u
          where s.soggetto = p_ni
            and s.utente = u.utente
            and u.stato not in ('S', 'R');
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
   end; -- so4_util.comp_get_utente
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
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica istituzionale)
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
                    p_se_progr_unita     se valorizzato a SI, il ref_cursor in uscita
                                         contiene anche il progressivo dell'unità
                                         organizzativa
                    p_tipo_assegnazione  I - Istituzionale, F - Funzionale; se non indicato
                                         si considerano tutti i tipi di assegnazione
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e' presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     04/01/2013  VD        Prima emissione.
       1     15/04/2013  VD        Tolta gestione parametro p_se_progr_unita: da SKEMA
                                   viene sempre richiamata con parametro = 'SI'
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    componenti.ottica%type;
      d_data      componenti.dal%type;
      d_revisione anagrafe_unita_organizzative.revisione_istituzione%type;
   begin
      --
      -- Se valorizzano i parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      open d_result for
         select distinct c.progr_unita_organizzativa
                        ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                                   ,d_data)
                        ,anagrafe_unita_organizzativa.get_descrizione(c.progr_unita_organizzativa
                                                                     ,d_data)
           from componenti           c
               ,attributi_componente a
               ,ruoli_componente     r
          where c.ottica = d_ottica
            and c.ni = p_ni
            and nvl(c.revisione_assegnazione, -2) != d_revisione
            and d_data between c.dal and
                nvl(decode(nvl(c.revisione_cessazione, -2)
                          ,d_revisione
                          ,to_date(null)
                          ,c.al)
                   ,to_date('3333333', 'j'))
            and c.id_componente = a.id_componente
            and nvl(a.revisione_assegnazione, -2) != d_revisione
            and d_data between a.dal and
                nvl(decode(nvl(a.revisione_cessazione, -2)
                          ,d_revisione
                          ,to_date(null)
                          ,a.al)
                   ,to_date('3333333', 'j'))
            and nvl(a.tipo_assegnazione, 'I') =
                nvl(p_tipo_assegnazione, nvl(a.tipo_assegnazione, 'I'))
            and c.id_componente = r.id_componente(+)
            and nvl(r.ruolo, '*') = nvl(p_ruolo, nvl(r.ruolo, '*'))
            and d_data between nvl(r.dal(+), d_data) and
                nvl(r.al(+), to_date('3333333', 'j'))
          order by 2
                  ,1;
      --
      return d_result;
      --
   end; -- so4_util.comp_get_unita
   -------------------------------------------------------------------------------
   function get_revisione_data
   (
      p_ottica ottiche.ottica%type
     ,p_data   revisioni_struttura.dal%type
   ) return revisioni_struttura.revisione%type is
      /******************************************************************************
       NOME:        get_revisione_data.
       DESCRIZIONE: Data un'ottica e una data, determina la revisione valida alla
                    data indicata
       PARAMETRI:   p_ottica             ottica di riferimento
                    p_data               data di riferimento
       RITORNA:     revisioni_struttura.revisione     Numero revisione valida
                                                      alla data indicata
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     14/01/2014  VD        Prima emissione.
      ******************************************************************************/
      d_result revisioni_struttura.revisione%type;
   begin
      --
      -- Determinazione della revisione di riferimento
      --
      select max(r1.revisione)
        into d_result
        from revisioni_struttura r1
       where r1.ottica = p_ottica
         and r1.stato = 'A'
         and r1.dal = (select max(r2.dal)
                         from revisioni_struttura r2
                        where r2.ottica = p_ottica
                          and r2.stato = 'A'
                          and r2.dal <= p_data);
      --
      return d_result;
      --
   end; -- so4_skema.get_revisione_data
   -------------------------------------------------------------------------------
   /*   function get_valutatori
   (
      p_id_componente componenti.id_componente%type
     ,p_ottica        componenti.ottica%type
     ,p_progr_unor    componenti.progr_unita_organizzativa%type
     ,p_data          componenti.dal%type
     ,p_ruolo_val     ruoli_componente.ruolo%type
   ) return afc.t_ref_cursor%type is
      /******************************************************************************
       NOME:        get_valutatori.
       DESCRIZIONE: Dato l'id di un componente, restituisce l'elenco dei valutatori
                    nel periodo indicato
       PARAMETRI:   p_id_componente      id del componente di cui si cerca il valutatore
                    p_data_dal           data di inizio periodo da ricercare
                    p_data_al            data di fine periodo da ricercare
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e' presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     03/01/2014  VD        Prima emissione.
      ******************************************************************************/
   /*      d_result            componenti.ni%type;
      d_ni_val            componenti.ni%type;
      d_id_componente_val componenti.id_componente%type;
      d_valutatore        afc.t_ref_cursor;
      d_desc_sogg_cur     varchar2(280);
      d_unita_ascendenti  afc.t_ref_cursor;
      d_progr_uo_asc      componenti.progr_unita_organizzativa%type;
      d_codice_uo_asc     anagrafe_unita_organizzative.codice_uo%type;
      d_desc_uo_asc       anagrafe_unita_organizzative.descrizione%type;
      d_dal_uo_asc        date;
      d_al_uo_asc         date;
   begin
      d_unita_ascendenti := so4_util.get_ascendenti(p_progr_unor => p_progr_unor
                                                   ,p_data       => p_data
                                                   ,p_ottica     => p_ottica);
      if d_unita_ascendenti%isopen then
         fetch d_unita_ascendenti
            into d_progr_uo_asc
                ,d_codice_uo_asc
                ,d_desc_uo_asc
                ,d_dal_uo_asc
                ,d_al_uo_asc;
         while d_unita_ascendenti%found
         loop
            d_valutatore := so4_skema.ruolo_get_componenti_id(p_progr_unor      => d_progr_uo_asc
                                                             ,p_ruolo           => p_ruolo_val
                                                             ,p_ottica          => p_ottica
                                                             ,p_data            => p_data
                                                             ,p_amministrazione => '');
            if d_valutatore%isopen then
               fetch d_valutatore
                  into d_ni_val
                      ,d_desc_sogg_cur
                      ,d_id_componente_val;
               if d_valutatore%found and d_id_componente_val != p_id_componente then
                  d_result := d_ni_val;
                  close d_valutatore;
                  return d_result;
               end if;
               close d_valutatore;
            end if;
            fetch d_unita_ascendenti
               into d_progr_uo_asc
                   ,d_codice_uo_asc
                   ,d_desc_uo_asc
                   ,d_dal_uo_asc
                   ,d_al_uo_asc;
         end loop;
         close d_unita_ascendenti;
      end if;
      d_result := to_number(null);
      --
      return d_result;
      --
   end; --so4_skema.get_valutatori*/
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
      000   05/03/2014  VD        Prima emissione
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione unita_organizzative.revisione%type;
      d_ottica    anagrafe_unita_organizzative.ottica%type;
   begin
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(p_ottica => d_ottica);
      open d_result for
         select distinct ni
                        ,nominativo descrizione
           from vista_componenti c
          where c.ottica = d_ottica
            and nvl(c.revisione_assegnazione, -2) != d_revisione
            and d_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                   ,d_revisione
                                                   ,to_date(null)
                                                   ,c.al)
                                            ,s_data_limite)
          order by 2
                  ,1;
      return d_result;
   end; -- get_all_componenti_ni
   -------------------------------------------------------------------------------
   function ruolo_get_all_periodi
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data_dal        ruoli_componente.dal%type
     ,p_data_al         ruoli_componente.al%type
     ,p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_ruolo_val       ruoli_componente.ruolo%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ruolo_get_all_periodi.
       DESCRIZIONE: Dato un ruolo, un periodo e ottica e/o amministrazione, restituisce
                    l'elenco dei componenti con quel ruolo e il relativo valutatore.
       PARAMETRI:   p_ruolo              ruolo da ricercare
                    p_data_dal           data di inizio periodo da ricercare
                    p_data_al            data di fine periodo da ricercare
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica istituzionale
                                         dell'amministrazione indicata)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
                    p_ruolo_valutatore   ruolo che identifica il valutatore
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e' presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     03/01/2014  VD        Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    ottiche.ottica%type;
      d_revisione revisioni_struttura.revisione%type;
      d_min_data  date;
      d_max_data  date;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_revisione := get_revisione_data(d_ottica, p_data_al);
      delete from temp_skema_val;
      --
      -- Si selezionano i componenti da valutare con i relativi periodi
      -- di assegnazione
      --
      if d_revisione is not null then

         for da_val in (select r.ni
                              ,r.nominativo
                              ,r.id_componente
                              ,r.progr_unita_organizzativa progr_unor
                              ,anagrafe_unita_organizzativa.get_codice_uo(r.progr_unita_organizzativa
                                                                         ,nvl(r.al
                                                                             ,trunc(sysdate))) codice_uo
                              ,anagrafe_unita_organizzativa.get_descrizione(r.progr_unita_organizzativa
                                                                           ,nvl(r.al
                                                                               ,trunc(sysdate))) descrizione
                              ,r.dal
                              ,nvl(r.al, to_date(3333333, 'j')) al
                          from vista_ruoli_componente r
                         where r.ottica = d_ottica
                           and r.ruolo = p_ruolo
                           and r.dal <= p_data_al
                           and nvl(r.al, to_date(3333333, 'j')) >= p_data_dal
                         order by r.ni)
         loop
            --
            -- per ogni unità selezionata si ricercano i valutatori per i vari
            -- periodi di validità
            --
            for unor in (select progr_padre
                               ,get_livello_rs(da_val.progr_unor, d_ottica, al_figlio) livello
                               ,cod_padre
                               ,descr_padre
                               ,get_livello_rs(progr_padre, d_ottica, al_figlio) val_livello
                           from relazioni_struttura
                          where ottica = d_ottica
                            and revisione = d_revisione
                            and progr_figlio = da_val.progr_unor
                            and dal_figlio <= p_data_al
                            and al_figlio >= p_data_dal
                          order by liv_figlio)
            loop
               insert into temp_skema_val
                  (ni
                  ,nominativo
                  ,id_componente
                  ,progr_unor
                  ,codice_uo
                  ,descrizione
                  ,dal
                  ,al
                  ,val_ni
                  ,val_nominativo
                  ,val_dal
                  ,val_al
                  ,val_codice_uo
                  ,val_descrizione
                  ,val_livello)
                  select da_val.ni
                        ,da_val.nominativo
                        ,da_val.id_componente
                        ,da_val.progr_unor
                        ,da_val.codice_uo
                        ,da_val.descrizione
                        ,da_val.dal
                        ,da_val.al
                        ,ni
                        ,nominativo
                        ,dal
                        ,al
                        ,unor.cod_padre
                        ,unor.descr_padre
                        ,unor.livello - unor.val_livello
                    from vista_ruoli_componente
                        ,dual
                   where ottica = d_ottica
                     and progr_unita_organizzativa = unor.progr_padre
                     and ruolo = p_ruolo_val
                     and ni != da_val.ni
                     and dal <= da_val.al
                     and nvl(al, to_date(3333333, 'j')) >= da_val.dal
                  union --#744
                  select da_val.ni
                        ,da_val.nominativo
                        ,da_val.id_componente
                        ,da_val.progr_unor
                        ,da_val.codice_uo
                        ,da_val.descrizione
                        ,da_val.dal
                        ,da_val.al
                        ,ni
                        ,nominativo
                        ,dal
                        ,al
                        ,unor.cod_padre
                        ,unor.descr_padre
                        ,unor.livello - unor.val_livello
                    from vista_ruoli_componente
                        ,dual
                   where ottica = d_ottica
                     and progr_unita_organizzativa = unor.progr_padre
                     and ruolo = p_ruolo_val
                     and ni != da_val.ni
                     and dal <= da_val.al
                     and nvl(al, to_date(3333333, 'j')) >= da_val.dal
                     and not exists
                   (select 'x' from vista_ruoli_componente where ruolo = p_ruolo_val);

               -- Se i valutatori selezionati coprono tutto il periodo richiesto si esce dal ciclo,
               -- altrimenti si prosegue la ricerca sulle unità ascendenti
               --
               select min(dal)
                     ,max(nvl(al, to_date(3333333, 'j')))
                 into d_min_data
                     ,d_max_data
                 from vista_ruoli_componente
                where ottica = d_ottica
                  and progr_unita_organizzativa = unor.progr_padre
                  and ruolo = p_ruolo_val
                  and ni != da_val.ni
                  and dal <= p_data_al
                  and nvl(al, to_date(3333333, 'j')) >= p_data_dal;

               if d_min_data <= p_data_dal and d_max_data >= p_data_al then
                  exit;
               end if;
            end loop;
         end loop;
         open d_result for
            select ni
                  ,nominativo
                  ,id_componente
                  ,progr_unor
                  ,codice_uo
                  ,descrizione
                  ,dal
                  ,al
                  ,val_ni
                  ,val_nominativo
                  ,val_dal
                  ,val_al
                  ,val_codice_uo
                  ,val_descrizione
                  ,val_livello
              from temp_skema_val
             order by val_livello
                     ,nominativo;
      else
         open d_result for
            select to_number(null)
                  ,null
                  ,to_number(null)
                  ,to_number(null)
                  ,null
                  ,null
                  ,to_date(null)
                  ,to_date(null)
                  ,to_number(null)
                  ,null
                  ,to_date(null)
                  ,to_date(null)
                  ,null
                  ,null
                  ,null
              from dual;
      end if;
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   function get_codice_uo_ni --#744
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data_dal        ruoli_componente.dal%type
     ,p_data_al         ruoli_componente.al%type
     ,p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_ruolo_val       ruoli_componente.ruolo%type
     ,p_ni              anagrafe_soggetti.ni%type
   ) return varchar2 is
      /******************************************************************************
       NOME:        ruolo_get_all_periodi.
       DESCRIZIONE: Dato un ruolo, un periodo e ottica e/o amministrazione, restituisce
                    l'elenco dei componenti con quel ruolo e il relativo valutatore.
       PARAMETRI:   p_ruolo              ruolo da ricercare
                    p_data_dal           data di inizio periodo da ricercare
                    p_data_al            data di fine periodo da ricercare
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica istituzionale
                                         dell'amministrazione indicata)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
                    p_ruolo_valutatore   ruolo che identifica il valutatore
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e' presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     03/01/2014  VD        Prima emissione.
      ******************************************************************************/
      d_ottica    ottiche.ottica%type;
      d_revisione revisioni_struttura.revisione%type;
      d_codice_uo anagrafe_unita_organizzative.codice_uo%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_revisione := get_revisione_data(d_ottica, p_data_al);

      --
      -- Si selezionano i componenti da valutare con i relativi periodi
      -- di assegnazione
      --
      if d_revisione is not null then
         begin
            select anagrafe_unita_organizzativa.get_descrizione(r.progr_unita_organizzativa
                                                               ,nvl(r.al, trunc(sysdate))) descrizione
              into d_codice_uo
              from vista_ruoli_componente r
             where r.ottica = d_ottica
               and r.ruolo = p_ruolo
               and p_data_al between r.dal and nvl(r.al, to_date(3333333, 'j'))
                  --              and r.dal <= p_data_al
                  --              and nvl(r.al, to_date(3333333, 'j')) >= p_data_dal
               and r.ni = p_ni;
         exception
            when no_data_found then
               d_codice_uo := null;
         end;
      else
         d_codice_uo := null;
      end if;
      --
      return d_codice_uo;
      --
   end;
   -------------------------------------------------------------------------------
   function get_progressivo_uo_ni --#744
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data_dal        ruoli_componente.dal%type
     ,p_data_al         ruoli_componente.al%type
     ,p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_ruolo_val       ruoli_componente.ruolo%type
     ,p_ni              anagrafe_soggetti.ni%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        ruolo_get_all_periodi.
       DESCRIZIONE: Dato un ruolo, un periodo e ottica e/o amministrazione, restituisce
                    l'elenco dei componenti con quel ruolo e il relativo valutatore.
       PARAMETRI:   p_ruolo              ruolo da ricercare
                    p_data_dal           data di inizio periodo da ricercare
                    p_data_al            data di fine periodo da ricercare
                    p_ottica             ottica di ricerca nella struttura (facoltativo -
                                         se non specificata si considera l'ottica istituzionale
                                         dell'amministrazione indicata)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale)
                    p_ruolo_valutatore   ruolo che identifica il valutatore
       RITORNA:     AFC.t_ref_cursor     Ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e' presente il
                                         componente
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       0     03/01/2014  VD        Prima emissione.
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica ottiche.ottica%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);

      --
      -- Si selezionano i componenti da valutare con i relativi periodi
      -- di assegnazione
      --
      --      dbms_output.put_line('SO4.....d_ottica '||d_ottica||' p_ruolo '||p_ruolo||' p_ruolo_val '||p_ruolo_val);
      open d_result for
         select r.progr_unita_organizzativa
               ,unita_get_codice_valido(r.progr_unita_organizzativa) codice_uo
               ,unita_get_descr_valida(r.progr_unita_organizzativa) descrizione_uo
           from vista_ruoli_componente r
          where r.ottica = d_ottica
            and r.ruolo = p_ruolo_val
            and nvl(p_data_al, to_date(3333333, 'j')) between r.dal and
                nvl(r.al, to_date(3333333, 'j'))
               --              and r.dal <= p_data_al
               --              and nvl(r.al, to_date(3333333, 'j')) >= p_data_dal
            and r.ni = p_ni;
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   function get_discendenti --#744
   (
      p_tipo        varchar2
     ,p_ni_padre    anagrafe_soggetti.ni%type
     ,p_ruolo_padre ruoli_componente.ruolo%type
     ,p_data        unita_organizzative.dal%type default null
     ,p_ottica      unita_organizzative.ottica%type default null
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
      002   12/09/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                  del cursore
      003   24/10/2016  ML        Modificata lettura per utilizzo vista_discendenti
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica);
      d_data   := set_data_default(p_data);

      open d_result for
         select distinct decode(p_tipo, 'U', codice_uo, ni)
           from vista_discendenti
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
            and ni_padre = p_ni_padre
            and ruolo_padre = p_ruolo_padre
            and ni != p_ni_padre;
      return d_result;
   end; -- so4_util.get_discendenti
   -------------------------------------------------------------------------------
   function comp_get_ni_ruolo_asc --#744
   (
      p_ni     in componenti.ni%type
     ,p_ruolo  ruoli_componente.ruolo%type
     ,p_ottica componenti.ottica%type
     ,p_data   in date default null
   ) return number is
      d_progr_unita_organizzativa componenti.progr_unita_organizzativa%type;
      d_ni                        componenti.ni%type;
      d_data                      componenti.dal%type := so4_skema.set_data_default(p_data);
   begin
      -- determina l'UO di assegnazione istituzionale; se assente o non univoca si riporta null
      begin
         select progr_unita_organizzativa
           into d_progr_unita_organizzativa
           from vista_componenti c
          where ottica = p_ottica
            and ni = p_ni
            and d_data between dal and nvl(al, to_date(3333333, 'j'))
            and tipo_assegnazione = 'I'
            and assegnazione_prevalente like '1%';
      exception
         when others then
            d_progr_unita_organizzativa := null;
            d_ni                        := to_number(null);
      end;
      --esploriamo la catena degli ascendenti
      if d_progr_unita_organizzativa is not null then
         for unor in (select progr_unita_organizzativa
                        from vista_unita_organizzative u
                       where ottica = p_ottica
                         and d_data between dal and nvl(al, to_date(3333333, 'j'))
                      connect by prior u.progr_unita_padre = progr_unita_organizzativa
                             and ottica = p_ottica
                             and d_data between dal and nvl(al, to_date(3333333, 'j'))
                       start with ottica = p_ottica
                              and progr_unita_organizzativa = d_progr_unita_organizzativa
                              and d_data between dal and nvl(al, to_date(3333333, 'j')))
         loop
            select min(ni)
              into d_ni
              from vista_ruoli_componente c
             where ottica = p_ottica
               and progr_unita_organizzativa = unor.progr_unita_organizzativa
               and ruolo = p_ruolo
               and d_data between dal and nvl(al, to_date(3333333, 'j'));
            if d_ni is not null then
               return d_ni;
            end if;
         end loop;
      end if;
      return d_ni;
   end comp_get_ni_ruolo_asc;
   -------------------------------------------------------------------------------
   function get_ascendenti_suddivisione
   (
      p_progr_unor   unita_organizzative.progr_unita_organizzativa%type
     ,p_suddivisione suddivisioni_struttura.suddivisione%type default null
     ,p_ordinamento  suddivisioni_struttura.ordinamento%type default null
     ,p_data         unita_organizzative.dal%type default null
     ,p_ottica       unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_ascendenti_suddivisione
      DESCRIZIONE: Dato il progressivo di un'unita restituisce Il dato richiesto
                   ( progr_unita_organizzativa , codice , descrizione ) dell' unita ascendente della suddivisione
                   richiesta.
      PARAMETRI:   p_progr_unor            Unit''rganizzativa da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                Ottica di riferimento
      RITORNA:     Afc.t_ref_cursor        Cursore contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   12/01/2017  VD        Prima emissione.
      001   06/10/2017  MM        Trasformazione #789
      ******************************************************************************/
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione revisioni_struttura.revisione%type;
      d_errore    varchar2(2000);
      d_result    afc.t_ref_cursor;
   begin
      d_ottica    := set_ottica_default(p_ottica);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
      --
      begin
         if (p_suddivisione is null and p_ordinamento is null) or
            (p_suddivisione is not null and p_ordinamento is not null) then
            open d_result for
               select -1
                     ,'Errore'
                     ,'Parametri errati: are you kidding me ?'
                 from dual;
         else
            open d_result for
               select unor.progr_unita_organizzativa
                     ,a.codice_uo
                     ,a.descrizione
                 from (select progr_unita_organizzativa
                             ,dal
                             ,al
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
                               and revisione != d_revisione
                               and d_data between dal and
                                   nvl(decode(revisione_cessazione
                                             ,d_revisione
                                             ,to_date(null)
                                             ,al)
                                      ,s_data_limite)) unor
                     ,anagrafe_unita_organizzative a
                     ,suddivisioni_struttura s
                where a.progr_unita_organizzativa = unor.progr_unita_organizzativa
                  and d_data between a.dal and
                      nvl(decode(a.revisione_cessazione, d_revisione, to_date(null), a.al)
                         ,to_date('3333333', 'j'))
                  and a.ottica = d_ottica
                  and a.id_suddivisione = s.id_suddivisione
                  and ((p_suddivisione is not null and s.suddivisione = p_suddivisione) or
                      (p_ordinamento is not null and
                      s.ordinamento =
                      (select max(s.ordinamento)
                           from (select progr_unita_organizzativa
                                       ,dal
                                       ,al
                                   from unita_organizzative
                                  where ottica = d_ottica
                                    and revisione != d_revisione
                                       --   and sysdate between dal and
                                    and d_data between dal and
                                        nvl(decode(revisione_cessazione
                                                  ,d_revisione
                                                  ,to_date(null)
                                                  ,al)
                                           ,to_date(3333333, 'j'))
                                 connect by prior id_unita_padre = progr_unita_organizzativa
                                        and ottica = d_ottica
                                           --  and sysdate between dal and
                                        and d_data between dal and
                                            nvl(al, to_date(3333333, 'j'))
                                  start with ottica = d_ottica
                                         and progr_unita_organizzativa = p_progr_unor
                                         and revisione != d_revisione
                                            --   and sysdate between dal and
                                         and d_data between dal and
                                             nvl(decode(revisione_cessazione
                                                       ,d_revisione
                                                       ,to_date(null)
                                                       ,al)
                                                ,to_date(3333333, 'j'))) unor
                               ,anagrafe_unita_organizzative a
                               ,suddivisioni_struttura s
                          where a.progr_unita_organizzativa =
                                unor.progr_unita_organizzativa
                               --  and sysdate between a.dal and
                            and d_data between a.dal and
                                nvl(decode(a.revisione_cessazione
                                          ,d_revisione
                                          ,to_date(null)
                                          ,a.al)
                                   ,to_date('3333333', 'j'))
                            and a.ottica = d_ottica
                            and a.id_suddivisione = s.id_suddivisione
                               -- and sysdate between unor.dal and
                            and d_data between unor.dal and
                                nvl(unor.al, to_date(3333333, 'j'))
                            and (p_ordinamento is not null and
                                s.ordinamento <= p_ordinamento))));
         end if;
      exception
         when others then
            d_errore := sqlerrm;
            open d_result for
               select -2
                     ,'Errore'
                     ,d_errore
                 from dual;
      end;
      --
      return d_result;
   end; -- so4_skema.get_ascendenti_suddivisione
   -------------------------------------------------------------------------------
   function get_uo_discendenti --#744
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
       ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_ottica      anagrafe_unita_organizzative.ottica%type;
      d_data        anagrafe_unita_organizzative.dal%type;
      s_data_limite date := to_date(3333333, 'j');
   begin
      d_ottica := so4_skema.set_ottica_default(p_ottica);
      d_data   := so4_skema.set_data_default(p_data);
      open d_result for
         select progr_unita_organizzativa
               ,codice_uo
               ,descrizione descrizione_uo
               ,dal
               ,al
               ,u.progr_unita_padre
               ,level livello
               ,decode((select count(*)
                         from vista_unita_organizzative
                        where ottica = d_ottica
                          and d_data between dal and nvl(al, to_date(3333333, 'j'))
                          and progr_unita_padre = u.progr_unita_organizzativa)
                      ,0
                      ,1
                      ,0) foglia
           from vista_unita_organizzative u
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
         connect by prior progr_unita_organizzativa = u.progr_unita_padre
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and progr_unita_organizzativa = p_progr_unor
                 and d_data between dal and nvl(al, s_data_limite);
      --
      return d_result;
   end; -- so4_util.get_uo_discendenti

   -------------------------------------------------------------------------------

   function get_struttura --#35534
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_struttura
      DESCRIZIONE: Restituisce un cursore contenente la struttura completa delle unita per una
                   certa amministrazione/ottica alla data indicata.
                   I campi del cursore sono, nell'ordine:
                   level, progr_unita_organizzativa, codice_uo,descrizione,progr_padre, codice_uo_padre, icona
      PARAMETRI:   p_amministrazione         amministrazione di riferimento
                   p_ottica                  ottica di riferimento
                   p_data                    data di riferimento
      RITORNA:     Afc.t_ref_cursor          cursore contenente la gerarchia.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   18/06/2019  MM        #35534
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select level
               ,anagrafe_unita_organizzativa.get_codice_uo_corrente(progr_unita_organizzativa
                                                                   ,d_data) codice_uo
               ,anagrafe_unita_organizzativa.get_descrizione_corrente(progr_unita_organizzativa
                                                                     ,d_data) descrizione_uo
               ,id_unita_padre
               ,anagrafe_unita_organizzativa.get_codice_uo_corrente(id_unita_padre
                                                                   ,d_data) codice_uo_padre
               ,suddivisione_struttura.get_icona_standard(anagrafe_unita_organizzativa.get_id_suddivisione(progr_unita_organizzativa
                                                                                                          ,d_data)) icona
               ,u.progr_unita_organizzativa
           from unita_organizzative u
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
         connect by prior progr_unita_organizzativa = id_unita_padre
                and ottica = d_ottica
                and d_data between dal and nvl(al, s_data_limite)
          start with ottica = d_ottica
                 and id_unita_padre is null
                 and d_data between dal and nvl(al, s_data_limite);
      --
      return d_result;
   end; -- so4_util.get_struttura

   -------------------------------------------------------------------------------

   function get_componenti --#35534
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_progr_unor      unita_organizzative.progr_unita_organizzativa%type default null
     ,p_data            unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_componenti
      DESCRIZIONE: Restituisce un cursore contenente la i componenti dell'unita data alla data indicata.
                   e a livello successivo, i ruoli del componente
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   18/06/2019  MM        #35534
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select 1 livello
               ,c.nominativo
               ,c.dal
               ,c.al
               ,c.id_componente
               ,c.ni
           from vista_componenti c
          where progr_unita_organizzativa = nvl(p_progr_unor, progr_unita_organizzativa)
            and d_data between c.dal and nvl(c.al, to_date(3333333, 'j'))
            and ottica = d_ottica
         union
         select 2
               ,r.ruolo || ' : ' || r.des_ruolo ruolo
               ,r.dal
               ,r.al
               ,r.id_componente
               ,r.ni
           from vista_ruoli_componente r
               ,ad4_ruoli              a
          where progr_unita_organizzativa = nvl(p_progr_unor, progr_unita_organizzativa)
            and d_data between r.dal and nvl(r.al, to_date(3333333, 'j'))
            and ottica = d_ottica
            and a.ruolo = r.ruolo
            and a.progetto = 'GPSVP'
          order by 5
                  ,1;
      --
      return d_result;
   end; -- so4_util.get_componenti

   -------------------------------------------------------------------------------

   function rigenera_ruoli_skema
   (
      p_amministrazione in ottiche.amministrazione%type
     ,p_rilevanza       in varchar default 'S'
   ) return varchar2
   /******************************************************************************
        Function per il lancio da interfaccia flex della procedure omonima #785
      ******************************************************************************/
    is
      d_sessione               key_error_log.error_session%type;
      d_segnalazione_bloccante varchar2(2000);
      d_segnalazione           varchar2(2000);
   begin
      begin
         rigenera_ruoli_skema(p_amministrazione
                             ,p_rilevanza
                             ,d_sessione
                             ,d_segnalazione_bloccante
                             ,d_segnalazione);
      exception
         when others then
            return d_segnalazione;
      end;
      return d_segnalazione;
   end; --rigenera_ruoli_skema

   procedure rigenera_ruoli_skema
   (
      p_amministrazione        in ottiche.amministrazione%type
     ,p_rilevanza              in varchar default 'S'
     ,p_sessione               in out key_error_log.error_session%type
     ,p_segnalazione_bloccante in out varchar2
     ,p_segnalazione           in out varchar2
   ) is
      d_id ruoli_componente.id_ruolo_componente%type;
      --
      d_chiave_default       varchar2(200);
      d_chiave               varchar2(200);
      d_ruolo                ruoli_componente.ruolo%type;
      d_ref_cursor           afc.t_ref_cursor;
      d_attribuzioni         integer := 0;
      d_attribuzioni_default integer := 0;
      errore_bloccante exception;
   begin
      begin
         --determiniamo il numero della sessione
         select nvl(max(error_session), 0) + 1
           into p_sessione
           from key_error_log
          where error_user = 'R.Skema';

         --disabilita i trigger su RUOLI_COMPONENTE
         begin
            execute immediate 'alter table RUOLI_COMPONENTE disable all triggers';
         exception
            when others then
               p_segnalazione_bloccante := 'Y';
               p_segnalazione           := 'Errore in disabilitazione triggers RUOLI_COMPONENTE - ' ||
                                           sqlerrm;
               raise errore_bloccante;
         end;

         --determina la chiave della relazione di default
         d_chiave_default := '%%%%%%%%%%%%';

         for comp in (select id_componente
                            ,(select cognome || ' ' || nome
                                from anagrafe_soggetti
                               where ni = c.ni) nominativo
                            ,dal
                            ,al
                            ,ci
                            ,ni
                        from componenti c
                       where ottica = (select ottica
                                         from ottiche o
                                        where amministrazione = p_amministrazione
                                          and o.ottica_istituzionale = 'SI')
                         and ci is not null
                         and dal <= nvl(al, to_date(3333333, 'j'))
                         and exists (select 'x'
                                from attributi_componente
                               where id_componente = c.id_componente
                                 and assegnazione_prevalente like '1%'
                                 and tipo_assegnazione = 'I')
                       order by ci
                               ,id_componente)
         loop
            delete from ruoli_componente
             where id_componente = comp.id_componente
               and utente_aggiornamento = 'Aut.SK';

            d_ref_cursor := gps_so4.get_dati_per_ruolo(comp.ci
                                                      ,p_amministrazione
                                                      ,nvl(comp.al, to_date(3333333, 'j')));
            loop
               fetch d_ref_cursor
                  into d_ruolo
                      ,d_chiave;
               exit when d_ref_cursor%notfound;

               select ruoli_componente_sq.nextval into d_id from dual;

               begin
                  ruolo_componente.ins(p_id_ruolo_componente  => d_id
                                      ,p_id_componente        => comp.id_componente
                                      ,p_ruolo                => d_ruolo
                                      ,p_dal                  => comp.dal
                                      ,p_al                   => comp.al
                                      ,p_dal_pubb             => comp.dal
                                      ,p_al_pubb              => comp.al
                                      ,p_utente_aggiornamento => 'Aut.SK'
                                      ,p_data_aggiornamento   => trunc(sysdate));

                  d_attribuzioni := d_attribuzioni + 1;

                  if d_chiave = d_chiave_default then
                     d_attribuzioni_default := d_attribuzioni_default + 1;
                  end if;

                  p_segnalazione_bloccante := 'N';
                  p_segnalazione           := 'Nominativo : ' || comp.nominativo ||
                                              '; CI : ' || comp.ci || ' - Periodo: ' ||
                                              to_char(comp.dal, 'dd/mm/yyyy') || '-' ||
                                              to_char(comp.al, 'dd/mm/yyyy') ||
                                              ' - Profilo: ' || d_ruolo;
                  key_error_log_tpk.ins(p_error_session  => p_sessione
                                       ,p_error_date     => sysdate
                                       ,p_error_text     => 'Attribuzione Profilo Skema'
                                       ,p_error_user     => 'R.Skema'
                                       ,p_error_usertext => p_segnalazione
                                       ,p_error_type     => 'I');
               exception
                  when others then
                     rollback;
                     p_segnalazione_bloccante := 'Y';
                     p_segnalazione           := 'Nominativo : ' || comp.nominativo ||
                                                 '; CI : ' || comp.ci || ' - Periodo: ' ||
                                                 to_char(comp.dal, 'dd/mm/yyyy') || '-' ||
                                                 to_char(comp.al, 'dd/mm/yyyy') ||
                                                 ' - Ruolo: ' || d_ruolo || ' --- ' ||
                                                 sqlerrm;
                     key_error_log_tpk.ins(p_error_session  => p_sessione
                                          ,p_error_date     => sysdate
                                          ,p_error_text     => 'Errore durante la creazione del profilo'
                                          ,p_error_user     => 'R.Skema'
                                          ,p_error_usertext => p_segnalazione
                                          ,p_error_type     => 'E');
                     raise errore_bloccante;
               end;

            end loop;
         end loop;

         --abilita i trigger su RUOLI_COMPONENTE
         begin
            execute immediate 'alter table RUOLI_COMPONENTE enable all triggers';
         exception
            when others then
               p_segnalazione_bloccante := 'Y';
               p_segnalazione           := 'Errore in abilitazione triggers RUOLI_COMPONENTE - ' ||
                                           sqlerrm;
               raise errore_bloccante;
         end;

         --composizione della segnalazione di fine elaborazione
         p_segnalazione_bloccante := 'N';

         if d_attribuzioni_default <> 0 then
            p_segnalazione := 'Elaborazione terminata. Attribuiti n.' || d_attribuzioni ||
                              ' profili di cui n.' || d_attribuzioni_default ||
                              ' profili generici. ' || '(Sessione: ' || p_sessione || ')';
         else
            p_segnalazione := 'Elaborazione terminata. Attribuiti n.' || d_attribuzioni ||
                              ' profili. (Sessione: ' || p_sessione || ')';
         end if;

      exception
         when errore_bloccante then
            p_segnalazione := 'Elaborazione terminata con errore: ' || p_segnalazione ||
                              ' - L''attribuzione dei profili non è stata eseguita';
         when others then
            p_segnalazione := 'Errore inatteso durante l''elaborazione: ' ||
                              p_segnalazione ||
                              ' - L''attribuzione dei profili non è stata eseguita';
      end;
   end; --rigenera_ruoli_skema
end so4_skema;
/


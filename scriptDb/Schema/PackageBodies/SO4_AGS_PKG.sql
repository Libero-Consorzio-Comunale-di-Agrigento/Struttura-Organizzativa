CREATE OR REPLACE package body so4_ags_pkg is
   /******************************************************************************
    NOME:        so4_ags_pkg.
    DESCRIZIONE: Raggruppa le funzioni di supporto per applicativi AGS.
    ANNOTAZIONI: .
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   20/08/2013  VD      Prima emissione.
    001   04/09/2013  VD      Modificata rispetto a SO4_UTIL per esigenze AGS.
    002   03/04/2014  VD      Corretta funzione COMP_GET_RUOLI per to_date(null)
                              in data AL
    003   25/06/2014  VD      Modificata AD4_UTENTE_GET_STORICO_UNITA per Bug#460
    004   21/08/2014  MM/AD   Modificata clausola di order by nella funzione 
                              unita_get_componenti_ord per valutare l'incarico di 
                              responsabilita' alla data di riferimento (Bug#487)  
    005   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                              query su viste per data pubblicazione 
          09/03/2015  MM      #576 Aggiunta distinct a unita_get_storico_discendenti
          26/05/2015  MM      #601 Aggiunta distinct a get_discendenti
    006   09/11/2015  MM      #661
          11/07/2016  MM      #734 - Correzione cursore ad4_utente_get_storico_unita              
    007   08/08/2017  MM      #776 - Corretta prior in get_ascendenza
          13/10/2017  MM      #790 - inclusione modifiche del gruppo Aff.Gen.
          14/02/2018  MM      #805 - ad4_utente_get_storico_unita: Se storico ruoli = N, 
                                     integrare il controllo in modo che vengano selezionati 
                                     anche i componenti che hanno coincidenza di date finale 
                                     per date effettive
    008   17/03/2022  MM      #55684
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '008';
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
   end; -- so4_ags_pkg.versione
   -------------------------------------------------------------------------------
   function set_ottica_default
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
   ) return ottiche.ottica%type is
   begin
      --
      return so4_util.set_ottica_default(p_ottica, p_amministrazione);
   end; -- so4_ags_pkg.set_ottica_default
   -------------------------------------------------------------------------------
   function set_data_default(p_data unita_organizzative.dal%type)
      return unita_organizzative.dal%type is
   begin
      --
      return so4_util.set_data_default(p_data);
   end; -- so4_ags_pkg.set_data_default
   -------------------------------------------------------------------------------
   function set_data_default(p_data varchar2) return unita_organizzative.dal%type is
   begin
      return so4_util.set_data_default(p_data);
   end; -- so4_ags_pkg.set_data_default
   -------------------------------------------------------------------------------
   function ad4_get_codiceuo
   (
      p_codice_gruppo   ad4_utenti.utente%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /******************************************************************************
       NOME:        AD4_get_codiceuo
       DESCRIZIONE: Dato il codice di un gruppo (ad4_utenti.utente) restituisce il 
                    codice della relativa unita' organizzativa
       PARAMETRI:   p_codice_gruppo    Codice del gruppo da trattare
                    p_ottica           ottica (facoltativa, alternativa all'ottica)
       RITORNA:     anagrafe_unita_organizzative.codice_uo%type    codice UO associato
                                                                   al gruppo AD4
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
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
      --
      return d_result;
   end; -- so4_ags_pkg.AD4_get_codiceuo
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
       PARAMETRI:   p_codice_uo               Codice della U.O. da trattare
                    p_ottica                  ottica (facoltativa, se non indicata si 
                                              assume l'ottica istituzionale)
                    p_amministrazione         codice amministrazione (falcoltativa, 
                                              alternativa all'ottica)
       RITORNA:     ad4_utenti.utente%type    utente AD4 associato alla U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione
      ******************************************************************************/
      d_result ad4_utenti.utente%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
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
      --
      return d_result;
   end; -- so4_ags_pkg.AD4_get_gruppo
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
                     p_amministrazione        codice amministrazione (falcoltativa, 
                                              alternativa all'ottica)
        RITORNA:     ad4_utenti.utente%type   utente AD4 associato alla U.O.
        REVISIONI:
        Rev.  Data        Autore  Descrizione
        ----  ----------  ------  ----------------------------------------------------
        000   20/08/2013  VD      Prima emissione.
        001   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                                  query su viste per data pubblicazione
      ******************************************************************************/
      d_result ad4_utenti.utente%type;
      d_ottica anagrafe_unita_organizzative.ottica%type;
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
      --
      return d_result;
   end; -- so4_ags_pkg.AD4_get_gruppo
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
       000   20/08/2013  VD        Prima emissione.
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
         when others then
            d_result := to_number(null);
      end;
      --
      return d_result;
   end; -- so4_ags_pkg.AD4_get_progr_unor
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
       000   20/08/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result     varchar2(32767);
      d_ni         as4_anagrafe_soggetti.ni%type;
      d_separatore varchar2(1);
   begin
      --
      --    se il separatore non e indicato, si assume #
      --
      d_separatore := so4_util.set_separatore_default(p_separatore, 1);
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
      --
      return d_result;
   end; -- so4_ags_pkg.AD4_utente_get_dati
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
                    p_ottica             ottica (facoltativa, se non indicata si
                                         assume l'ottica istituzionale dell'amministrazione
                                         indicata)
                    p_amministrazione    codice amministrazione (falcoltativa, 
                                         alternativa all'ottica)
       ritorna:     afc.t_ref_cursor     ref_cursor contenente le coppie codice / descrizione
                                         dei ruoli del componente
       revisioni:
       rev.  data        autore    descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := so4_util.set_separatore_default(d_separatore, 1);
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
   end; -- so4_ags_pkg.ad4_utente_get_ruoli
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
                    p_ottica             ottica (facoltativa, se non indicata si
                                         assume l'ottica istituzionale dell'amministrazione
                                         indicata)
                    p_amministrazione    codice amministrazione (falcoltativa, 
                                         alternativa all'ottica)
       ritorna:     afc.t_ref_cursor     ref_cursor contenente le coppie codice / descrizione
                                         delle unita organizzative in cui e presente il
                                         componente
       revisioni:
       rev.  data        autore    descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_dati_utente varchar2(32767);
      d_separatore  varchar2(1);
      d_ni          number;
      pos_sep       number;
   begin
      d_separatore  := so4_util.set_separatore_default(d_separatore, 1);
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
   end; -- so4_ags_pkg.ad4_utente_get_ruoli
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
                    anche in passato, completo di eventuali cambi di codice delle
                    unita'
       PARAMETRI:   p_utente             Codice utente di AD4
                    p_ottica             ottica di riferimento (nota: era facoltativa,
                                         ora e' obbligatoria)
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
       000   20/08/2013  VD        Prima emissione.
       001   04/09/2013  VD        Modificata rispetto a SO4_UTIL per esigenze AGS.
       002   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione
       003   09/03/2017   SC       In caso di STORIC_RUOLI = N trattamo ruolo
                                   chiuso e componente chiuso
                                   allo stesso modo.
                                   
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
                  --#805
               and c.al in
                   (select max(al)
                      from vista_pubb_anuo x
                     where x.progr_unita_organizzativa = c.progr_unita_organizzativa
                    union
                    select max(a1.al)
                      from revisioni_modifica           r1
                          ,anagrafe_unita_organizzative a1
                     where r1.ottica = a1.ottica
                       and a1.revisione_istituzione <> r1.revisione_modifica
                       and a1.progr_unita_organizzativa = c.progr_unita_organizzativa)
                  --
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
                  ,decode(a.al, null, r.al, decode(r.al, null, a.al, least(a.al, r.al))) --#661
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
               and trunc(sysdate) between r.dal and nvl(r.al, s_data_limite) --#790
             order by 4
                     ,5;
      end if;
      --
      return d_result;
      --
   end; -- so4_ags_pkg.AD4_utente_get_storico_unita
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
   begin
   
      return so4_util.ad4_utente_get_unita(p_utente
                                          ,p_ruolo
                                          ,p_ottica
                                          ,p_data
                                          ,p_se_progr_unita
                                          ,p_tipo_assegnazione);
   end; -- so4_ags_pkg.AD4_utente_get_unita
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
   begin
   
      return so4_util.ad4_utente_get_unita(p_utente
                                          ,p_ruolo
                                          ,p_ottica
                                          ,p_data
                                          ,p_se_progr_unita
                                          ,p_se_ordinamento
                                          ,p_se_descrizione
                                          ,p_tipo_assegnazione);
   end; -- so4_ags_pkg.AD4_utente_get_unita
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
       PARAMETRI:   p_ottica             ottica di riferimento (facoltativa,
                                         alternativa all'amministrazione)
                    p_amministrazione    amministrazione di riferimento
                                         (facoltativa, alternativa all'ottica)                    
                    p_codice_uo          codice dell'unita' organizzativa
                    p_data               data di confronto (facoltativa, se non 
                                         indicata si assume la data di sistema)
                    
       RITORNA:     progressivo dell'unita' organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
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
      --
      return d_result;
   end; -- so4_ags_pkg.anuo_get_progr
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
       000   20/08/2013  VD        Prima emissione.
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
      --
      return d_result;
   end; -- so4_ags_pkg.anuo_get_descrizione
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
   begin
      return so4_util.comp_get_responsabile(p_ni
                                           ,p_codice_uo
                                           ,p_ruolo
                                           ,p_ottica
                                           ,p_data
                                           ,p_amministrazione);
   end; -- so4_ags_pkg.comp_get_responsabile
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
                    p_codice_uo        codice dell'unita organizzativa (facoltativo,
                                       se non indicato si considerano tutte le unita)
                    p_data             data a cui eseguire la ricerca (facoltativa,
                                       se non indicata si considera la data di sistema)
                    p_ottica           ottica di riferimento (facoltativa,
                                       alternativa all'amministrazione per la definizione
                                       dell'ottica istituzionale)
                    p_amministrazione  amministrazione di riferimento (facoltativa,
                                       alternativa all'ottica per la definizione
                                       dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor   Ref cursor contenente le coppie codice / descrizione
                                       dei ruoli del componente
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   20/08/2013  VD      Prima emissione.
       001   19/09/2014  VD      Eliminate condizioni di where non necessarie in
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
         d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
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
   end; -- so4_ags_pkg.comp_get_ruoli
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
                    p_codice_uo        codice dell'unita organizzativa (facoltativo,
                                       se non indicato si considerano tutte le unita)
                    p_data             data a cui eseguire la ricerca (facoltativa,
                                       se non indicata si considera la data di sistema)
                    p_ottica           ottica di riferimento (facoltativa, alternativa
                                       all'amministrazione)
                    p_amministrazione  amministrazione di riferimento (facoltativa,
                                       alternativa all'ottica per la definizione
                                       dell'ottica istituzionale)
                    p_se_ordinamento
                    p_se_descrizione                   
       RITORNA:     AFC.t_ref_cursor   Ref cursor contenente le coppie codice / descrizione
                                       dei ruoli del componente separati dal carattere
                                       separatore
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   20/08/2013  VD      Prima emissione.
       001   19/09/2014  VD      Eliminate condizioni di where non necessarie in
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
         d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                   ,p_codice_uo => p_codice_uo
                                                   ,p_data      => d_data);
      end if;
      --
      open d_result for
         select ruolo
               ,null
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
   end; -- so4_ags_pkg.comp_get_ruoli
   -------------------------------------------------------------------------------
   function comp_get_utente(p_ni componenti.ni%type) return varchar2 is
      /******************************************************************************
       NOME:        comp_get_utente.
       DESCRIZIONE: Dato l'ni di un componente, restituisce il codice utente corrispondente
       PARAMETRI:   p_ni               ni del componente
       RITORNA:     VARCHAR2  codice utente corrispondente
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       000   20/08/2013  VD       Prima emissione.
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
   end; -- so4_ags_pkg.comp_get_utente
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
       PARAMETRI:   p_ottica                ottica di riferimento (facoltativa,
                                            alternativa all'amministrazione)
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_amministrazione       amministrazione di ricerca nella struttura
                                            (facoltativa, alternativa all'ottica per la
                                            definizione dell'ottica istituzionale)
       RITORNA:     Ref_cursor              contiene l'elenco delle unita' radice
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   19/09/2014  VD        Eliminate condizioni di where non necessarie in
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
         select codice_uo
               ,descrizione
               ,dal
               ,al
           from vista_unita_organizzative_pubb
          where ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
            and progr_unita_padre is null
          order by suddivisione_struttura.get_ordinamento(id_suddivisione)
                  ,sequenza;
      --
      return d_result;
   end; -- so4_ags_pkg.get_all_unita_radici
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
                    appartenenza di una unita' organizzativa
       PARAMETRI:   p_progr_unor            Unita' organizzativa da trattare
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_ottica                Ottica di riferimento (facolatativa,
                                            alternativa all'amministrazione)
                    p_separatore_1          carattere di separazione per concatenare i dati
                    p_separatore_2          carattere di separazione per concatenare i dati
                    p_amministrazione       amministrazione di riferimento (facoltativa,
                                            alternativa all'ottica per la definizione 
                                            dell'ottica istituzionale)
                    p_se_tipo               Indica se nella stringa deve apparire anche il
                                            tipo "O" (per AD4 ?) - default null                                           
       RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                            di appartenenza della U.O. concatenata con
                                            il carattere separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   19/09/2014  VD        Eliminate condizioni di where non necessarie in
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
      d_separatore_1 := so4_util.set_separatore_default(p_separatore_1, 1);
      d_separatore_2 := so4_util.set_separatore_default(p_separatore_2, 2);
      d_contatore    := 0;
      d_result       := '';
      --
      for sel_asc in (select /*+ first_rows */
                       codice_uo
                      ,descrizione
                        from vista_unita_organizzative_pubb
                       where ottica = d_ottica
                         and d_data between dal and nvl(al, s_data_limite)
                      connect by prior progr_unita_padre = progr_unita_organizzativa --#776
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
   end; -- so4_ags_pkg.get_ascendenza
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
                    ATTENZIONE! VERSIONE ORRENDA CHE TRATTA SOLO LE UNITA' CON
                    ID_SUDDIVISIONE 1 E 2, FATTA PER ZOLI (E NON SO SE HA ANCORA 
                    SENSO DI ESISTERE)
       PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_ottica                ottica di riferimento (facoltativa, alternativa
                                            all'amministrazione)
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
       000   20/08/2013  VD        Prima emissione.
       001   19/09/2014  VD        Eliminate condizioni di where non necessarie in
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
      d_separatore_1 := so4_util.set_separatore_default(p_separatore_1, 1);
      d_separatore_2 := so4_util.set_separatore_default(p_separatore_2, 2);
      d_result       := '';
      --
      for sel_asc in (select /*+ first_rows */
                       codice_uo
                      ,descr_suddivisione || ' ' || descrizione descrizione
                        from vista_unita_organizzative_pubb u
                       where u.ottica = d_ottica
                         and u.id_suddivisione in (1, 2)
                         and d_data between u.dal and nvl(u.al, s_data_limite)
                      connect by prior u.progr_unita_padre = u.progr_unita_organizzativa
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
   end get_ascendenza_padre; -- so4_ags_pkg.get_ascendenza_padre
   -------------------------------------------------------------------------------
   function get_discendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        get_discendenti
       DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                    (progressivo, codice, descrizione e dal) delle unita
                    discendenti.
       PARAMETRI:   p_progr_unor            unità organizzativa da trattare
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_ottica                ottica di riferimento
       RITORNA:     afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                            di appartenenza della u.o.
       REVISIONI:
       Rev.  Rata        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   04/09/2013  VD        Modificata rispetto a SO4_UTIL per esigenze AGS.
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
   begin
      /*d_ottica := set_ottica_default(p_ottica);
      open d_result for
      --#601
         select \*+ first_rows *\
         distinct progr_unita_organizzativa
                 ,codice_uo
                 ,descrizione
                 ,dal
                 ,al
           from vista_unita_organizzative_pubb
          where ottica = d_ottica
         connect by prior progr_unita_organizzativa = progr_unita_padre
                and ottica = d_ottica
          start with ottica = d_ottica
                 and progr_unita_organizzativa = p_progr_unor;
      --
      return d_result;*/
      --#790
      return so4_util.get_discendenti(p_progr_unor, p_data, p_ottica);
   
   end; -- so4_ags_pkg.get_discendenti
   -------------------------------------------------------------------------------
   function ruolo_get_componenti
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
   begin
      return so4_util.ruolo_get_componenti(p_ruolo, p_data, p_ottica, p_amministrazione);
   end; -- so4_ags_pkg.ruolo_get_componenti
   -------------------------------------------------------------------------------
   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /******************************************************************************
       NOME:        unita_get_codice_valido
       DESCRIZIONE: Restituisce una stringa contenente il codice dell'unita' alla
                    data indicata; se non esiste, restituisce l'ultimo codice valido
       PARAMETRI:   p_progr_unor            Unità organizzativa da trattare
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
       RITORNA:     varchar2                codice dell'unita'; se non esiste, 16 asterischi
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
   begin
      return so4_util.unita_get_codice_valido(p_progr_unor, p_data);
      --
   end; -- so4_ags_pkg.unita_get_codice_valido
   -------------------------------------------------------------------------------
   function unita_get_ascendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_ascendenza
       DESCRIZIONE: restituisce un ref cursor contenente la gerarchia del ramo di
                    appartenenza di una unità organizzativa.
       PARAMETRI:   p_codice_uo            Codice unita' organizzativa da trattare
                    p_data                 Data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                    p_ottica               Ottica di riferimento (nota: era facoltativa,
                                           ora e' obbligatoria)
       RITORNA:     varchar2               Cursore contenente la gerarchia del ramo
                                           di appartenenza della u.o.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      --
      d_result := so4_util.get_ascendenti(p_progr_unor => d_progr_unor
                                         ,p_data       => d_data
                                         ,p_ottica     => d_ottica);
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_ascendenti
   -------------------------------------------------------------------------------
   function unita_get_ascendenti_sudd
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_ascendenti_sudd
       DESCRIZIONE: Restituisce un ref cursor contenente la gerarchia del ramo di
                    appartenenza di una unità organizzativa.
       PARAMETRI:   p_codice_uo            Codice unità organizzativa da trattare
                    p_data                 Data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                    p_ottica               Ottica di riferimento (nota: era facoltativa,
                                           ora e' obbligatoria)
       RITORNA:     ref_cursor             Cursore contenente la gerarchia del ramo
                                           di appartenenza della u.o.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      --
      d_result := so4_util.get_ascendenti_sudd(p_progr_unor => d_progr_unor
                                              ,p_data       => d_data
                                              ,p_ottica     => d_ottica);
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_ascendenti_sudd
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
      PARAMETRI:   p_codice_uo             Codice Unità organizzativa da trattare
                   p_data                  Data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_ottica                Ottica di riferimento (nota: era facoltativa,
                                           ora e' obbligatoria)
                   p_separatore_1          carattere di separazione per concatenare i dati
                   p_separatore_2          carattere di separazione per concatenare i dati
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O. concatenata con
                                           il carattere separatore
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result     varchar2(32767);
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica := set_ottica_default(p_ottica);
      d_data   := set_data_default(p_data);
      --
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      --                                             
      d_result := get_ascendenza(p_progr_unor   => d_progr_unor
                                ,p_data         => d_data
                                ,p_ottica       => d_ottica
                                ,p_separatore_1 => p_separatore_1
                                ,p_separatore_2 => p_separatore_2);
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_ascendenza
   -------------------------------------------------------------------------------
   function unita_get_discendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_discendenti
       DESCRIZIONE: Restituisce un ref cursor contenente la gerarchia sottostante il 
                    ramo di appartenenza di una unità organizzativa.
       PARAMETRI:   p_codice_uo             Codice Unità organizzativa da trattare
                    p_data                  Data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_ottica                Ottica di riferimento.
       RITORNA:     varchar2                Ref cursor contenente la gerarchia del ramo
                                            di appartenenza della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result     afc.t_ref_cursor;
      d_ottica     anagrafe_unita_organizzative.ottica%type;
      d_data       anagrafe_unita_organizzative.dal%type;
      d_progr_unor unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_ottica     := set_ottica_default(p_ottica);
      d_data       := set_data_default(p_data);
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      -- 
      d_result := get_discendenti(p_progr_unor => d_progr_unor
                                 ,p_data       => d_data
                                 ,p_ottica     => d_ottica);
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_discendenti
   -------------------------------------------------------------------------------
   function unita_get_radice
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_radice
       DESCRIZIONE: Data una unita organizzativa restituisce i dati dell'unita radice.
       
       PARAMETRI:   p_progr_uo              Progr Unità organizzativa da trattare
                    p_ottica                Ottica di riferimento (facoltativa,
                                            alternativa all'amministrazione - se non
                                            indicata si assume l'ottica istituzionale
                                            dell'amministrazione)
                    p_data                  Data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_amministrazione       Amministrazione di riferimento (facoltativa,
                                            alternativa all'ottica)
       RITORNA:     varchar2                Ref cursor contenente la gerarchia del ramo
                                            di appartenenza della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
   begin
      return so4_util.unita_get_radice(p_progr           => p_progr
                                      ,p_ottica          => p_ottica
                                      ,p_data            => p_data
                                      ,p_amministrazione => p_amministrazione);
   end; -- so4_ags_pkg.unita_get_radice
   -------------------------------------------------------------------------------
   function unita_get_radice
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_radice
       DESCRIZIONE: Data una unita organizzativa restituisce i dati dell'unita radice.
       
       PARAMETRI:   p_codice_uo             Codice Unità organizzativa da trattare
                    p_ottica                Ottica di riferimento (facoltativa,
                                            alternativa all'amministrazione - se non
                                            indicata si assume l'ottica istituzionale
                                            dell'amministrazione)
                    p_data                  Data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_amministrazione       Amministrazione di riferimento (facoltativa,
                                            alternativa all'ottica)
       RITORNA:     varchar2                Ref cursor contenente la gerarchia del ramo
                                            di appartenenza della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
   begin
      return so4_util.unita_get_radice(p_codice_uo       => p_codice_uo
                                      ,p_ottica          => p_ottica
                                      ,p_data            => p_data
                                      ,p_amministrazione => p_amministrazione);
      --
   end; -- so4_ags_pkg.unita_get_radice
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
       PARAMETRI:   p_progr           Progressivo che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa, 
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
                    p_tipo_data       indica quale data utilizzare nella ricerca:
                                      null = data di pubblicazione
                                      1 = data effettiva
       RITORNA:     varchar2          Stringa contenente i dati progressivo, codice unita, 
                                      descrizione dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   19/09/2014  VD        Eliminate condizioni di where non necessarie in
                                   query su viste per data pubblicazione                                        
      ******************************************************************************/
      d_result       varchar2(2000);
      d_ottica       unita_organizzative.ottica%type;
      d_data         unita_organizzative.dal%type;
      d_progr_padre  unita_organizzative.progr_unita_organizzativa%type;
      d_codice_padre anagrafe_unita_organizzative.codice_uo%type;
      d_descr_padre  anagrafe_unita_organizzative.descrizione%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
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
            and d_data between dal and nvl(al, s_data_limite)
            and p_tipo_data = 1;
      exception
         when no_data_found then
            d_progr_padre := to_number(null);
         when too_many_rows then
            d_progr_padre := to_number(null);
      end;
      --
      if d_progr_padre is null then
         d_result := null;
      else
         d_codice_padre := so4_util.anuo_get_codice_uo(p_progr_unita_organizzativa => d_progr_padre
                                                      ,p_dal                       => d_data);
         d_descr_padre  := so4_ags_pkg.anuo_get_descrizione(p_progr_unita_organizzativa => d_progr_padre
                                                           ,p_dal                       => d_data);
         d_result       := d_progr_padre || '#' || d_codice_padre || '#' || d_descr_padre;
      end if;
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_unita_padre
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
       DESCRIZIONE: Dato il codice di un'unita restituisce la descrizione
                    dell'unita padre
       PARAMETRI:   p_codice_uo       Codice dell'unita
                    p_ottica          Ottica di riferimento (facoltativo,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa, 
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
       RITORNA:     varchar2          Stringa contenente la descrizione dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
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
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      d_result     := unita_get_unita_padre(p_progr           => d_progr_unor
                                           ,p_ottica          => d_ottica
                                           ,p_data            => d_data
                                           ,p_amministrazione => p_amministrazione);
      d_result     := substr(d_result, instr(d_result, '#', 1, 2) + 1, 200);
      return d_result;
      --
   end; -- so4_ags_pkg.unita_get_unita_padre
   -------------------------------------------------------------------------------
   function unita_get_unita_padri
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_padri.
       DESCRIZIONE: Dato il codice di un'unita restituisce un ref_cursor contenente
                    progressivo, codici, descrizioni e date di validità delle unità
                    padre.
       PARAMETRI:   p_progr           Progressivo che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa, 
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
                    p_tipo_data       indica quale data utilizzare nella ricerca:
                                      null = data di pubblicazione
                                      1 = data effettiva
       RITORNA:     varchar2          Stringa contenente i dati progressivo, 
                                      codice unita, descrizione dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
       000   11/09/2013  VD        Prima emissione.
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
         select progr_unita_organizzativa
               ,codice_uo
               ,descrizione
               ,dal
               ,al
           from vista_unita_organizzative_pubb
          where ottica = d_ottica
            and p_data between dal and nvl(al,to_date(3333333,'j')) --#55684
            and progr_unita_organizzativa in
                (select distinct progr_unita_padre
                   from vista_unita_organizzative_pubb
                  where ottica = d_ottica
                    and p_data between dal and nvl(al,to_date(3333333,'j')) --#55684
                    and progr_unita_organizzativa = p_progr)
          order by 4;
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_unita_padri
   -------------------------------------------------------------------------------
   function unita_get_unita_padri
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_unita_padri.
       DESCRIZIONE: Dato il codice di un'unita restituisce un ref_cursor contenente
                    progressivo, codici, descrizioni e date di validità dell'unità
                    padre.
       PARAMETRI:   p_codice_uo       Codice dell'unita
                    p_ottica          Ottica di riferimento (facoltativo,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa, 
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
       RITORNA:     varchar2          Stringa contenente la descrizione dell'unita padre.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      d_result     := unita_get_unita_padri(p_progr           => d_progr_unor
                                           ,p_ottica          => d_ottica
                                           ,p_data            => d_data
                                           ,p_amministrazione => p_amministrazione);
      return d_result;
      --
   end; -- so4_ags_pkg.unita_get_unita_padre
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
                    (progressivo, codice e descrizione) delle unita figlie,
                    considerando anche eventuali cambi di codice.
       PARAMETRI:   p_progr           Progressivo che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si considera la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa,
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le righe progressivo, codice unita, 
                                      descrizione delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   20/08/2013  VD        Prima emissione.
       001   04/09/2013  VD        Modificata rispetto a SO4_UTIL per esigenze AGS.
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica unita_organizzative.ottica%type;
      d_data   unita_organizzative.dal%type;
   begin
      --
      -- Impostazione parametri di default
      --
      /*      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --
      open d_result for
         select v.progr_unita_organizzativa
               ,v.codice_uo
               ,v.descrizione
               ,v.dal
               ,v.al
           from vista_unita_organizzative_pubb v
          where v.ottica = d_ottica
            and v.progr_unita_padre = p_progr
               --            and d_data between v.dal and nvl(v.al, s_data_limite)
            and v.progr_unita_organizzativa in
                (select x.progr_unita_organizzativa
                   from vista_unita_organizzative_pubb x
                  where x.ottica = d_ottica
                    and x.progr_unita_padre = p_progr
                    and d_data between x.dal and nvl(x.al, s_data_limite))
          order by 2
                  ,3;
      --
      return d_result;*/
      --#790
      return so4_util.unita_get_unita_figlie(p_progr           => p_progr
                                            ,p_ottica          => p_ottica
                                            ,p_data            => p_data
                                            ,p_amministrazione => p_amministrazione);
   end; -- so4_ags_pkg.unita_get_unita_figlie
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
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco (progressivo, 
                    codice e descrizione) delle unita figlie
       PARAMETRI:   p_codice_uo       Codice che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa, 
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Cursore contenente le righe progressivo, codice unita, 
                                      descrizione delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      --                                                
      d_result := so4_ags_pkg.unita_get_unita_figlie(d_progr_unor
                                                    ,d_ottica
                                                    ,d_data
                                                    ,p_amministrazione);
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_unita_figlie
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
       DESCRIZIONE: Dato il codice di un'unita, restituisce l'elenco
                    (progressivo, codice e descrizione) delle unita figlie
                    ordinato per suddivisione e sequenza
       PARAMETRI:   p_codice_uo       Codice che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione amministrazione di riferimento (facoltativa, 
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Cursore contenente progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
      000   20/08/2013  VD       Prima emissione.
      001   19/09/2014  VD       Eliminate condizioni di where non necessarie in
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
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      --
      open d_result for
         select progr_unita_organizzativa
               ,codice_uo
               ,descrizione
               ,dal
               ,al
           from vista_unita_organizzative_pubb
          where progr_unita_padre = d_progr_unor
            and ottica = d_ottica
            and d_data between dal and nvl(al, s_data_limite)
          order by suddivisione_struttura.get_ordinamento(id_suddivisione)
                  ,sequenza
                  ,2;
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_unita_figlie_ord
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
                   stesso livello), considerando anche gli eventuali cambi di
                   codice.
      PARAMETRI:   p_progr_uo        Progressivo dell'unita organizzativa
                   p_ottica          Ottica di riferimento (facoltativa,
                                     alternativa all'amministrazione)
                   p_data            Sata a cui eseguire la ricerca (facoltativa,
                                     se non indicata si assume la data di sistema)
                   p_amministrazione Amministrazione di riferimento (facoltativa,
                                     alternativa all'ottica per la definizione 
                                     dell'ottica istituzionale)
      RITORNA:     AFC.t_ref_cursor  Elenco contenente le righe progressivo, codice 
                                     unita, descrizione delle unita figlie.
      REVISIONI:
      Rev.  Data        Autore  Descrizione
      ----  ----------  ------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
      001   04/09/2013  VD        Modificata rispetto a SO4_UTIL per esigenze AGS.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_ottica      unita_organizzative.ottica%type;
      d_data        unita_organizzative.dal%type;
      d_progr_padre unita_organizzative.id_unita_padre%type;
   begin
      --
      -- Impostazione parametri di default
      --
      d_ottica := set_ottica_default(p_ottica, p_amministrazione);
      d_data   := set_data_default(p_data);
      --#790
      return so4_util.unita_get_pari_livello(p_progr_uo => p_progr_uo
                                            ,p_data     => d_data
                                            ,p_ottica   => d_ottica);
      /*      --
      -- Si determina il progressivo dell'unita' padre
      --
      begin
         select progr_unita_padre
           into d_progr_padre
           from vista_unita_organizzative_pubb v
          where v.ottica = d_ottica
            and v.progr_unita_organizzativa = p_progr_uo
            and d_data between v.dal and nvl(v.al, s_data_limite);
      exception
         when others then
            d_progr_padre := -1;
      end;
      --
      if nvl(d_progr_padre, 0) >= 0 then
         open d_result for
            select v.progr_unita_organizzativa
                  ,v.codice_uo
                  ,v.descrizione
                  ,v.dal
                  ,v.al
              from vista_unita_organizzative_pubb v
             where v.ottica = d_ottica
               and v.progr_unita_organizzativa != p_progr_uo
               and nvl(v.progr_unita_padre, 0) = nvl(d_progr_padre, 0)
                  --               and d_data between v.dal and nvl(v.al, s_data_limite)
               and v.progr_unita_organizzativa in
                   (select x.progr_unita_organizzativa
                      from vista_unita_organizzative_pubb x
                     where x.ottica = d_ottica
                       and x.progr_unita_padre = d_progr_padre
                       and d_data between x.dal and nvl(x.al, s_data_limite))
             order by 2
                     ,3;
      else
         open d_result for
            select to_number(null)
                  ,null
                  ,null
                  ,to_date(null)
                  ,to_date(null)
              from dual;
      end if;
      --
      return d_result;*/
   end; -- so4_ags_pkg.unita_get_unita_pari_livello
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
       PARAMETRI:   p_codice_uo       Codice che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_data            Data a cui eseguire la ricerca (facoltativa,
                                      se non indicata si assume la data di sistema)
                    p_amministrazione Amministrazione di riferimento (facoltativa,
                                      alternativa all'ottica per la definizione 
                                      dell'ottica istituzionale)
       RITORNA:     AFC.t_ref_cursor  Elenco contenente le righe progressivo, codice unita, descrizione
                                      delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica    => d_ottica
                                                ,p_codice_uo => p_codice_uo
                                                ,p_data      => d_data);
      --
      d_result := so4_ags_pkg.unita_get_pari_livello(p_progr_uo        => d_progr_unor
                                                    ,p_data            => d_data
                                                    ,p_ottica          => d_ottica
                                                    ,p_amministrazione => p_amministrazione);
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_unita_pari_livello
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
       PARAMETRI:   p_progr_uo        Progressivo dell'unita organizzativa
                    p_ottica          Ottica di riferimento (facoltativa,
                                      alternativa all'amministrazione)
                    p_amministrazione Amministrazione di riferimento (facoltativa,
                                      alternativa all'ottica)
       RITORNA:     Afc.t_ref_cursor  Cursore contenente le righe progressivo, codice unita, 
                                      descrizione delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
           from vista_unita_organizzative_pubb v
          where v.ottica = d_ottica
            and v.progr_unita_padre = p_progr_uo
          order by 2
                  ,3;
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_storico_figlie
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
       PARAMETRI:   p_codice_uo             Codice che identifica l'unita
                    p_ottica                Ottica di riferimento (facoltativa,
                                            alternativa all'amministrazione)
                    p_amministrazione       Amministrazione di riferimento
                                            (facoltativa, alternativa all'ottica)
       RITORNA:     Afc.t_ref_cursor        Cursore contenente le righe progressivo, 
                                            codice unita, descrizione delle unita figlie.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
      d_result := so4_ags_pkg.unita_get_storico_figlie(p_progr_uo        => d_progr_unor
                                                      ,p_ottica          => d_ottica
                                                      ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_ags_pkg.unita_get_storico_figlie
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
   end; -- so4_ags_pkg.unita_get_storico_discendenti
   -------------------------------------------------------------------------------
   function unita_get_storico_discendenti
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_storico_discendenti
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco
                    (progressivo, codice, descrizione e dal) delle unita
                    discendenti.
       PARAMETRI:   p_codice_uo             Codice che identifica l'unita
                    p_ottica                Cttica di riferimento (facoltativo,
                                            alternativa all'amministrazione)
                    p_amministrazione       Amministrazione di riferimento
                                            (facoltativa, alternativa all'ottica)
       RITORNA:     afc.t_ref_cursor        Cursore contenente la gerarchia delle
                                            unita' figlie della U.O.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
      d_result := so4_ags_pkg.unita_get_storico_discendenti(p_progr_uo        => d_progr_unor
                                                           ,p_ottica          => d_ottica
                                                           ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_ags_pkg.unita_get_storico_discendenti
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
      000   20/08/2013  VD        Prima emissione.
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
           from vista_unita_organizzative_pubb v
          where v.ottica = d_ottica
            and v.progr_unita_organizzativa != p_progr_uo
            and nvl(v.progr_unita_padre, 0) in
                (select nvl(v2.progr_unita_padre, 0)
                   from vista_unita_organizzative_pubb v2
                  where v2.ottica = d_ottica
                    and v2.progr_unita_organizzativa = p_progr_uo)
          order by 2
                  ,3;
      --
      return d_result;
   end; -- so4_ags_pkg.unita_get_storico_pari_livello
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
       PARAMETRI:   p_codice_uo       Codice che identifica l'unita
                    p_ottica          Ottica di riferimento (facoltativo,
                                      alternativa all'amministrazione)
                    p_amministrazione Amministrazione di riferimento
                                      (facoltativa, alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor  Cursore contenente le righe con progressivo,
                                      codice unita, descrizione, dal e al delle
                                      unita di pari livello.
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
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
      d_result := so4_ags_pkg.unita_get_storico_pari_livello(p_progr_uo        => d_progr_unor
                                                            ,p_ottica          => d_ottica
                                                            ,p_amministrazione => p_amministrazione);
      --
      return d_result;
      --
   end; -- so4_ags_pkg.unita_get_storico_pari_livello
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
       NOME:        unita_get_componenti
       DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco dei 
                    componenti aventi l'eventuale ruolo indicato
       PARAMETRI:   p_progr_uo        Progressivo dell'unita organizzativa
                    p_ruolo           Ruolo da ricercare (facoltativo, se non
                                      indicato si trattano tutti i componenti)
                    p_ottica          Ottica di riferimento (facoltativo,
                                      alternativa all'amministrazione)
                    p_data            Data di riferimento (facoltativa, se non
                                      indicata si considera la data di sistema)
                    p_amministrazione Amministrazione di riferimento
                                      (facoltativa, alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor  Cursore contenente le coppie ni / cognome 
                                      e nome dei componenti dell'unita organizzativa 
                                      separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
   begin
      return so4_util.unita_get_componenti(p_progr_uo
                                          ,p_ruolo
                                          ,p_ottica
                                          ,p_data
                                          ,p_amministrazione);
   end; -- so4_ags_pkg.unita_get_componenti
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
       NOME:        unita_get_componenti
       DESCRIZIONE: Dato il codice di un'unita restituisce l'elenco dei 
                    componenti aventi l'eventuale ruolo indicato
       PARAMETRI:   p_codice_uo       Codice dell'unita organizzativa
                    p_ruolo           Ruolo da ricercare (facoltativo, se non
                                      indicato si trattano tutti i componenti)
                    p_ottica          Ottica di riferimento (facoltativo,
                                      alternativa all'amministrazione)
                    p_data            Data di riferimento (facoltativa, se non
                                      indicata si considera la data di sistema)
                    p_amministrazione Amministrazione di riferimento
                                      (facoltativa, alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor  Cursore contenente le coppie ni / cognome 
                                      e nome dei componenti dell'unita organizzativa 
                                      separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
   begin
      return so4_util.unita_get_componenti(p_codice_uo
                                          ,p_ruolo
                                          ,p_ottica
                                          ,p_data
                                          ,p_amministrazione);
   end; -- so4_ags_pkg.unita_get_componenti
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
      d_progr_unor := so4_ags_pkg.anuo_get_progr(p_ottica          => d_ottica
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
   end; -- so4_ags_pkg.unita_get_componenti_ord
   -------------------------------------------------------------------------------
   function unita_get_responsabile
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        unita_get_responsabile
       DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco dei 
                    componenti aventi l'incarico di responsabile
       PARAMETRI:   p_progr_uo        Progressivo dell'unita organizzativa
                    p_ruolo           Ruolo da ricercare (facoltativo, se non
                                      indicato si trattano tutti i componenti)
                    p_ottica          Ottica di riferimento (facoltativo,
                                      alternativa all'amministrazione)
                    p_data            Data di riferimento (facoltativa, se non
                                      indicata si considera la data di sistema)
                    p_amministrazione Amministrazione di riferimento
                                      (facoltativa, alternativa all'ottica)
       RITORNA:     AFC.t_ref_cursor  Cursore contenente le coppie ni / cognome 
                                      e nome dei componenti dell'unita organizzativa 
                                      separati dal separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    ----------------------------------------------------
      000   20/08/2013  VD        Prima emissione.
      ******************************************************************************/
   begin
      return so4_util.unita_get_responsabile(p_progr_unita
                                            ,p_codice_uo
                                            ,p_ottica
                                            ,p_data
                                            ,p_amministrazione);
      --
   end; -- so4_ags_pkg.unita_get_responsabile
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
      d_ottica := so4_ags_pkg.set_ottica_default(p_ottica, p_amministrazione);
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
   function anuo_get_storico_codici
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data_rif                  in date
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        anuo_get_storico_codici
       DESCRIZIONE: Restituisce un cursore coi codici unita' fino alla data p_data_rif. 
                    NOTA: LA FUNZIONE NON CONSIDERA LA REVISIONE IN MODIFICA
                    PERCHE' AGISCE SULLA VISTA PER DATA DI PUBBLICAZIONE
       PARAMETRI:   progressivi unita e data di riferimento
       RITORNA:     afc.t_ref_cursor
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   04/04/2014  SC        #790
      ******************************************************************************/
      d_result afc.t_ref_cursor;
   begin
      open d_result for
         select distinct codice_uo
           from vista_pubb_anuo
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and nvl(al, s_data_limite) <= nvl(p_data_rif, s_data_limite);
   
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
end so4_ags_pkg;
/


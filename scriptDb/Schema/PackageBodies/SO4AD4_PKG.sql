CREATE OR REPLACE package body so4ad4_pkg is
   /******************************************************************************
    NOME:        SO4AD4_PKG.
     DESCRIZIONE: Procedure e Funzioni di utilita' utilizzate dallo user oracle
                 AD4 ma che lavorano sui dati di SO4
    ANNOTAZIONI: .
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   23/08/2012  AD      Prima emissione.
    001   31/01/2012  AD      Aggiunta is_soggetto_componente per compatibilita
                              con nuove versioni di AD4
    002   12/09/2013  AD      Aggiunti alias di colonna nei cursori di ritorno delle
                              funzioni per corretta usabilità a mezzo WS Bug#307
    003   18/09/2014  VD      Eliminate condizioni di where su revisione in modifica
                              dopo ristrutturazione viste per data pubblicazione
                              (Feature #178)
    004   18/06/2015  AD      Aggiunta funzione ad4_utente_get_ruoli (Feature#609)                                                            
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '004';
   s_data_limite    constant date := to_date(3333333, 'j');
   ----------------------------------------------------------------------------------
   function versione return varchar2 is
      /******************************************************************************
       NOME:        versione.
       DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
       RITORNA:     VARCHAR2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;
   ----------------------------------------------------------------------------------
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
      000   02/01/2007  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result ottiche.ottica%type;
   begin
      -- Se l'ottica non è indicata, si assume l'ottica istituzionale
      --
      if p_ottica is null then
         begin
            select min(ottica)
              into d_result
              from ottiche
             where amministrazione = nvl(p_amministrazione, amministrazione)
               and ottica_istituzionale = 'SI';
         exception
            when others then
               d_result := null;
         end;
      else
         d_result := p_ottica;
      end if;
      --
      if d_result is null then
         raise_application_error(-20999
                                ,'Impossibile determinare l''ottica istituzionale');
      end if;
      --
      return d_result;
   end; -- so4_util.set_ottica_default
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
      -- Se il separatore non è indicato, si assume # o [
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
                    p_data                  data a cui eseguire la ricerca (facoltativa,
                                            se non indicata si assume la data di sistema)
                    p_ottica                Ottica di ricerca nella struttura (facoltativa,
                                            alternativa all'amministrazione)
                    p_separatore_1          carattere di separazione per concatenare i dati
                    p_separatore_2          carattere di separazione per concatenare i dati
                    p_amministrazione       amministrazione di ricerca nella struttura
                                            (facoltativa, alternativa all'ottica per la
                                            definizione dell'ottica istituzionale)
       RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                            di appartenenza della U.O. concatenata con
                                            il carattere separatore
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   19/12/2006  VD        Prima emissione.
       001   07/02/2012  VD        Sostituite tabelle con viste per date di pubblicazione
       003   18/09/2014  VD        Eliminate condizioni di where su revisione in modifica
                                   dopo ristrutturazione viste per data pubblicazione
                                   (Feature #178)                              
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
      for sel_asc in (select /*+ first_rows */
                       so4_util.anuo_get_utente_ad4(progr_unita_organizzativa, d_data) codice_uo
                       -- Bug #365 rimuovo dalla descrizione abbreviata i separatori di default
                      ,replace(replace(so4_util.anuo_get_des_abb(progr_unita_organizzativa
                                                                ,d_data)
                                      ,'['
                                      ,'(')
                              ,'#'
                              ,'') || '-' ||
                       aoo_pkg.get_codice_aoo(so4_util.anuo_get_progr_aoo(progr_unita_organizzativa
                                                                         ,d_data)
                                             ,d_data) descrizione
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
         d_result := d_result || 'O' || d_separatore_1 || sel_asc.codice_uo ||
                     d_separatore_1 || sel_asc.descrizione || d_separatore_2;
      end loop;
      --
      return d_result;
   end; -- so4_util.get_ascendenza_ad4
   -------------------------------------------------------------------------------
   function ad4_utente_get_dati
   (
      p_utente     ad4_utenti.utente%type
     ,p_separatore varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        AD4_get_dati_utente
       DESCRIZIONE: Dato un utente di AD4, restituisce i dati anagrafici da
                    anagrafe_soggetti di AS4.
       PARAMETRI:   p_utente       Codice utente di AD4
                    p_separatore   Carattere utilizzato come separatore dei dati
                                   nella stringa di output
       RITORNA:     varchar2       Stringa contenente i dati anagrafici
       REVISIONI:
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       000   14/12/2006  VD      Prima emissione.
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
      return d_result;
   end; -- so4.util.AD4_utente_get_dati
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
      000   19/12/2006  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result     varchar2(32767);
      d_separatore varchar2(1);
   begin
      d_separatore := set_separatore_default(p_separatore, 1);
      d_result     := '';
      begin
         select 'R' || d_separatore || r.ruolo || d_separatore || r.descrizione ||
                d_separatore || u.utente
           into d_result
           from ad4_ruoli  r
               ,ad4_utenti u
          where r.ruolo = p_ruolo
            and r.descrizione = u.nominativo
            and r.ruolo = u.gruppo_lavoro
            and u.tipo_utente = 'O';
      exception
         when others then
            d_result := '';
      end;
      --
      return d_result;
   end; -- so4_util.AD4_get_ruolo
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
      002   12/09/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                  del cursore
      003   18/09/2014  VD        Eliminate condizioni di where su revisione in modifica
                                  dopo ristrutturazione viste per data pubblicazione
                                  (Feature #178)                              
      ******************************************************************************/
      d_result         afc.t_ref_cursor;
      d_ottica         anagrafe_unita_organizzative.ottica%type;
      d_data           anagrafe_unita_organizzative.dal%type;
      d_separatore_1   varchar2(1);
      d_separatore_2   varchar2(1);
      d_nominativo     ad4_utenti.nominativo%type;
      d_tipo_utente    ad4_utenti.tipo_utente%type;
      d_gruppo_lavoro  ad4_utenti.gruppo_lavoro%type;
      d_componente     componenti.ni%type;
      d_stringa_utente varchar2(1000);
   begin
      --
      -- Si valorizzano i parametri di default se nulli
      --
      d_ottica := p_ottica;
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
                   u.utente || d_separatore_1 || u.nominativo stringa_struttura
              from vista_pubb_comp     c
                  ,ad4_utenti          u
                  ,ad4_utenti_soggetti s
             where ottica = nvl(d_ottica, ottica)
               and ottica.get_ottica_istituzionale(ottica) = 'SI'
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and c.ni = s.soggetto
               and s.utente = u.utente
            union
            select ad4_get_ruolo(r.ruolo) || d_separatore_2 || 'U' || d_separatore_1 ||
                   u.utente || d_separatore_1 || u.nominativo stringa_struttura
              from vista_pubb_comp     c
                  ,vista_pubb_ruco     r
                  ,ad4_utenti          u
                  ,ad4_utenti_soggetti s
             where c.ottica = nvl(d_ottica, ottica)
               and c.id_componente = r.id_componente
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and d_data between r.dal and nvl(r.al, s_data_limite)
               and c.ni = s.soggetto
               and s.utente = u.utente
               and ad4_get_ruolo(r.ruolo) is not null
            union -- unità che non contengono componenti
            select so4_util.get_ascendenza_ad4(a.progr_unita_organizzativa
                                              ,d_data
                                              ,a.ottica
                                              ,d_separatore_1
                                              ,d_separatore_2) stringa_struttura
              from vista_pubb_anuo a
             where a.ottica = nvl(d_ottica, ottica)
               and ottica.get_ottica_istituzionale(ottica) = 'SI'
               and d_data between a.dal and nvl(a.al, s_data_limite)
               and a.progr_unita_organizzativa not in
                   (select c.progr_unita_organizzativa
                      from vista_pubb_comp c
                     where ottica = nvl(d_ottica, ottica)
                       and ottica.get_ottica_istituzionale(ottica) = 'SI'
                       and d_data between c.dal and nvl(c.al, s_data_limite));
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
                                     ,d_separatore_2) || d_stringa_utente stringa_struttura
              from vista_pubb_comp
             where ottica = nvl(d_ottica, ottica)
               and ottica.get_ottica_istituzionale(ottica) = 'SI'
               and ni = d_componente
               and d_data between dal and nvl(al, s_data_limite)
            union
            select ad4_get_ruolo(r.ruolo) || d_separatore_2 || d_stringa_utente stringa_struttura
              from vista_pubb_comp c
                  ,vista_pubb_ruco r
             where c.ottica = nvl(d_ottica, ottica)
               and c.ni = d_componente
               and c.id_componente = r.id_componente
               and d_data between c.dal and nvl(c.al, s_data_limite)
               and d_data between r.dal and nvl(r.al, s_data_limite)
               and ad4_get_ruolo(r.ruolo) is not null;
      else
         if nvl(d_gruppo_lavoro, 'def') = 'def' then
            open d_result for
               select get_ascendenza_ad4(progr_unita_organizzativa
                                        ,d_data
                                        ,ottica
                                        ,d_separatore_1
                                        ,d_separatore_2) stringa_struttura
                 from vista_pubb_anuo
                where utente_ad4 = p_utente
                  and d_data between dal and nvl(al, s_data_limite);
         end if;
      end if;
      --
      return d_result;
      --
      --
   end get_struttura;
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
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      begin
         select afc_error.ok into d_result from componenti where ni = p_ni;
      exception
         when no_data_found then
            d_result := 0;
         when too_many_rows then
            d_result := afc_error.ok;
      end;
      --
      return d_result;
   end; -- so4ad4_pkg.is_soggetto_componente
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
       003   18/09/2014  VD      Eliminate condizioni di where su revisione in modifica
                                 dopo ristrutturazione viste per data pubblicazione
                                 (Feature #178)                              
      ******************************************************************************/
      d_result varchar2(32767);
      d_ni     as4_anagrafe_soggetti.ni%type;
   begin
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
      --    Se e stato trovato l'ni, si seleziona l'utente di AD4 associato alla U.O.
      --    di assegnazione prevalente
      --
      if d_ni is not null then
         begin
            select so4_util.anuo_get_utente_ad4(progr_unita_organizzativa, trunc(sysdate))
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
             and substr(nvl(a.assegnazione_prevalente, 0), 1, 1) like '1%' and nvl(a.tipo_assegnazione, 'I') = 'I';
         exception
            when no_data_found then
               d_result := '*Componente privo di assegnazione prevalente';
            when others then
               d_result := '*Errore in lettura Componenti - ' || sqlerrm;
         end;
      end if;
      return d_result;
   end; -- so4_util.AD4_utente_get_unita_prev
-------------------------------------------------------------------------------

   function ad4_utente_get_ruoli
   (  p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            anagrafe_unita_organizzative.al%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progetto        ad4_ruoli.progetto%type default null
   ) return afc.t_ref_cursor is
   begin
    return so4ad4_pkg.ad4_utente_get_ruoli(p_utente
                                           ,p_codice_uo
                                           ,to_char(p_data,'dd/mm/yyyy')
                                           ,p_ottica
                                           ,p_amministrazione
                                           ,p_progetto
                                           );
   end;
-------------------------------------------------------------------------------
      
   function ad4_utente_get_ruoli
   (  p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            varchar2 default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progetto        ad4_ruoli.progetto%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       nome:        ad4_utente_get_ruoli.
       descrizione: dato il codice di un utente, individua l'ni del componente
                    collegato e restituisce l'elenco (codice-descrizione) dei ruoli
                    del componente nell'eventuale unita indicata
       parametri:   p_utente             codice utente di ad4
                    p_codice_uo          codice dell'unita organizzativa (facoltativo -
                                         se non specificato si considerano tutte le unita)
                    p_data               data a cui eseguire la ricerca in formato dd/mm/yyyy
                                         (facoltativa -  se non specificata si considera la data di sistema)
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
      d_ottica     componenti.ottica%type;
      d_data       componenti.dal%type;
      d_progr_unor componenti.progr_unita_organizzativa%type;      
   begin
      d_separatore  := set_separatore_default(d_separatore, 1);
      d_dati_utente := ad4_utente_get_dati(p_utente, d_separatore);
      --
      if substr(d_dati_utente, 1, 1) <> '*' then
          pos_sep  := instr(d_dati_utente, d_separatore);
          d_ni     := substr(d_dati_utente, 1, pos_sep - 1);
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
             select 'A' tipo
                  , ruolo||' - '||ad4_ruoli_tpk.get_descrizione(ruolo) descrizione
                  , ANAGRAFE_UNITA_ORGANIZZATIVA.GET_descrizione_corrente(c.progr_unita_organizzativa, nvl(c.al,to_date(3333333,'j'))) uo
                  , to_char(r.dal,'DD/MM/YYYY') decorrenza
               from vista_pubb_comp c
                   ,vista_pubb_ruco r
              where c.ni = d_ni
                and c.ottica = d_ottica
                and c.progr_unita_organizzativa =
                    nvl(d_progr_unor, c.progr_unita_organizzativa)
                and d_data between c.dal and nvl(c.al, s_data_limite)
                and c.id_componente = r.id_componente
                and d_data between r.dal and nvl(r.al, s_data_limite)
                and nvl(ad4_ruoli_tpk.get_progetto(ruolo),'%') = nvl(p_progetto,nvl(ad4_ruoli_tpk.get_progetto(ruolo),'%'))
union
 select 'R' tipo
      , ruolo||' - '||ad4_ruoli_tpk.get_descrizione(ruolo) descrizione
      , ANAGRAFE_UNITA_ORGANIZZATIVA.GET_descrizione_corrente(c.progr_unita_organizzativa, nvl(c.al,to_date(3333333,'j'))) uo
      , to_char(r.al,'DD/MM/YYYY') decorrenza
   from vista_pubb_comp c
       ,vista_pubb_ruco r
  where c.ni = d_ni
    and c.ottica = d_ottica
    and c.progr_unita_organizzativa =
        nvl(d_progr_unor, c.progr_unita_organizzativa)
    and c.id_componente = r.id_componente
    and nvl(r.al, to_date(3333333,'j')) <= d_data
    and nvl(ad4_ruoli_tpk.get_progetto(ruolo),'%') = nvl(p_progetto,nvl(ad4_ruoli_tpk.get_progetto(ruolo),'%'))
    and r.al = (select max(r1.al)
                from vista_pubb_comp c1
                   , vista_pubb_ruco r1
               where c1.ni = c.ni
                 and c1.ottica = c.ottica
                 and c.progr_unita_organizzativa = c1.progr_unita_organizzativa
                 and c1.id_componente = r1.id_componente
                 and nvl(r1.al, to_date(3333333,'j')) <= d_data
                 and nvl(ad4_ruoli_tpk.get_progetto(r1.ruolo),'%') = nvl(p_progetto,nvl(ad4_ruoli_tpk.get_progetto(r1.ruolo),'%'))
                 )  
                    
              order by 1
                      ,2;
      --
      else
         open d_result for
            select null tipo
                  ,null descrizione
                  , null uo
                  , null dal 
              from dual
             where 1=2 ;
      end if;
      --
      return d_result;
      --
   end; -- soad4_pkg.ad4_utente_get_ruoli
   
end so4ad4_pkg;
/


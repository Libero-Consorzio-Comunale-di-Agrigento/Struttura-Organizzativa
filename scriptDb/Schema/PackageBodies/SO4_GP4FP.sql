CREATE OR REPLACE package body so4_gp4fp is
   /******************************************************************************
    NOME:        so4_gp4fp.
    DESCRIZIONE: Raggruppa le funzioni di supporto per l'applicativo GP4FP
    ANNOTAZIONI: Contiene la replica di alcuni metodi del package SO4_UTIL che
                 devono accedere ai dati mediante data effettiva di validita'
                 (e non data di pubblicazione)
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   07/01/2013  VD      Prima emissione.
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '000';
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
      000   07/01/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result ottiche.ottica%type;
   begin
      --
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
   end set_ottica_default;
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
      000   07/01/2013  VD        Prima emissione.
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
   end set_data_default;
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
      000   07/01/2013  VD        Prima emissione.
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
   end set_data_default;
   -------------------------------------------------------------------------------
   function comp_get_resp_gerarchia
   (
      p_progr_uo        componenti.progr_unita_organizzativa%type
     ,p_ruolo           ruoli_componente.ruolo%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        comp_get_responsabile_gerarchia.
       DESCRIZIONE: Dato il progressivo di una unita', restituisce l'elenco dei
                    responsabili della stessa e delle unita' a livello superiore 
                    aventi l'eventuale ruolo indicato
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
       0     07/01/2013  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    componenti.ottica%type;
      d_data      componenti.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      --
      -- Impostazione parametri di default
      d_ottica    := set_ottica_default(p_ottica, p_amministrazione);
      d_data      := set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      -- Svuotamento tabella temporanea
      --
      delete from temp_so4;
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
              from unita_organizzative
             where ottica = d_ottica
               and revisione != d_revisione
               and d_data between dal and
                   nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                      ,s_data_limite)
            connect by prior id_unita_padre = id_elemento
                   and d_data between prior dal and nvl(prior al, s_data_limite)
             start with progr_unita_organizzativa = p_progr_uo
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
            select c.ni
                  ,c.ci
                  ,s.cognome
                  ,s.nome
                  ,s.sesso
                  ,s.codice_fiscale
                  ,s.data_nas
                  ,s.comune_nas
                  ,s.provincia_nas
                  ,c.progr_unita_organizzativa
                  ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                             ,d_data)
                  ,anagrafe_unita_organizzativa.get_descrizione(c.progr_unita_organizzativa
                                                               ,d_data)
              from componenti            c
                  ,attributi_componente  a
                  ,temp_so4              t
                  ,as4_anagrafe_soggetti s
             where c.ottica = d_ottica
               and t.tipo_record = 'UO'
                  --            and t.livello > 1
               and c.progr_unita_organizzativa = t.progr_uo
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and
                   nvl(decode(c.revisione_cessazione, d_revisione, null, c.al)
                      ,s_data_limite)
               and c.id_componente = a.id_componente
               and nvl(a.revisione_assegnazione, -2) != d_revisione
               and d_data between a.dal and
                   nvl(decode(a.revisione_cessazione, d_revisione, null, a.al)
                      ,s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and c.ni = s.ni
               and d_data between s.dal and nvl(s.al, s_data_limite)
             order by 2
                     ,1;
      else
         open d_result for
            select c.ni
                  ,c.ci
                  ,s.cognome
                  ,s.nome
                  ,s.sesso
                  ,s.codice_fiscale
                  ,s.data_nas
                  ,s.comune_nas
                  ,s.provincia_nas
                  ,c.progr_unita_organizzativa
                  ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                             ,d_data)
                  ,anagrafe_unita_organizzativa.get_descrizione(c.progr_unita_organizzativa
                                                               ,d_data)
              from componenti            c
                  ,attributi_componente  a
                  ,ruoli_componente      r
                  ,temp_so4              t
                  ,as4_anagrafe_soggetti s
             where c.ottica = d_ottica
               and t.tipo_record = 'UO'
                  --            and t.livello > 1
               and c.progr_unita_organizzativa = t.progr_uo
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and
                   nvl(decode(c.revisione_cessazione, d_revisione, null, c.al)
                      ,s_data_limite)
               and c.id_componente = a.id_componente
               and nvl(a.revisione_assegnazione, -2) != d_revisione
               and d_data between a.dal and
                   nvl(decode(a.revisione_cessazione, d_revisione, null, a.al)
                      ,s_data_limite)
               and tipo_incarico.get_responsabile(a.incarico) = 'SI'
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and d_data between r.dal and nvl(r.al, s_data_limite)
               and c.ni = s.ni
               and d_data between s.dal and nvl(s.al, s_data_limite)
             order by 2
                     ,1;
      end if;
      --
      return d_result;
      --
   end comp_get_resp_gerarchia;
end so4_gp4fp;
/


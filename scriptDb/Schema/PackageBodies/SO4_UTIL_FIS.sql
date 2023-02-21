CREATE OR REPLACE package body so4_util_fis is
   /******************************************************************************
    NOME:        so4_util_fis.
    DESCRIZIONE: Raggruppa le funzioni di supporto per altri applicativi relative
                 alla struttura fisica
    ANNOTAZIONI: .
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   04/05/2009  VDAVALLI  Prima emissione.
    001   23/09/2011  VDAVALLI  Modifica function get_ordinamento: se le unita'
                                non sono inserite in struttura, restituisce il
                                codice dell'unita'
    002   26/09/2011  VDAVALLI  Nuova funzione GET_ASCENDENTI_SUDD
    003   06/10/2011  VDAVALLI  Nuova funzione GET_STRINGA_ASCENDENTI
    004   09/01/2013  ADADAMO   Aggiunte funzioni unita_get_ramo e 
                                get_recapito_ascendenti (Redmine #142)
          11/01/2013  ADADAMO   Aggiunta funzione get_stringa_solo_ascendenti
                                (Redmine #144)  
    005   08/10/2014  VDAVALLI  Corretta connect by prior in get_discendenti 
                                (Issue #534)                         
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '005';

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
   function set_data_default(p_data unita_fisiche.dal%type) return unita_fisiche.dal%type is
      /******************************************************************************
      NOME:        set_data_default
      DESCRIZIONE: Se la data non viene indicata, si assume la data di sistema
      PARAMETRI:   p_data                data a cui eseguire le ricerche e/o
                                         i controlli
      RITORNA:     unita_organizzative.dal%type     data da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result unita_fisiche.dal%type;
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
   function set_data_default(p_data varchar2) return unita_fisiche.dal%type is
      /******************************************************************************
      NOME:        set_data_default
      DESCRIZIONE: Se la data non viene indicata, si assume la data di sistema
      PARAMETRI:   p_data                data a cui eseguire le ricerche e/o
                                         i controlli
      RITORNA:     unita_organizzative.dal%type     data da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result unita_fisiche.dal%type;
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
   function set_data_limite return unita_fisiche.dal%type is
      /******************************************************************************
      NOME:        set_data_limite
      DESCRIZIONE: Si imposta la data limite a 31/12/2200
      PARAMETRI:   p_data                data limite
      RITORNA:     unita_organizzative.dal%type     data da trattare
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result unita_fisiche.dal%type;
   begin
      d_result := to_date('3333333', 'j');
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
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result varchar2(1);
   begin
      d_result := p_separatore;
      if d_result is null then
         if p_tipo_separatore = 1 then
            d_result := '#';
         elsif p_tipo_separatore = 2 then
            d_result := '[';
         else
            d_result := '?';
         end if;
      end if;
      --
      return d_result;
   end;
   -------------------------------------------------------------------------------
   function get_ordinamento
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ordinamento
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità fisica
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
      
      RITORNA:     varchar2                stringa contenente la gerarchia del ramo
                                           di appartenenza della U.O.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result      varchar2(32767);
      d_data        anagrafe_unita_fisiche.dal%type;
      d_data_limite anagrafe_unita_fisiche.dal%type;
   begin
      d_data        := set_data_default(p_data);
      d_data_limite := set_data_limite;
      d_result      := '';
      for sel_asc in (select /*+ first_rows */
                       sequenza
                      ,anagrafe_unita_fisica.get_codice_uf(progr_unita_fisica, d_data) codice_uf
                        from unita_fisiche
                       where amministrazione = p_amministrazione
                         and d_data between dal and nvl(al, d_data_limite)
                      connect by prior id_unita_fisica_padre = progr_unita_fisica
                             and d_data between prior dal and nvl(prior al, d_data_limite)
                       start with progr_unita_fisica = p_progr_unfi
                              and d_data between dal and nvl(al, d_data_limite)
                       order by level desc)
      loop
         d_result := d_result || lpad(sel_asc.sequenza, 6, '0') || sel_asc.codice_uf;
      end loop;
      --
      if d_result is null then
         d_result := anagrafe_unita_fisica.get_codice_uf(p_progr_unfi, d_data);
      end if;
      --
      return d_result;
   end; -- so4_util_fis.get_ordinamento
   -------------------------------------------------------------------------------
   function get_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_ascendenti
      DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione e dal) delle unita ascendenti.
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
      RITORNA:     Afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                           di appartenenza della U.F.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_data        anagrafe_unita_fisiche.dal%type;
      d_data_limite anagrafe_unita_fisiche.dal%type;
   begin
      d_data        := set_data_default(p_data);
      d_data_limite := set_data_limite;
      --
      open d_result for
         select progr_unita_fisica
               ,anagrafe_unita_fisica.get_codice_uf(progr_unita_fisica, d_data)
               ,anagrafe_unita_fisica.get_denominazione(progr_unita_fisica, d_data)
               ,unita_fisiche.dal
               ,unita_fisiche.al
           from unita_fisiche
          where amministrazione = p_amministrazione
            and d_data between dal and nvl(al, d_data_limite)
         connect by prior id_unita_fisica_padre = progr_unita_fisica
                and d_data between prior dal and nvl(prior al, d_data_limite)
          start with progr_unita_fisica = p_progr_unfi
                 and d_data between dal and nvl(al, d_data_limite);
      --
      return d_result;
      --
   end; -- so4_util_fis.get_ascendenti
   -------------------------------------------------------------------------------
   function get_ascendenti_sudd
   (
      p_progr_unfi unita_fisiche.progr_unita_fisica%type
     ,p_data       unita_fisiche.dal%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        get_ascendenti_sudd
      DESCRIZIONE: Dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione e dal) delle unita ascendenti.
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
      RITORNA:     Afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                           di appartenenza della U.F.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   26/09/2011  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_data        anagrafe_unita_fisiche.dal%type;
      d_data_limite anagrafe_unita_fisiche.dal%type;
      d_cod_amm     anagrafe_unita_fisiche.amministrazione%type;
   begin
      d_data        := set_data_default(p_data);
      d_data_limite := set_data_limite;
      --
      begin
         d_cod_amm := anagrafe_unita_fisica.get_amministrazione(p_progr_unfi, p_data);
      exception
         when others then
            d_cod_amm := '';
      end;
      --
      open d_result for
         select progr_unita_fisica
               ,anagrafe_unita_fisica.get_codice_uf(progr_unita_fisica, d_data) codice_uf
               ,anagrafe_unita_fisica.get_denominazione(progr_unita_fisica, d_data) descr_uf
               ,unita_fisiche.dal
               ,unita_fisiche.al
               ,suddivisione_fisica.get_suddivisione(anagrafe_unita_fisica.get_id_suddivisione(progr_unita_fisica
                                                                                              ,d_data)) cod_sudd
               ,suddivisione_fisica.get_denominazione(anagrafe_unita_fisica.get_id_suddivisione(progr_unita_fisica
                                                                                               ,d_data)) descr_sudd
           from unita_fisiche
          where amministrazione = nvl(d_cod_amm, amministrazione)
            and d_data between dal and nvl(al, d_data_limite)
         connect by prior id_unita_fisica_padre = progr_unita_fisica
                and d_data between prior dal and nvl(prior al, d_data_limite)
          start with progr_unita_fisica = p_progr_unfi
                 and d_data between dal and nvl(al, d_data_limite);
      --
      return d_result;
      --
   end; -- so4_util_fis.get_ascendenti_sudd
   -------------------------------------------------------------------------------
   function get_stringa_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
     ,p_direzione       number
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_stringa_ascendenti
      DESCRIZIONE: Dato il progressivo di un'unita restituisce una stringa contenente
                   le descrizioni concatenate delle unità ascendenti
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
                   p_direzione             indica il verso di concatenazione della stringa:
                                           1: dal figlio al padre
                                           2: dal padre al figlio
      RITORNA:     varchar2                cursore contenente la gerarchia del ramo
                                           di appartenenza della U.F.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   06/10/2011  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result     varchar2(4000);
      d_data       anagrafe_unita_fisiche.dal%type;
      d_contatore  number(2);
      d_cursore    afc.t_ref_cursor;
      d_progr_unfi anagrafe_unita_fisiche.progr_unita_fisica%type;
      d_codice_uf  anagrafe_unita_fisiche.codice_uf%type;
      d_descr_uf   anagrafe_unita_fisiche.denominazione%type;
      d_dal        anagrafe_unita_fisiche.dal%type;
      d_al         anagrafe_unita_fisiche.al%type;
   begin
      d_data      := set_data_default(p_data);
      d_cursore   := so4_util_fis.get_ascendenti(p_progr_unfi, d_data, p_amministrazione);
      d_contatore := 0;
      --
      if d_cursore%isopen then
         loop
            fetch d_cursore
               into d_progr_unfi
                   ,d_codice_uf
                   ,d_descr_uf
                   ,d_dal
                   ,d_al;
            exit when d_cursore%notfound;
            d_contatore := d_contatore + 1;
            if p_direzione = 1 then
               if d_contatore = 1 then
                  d_result := d_descr_uf;
               else
                  d_result := d_result || ' ' || d_descr_uf;
               end if;
            else
               d_result := d_descr_uf || ' ' || d_result;
            end if;
         end loop;
      end if;
      --
      return d_result;
      --
   end; -- so4_util_fis.get_stringa_ascendenti
   -------------------------------------------------------------------------------
   function get_stringa_solo_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_stringa_solo_ascendenti
      DESCRIZIONE: Dato il progressivo di un'unita restituisce una stringa contenente
                   le descrizioni concatenate delle unità ascendenti
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa
                                           . se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di ricerca nella struttura
      RITORNA:     varchar2                cursore contenente la gerarchia del ramo
                                           di appartenenza della U.F.
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   06/10/2011  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result     varchar2(4000);
      d_data       anagrafe_unita_fisiche.dal%type;
      d_cursore    afc.t_ref_cursor;
      d_progr_unfi anagrafe_unita_fisiche.progr_unita_fisica%type;
      d_codice_uf  anagrafe_unita_fisiche.codice_uf%type;
      d_descr_uf   anagrafe_unita_fisiche.denominazione%type;
      d_dal        anagrafe_unita_fisiche.dal%type;
      d_al         anagrafe_unita_fisiche.al%type;
   begin
      d_data    := set_data_default(p_data);
      d_cursore := so4_util_fis.get_ascendenti(p_progr_unfi, d_data, p_amministrazione);
      --
      if d_cursore%isopen then
         loop
            fetch d_cursore
               into d_progr_unfi
                   ,d_codice_uf
                   ,d_descr_uf
                   ,d_dal
                   ,d_al;
            exit when d_cursore%notfound;
            if d_progr_unfi != p_progr_unfi then
               d_result := suddivisione_fisica.get_denominazione(anagrafe_unita_fisica.get_id_suddivisione(d_progr_unfi
                                                                                                          ,anagrafe_unita_fisica.get_dal_id(d_progr_unfi
                                                                                                                                           ,nvl(d_al
                                                                                                                                               ,d_dal)))) || ': ' ||
                           d_descr_uf || ', ' || d_result;
            end if;
         end loop;
      end if;
      --
      if d_result is not null then
         -- tolgo la virgola finale
         d_result := substr(d_result, 1, length(d_result) - 2);
      end if;
      return d_result;
      --
   end; -- so4_util_fis.get_stringa_ascendenti
   -------------------------------------------------------------------------------   
   function get_discendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
      nome:        get_discendenti
      descrizione: dato il progressivo di un'unita restituisce l'elenco
                   (progressivo, codice, descrizione e dal) delle unita
                   discendenti.
      parametri:   p_progr_unfi            unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di riferimento
      ritorna:     afc.t_ref_cursor        cursore contenente la gerarchia del ramo
                                           di appartenenza della u.f.
      revisioni:
      rev.  data        autore    descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   04/05/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result      afc.t_ref_cursor;
      d_data        anagrafe_unita_fisiche.dal%type;
      d_data_limite anagrafe_unita_fisiche.dal%type;
   begin
      d_data        := set_data_default(p_data);
      d_data_limite := set_data_limite;
      --
      open d_result for
         select progr_unita_fisica
               ,anagrafe_unita_fisica.get_codice_uf(progr_unita_fisica, d_data)
               ,anagrafe_unita_fisica.get_denominazione(progr_unita_fisica, d_data)
               ,unita_fisiche.dal
           from unita_fisiche
          where amministrazione = p_amministrazione
            and d_data between dal and nvl(al, d_data_limite)
         connect by prior progr_unita_fisica = id_unita_fisica_padre
                and d_data between prior dal and nvl(prior al, d_data_limite)
          start with progr_unita_fisica = p_progr_unfi
                 and d_data between dal and nvl(al, d_data_limite);
      --
      return d_result;
      --
   end; -- so4_util.get_discendenti
   -------------------------------------------------------------------------------
   function get_area_unita
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_id_suddivisione anagrafe_unita_fisiche.id_suddivisione%type
   ) return unita_fisiche.progr_unita_fisica%type is
      /******************************************************************************
      nome:        get_area_unita
      descrizione: dato il progressivo di un'unita restituisce il progressivo
                   dell'unita' fisica ascendente della suddivisione indicata.
      
      parametri:   p_progr_unfi            unità fisica da trattare
                   p_data                  data a cui eseguire la ricerca (facoltativa,
                                           se non indicata si assume la data di sistema)
                   p_amministrazione       amministrazione di riferimento
      ritorna:     unita_fisiche.progr_unita_fisica%type
      revisioni:
      rev.  data        autore    descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   16/01/2012  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result           unita_fisiche.progr_unita_fisica%type;
      d_ref_cursor       afc.t_ref_cursor;
      d_data             anagrafe_unita_fisiche.dal%type;
      d_progr_unfi       anagrafe_unita_fisiche.progr_unita_fisica%type;
      d_codice_uf        anagrafe_unita_fisiche.codice_uf%type;
      d_descrizione      anagrafe_unita_fisiche.denominazione%type;
      d_dal              anagrafe_unita_fisiche.dal%type;
      d_al               anagrafe_unita_fisiche.al%type;
      d_cod_suddivisione suddivisioni_fisiche.suddivisione%type;
      d_des_suddivisione suddivisioni_fisiche.denominazione%type;
      d_id_suddivisione  anagrafe_unita_fisiche.id_suddivisione%type;
   begin
      d_data       := set_data_default(p_data);
      d_result     := to_number(null);
      d_ref_cursor := so4_util_fis.get_ascendenti_sudd(p_progr_unfi => p_progr_unfi
                                                      ,p_data       => d_data);
      --
      loop
         fetch d_ref_cursor
            into d_progr_unfi
                ,d_codice_uf
                ,d_descrizione
                ,d_dal
                ,d_al
                ,d_cod_suddivisione
                ,d_des_suddivisione;
         exit when d_ref_cursor%notfound;
         d_id_suddivisione := anagrafe_unita_fisica.get_id_suddivisione(d_progr_unfi
                                                                       ,to_date('01011951'
                                                                               ,'ddmmyyyy'));
         if d_id_suddivisione = p_id_suddivisione then
            d_result := d_progr_unfi;
         end if;
      end loop;
      --
      return d_result;
      --
   end; -- so4_util.get_area_unita

   -------------------------------------------------------------------------------
   function unita_get_ramo
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione unita_fisiche.amministrazione%type
     ,p_data            unita_fisiche.dal%type
   ) return varchar2 is
      /******************************************************************************
      NOME:        unita_get_ramo
      DESCRIZIONE: Restituisce una stringa contenente la gerarchia del ramo di
                   appartenenza di una unità fisica, ogni elemento è separato dal
                   carattere ;
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_amministrazione       Amministrazione a cui appartiene l'unita'
                   p_data                  data a cui eseguire la ricerca 
      RITORNA:     varchar2                stringa contenente i campi id_elemento della
                                           gerarchia del ramo di appartenenza della U.F.
                                           concatenati con il carattere ;
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   09/01/2013  AD        Prima emissione.
      ******************************************************************************/
      d_result varchar2(32767);
   begin
      d_result := '';
      for sel_asc in (select /*+ first_rows */
                       id_elemento_fisico
                        from unita_fisiche
                       where amministrazione = p_amministrazione
                         and p_data between dal and nvl(al, to_date(3333333, 'j'))
                      connect by prior id_unita_fisica_padre = progr_unita_fisica
                             and amministrazione = p_amministrazione
                             and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       start with amministrazione = p_amministrazione
                              and progr_unita_fisica = p_progr_unfi
                              and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       order by 1 desc)
      loop
         d_result := lpad(sel_asc.id_elemento_fisico, 8, '0') || ';' || d_result;
      end loop;
      --
      return d_result;
   end; -- so4_util_fis.unita_get_ramo
   -------------------------------------------------------------------------------
   function get_recapito_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_recapito_ascendenti
      DESCRIZIONE: Restituisce una stringa contenente il recapito della unita' fisica
                   specificata, determinata esaminando gli ascendenti
                   appartenenza di una unità fisica, ogni elemento è separato da virgole
      PARAMETRI:   p_progr_unfi            Unità fisica da trattare
                   p_amministrazione       Amministrazione a cui appartiene l'unita'
                   p_data                  data a cui eseguire la ricerca 
      RITORNA:     varchar2                stringa contenente il recapito della unita'
                                           fisica
      REVISIONI:
      Rev.  Data        Autore    Descrizione
      ----  ----------  --------  ----------------------------------------------------
      000   09/01/2013  AD        Prima emissione.
      ******************************************************************************/
      d_result             varchar2(4000);
      d_ref_cursor         afc.t_ref_cursor;
      d_progr_unfi         anagrafe_unita_fisiche.progr_unita_fisica%type;
      d_codice_uf          anagrafe_unita_fisiche.codice_uf%type;
      d_descrizione        anagrafe_unita_fisiche.denominazione%type;
      d_dal                anagrafe_unita_fisiche.dal%type;
      d_al                 anagrafe_unita_fisiche.al%type;
      d_indirizzo          anagrafe_unita_fisiche.indirizzo%type;
      d_numero_civico      anagrafe_unita_fisiche.numero_civico%type;
      d_esponente_civico_1 anagrafe_unita_fisiche.esponente_civico_1%type;
      d_esponente_civico_2 anagrafe_unita_fisiche.esponente_civico_2%type;
      d_tipo_civico        anagrafe_unita_fisiche.tipo_civico%type;
      d_cap                ad4_comuni.cap%type;
      d_comune             ad4_comuni.denominazione%type;
      d_provincia          ad4_province.denominazione%type;
   begin
      d_ref_cursor := so4_util_fis.get_ascendenti(p_progr_unfi      => p_progr_unfi
                                                 ,p_data            => p_data
                                                 ,p_amministrazione => p_amministrazione);
      --
      loop
         fetch d_ref_cursor
            into d_progr_unfi
                ,d_codice_uf
                ,d_descrizione
                ,d_dal
                ,d_al;
         exit when d_ref_cursor%notfound;
         d_indirizzo := anagrafe_unita_fisica.get_indirizzo(d_progr_unfi, d_dal);
         if d_indirizzo is not null then
            d_numero_civico      := anagrafe_unita_fisica.get_numero_civico(d_progr_unfi
                                                                           ,d_dal);
            d_esponente_civico_1 := anagrafe_unita_fisica.get_esponente_civico_1(d_progr_unfi
                                                                                ,d_dal);
            d_esponente_civico_2 := anagrafe_unita_fisica.get_esponente_civico_2(d_progr_unfi
                                                                                ,d_dal);
            d_tipo_civico        := anagrafe_unita_fisica.get_tipo_civico(d_progr_unfi
                                                                         ,d_dal);
            d_cap                := ad4_comune.get_cap(anagrafe_unita_fisica.get_provincia(d_progr_unfi
                                                                                          ,d_dal)
                                                      ,anagrafe_unita_fisica.get_comune(d_progr_unfi
                                                                                       ,d_dal));
            d_comune             := ad4_comune.get_denominazione(anagrafe_unita_fisica.get_provincia(d_progr_unfi
                                                                                                    ,d_dal)
                                                                ,anagrafe_unita_fisica.get_comune(d_progr_unfi
                                                                                                 ,d_dal));
            d_provincia          := ad4_provincia.get_sigla(anagrafe_unita_fisica.get_provincia(d_progr_unfi
                                                                                               ,d_dal));
            select d_indirizzo ||
                   decode(d_numero_civico, null, null, ', ' || d_numero_civico) ||
                   decode(d_esponente_civico_1, null, null, '/' || d_esponente_civico_1) ||
                   decode(d_esponente_civico_2, null, null, '/' || d_esponente_civico_2) ||
                   decode(d_tipo_civico, null, null, '/' || d_tipo_civico) || ' ' ||
                   d_cap || ' ' || d_comune || ' (' || d_provincia || ')'
              into d_result
              from dual;
            exit;
         end if;
      end loop;
      return d_result;
   end;
end so4_util_fis;
/


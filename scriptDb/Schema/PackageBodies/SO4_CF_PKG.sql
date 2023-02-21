CREATE OR REPLACE package body so4_cf_pkg is
   /******************************************************************************
    NOME:        so4_cf_pkg.
    DESCRIZIONE: Raggruppa le funzioni di supporto per applicativi CF.
    ANNOTAZIONI: 
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   18/02/2014  AD      Prima emissione.  
    001   19/09/2014  VD      Eliminate condizioni di where non necessarie in
                              query su viste per data pubblicazione 
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '001';
   s_data_limite    constant date := to_date(3333333, 'j');
   -------------------------------------------------------------------------------
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
   end; --  so4_cf_pkg.versione
   -------------------------------------------------------------------------------
   function set_separatore_default
   (
      p_separatore      varchar2
     ,p_tipo_separatore number
   ) return varchar2 is
   begin
      return so4_util.set_separatore_default(p_separatore, p_tipo_separatore);
   end;
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
   end; -- so4_cf_pkg.AD4_utente_get_unita
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
   end; -- so4_cf_pkg.AD4_utente_get_unita
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
      d_ottica := so4_util.set_ottica_default(p_ottica);
      d_data   := so4_util.set_data_default(p_data);
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
   end; -- so4_cf_pkg.get_ascendenti
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
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_data   anagrafe_unita_organizzative.dal%type;
      d_conta  number(1);
   begin
      d_data      := so4_util.set_data_default(p_data);
   
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
   end; -- so4_cf_pkg.get_ascendenti_cf
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
      002   12/09/2013  AD        Aggiunti alias codice_uo e descrizione_uo su colonne
                                  del cursore             
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := so4_util.set_ottica_default(p_ottica);
      d_data   := so4_util.set_data_default(p_data);
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
   end; -- so4_cf_pkg.get_discendenti   
   -------------------------------------------------------------------------------      
   function utente_get_utilizzo
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor is
      /******************************************************************************
      NOME:        utente_get_utilizzo
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
      d_data        := so4_util.set_data_default(p_data => to_date(null));
      d_ottica      := nvl(p_ottica
                          ,so4_util.ad4_utente_get_ottica(p_utente => p_utente
                                                         ,p_data   => d_data));
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
      d_lista_utente := so4_util.ad4_utente_get_unita(p_utente         => p_utente
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
   end; -- so4_cf_pkg.utente_get_struttura
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
      d_data        := so4_util.set_data_default(p_data => to_date(null));
      d_ottica      := nvl(p_ottica
                          ,so4_util.ad4_utente_get_ottica(p_utente => p_utente
                                                         ,p_data   => d_data));
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
   end; -- so4_cf_pkg.utente_get_gestione
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
      d_ref_cursor := get_ascendenti(p_progr_unita_organizzativa, p_data, d_ottica);
      -- verificare se riferire la chiamata al so4_util                                             
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
   function unita_get_responsabile
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
   begin
      return so4_util.unita_get_responsabile(p_progr_unita
                                            ,p_codice_uo
                                            ,p_ottica
                                            ,p_data
                                            ,p_amministrazione);
      --
   end; -- so4_cf_pkg.unita_get_responsabile
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
   
   end; -- so4_cf_pkg.unita_get_stringa_ascendenti
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
   end; -- so4_cf_pkg.AD4_utente_get_unita_prev
   -------------------------------------------------------------------------------
   function unita_get_radice
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
   begin
      return so4_util.unita_get_radice(p_progr           => p_progr
                                      ,p_ottica          => p_ottica
                                      ,p_data            => p_data
                                      ,p_amministrazione => p_amministrazione);
      --
   end; -- so4_cf_pkg.unita_get_radice
   -------------------------------------------------------------------------------
   function unita_get_radice
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2 is
   begin
      return so4_util.unita_get_radice(p_codice_uo       => p_codice_uo
                                      ,p_ottica          => p_ottica
                                      ,p_data            => p_data
                                      ,p_amministrazione => p_amministrazione);
      --
   end; -- so4_cf_pkg.unita_get_radice
   -------------------------------------------------------------------------------
   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2 is
   begin
      return so4_util.unita_get_codice_valido(p_progr_unor, p_data);
      --
   end; -- so4_cf_pkg.unita_get_codice_valido

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
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
      d_data   date;
   begin
      d_data := so4_util.set_data_default(p_data);
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
   end; -- so4_cf_pkg.unita_get_descr_valida

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
      --
      return so4_util.comp_get_responsabile(p_ni
                                           ,p_codice_uo
                                           ,p_ruolo
                                           ,p_ottica
                                           ,p_data
                                           ,p_amministrazione);
      --
   end; -- so4_cf_pkg.comp_get_responsabile
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
      --
   end; -- so4_cf_pkg.ruolo_get_componenti
   -------------------------------------------------------------------------------   
   function unita_get_componenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
   begin
      return so4_util.unita_get_componenti(p_progr_uo
                                          ,p_ruolo
                                          ,p_ottica
                                          ,p_data
                                          ,p_amministrazione);
      --
   end; -- so4_cf_pkg.unita_get_componenti
   -------------------------------------------------------------------------------
   function unita_get_componenti
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor is
   begin
      return so4_util.unita_get_componenti(p_codice_uo
                                          ,p_ruolo
                                          ,p_ottica
                                          ,p_data
                                          ,p_amministrazione);
   end; -- so4_cf_pkg.unita_get_componenti
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
   end; -- so4_cf_pkg.unita_get_ultima_descrizione
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
   end; -- so4_cf_pkg.unita_get_ultima_descrizione
   -------------------------------------------------------------------------------
   function get_indirizzo_web
   (
      p_ni   in as4_anagrafe_soggetti.ni%type
     ,p_data in as4_anagrafe_soggetti.dal%type
   ) return as4_anagrafe_soggetti.indirizzo_web%type is
   begin
      return so4_util_as4.get_indirizzo_web(p_ni, p_data);
   end; -- so4_cf_pkg.get_indirizzo_web
   -------------------------------------------------------------------------------
   function get_icona_standard(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.icona_standard%type is
   begin
      return suddivisione_struttura.get_icona_standard(p_id_suddivisione);
   end; -- so4_cf_pkg.get_indirizzo_web
   -------------------------------------------------------------------------------
   function unita_get_responsabile_cf
   (
      p_progr_uo  anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo     ad4_ruoli.ruolo%type default null
     ,p_ottica    ottiche.ottica%type
     ,p_data      componenti.dal%type
     ,p_revisione revisioni_struttura.revisione%type
   ) return varchar2 is
      /******************************************************************************
        NOME:        unita_get_responsabile_cf.
        DESCRIZIONE: Dati progr. U.O., ottica e data restituisce i dati del componente
                     avente il ruolo indicato
                     NOTA: trattandosi di ruolo di responsabile per la contabilita'
                           finanziaria, ci si aspetta che ce ne sia solo uno.
                           In caso di responsabili multipli, si tratta quello che
                           ha il ruolo da più tempo
        PARAMETRI:   p_progr_uo           progressivo dell'unita organizzativa
                     p_ruolo              ruolo da selezionare (facoltativo)
                     p_ottica             ottica da trattare
                     p_data               data di confronto
                     p_amministrazione    amministrazione di ricerca nella struttura
                                          (facoltativa - alternativa all'ottica per la
                                          definizione dell'ottica istituzionale
        RITORNA:
        REVISIONI:
        Rev.  Data        Autore    Descrizione
        ----  ----------  ------    --------------------------------------------------
        000   24/05/2013  VD        Prima emissione.
      ******************************************************************************/
      d_result     varchar2(2000);
      d_data_ruolo ruoli_componente.dal%type;
   begin
      --
      if p_ruolo is null then
         begin
            select min(soggetti_get_descr(ni, p_data, 'COGNOME E NOME'))
              into d_result
              from vista_pubb_comp c
             where c.progr_unita_organizzativa = p_progr_uo
               and c.ottica = p_ottica
               and p_data between c.dal and nvl(c.al, s_data_limite);
         exception
            when others then
               d_result := null;
         end;
      else
         --
         -- Si seleziona la data minima di assegnazione per il ruolo
         -- e per l unita indicati
         --
         begin
            select min(dal)
              into d_data_ruolo
              from vista_pubb_ruco r
             where p_data between r.dal and nvl(r.al, s_data_limite)
               and r.ruolo = p_ruolo
               and r.id_componente in
                   (select c.id_componente
                      from vista_pubb_comp c
                     where c.ottica = p_ottica
                       and c.progr_unita_organizzativa = p_progr_uo
                       and p_data between c.dal and nvl(c.al, s_data_limite));
         exception
            when others then
               d_data_ruolo := to_date(null);
         end;
         --
         if d_data_ruolo is null then
            d_result := null;
         else
            begin
               select soggetti_get_descr(ni, p_data, 'COGNOME E NOME')
                 into d_result
                 from vista_pubb_comp c
                     ,vista_pubb_ruco r
                where c.ottica = p_ottica
                  and c.progr_unita_organizzativa = p_progr_uo
                  and p_data between c.dal and nvl(c.al, s_data_limite)
                  and c.id_componente = r.id_componente
                  and r.ruolo = p_ruolo
                  and r.dal = d_data_ruolo;
            exception
               when others then
                  null;
            end;
         end if;
      end if;
      --
      return d_result;
      --
   end; -- so4_cf_pkg.unita_get_responsabile_cf

end so4_cf_pkg;
/


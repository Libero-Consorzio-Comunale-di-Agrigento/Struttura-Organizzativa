CREATE OR REPLACE package body so4_pkg is
   /******************************************************************************
   NOME:        SO4_PKG.
   DESCRIZIONE: Procedure e Funzioni di utilita' comune per l'applicativo Struttura Organizzativa
   ANNOTAZIONI: .
   REVISIONI: .
   Rev.  Data        Autore  Descrizione.
   000   21/09/2006  VD      Prima emissione.
   001   09/08/2012  AD      Aggiunta funzione da utilizzare per l'ordinamento
                             della struttura nelle stampe
   002   15/10/2012  AD      Aggiunte funzione per fascia e peso economico per
                             stampa struttura con budget
         26/10/2012  AD      Aggiunta funzione per la formattazione delle cifre
         31/10/2012  AD      Aggiunta funzione per la totalizzazione sulle AP (REMA)
   003   26/02/2013  AD      Aggiunta funzione get_integrazione_gp (Redmine #184)
         20/03/2013  AD      Aggiunta funzione check_assegnazione_prev (Redmine #184)
         28/03/2013  AD      Aggiunta funzione get_data_riferimento
   004   09/12/2013  AD      Corretta determinazione della data di decorrenza nel
                             caso di revisione in modifica progressiva con data
                             di decorrenza già inizializzata
         18/12/2013  AD      Aggiunta funzione get_data_elab_stampa
         02/01/2014  AD      Modifica ordertree per gestire anche il progressivo dell'unita'
         28/01/2014  AD      Aggiunta funzione per determinare la sede di imputazione
   005   27/03/2014  ADADAMO Sostituiti riferimenti al so4gp4 con so4gp_pkg Feature#418
   006   24/04/2014  MMONARI Sostituiti riferimenti agli oggetti P00SO4_xxx Feature#429
   007   28/04/2014  MMONARI Issue #434 (get_data_riferimento)
   008   13/05/2014  ADADAMO Issue #444 aggiunta funzione per get dei dati di pubblicazione
                             la stringa ritornata contiene tag per HTML
         10/12/2014  MMONARI Issue #548 : nuove funzioni generiche per la determinazione delle
                             date di pubblicazione
   009   23/05/2016  ADADAMO Aggiunte funzioni invalid_object_handler e check_db_integrity
                             per gestione oggetti invalidi (Issue #179)
   010   10/05/2017  MMONARI Aggiunte funzioni get_mail_soggetto e notifica_mail (Issue #772)
   011   18/06/2018  ADADAMO Aggiunta funzione per verifica componente di integrazione con
                             AS4 in versione 4.4 o successive (Issue #28857)
   012   13/07/2018  ADADAMO Reso dinamico il tag con cui vengono effettuate le notifiche
                             via mail (Issue #793)
                     MMONARI #30648
   013   12/10/2020  MMONARI #45269 disaccoppiamento P00_RAPPORTI_INDIVIDUALI
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '013';
   s_data_limite date := to_date(3333333, 'j');
   s_oggi        date := trunc(sysdate);
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
   procedure init_cronologia
   (
      p_utente   in out varchar2
     ,p_data_agg in out date
   ) is
      /******************************************************************************
       NOME:        init_cronologia.
       DESCRIZIONE: valorizza i campi UTENTE e DATA_AGG con i relativi valori.
       PARAMETRI:   p_utente   IN OUT varchar2(8) campo UTENTE.
                    p_data_agg IN OUT varchar2(8) campo DATA_AGG.
       ECCEZIONI:   --
       REVISIONI:
       Rev. Data         Autore      Descrizione
       ---- -----------  ----------  ------------------------------------------------
       000   21/09/2006  VD          Prima emissione.
      ******************************************************************************/
   begin
      p_utente   := nvl(p_utente, si4.utente);
      p_data_agg := sysdate;
   end init_cronologia;
   ----------------------------------------------------------------------------------
   function ordertree
   (
      p_level  in number
     ,p_figlio in varchar2
     ,p_strlen in number default 16
   ) return varchar2
   /******************************************************************************
       NOME:        ordertree
       DESCRIZIONE: Gestisce l'ordinamento di un tree mantenendo la gerarchia(da usare
                    nella order by).
       NOTE:        --
      ******************************************************************************/
    is
   begin
      v_testo := substr(v_testo, 1, (p_level - 1) * nvl(p_strlen, 16)) || p_figlio;
      return v_testo;
   exception
      when no_data_found then
         return(null);
   end ordertree; -- so4_util.ordertree
   -------------------------------------------------------------------------------
   function unita_get_peso_economico
   (
      p_progr_unita anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_ottica      componenti.ottica%type default null
     ,p_data        componenti.dal%type default null
   ) return number is
      /******************************************************************************
       NOME:        unita_get_peso_economico
       DESCRIZIONE: Data una unità organizzativa restituisce il peso economico
                    combinando gli attributi del responsabile e dell'unita'
       PARAMETRI:   p_progr_unita        progressivo numerico dell'unita organizzativa
                                         (alternativa al codice)
                    p_ottica             ottica in cui eseguire la ricerca
                                         (alternativa all'amministrazione)
                    p_data               data a cui eseguire la ricerca
                                         (null = data di sistema)
       RITORNA:     valore del peso economico dell'unità organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   20/08/2012  AD        Prima emissione.
      ******************************************************************************/
      d_result number;
   begin
      begin
         select so4gp_pkg.get_valore_gradazione(nvl(incarico
                                                   ,anagrafe_unita_organizzativa.get_incarico_resp(p_progr_unita
                                                                                                  ,sysdate))
                                               ,ottica
                                               ,p_progr_unita
                                               ,suddivisione_struttura.get_suddivisione(anagrafe_unita_organizzativa.get_id_suddivisione(p_progr_unita
                                                                                                                                        ,sysdate))
                                               ,nvl(gradazione
                                                   ,anagrafe_unita_organizzativa.get_tipologia_unita(p_progr_unita
                                                                                                    ,sysdate))
                                               ,nvl(p_data, sysdate))
           into d_result
           from vista_componenti
          where progr_unita_organizzativa = p_progr_unita
            and nvl(p_data, sysdate) between dal and nvl(al, to_date(3333333, 'j'))
            and responsabile = 'SI'
            and ottica = p_ottica
            and id_componente = (select min(id_componente)
                                   from vista_componenti
                                  where progr_unita_organizzativa = p_progr_unita
                                    and nvl(p_data, sysdate) between dal and
                                        nvl(al, to_date(3333333, 'j'))
                                    and responsabile = 'SI'
                                    and ottica = p_ottica);
      exception
         when no_data_found then
            -- aggiunta per gestire il caso in cui la UO non abbia responsabile
            null;
      end;
      return d_result;
   end; -- so4_pkg.unita_get_peso_economico
   --
   function get_assegnazione_logica
   (
      p_ni              componenti.ni%type
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        comp_get_assegnazione.
       DESCRIZIONE: Dato l'ni di un componente, restituisce l'unita' di assegnazione
                    secondo queste priorita:
                    - Assegnazione istituzionale su ottica istituzionale
                    - Prima assegnazione funzionale su ottica istituzionale
                    - Prima assegnazione funzionale su ottiche non istituzionali
       PARAMETRI:   p_ni                 ni del componente
                    p_data               data a cui eseguire la ricerca (facoltativa -
                                         se non specificata si considera la data di sistema)
                    p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                         - alternativa all'ottica per la definizione
                                         dell'ottica istituzionale
       RITORNA:     componenti.progr_unita_organizzativa%type
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  --------  ----------------------------------------------------
       000   31/08/2012  MM        Prima emissione.
      ******************************************************************************/
      d_result    componenti.progr_unita_organizzativa%type;
      d_ottica    componenti.ottica%type;
      d_data      componenti.dal%type;
      d_revisione componenti.revisione_assegnazione%type;
   begin
      --
      -- Se valorizzano i parametri di default
      --
      d_ottica    := so4_util.set_ottica_default(null, p_amministrazione);
      d_data      := so4_util.set_data_default(p_data);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      -- ricerca assegnazione istituzionale su ottica istituzionale
      begin
         select progr_unita_organizzativa
           into d_result
           from vista_componenti c
          where c.ottica = d_ottica
            and c.ni = p_ni
            and nvl(c.revisione_assegnazione, -2) != d_revisione
            and d_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                   ,d_revisione
                                                   ,to_date(null)
                                                   ,c.al)
                                            ,s_data_limite)
            and nvl(c.revisione_assegnazione, -2) != d_revisione
            and nvl(c.tipo_assegnazione, 'I') = 'I'
            and dal = (select min(dal)
                         from vista_componenti c
                        where c.ottica = d_ottica
                          and c.ni = p_ni
                          and nvl(c.revisione_assegnazione, -2) != d_revisione
                          and d_data between c.dal and
                              nvl(decode(nvl(c.revisione_cessazione, -2)
                                        ,d_revisione
                                        ,to_date(null)
                                        ,c.al)
                                 ,s_data_limite)
                          and nvl(c.revisione_assegnazione, -2) != d_revisione
                          and nvl(c.tipo_assegnazione, 'I') = 'I');
      exception
         when no_data_found then
            d_result := to_number(null);
         when too_many_rows then
            d_result := to_number(null);
      end;
      -- ricerca prima assegnazione funzionale su ottica istituzionale
      if d_result is null then
         begin
            select progr_unita_organizzativa
              into d_result
              from vista_componenti c
             where c.ottica = d_ottica
               and c.ni = p_ni
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                      ,d_revisione
                                                      ,to_date(null)
                                                      ,c.al)
                                               ,s_data_limite)
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and nvl(c.tipo_assegnazione, 'I') = 'F'
               and c.dal = (select min(dal)
                              from vista_componenti c
                             where c.ottica = d_ottica
                               and c.ni = p_ni
                               and nvl(c.revisione_assegnazione, -2) != d_revisione
                               and d_data between c.dal and
                                   nvl(decode(nvl(c.revisione_cessazione, -2)
                                             ,d_revisione
                                             ,to_date(null)
                                             ,c.al)
                                      ,s_data_limite)
                               and nvl(c.revisione_assegnazione, -2) != d_revisione
                               and nvl(c.tipo_assegnazione, 'I') = 'F');
         exception
            when no_data_found then
               d_result := to_number(null);
            when too_many_rows then
               d_result := to_number(null);
         end;
      end if;
      -- ricerca prima assegnazione funzionale su ottiche non istituzionali
      if d_result is null then
         begin
            select progr_unita_organizzativa
              into d_result
              from vista_componenti c
             where c.ottica <> d_ottica
               and c.ni = p_ni
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and d_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                      ,d_revisione
                                                      ,to_date(null)
                                                      ,c.al)
                                               ,s_data_limite)
               and nvl(c.revisione_assegnazione, -2) != d_revisione
               and nvl(c.tipo_assegnazione, 'I') = 'F'
               and c.dal = (select min(dal)
                              from vista_componenti c
                             where c.ottica <> d_ottica
                               and c.ni = p_ni
                               and nvl(c.revisione_assegnazione, -2) != d_revisione
                               and d_data between c.dal and
                                   nvl(decode(nvl(c.revisione_cessazione, -2)
                                             ,d_revisione
                                             ,to_date(null)
                                             ,c.al)
                                      ,s_data_limite)
                               and nvl(c.revisione_assegnazione, -2) != d_revisione
                               and nvl(c.tipo_assegnazione, 'I') = 'F');
         exception
            when no_data_found then
               d_result := to_number(null);
            when too_many_rows then
               d_result := to_number(null);
         end;
      end if;
      --
      return d_result;
      --
   end;
   ---------------------------------------------------------------------------------------------------------------------------------
   function get_assegnazione_logica
   (
      p_ni                   componenti.ni%type
     ,p_amministrazione      amministrazioni.codice_amministrazione%type default null
     ,p_data                 componenti.dal%type default null
     ,p_ottica               componenti.ottica%type default '%'
     ,p_ottica_istituzionale ottiche.ottica_istituzionale%type default 'SI'
   ) return componenti.id_componente%type is
      /*
      -1 non esistono assegnazioni logiche
      -2 assegnazioni istituzionali multiple
      -3 assegnazioni funzionali multiple
      -4 assegnazioni istituzionali multiple su diversa amministrazione
      -5 assegnazioni funzionali multiple su diversa amministrazione
      */
      d_id_componente number;
   begin
      begin
         -- ricerca assegnazione univoca su stessa amministrazione
         select id_componente
           into d_id_componente
           from componenti c
               ,ottiche    o
          where ni = p_ni
            and c.ottica = o.ottica
            and o.amministrazione = p_amministrazione
            and (o.ottica_istituzionale = p_ottica_istituzionale or
                c.ottica like p_ottica)
            and nvl(c.revisione_assegnazione, -2) !=
                revisione_struttura.get_revisione_mod(c.ottica)
            and nvl(p_data, trunc(sysdate)) between dal and
                nvl(decode(c.revisione_cessazione
                          ,revisione_struttura.get_revisione_mod(c.ottica)
                          ,to_date(null)
                          ,c.al)
                   ,to_date(3333333, 'j'));
      exception
         when no_data_found then
            begin
               select id_componente
                 into d_id_componente
                 from componenti c
                     ,ottiche    o
                where ni = p_ni
                  and nvl(c.revisione_assegnazione, -2) !=
                      revisione_struttura.get_revisione_mod(c.ottica)
                  and nvl(p_data, trunc(sysdate)) between dal and
                      nvl(decode(c.revisione_cessazione
                                ,revisione_struttura.get_revisione_mod(c.ottica)
                                ,to_date(null)
                                ,c.al)
                         ,to_date(3333333, 'j'))
                  and o.ottica = c.ottica
                  and o.amministrazione <> p_amministrazione
                  and (o.ottica_istituzionale = p_ottica_istituzionale or
                      c.ottica like p_ottica)
                  and id_componente =
                      (select id_componente
                         from vista_componenti
                        where id_componente = c.id_componente
                          and nvl(p_data, trunc(sysdate)) between dal and
                              nvl(al, to_date(3333333, 'j'))
                          and nvl(tipo_assegnazione, 'I') = 'I'
                          and nvl(assegnazione_prevalente, -99) =
                              (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                 from vista_componenti
                                where id_componente = c.id_componente
                                  and nvl(p_data, trunc(sysdate)) between dal and
                                      nvl(al, to_date(3333333, 'j'))
                                  and nvl(tipo_assegnazione, 'I') = 'I'));
            exception
               when no_data_found then
                  -- ricerca assegnazioni funzionali su amministrazione diversa
                  begin
                     select id_componente
                       into d_id_componente
                       from componenti c
                           ,ottiche    o
                      where ni = p_ni
                        and nvl(c.revisione_assegnazione, -2) !=
                            revisione_struttura.get_revisione_mod(c.ottica)
                        and nvl(p_data, trunc(sysdate)) between dal and
                            nvl(decode(c.revisione_cessazione
                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                      ,to_date(null)
                                      ,c.al)
                               ,to_date(3333333, 'j'))
                        and o.ottica = c.ottica
                        and o.amministrazione <> p_amministrazione
                        and (o.ottica_istituzionale = p_ottica_istituzionale or
                            c.ottica like p_ottica)
                        and id_componente =
                            (select id_componente
                               from vista_componenti
                              where id_componente = c.id_componente
                                and nvl(p_data, trunc(sysdate)) between dal and
                                    nvl(al, to_date(3333333, 'j'))
                                and nvl(tipo_assegnazione, 'I') = 'F'
                                and nvl(assegnazione_prevalente, -99) =
                                    (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                       from vista_componenti
                                      where id_componente = c.id_componente
                                        and nvl(p_data, trunc(sysdate)) between dal and
                                            nvl(al, to_date(3333333, 'j'))
                                        and nvl(tipo_assegnazione, 'I') = 'F'));
                  exception
                     when no_data_found then
                        d_id_componente := -1;
                     when too_many_rows then
                        d_id_componente := -5;
                  end;
               when too_many_rows then
                  d_id_componente := -4;
            end;
         when too_many_rows then
            -- ricerca assegnazioni istituzionali su stessa amministrazione
            begin
               select id_componente
                 into d_id_componente
                 from componenti c
                     ,ottiche    o
                where ni = p_ni
                  and nvl(c.revisione_assegnazione, -2) !=
                      revisione_struttura.get_revisione_mod(c.ottica)
                  and nvl(p_data, trunc(sysdate)) between dal and
                      nvl(decode(c.revisione_cessazione
                                ,revisione_struttura.get_revisione_mod(c.ottica)
                                ,to_date(null)
                                ,c.al)
                         ,to_date(3333333, 'j'))
                  and o.ottica = c.ottica
                  and o.amministrazione = p_amministrazione
                  and (o.ottica_istituzionale = p_ottica_istituzionale or
                      c.ottica like p_ottica)
                  and id_componente =
                      (select id_componente
                         from vista_componenti
                        where id_componente = c.id_componente
                          and nvl(p_data, trunc(sysdate)) between dal and
                              nvl(al, to_date(3333333, 'j'))
                          and nvl(tipo_assegnazione, 'I') = 'I'
                          and nvl(assegnazione_prevalente, -99) =
                              (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                 from vista_componenti
                                where id_componente = c.id_componente
                                  and nvl(p_data, trunc(sysdate)) between dal and
                                      nvl(al, to_date(3333333, 'j'))
                                  and nvl(tipo_assegnazione, 'I') = 'I'));
            exception
               when no_data_found then
                  begin
                     -- ricerca assegnazioni funzionali su stessa amministrazione
                     select id_componente
                       into d_id_componente
                       from componenti c
                           ,ottiche    o
                      where ni = p_ni
                        and nvl(c.revisione_assegnazione, -2) !=
                            revisione_struttura.get_revisione_mod(c.ottica)
                        and nvl(p_data, trunc(sysdate)) between dal and
                            nvl(decode(c.revisione_cessazione
                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                      ,to_date(null)
                                      ,c.al)
                               ,to_date(3333333, 'j'))
                        and o.ottica = c.ottica
                        and o.amministrazione = p_amministrazione
                        and (o.ottica_istituzionale = p_ottica_istituzionale or
                            c.ottica like p_ottica)
                        and id_componente =
                            (select id_componente
                               from vista_componenti
                              where id_componente = c.id_componente
                                and nvl(p_data, trunc(sysdate)) between dal and
                                    nvl(al, to_date(3333333, 'j'))
                                and nvl(tipo_assegnazione, 'I') = 'F'
                                and nvl(assegnazione_prevalente, -99) =
                                    (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                       from vista_componenti
                                      where id_componente = c.id_componente
                                        and nvl(p_data, trunc(sysdate)) between dal and
                                            nvl(al, to_date(3333333, 'j'))
                                        and nvl(tipo_assegnazione, 'I') = 'F'));
                  exception
                     when no_data_found then
                        -- ricerca assegnazioni istituzionali su amministrazione diversa
                        d_id_componente := -1;
                     when too_many_rows then
                        d_id_componente := -3;
                  end;
               when too_many_rows then
                  d_id_componente := -2;
                  /*            end;
                           when too_many_rows then
                              d_id_componente := -2;
                  */
            end;
      end;
      return(d_id_componente);
   end get_assegnazione_logica;
   ----------------------------------------------------------------------------------
   function get_descr_assegnazione_logica
   (
      p_ni                   componenti.ni%type
     ,p_amministrazione      amministrazioni.codice_amministrazione%type default null
     ,p_data                 componenti.dal%type default null
     ,p_ottica               componenti.ottica%type default '%'
     ,p_ottica_istituzionale ottiche.ottica_istituzionale%type default 'SI'
   ) return varchar2 is
      /*
      -1 non esistono assegnazioni logiche
      -2 assegnazioni istituzionali multiple
      -3 assegnazioni funzionali multiple
      -4 assegnazioni istituzionali multiple su diversa amministrazione
      -5 assegnazioni funzionali multiple su diversa amministrazione
      */
      d_id_componente number;
      d_result        varchar2(2000);
      d_data          date;
   begin
      if p_data is null then
         d_data := trunc(sysdate);
      else
         d_data := p_data;
      end if;
      begin
         -- ricerca assegnazione univoca su stessa amministrazione
         select id_componente
           into d_id_componente
           from componenti c
               ,ottiche    o
          where ni = p_ni
            and c.ottica = o.ottica
            and o.amministrazione = p_amministrazione
            and (o.ottica_istituzionale = p_ottica_istituzionale or
                c.ottica like p_ottica)
            and nvl(c.revisione_assegnazione, -2) !=
                revisione_struttura.get_revisione_mod(c.ottica)
            and d_data between dal and nvl(decode(c.revisione_cessazione
                                                 ,revisione_struttura.get_revisione_mod(c.ottica)
                                                 ,to_date(null)
                                                 ,c.al)
                                          ,to_date(3333333, 'j'));
      exception
         when no_data_found then
            begin
               select id_componente
                 into d_id_componente
                 from componenti c
                     ,ottiche    o
                where ni = p_ni
                  and nvl(c.revisione_assegnazione, -2) !=
                      revisione_struttura.get_revisione_mod(c.ottica)
                  and d_data between dal and
                      nvl(decode(c.revisione_cessazione
                                ,revisione_struttura.get_revisione_mod(c.ottica)
                                ,to_date(null)
                                ,c.al)
                         ,to_date(3333333, 'j'))
                  and o.ottica = c.ottica
                  and o.amministrazione <> p_amministrazione
                  and (o.ottica_istituzionale = p_ottica_istituzionale or
                      c.ottica like p_ottica)
                  and id_componente =
                      (select id_componente
                         from vista_componenti
                        where id_componente = c.id_componente
                          and d_data between dal and nvl(al, to_date(3333333, 'j'))
                          and nvl(tipo_assegnazione, 'I') = 'I'
                          and nvl(assegnazione_prevalente, -99) =
                              (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                 from vista_componenti
                                where id_componente = c.id_componente
                                  and d_data between dal and nvl(al, to_date(3333333, 'j'))
                                  and nvl(tipo_assegnazione, 'I') = 'I'));
            exception
               when no_data_found then
                  -- ricerca assegnazioni funzionali su amministrazione diversa
                  begin
                     select id_componente
                       into d_id_componente
                       from componenti c
                           ,ottiche    o
                      where ni = p_ni
                        and nvl(c.revisione_assegnazione, -2) !=
                            revisione_struttura.get_revisione_mod(c.ottica)
                        and d_data between dal and
                            nvl(decode(c.revisione_cessazione
                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                      ,to_date(null)
                                      ,c.al)
                               ,to_date(3333333, 'j'))
                        and o.ottica = c.ottica
                        and o.amministrazione <> p_amministrazione
                        and (o.ottica_istituzionale = p_ottica_istituzionale or
                            c.ottica like p_ottica)
                        and id_componente =
                            (select id_componente
                               from vista_componenti
                              where id_componente = c.id_componente
                                and d_data between dal and nvl(al, to_date(3333333, 'j'))
                                and nvl(tipo_assegnazione, 'I') = 'F'
                                and nvl(assegnazione_prevalente, -99) =
                                    (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                       from vista_componenti
                                      where id_componente = c.id_componente
                                        and d_data between dal and
                                            nvl(al, to_date(3333333, 'j'))
                                        and nvl(tipo_assegnazione, 'I') = 'F'));
                  exception
                     when no_data_found then
                        d_id_componente := -1;
                     when too_many_rows then
                        d_id_componente := -5;
                  end;
               when too_many_rows then
                  d_id_componente := -4;
            end;
         when too_many_rows then
            -- ricerca assegnazioni istituzionali su stessa amministrazione
            begin
               select id_componente
                 into d_id_componente
                 from componenti c
                     ,ottiche    o
                where ni = p_ni
                  and nvl(c.revisione_assegnazione, -2) !=
                      revisione_struttura.get_revisione_mod(c.ottica)
                  and d_data between dal and
                      nvl(decode(c.revisione_cessazione
                                ,revisione_struttura.get_revisione_mod(c.ottica)
                                ,to_date(null)
                                ,c.al)
                         ,to_date(3333333, 'j'))
                  and o.ottica = c.ottica
                  and o.amministrazione = p_amministrazione
                  and (o.ottica_istituzionale = p_ottica_istituzionale or
                      c.ottica like p_ottica)
                  and id_componente =
                      (select id_componente
                         from vista_componenti
                        where id_componente = c.id_componente
                          and d_data between dal and nvl(al, to_date(3333333, 'j'))
                          and nvl(tipo_assegnazione, 'I') = 'I'
                          and nvl(assegnazione_prevalente, -99) =
                              (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                 from vista_componenti
                                where id_componente = c.id_componente
                                  and d_data between dal and nvl(al, to_date(3333333, 'j'))
                                  and nvl(tipo_assegnazione, 'I') = 'I'));
            exception
               when no_data_found then
                  begin
                     -- ricerca assegnazioni funzionali su stessa amministrazione
                     select id_componente
                       into d_id_componente
                       from componenti c
                           ,ottiche    o
                      where ni = p_ni
                        and nvl(c.revisione_assegnazione, -2) !=
                            revisione_struttura.get_revisione_mod(c.ottica)
                        and d_data between dal and
                            nvl(decode(c.revisione_cessazione
                                      ,revisione_struttura.get_revisione_mod(c.ottica)
                                      ,to_date(null)
                                      ,c.al)
                               ,to_date(3333333, 'j'))
                        and o.ottica = c.ottica
                        and o.amministrazione = p_amministrazione
                        and (o.ottica_istituzionale = p_ottica_istituzionale or
                            c.ottica like p_ottica)
                        and id_componente =
                            (select id_componente
                               from vista_componenti
                              where id_componente = c.id_componente
                                and d_data between dal and nvl(al, to_date(3333333, 'j'))
                                and nvl(tipo_assegnazione, 'I') = 'F'
                                and nvl(assegnazione_prevalente, -99) =
                                    (select min(to_char(nvl(assegnazione_prevalente, -99)))
                                       from vista_componenti
                                      where id_componente = c.id_componente
                                        and d_data between dal and
                                            nvl(al, to_date(3333333, 'j'))
                                        and nvl(tipo_assegnazione, 'I') = 'F'));
                  exception
                     when no_data_found then
                        -- ricerca assegnazioni istituzionali su amministrazione diversa
                        d_id_componente := -1;
                     when too_many_rows then
                        d_id_componente := -3;
                  end;
               when too_many_rows then
                  d_id_componente := -2;
            end;
      end;
      if d_id_componente = -1 then
         d_result := 'Nessuna assegnazione';
      elsif d_id_componente = -2 then
         d_result := 'Assegnazioni istituzionali multiple';
      elsif d_id_componente = -3 then
         d_result := 'Assegnazioni funzionali multiple';
      elsif d_id_componente = -4 then
         d_result := 'Assegnazioni istituzionali multiple su amministrazioni diverse';
      elsif d_id_componente = -5 then
         d_result := 'Assegnazioni funzionali multiple su amministrazioni diverse';
      elsif ottica.get_amministrazione(componente.get_ottica(d_id_componente)) <>
            p_amministrazione then
         select descrizione || ' (' || codice_uo || ')' || ' - Incarico : ' ||
                nvl(tipo_incarico.get_descrizione(attributo_componente.get_incarico_valido(c.id_componente
                                                                                          ,d_data
                                                                                          ,c.ottica))
                   ,'non definito') || ' - Assegnazione su diversa amministrazione'
           into d_result
           from anagrafe_unita_organizzative a
               ,componenti                   c
          where c.id_componente = d_id_componente
            and a.progr_unita_organizzativa = c.progr_unita_organizzativa
            and d_data between a.dal and nvl(a.al, to_date(3333333, 'j'));
      else
         select descrizione || ' (' || codice_uo || ')' || ' - Incarico : ' ||
                nvl(tipo_incarico.get_descrizione(attributo_componente.get_incarico_valido(c.id_componente
                                                                                          ,d_data
                                                                                          ,c.ottica))
                   ,'non definito')
           into d_result
           from anagrafe_unita_organizzative a
               ,componenti                   c
          where c.id_componente = d_id_componente
            and a.progr_unita_organizzativa = c.progr_unita_organizzativa
            and d_data between a.dal and nvl(a.al, to_date(3333333, 'j'));
      end if;
      return(d_result);
   end get_descr_assegnazione_logica;
   -------------------------------------------------------------------------------
   function unita_get_fascia
   (
      p_progr_unita anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_ottica      componenti.ottica%type default null
     ,p_data        componenti.dal%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        unita_get_fascia
       DESCRIZIONE: Data una unità organizzativa restituisce la fascia
                    combinando gli attributi del responsabile e dell'unita'
       PARAMETRI:   p_progr_unita        progressivo numerico dell'unita organizzativa
                                         (alternativa al codice)
                    p_ottica             ottica in cui eseguire la ricerca
                                         (alternativa all'amministrazione)
                    p_data               data a cui eseguire la ricerca
                                         (null = data di sistema)
       RITORNA:     codice del tipo rapporto associato all'unità organizzativa
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   12/10/2012  AD        Prima emissione.
      ******************************************************************************/
      d_result varchar2(10);
   begin
      begin
         select so4gp_pkg.get_fascia_gradazione(nvl(incarico
                                                   ,anagrafe_unita_organizzativa.get_incarico_resp(p_progr_unita
                                                                                                  ,sysdate))
                                               ,ottica
                                               ,p_progr_unita
                                               ,suddivisione_struttura.get_suddivisione(anagrafe_unita_organizzativa.get_id_suddivisione(p_progr_unita
                                                                                                                                        ,sysdate))
                                               ,nvl(gradazione
                                                   ,anagrafe_unita_organizzativa.get_tipologia_unita(p_progr_unita
                                                                                                    ,sysdate))
                                               ,nvl(p_data, sysdate))
           into d_result
           from vista_componenti
          where progr_unita_organizzativa = p_progr_unita
            and nvl(p_data, sysdate) between dal and nvl(al, to_date(3333333, 'j'))
            and responsabile = 'SI'
            and ottica = p_ottica
            and id_componente = (select min(id_componente)
                                   from vista_componenti
                                  where progr_unita_organizzativa = p_progr_unita
                                    and nvl(p_data, sysdate) between dal and
                                        nvl(al, to_date(3333333, 'j'))
                                    and responsabile = 'SI'
                                    and ottica = p_ottica);
      end;
      return d_result;
      --
   end; -- so4_pkg.unita_get_peso_economico
   function get_totale_per_suddivisione
   (
      p_progr_uo in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica   in anagrafe_unita_organizzative.ottica%type
     ,p_data     in date
   ) return number is
      d_result             number := 0;
      d_ref_cursor         afc.t_ref_cursor;
      d_progr_uo           anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo          anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione        anagrafe_unita_organizzative.descrizione%type;
      d_dal                anagrafe_unita_organizzative.dal%type;
      d_al                 anagrafe_unita_organizzative.al%type;
      d_suddivisioni_somma registro.valore%type := registro_utility.leggi_stringa('PRODUCTS/SO4/STAMPE/BUDGET'
                                                                                 ,'Somma su tipo suddivisione'
                                                                                 ,0);
   begin
      d_ref_cursor := so4_util.get_discendenti(p_progr_uo, p_data, p_ottica);
      loop
         fetch d_ref_cursor
            into d_progr_uo
                ,d_codice_uo
                ,d_descrizione
                ,d_dal
                ,d_al;
         exit when d_ref_cursor%notfound;
         if instr(d_suddivisioni_somma
                 ,suddivisione_struttura.get_suddivisione(so4_util.anuo_get_id_suddivisione(d_progr_uo
                                                                                           ,p_data))) != 0 and
            p_progr_uo != d_progr_uo then
            d_result := d_result +
                        nvl(so4_pkg.unita_get_peso_economico(d_progr_uo, p_ottica, p_data)
                           ,0);
         end if;
      end loop;
      return d_result;
   end;
   function get_totale_ap
   (
      p_progr_uo in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica   in anagrafe_unita_organizzative.ottica%type
     ,p_data     in date
   ) return number is
      d_result      number := 0;
      d_ref_cursor  afc.t_ref_cursor;
      d_progr_uo    anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo   anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione anagrafe_unita_organizzative.descrizione%type;
      d_dal         anagrafe_unita_organizzative.dal%type;
      d_al          anagrafe_unita_organizzative.al%type;
   begin
      d_ref_cursor := so4_util.get_discendenti(p_progr_uo, p_data, p_ottica);
      loop
         fetch d_ref_cursor
            into d_progr_uo
                ,d_codice_uo
                ,d_descrizione
                ,d_dal
                ,d_al;
         exit when d_ref_cursor%notfound;
         if suddivisione_struttura.get_suddivisione(so4_util.anuo_get_id_suddivisione(d_progr_uo
                                                                                     ,p_data)) = '14' then
            d_result := d_result +
                        nvl(so4_pkg.unita_get_peso_economico(d_progr_uo, p_ottica, p_data)
                           ,0);
         end if;
      end loop;
      return d_result;
   end;
   function get_desc_totali(p_ottica in ottiche.ottica%type) return varchar2 is
      d_result  varchar2(2000) := null;
      d_stringa varchar2(2000);
   begin
      d_stringa := registro_utility.leggi_stringa('PRODUCTS/SO4/STAMPE/BUDGET'
                                                 ,'Somma su tipo suddivisione'
                                                 ,0);
      while instr(d_stringa, '|') != 0
      loop
         begin
            select d_result || descrizione || ', '
              into d_result
              from suddivisioni_struttura
             where suddivisione = substr(d_stringa, 1, instr(d_stringa, '|') - 1)
               and ottica = p_ottica;
         exception
            when others then
               null;
         end;
         d_stringa := substr(d_stringa, instr(d_stringa, '|') + 1);
      end loop;
      return substr(d_result, 1, length(d_result) - 2);
   end;
   ----------------------------------------------------------------------------------
   function formatta_numero(p_numero in number) return varchar2 is
   begin
      if p_numero = 0 then
         return p_numero;
      else
         return to_char(p_numero, '999G999G999D99');
      end if;
   end;
   function get_next_codice_uo(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return anagrafe_unita_organizzative.codice_uo%type is
      d_numerazione         varchar2(2);
      d_ret_value           anagrafe_unita_organizzative.codice_uo%type;
      d_ret_value_eliminate anagrafe_unita_organizzative.codice_uo%type;
   begin
      d_numerazione := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO/' ||
                                                          p_codice_amministrazione
                                                         ,'Inizializzazione Automatica UO'
                                                         ,0)
                          ,'NO');
      if d_numerazione = 'SI' then
         begin
            select max(to_number(codice_uo))
              into d_ret_value
              from anagrafe_unita_organizzative anuo
             where anuo.amministrazione = p_codice_amministrazione
               and afc.is_number(codice_uo) = 1;
         exception
            when others then
               d_ret_value := null;
         end;
         begin
            select nvl(max(to_number(codice_uo)), 0)
              into d_ret_value_eliminate
              from anagrafe_unita_eliminate anue
             where anue.amministrazione = p_codice_amministrazione
               and afc.is_number(codice_uo) = 1;
         exception
            when others then
               d_ret_value := null;
         end;
         d_ret_value := to_char(greatest(nvl(to_number(d_ret_value), 0)
                                        ,nvl(to_number(d_ret_value_eliminate), 0)) + 1);
      end if;
      return d_ret_value;
   end;
   ----------------------------------------------------------------------------------
   function get_next_codice_uf(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return anagrafe_unita_fisiche.codice_uf%type is
      d_numerazione varchar2(2);
      d_ret_value   anagrafe_unita_fisiche.codice_uf%type;
   begin
      d_numerazione := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO/' ||
                                                          p_codice_amministrazione
                                                         ,'Inizializzazione Automatica UF'
                                                         ,0)
                          ,'NO');
      if d_numerazione = 'SI' then
         begin
            select max(to_number(codice_uf))
              into d_ret_value
              from anagrafe_unita_fisiche anuf
             where anuf.amministrazione = p_codice_amministrazione
               and afc.is_number(codice_uf) = 1;
            d_ret_value := to_char(nvl(to_number(d_ret_value), 0) + 1);
         exception
            when others then
               d_ret_value := null;
         end;
      end if;
      return d_ret_value;
   end;
   function get_integrazione_gp return varchar2 is
   begin
      --#429
      if so4gp_pkg.is_int_gp4 or so4gp_pkg.is_int_gps then
         return 'SI';
      else
         return 'NO';
      end if;
   end;

   function get_integrazione_as4new return varchar2 is
      d_is_intas4new  varchar2(2);
      d_utente_oracle varchar2(2000) := sys_context('userenv', 'CURRENT_USER');
   begin
      --#429
      begin
         select instr(installazione, 'AS4NEW')
           into d_is_intas4new
           from ad4_istanze
         -- Bug#483
          where user_oracle = d_utente_oracle
            and progetto = 'SI4SO'
            and installazione is not null;
      exception
         when others then
            d_is_intas4new := 0;
      end;
      if d_is_intas4new = 0 then
         return 'NO';
      else
         return 'SI';
      end if;
   end;

   function check_assegnazione_prev
   (
      p_valore in varchar2
     ,p_ottica in ottiche.ottica%type
   ) return number is
   begin
      if get_integrazione_gp = 'NO' then
         -- se non c'è integrazione ritorna 1 per tutte le codifiche
         return 1;
      else
         -- c'è integrazione, devo verificare se l'ottica è gestita
         if so4gp_pkg.is_struttura_integrata('', p_ottica) = 'SI' then
            --#429
            if p_valore like '1%' then
               return 0;
            else
               return 1;
            end if;
         else
            return 1;
         end if;
      end if;
   end;
   function get_data_riferimento(p_ottica in ottiche.ottica%type) return date
   /******************************************************************************
       NOME:        get_data_riferimento
       DESCRIZIONE: Data una ottica determina a quale data deve essere interrogato
                    l'albero della struttura ragionando sulla presenza di una revisione
                    in modifica retroattiva
       PARAMETRI:   p_ottica            ottica di cui determinare la data di riferimento
       RITORNA:     data di riferimento per l'interrogazione dell'albero
       REVISIONI:
       Rev.  Data        Autore    Descrizione
       ----  ----------  ------    --------------------------------------------------
       000   28/03/2013  AD        Prima emissione.
       001   09/12/2013  AD        Corretta determinazione della data di decorrenza nel
                                   caso di revisione in modifica progressiva con data
                                   di decorrenza già inizializzata
      ******************************************************************************/
    is
      d_data          date := trunc(sysdate);
      d_revisione_mod revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(p_ottica);
      d_ultima_rev    revisioni_struttura.revisione%type := revisione_struttura.get_ultima_revisione(p_ottica);
   begin
      if d_revisione_mod != -1 then
         -- esiste revisione in modifica
         if nvl(revisione_struttura.get_tipo_revisione(p_ottica, d_revisione_mod), 'N') = 'R' then
            -- revisione retroattiva
            d_data := trunc(revisione_struttura.get_dal(p_ottica, d_revisione_mod));
         else
            -- revisione progressiva
            if d_ultima_rev = -1 then
               d_data := trunc(sysdate);
            else
               if revisione_struttura.get_dal(p_ottica, d_revisione_mod) is null then
                  --#434
                  if revisione_struttura.get_dal(p_ottica, d_ultima_rev) > trunc(sysdate) then
                     d_data := trunc(nvl(revisione_struttura.get_dal(p_ottica
                                                                    ,d_ultima_rev) + 1
                                        ,trunc(sysdate)));
                  else
                     d_data := trunc(sysdate);
                  end if;
               else
                  d_data := revisione_struttura.get_dal(p_ottica, d_revisione_mod);
               end if;
            end if;
         end if;
      else
         d_data := trunc(sysdate);
      end if;
      return d_data;
   end;
   function get_data_elab_stampa(p_ottica in ottiche.ottica%type) return date is
      d_result date;
   begin
      if revisione_struttura.get_ultima_revisione(p_ottica) = -1 then
         -- prima revisione
         d_result := trunc(sysdate);
      else
         d_result := nvl(revisione_struttura.get_dal(p_ottica
                                                    ,revisione_struttura.get_revisione_mod(p_ottica))
                        ,sysdate);
      end if;
      return d_result;
   end;
   function get_sede(p_numero in imputazioni_bilancio.numero%type) return varchar2 is
      d_result    varchar2(2000);
      dummy       varchar2(1);
      d_statement varchar2(2000);
   begin
      begin
         select 'x'
           into dummy
           from user_objects
          where object_name = 'P00SO4_GP4SO4'
            and object_type = 'SYNONYM';
         d_statement := 'begin select P00SO4_GP4SO4.get_desc_sede(' ||
                        nvl(to_char(p_numero), '0') || ') into :d_res from dual; end;';
         execute immediate d_statement
            using in out d_result;
      exception
         when no_data_found then
            d_result := '';
      end;
      return d_result;
   end;
   function get_mail_soggetto(p_ni in anagrafe_soggetti.ni%type) --#772
    return anagrafe_soggetti.indirizzo_web%type is
      d_statement varchar2(2000); --#45269
      d_result    anagrafe_soggetti.indirizzo_web%type;
   begin
      begin
         select indirizzo_web into d_result from anagrafe_soggetti where ni = p_ni;
      exception
         when no_data_found then
            d_result := '';
      end;
      if d_result is null then
         d_result := soggetti_rubrica_pkg.get_email(p_ni);
      end if;
      if d_result is null then
         begin
            --#45269
            d_statement := 'select max(r.e_mail)
              from p00_rapporti_individuali r
             where ni = (select ni_gp4 from p00_dipendenti_soggetti where ni_as4 = ' || p_ni ||')';
            execute immediate d_statement
               into d_result;
         exception
            when no_data_found then
               d_result := '';
         end;
      end if;
      return d_result;
   end;
   procedure notifica_mail --#772
   (
      p_name         varchar2
     ,p_sender_email varchar2
     ,p_recipient    varchar2
     ,p_subject      varchar2
     ,p_text_msg     varchar2
   ) is
      d_notifica_tag     varchar2(100);
      d_err              integer;
      d_sender_email     varchar2(2000);
      v_destinatari      varchar2(2000);
      v_nome             varchar2(2000);
      messaggio_completo varchar2(32000) := p_text_msg;
   begin
      d_notifica_tag := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                          ,'TagInvioMail'
                                                          ,0)
                           ,'mail'); --793 reso dinamico da DB
      d_sender_email := p_sender_email;
      v_destinatari  := p_recipient;
      if p_name is null then
         raise_application_error(-20999, 'Impossibile inviare mail a ' || p_name);
      else
         d_err := ad4_si4cim.initializemessage(d_notifica_tag);
         /*-----------------------------------------------------
               Inizializza il Mittente.
         -----------------------------------------------------*/
         ad4_si4cim.setsender(senderip    => ''
                             ,sendername  => ''
                             ,id          => ''
                             ,name        => p_name
                             ,company     => ''
                             ,address     => ''
                             ,code        => ''
                             ,city        => ''
                             ,province    => ''
                             ,state       => ''
                             ,email       => d_sender_email
                             ,phonenumber => ''
                              -- chi riceve la mail se la vede autoinviata
                             ,faxnumber => '');
         /*-----------------------------------------------------
                      Inizializza il Destinatario.
         -----------------------------------------------------*/
         while v_destinatari is not null
         loop
            v_nome := afc.get_substr(p_stringa => v_destinatari, p_separatore => ';');
            ad4_si4cim.addrecipient(id          => ''
                                   ,name        => v_nome
                                   ,company     => ''
                                   ,address     => ''
                                   ,code        => ''
                                   ,city        => ''
                                   ,province    => ''
                                   ,state       => ''
                                   ,email       => v_nome
                                   ,phonenumber => ''
                                   ,faxnumber   => '');
         end loop;
         /*-----------------------------------------------------
                  Predispone l'oggetto del messaggio.
         -----------------------------------------------------*/
         ad4_si4cim.setsubject(p_subject);
         /*-----------------------------------------------------
                  Predispone il testo del messaggio.
         -----------------------------------------------------*/
         ad4_si4cim.settext(messaggio_completo);
         /*-----------------------------------------------------
                         Invia il messaggio.
         -----------------------------------------------------*/
         d_err := ad4_si4cim.send;
      end if;
   end notifica_mail;
   function get_dati_pubblicazione
   (
      p_oggetto in varchar2
     ,p_pk      in number
   ) return varchar2 is
      d_result varchar2(2000);
   begin
      --#444
      if p_oggetto = 'COMPONENTI' then
         select 'Pubblicazione: <b>dal ' || to_char(dal_pubb, 'dd/mm/yyyy') || ' ' ||
                decode(al_pubb, null, ' ', 'al ' || to_char(al_pubb, 'dd/mm/yyyy')) ||
                '</b>'
           into d_result
           from componenti
          where id_componente = p_pk;
      elsif p_oggetto = 'ATTRIBUTI_COMPONENTE' then
         select 'Pubblicazione: <b>dal ' || to_char(dal_pubb, 'dd/mm/yyyy') || ' ' ||
                decode(al_pubb, null, ' ', 'al ' || to_char(al_pubb, 'dd/mm/yyyy')) ||
                '</b>'
           into d_result
           from attributi_componente
          where id_attr_componente = p_pk;
      elsif p_oggetto = 'RUOLI_COMPONENTE' then
         select 'Pubblicazione: <b>dal ' || to_char(dal_pubb, 'dd/mm/yyyy') || ' ' ||
                decode(al_pubb, null, ' ', 'al ' || to_char(al_pubb, 'dd/mm/yyyy')) ||
                '</b>'
           into d_result
           from ruoli_componente
          where id_ruolo_componente = p_pk;
      end if;
      return d_result;
   end;
   function al_pubblicazione
   (
      p_operazione   in varchar2
     ,p_contesto     in varchar2
     ,p_al_pubb_prec in date default to_date(3333333, 'j')
     ,p_new_al       in date default to_date(3333333, 'j')
     ,p_old_al       in date default to_date(3333333, 'j')
     ,p_al_limite    in date default to_date(3333333, 'j')
     ,p_intersezione in number default 0
   ) return date is
      /***********************************************************************************
               NOME:        Determina la date di termine della pubblicazione del periodo
                            indicato in base  all'operazione e al contesto
               DESCRIZIONE: #548
      ************************************************************************************/
      d_al_pubb      date;
      d_al_pubb_prec date;
   begin
      d_al_pubb_prec := nvl(p_al_pubb_prec, to_date(3333333, 'j'));
      if p_operazione = 'I' then
         -- creazione di un nuovo record
         select decode(least(nvl(p_new_al, to_date(3333333, 'j'))
                            ,nvl(p_al_limite, to_date(3333333, 'j')))
                      ,to_date(3333333, 'j')
                      ,to_date(null)
                      ,least(nvl(p_new_al, to_date(3333333, 'j'))
                            ,nvl(p_al_limite, to_date(3333333, 'j'))))
           into d_al_pubb
           from dual;
      elsif p_operazione = 'E' then
         -- eliminazione logica di un record
         d_al_pubb := least(nvl(d_al_pubb_prec, to_date(3333333, 'j')), s_oggi);
      elsif p_operazione = 'U' then
         -- modifica degli estremi di un record
         if nvl(p_new_al, to_date(3333333, 'j')) <> nvl(p_old_al, to_date(3333333, 'j')) then
            if nvl(p_new_al, to_date(3333333, 'j')) >
               nvl(p_old_al, to_date(3333333, 'j')) then
               if nvl(p_old_al, to_date(3333333, 'j')) < s_oggi and
                  nvl(p_new_al, to_date(3333333, 'j')) < s_oggi then
                  d_al_pubb := d_al_pubb_prec;
               elsif (nvl(p_old_al, to_date(3333333, 'j')) >= s_oggi and
                     nvl(p_new_al, to_date(3333333, 'j')) > s_oggi) or
                     (nvl(p_old_al, to_date(3333333, 'j')) < s_oggi and
                     nvl(p_new_al, to_date(3333333, 'j')) >= s_oggi and
                     p_intersezione = 0) then
                  d_al_pubb := least(nvl(p_new_al, to_date(3333333, 'j'))
                                    ,nvl(p_al_limite, to_date(3333333, 'j')));
               elsif nvl(p_old_al, to_date(3333333, 'j')) < s_oggi and
                     nvl(p_new_al, to_date(3333333, 'j')) >= s_oggi and
                     p_intersezione = 1 then
                  d_al_pubb := nvl(p_new_al, to_date(3333333, 'j'));
               end if;
            else
               if nvl(p_old_al, to_date(3333333, 'j')) < s_oggi and
                  nvl(p_new_al, to_date(3333333, 'j')) < s_oggi then
                  d_al_pubb := d_al_pubb_prec;
               elsif nvl(p_old_al, to_date(3333333, 'j')) >= s_oggi and
                     nvl(p_new_al, to_date(3333333, 'j')) < s_oggi then
                  d_al_pubb := s_oggi;
               elsif nvl(p_old_al, to_date(3333333, 'j')) >= s_oggi and
                     nvl(p_new_al, to_date(3333333, 'j')) >= s_oggi then
                  d_al_pubb := nvl(p_new_al, to_date(3333333, 'j'));
               end if;
            end if;
         else
            d_al_pubb := d_al_pubb_prec;
         end if;
      end if;
      if nvl(d_al_pubb, to_date(3333333, 'j')) = to_date(3333333, 'j') then
         return to_date(null);
      else
         return d_al_pubb;
      end if;
   end;
   function dal_pubblicazione
   (
      p_operazione    in varchar2
     ,p_contesto      in varchar2
     ,p_dal_pubb_prec in date default to_date(3333333, 'j')
     ,p_new_dal       in date default to_date(2222222, 'j')
     ,p_old_dal       in date default to_date(2222222, 'j')
     ,p_dal_limite    in date default to_date(2222222, 'j')
   ) return date is
      /***********************************************************************************
               NOME:        Determina la date di decorrenza della pubblicazione del periodo
                            indicato in base  all'operazione e al contesto
               DESCRIZIONE: #548
      ************************************************************************************/
      d_dal_pubb date;
   begin
      if p_operazione = 'I' then
         -- creazione di un nuovo record
         d_dal_pubb := greatest(s_oggi, p_new_dal, p_dal_limite);
      elsif p_operazione = 'E' then
         -- eliminazione logica di un record
         d_dal_pubb := p_dal_pubb_prec;
      elsif p_operazione = 'U' then
         -- modifica degli estremi di un record
         if p_new_dal <> p_old_dal then
            if p_new_dal < p_old_dal then
               if p_old_dal > s_oggi and p_new_dal <= s_oggi then
                  d_dal_pubb := s_oggi;
               elsif p_old_dal >= s_oggi and p_new_dal >= s_oggi then
                  d_dal_pubb := p_new_dal;
               elsif p_old_dal <= s_oggi and p_new_dal <= s_oggi then
                  d_dal_pubb := p_dal_pubb_prec;
               end if;
            else
               if p_old_dal <= s_oggi and p_new_dal < s_oggi then
                  d_dal_pubb := p_dal_pubb_prec;
               elsif p_old_dal < s_oggi and p_new_dal >= s_oggi then
                  d_dal_pubb := p_dal_pubb_prec;
               elsif p_old_dal >= s_oggi and p_new_dal >= s_oggi then
                  d_dal_pubb := p_new_dal;
               end if;
            end if;
         else
            d_dal_pubb := p_dal_pubb_prec;
         end if;
      end if;
      return d_dal_pubb;
   end;
   function invalid_object_handler return number is
      ret_val number;
   begin
      select count(*) into ret_val from vista_oggetti_invalidi;
      return ret_val;
   end;
   function check_db_integrity return number is
      w_max_constraints      number;
      w_max_triggers         number;
      w_disabled_constraints number;
      w_disabled_triggers    number;
      ret_val                number;
   begin
      w_max_constraints := nvl(registro_utility.leggi_stringa('DB_USERS/' || user
                                                             ,'DisabledConstraints'
                                                             ,0)
                              ,0);
      w_max_triggers    := nvl(registro_utility.leggi_stringa('DB_USERS/' || user
                                                             ,'DisabledTriggers'
                                                             ,0)
                              ,0);
      select count(*)
        into w_disabled_constraints
        from vista_oggetti_invalidi
       where object_type = 'CONSTRAINT'
         and trigger_status = 'DISABLED';
      select count(*)
        into w_disabled_triggers
        from vista_oggetti_invalidi
       where object_type = 'TRIGGER'
         and trigger_status = 'DISABLED';
      if w_disabled_constraints > w_max_constraints or
         w_disabled_triggers > w_max_triggers then
         ret_val := -1;
      else
         ret_val := 0;
      end if;
      return ret_val;
   end;

   --#30648
   function check_ruolo_riservato(p_ruolo in ruoli_componente.ruolo%type) return number is
      ret_val number := 0;
   begin
      begin
         select distinct 1
           into ret_val
           from registro
          where stringa = 'Gestione ruoli'
            and valore <> '(nessuno)'
            and instr(valore, p_ruolo || ',') > 0;
      exception
         when others then
            ret_val := 0;
      end;
      return ret_val;
   end;
end so4_pkg;
/


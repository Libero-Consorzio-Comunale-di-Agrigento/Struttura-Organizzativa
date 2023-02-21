CREATE OR REPLACE package body so4_ciweb is
   /******************************************************************************
    NOME:        so4_ciweb
    DESCRIZIONE: Contiene  procedure e function fatti per ciweb
    REVISIONI:
    Rev. Data        Autore  Descrizione
    ---- ----------  ------  ----------------------------------------------------
    000                      Prima emissione
    001  05/08/2008  SM      Inserimento commento
    002  04/03/2010  VD      Nuove funzioni per gestione consegnatario
    003  01/09/2010  VD      Nuove funzioni per gestione sub-consegnatario
    004  10/12/2010  VD      Correzione per gestione cursori aperti
    005  13/12/2010  VD      Modifiche x gestione consegnatario mancante
    006  05/01/2011  VD      Modifiche per gestione ultimi dati validi per
                             unita' organizzative
    007  14/03/2011  VD      Aggiunte funzioni INS_ANA_UNOR e INS_ANA_UNFI per
                             trascodifiche da GE4 con SO4 non popolato
    008  23/03/2011  VD      Aggiunta procedura INS_CENTRI per trascodifiche
                             da CI4 con SO4 non popolato
    009  24/05/2011  MM      Modificate funzioni INS_ANA_UNOR e INS_ANA_UNFI
                             (gestione dei parametri p_id_suddivisione, p_ottica
                             e p_amministrazione)
    010  10/10/2011  VD      Modificata funzione GET_ANA_UNITA_FISICA_CAMPI: i
                             dati vengono selezionati dalla vista SO_ANA_UNITA_FISICHE
                             invece che dalla tabella ANAGRAFE_UNITA_FISICHE
    011  25/01/2012  VD      Corretta funzione GET_ANA_UNITA_ORG_CAMPI per gestione
                             data in SQL dinamico
    012  10/10/2012  VD      Modifiche post collaudo regione Calabria:
                             gestione reperimento dati unita' chiuse
    013  08/03/2013  VD      Nuova funzione: reperimento id_soggetto abbinato a
                             matricola (ci)
    014  12/03/2013  VD      Correzione errore su funzione se_competenza_unita
                             (rilevato al S.Orsola)
    015  28/05/2013  VD      Nuova funzione: reperimento ci abbinato a id_soggetto
    016  02/07/2013  VD      Modifica funzione SE_ESISTE_RELAZIONE e nuove funzioni
                             GET_UNITA_SOGGETTO e SE_COMBINAZIONE_VALIDA
    017  30/01/2014  VD      Modifica funzione GET_CONSEGNATARI per ricerca
                             ottica di riferimento
    018  08/05/2014  VD      Correzione funzione GET_AREA_UNITA per gestione data
                             di riferimento nulla.
         17/12/2014  MM      #552 - corretti riferimenti a so4_centi in ins_centri
         09/02/2016  MM      #683 Nuova function get_storico_consegnatari
         01/04/2016  MM      #707 Modifiche a function get_storico_consegnatari
    019  15/02/2018  MM      #800 modifiche alla get_id_consegnatario
         13/06/2019  MM      #35474 Nuova function get_ascendenti e modifiche a
                             get_id_consegnatario
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '019';

   function versione return varchar2 is
      /******************************************************************************
      NOME:        versione.
      DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
      RITORNA:     VARCHAR2                  stringa contenente versione e revisione.
      NOTE:        Primo numero  : versione compatibilità del Package.
                   Secondo numero: revisione del Package specification.
                   Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;
   -------------------------------------------------------------------------------
   function get_amministrazioni_denom(p_codice_amm so_amministrazioni.codice_amministrazione%type)
      return so_amministrazioni.denominazione%type is
      /******************************************************************************
       NOME:        get_amministrazioni_denom
       DESCRIZIONE: Dato il codice, restituisce la denominazione dell'amministrazione
                    dalla vista SO_AMMINISTRAZIONI
       PARAMETRI:   p_codice_amm             codice amministrazione
       RITORNA:     descrizione dell'amministrazione
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0                        Prima emissione.
       1    05/08/2008  SM      Inserimento commento.
      ******************************************************************************/
      d_denominazione_amm so_amministrazioni.denominazione%type;
   begin
      begin
         select denominazione
           into d_denominazione_amm
           from so_amministrazioni
          where codice_amministrazione = p_codice_amm;
      exception
         when no_data_found then
            d_denominazione_amm := null;
         when too_many_rows then
            d_denominazione_amm := null;
      end;
      --
      return d_denominazione_amm;
      --
   end get_amministrazioni_denom;
   -------------------------------------------------------------------------------
   function get_ana_unita_org_campi
   (
      p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      date
     ,p_campo                     varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_ana_unita_org_campi
       DESCRIZIONE: Dato il progressivo di una unita' organizzativa e la data,
                    restituisce il valore del campo indicato nel parametro p_campo
       PARAMETRI:   p_progr_unita_organizzativa     progr. U.O.
                    p_data                          data a cui eseguire la query
                    p_campo                         nome del campo da restituire
       RITORNA:     varchar2                        valore del campo da restituire
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0                        Prima emissione.
       1    04/03/2010  VD      Inserimento commento.
      ******************************************************************************/
      d_dal    date;
      d_valore varchar2(2000);
      d_select varchar2(2000);
   begin
      if p_progr_unita_organizzativa is null then
         d_valore := null;
      else
         begin
            select dal
              into d_dal
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and nvl(revisione_istituzione, -2) !=
                   revisione_struttura.get_revisione_mod(ottica)
               and p_data between dal and
                   nvl(decode(nvl(revisione_cessazione, -2)
                             ,revisione_struttura.get_revisione_mod(ottica)
                             ,to_date(null)
                             ,al)
                      ,to_date(3333333, 'j'));
         exception
            when no_data_found or too_many_rows then
               d_dal := to_date(null);
         end;
         if d_dal is null then
            begin
               select max(dal)
                 into d_dal
                 from anagrafe_unita_organizzative
                where progr_unita_organizzativa = p_progr_unita_organizzativa
                  and nvl(revisione_istituzione, -2) !=
                      revisione_struttura.get_revisione_mod(ottica);
            exception
               when others then
                  d_dal := to_date(null);
            end;
         end if;
         if d_dal is not null then
            begin
               d_select := 'select ' || p_campo ||
                           ' from anagrafe_unita_organizzative where progr_unita_organizzativa = ' ||
                           p_progr_unita_organizzativa;
               d_select := d_select || ' and dal = to_date(''' ||
                           to_char(d_dal, 'ddmmyyyy') || ''',''ddmmyyyy'')';
               --               D_select := D_select||' and '''||p_data||''' between dal and nvl(al,'''||p_data||''')';
               -- raise_application_error(-20999,D_select);
               d_valore := afc.sql_execute(d_select);
            exception
               when others then
                  d_valore := null;
            end;
         else
            d_valore := null;
         end if;
      end if;
      --
      return d_valore;
   end get_ana_unita_org_campi;
   -------------------------------------------------------------------------------
   function get_ana_unita_fisica_campi
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_data               in date default null
     ,p_campo              in varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_ana_unita_fisica_campi
       DESCRIZIONE: Dato il progressivo di una unita' fisica e la data,
                    restituisce il valore del campo indicato nel parametro p_campo
       PARAMETRI:   p_progr_unita_fisica            progr. U.F.
                    p_data                          data a cui eseguire la query
                    p_campo                         nome del campo da restituire
       RITORNA:     varchar2                        valore del campo da restituire
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0                        Prima emissione.
       1    04/03/2010  VD      Inserimento commento.
      ******************************************************************************/
      d_valore varchar2(2000);
      d_select varchar2(2000);
      d_dal    anagrafe_unita_fisiche.dal%type;
   begin
      if p_progr_unita_fisica is null then
         d_valore := null;
      else
         begin
            select dal
              into d_dal
              from anagrafe_unita_fisiche
             where progr_unita_fisica = p_progr_unita_fisica
               and nvl(p_data, trunc(sysdate)) between dal and
                   nvl(al, to_date(3333333, 'j'));
         exception
            when no_data_found or too_many_rows then
               d_dal := to_date(null);
         end;
         if d_dal is null then
            begin
               select max(dal)
                 into d_dal
                 from anagrafe_unita_fisiche
                where progr_unita_fisica = p_progr_unita_fisica;
            exception
               when others then
                  d_dal := to_date(null);
            end;
         end if;
         if d_dal is not null then
            begin
               d_select := 'select ' || p_campo ||
                           ' from so_ana_unita_fisiche where progr_unita_fisica = ' ||
                           p_progr_unita_fisica;
               --raise_application_error(-20999,D_select);
               d_valore := afc.sql_execute(d_select);
            exception
               when others then
                  d_valore := null;
            end;
         else
            d_valore := null;
         end if;
      end if;
      --
      return d_valore;
   end get_ana_unita_fisica_campi;
   -------------------------------------------------------------------------------
   function get_area_unita
   (
      p_id_suddivisione           suddivisioni_struttura.id_suddivisione%type
     ,p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        get_area_unita
       DESCRIZIONE: Dati il progr. di una unita' organizzativa, l'identificativo
                    di una suddivisione e una data, restituisce il progr. dell'unita'
                    avente la suddivisione indicata e gerarchicamente superiore
                    all'unita' data
       PARAMETRI:   p_id_suddivisione               id. della suddivisione da ricercare
                    p_progr_unita_organizzativa     progr. U.O.
                    p_data                          data a cui eseguire la query
       RITORNA:     progr.U.O.
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0                        Prima emissione.
       1    04/03/2010  VD      Inserimento commento.
      ******************************************************************************/
      d_result          anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_ref_cursor      afc.t_ref_cursor;
      d_ottica          ottiche.ottica%type;
      d_data            anagrafe_unita_organizzative.dal%type;
      d_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo       anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione     anagrafe_unita_organizzative.descrizione%type;
      d_dal             anagrafe_unita_organizzative.dal%type;
      d_al              anagrafe_unita_organizzative.al%type;
      d_id_suddivisione anagrafe_unita_organizzative.id_suddivisione%type;
   begin
      d_ottica := suddivisione_struttura.get_ottica(p_id_suddivisione);
      --
      -- Si seleziona il max(al) dell'unita' per trattare correttamente anche le
      -- unita' gia' chiuse
      --
      begin
         select nvl(a.al, trunc(sysdate))
           into d_data
           from anagrafe_unita_organizzative a
          where a.progr_unita_organizzativa = p_progr_unita_organizzativa
            and a.dal =
                (select max(b.dal)
                   from anagrafe_unita_organizzative b
                  where b.progr_unita_organizzativa = a.progr_unita_organizzativa);
      exception
         when others then
            d_data := nvl(p_data, trunc(sysdate));
      end;
      --
      d_result     := to_number(null);
      d_ref_cursor := so4_util.get_ascendenti(p_progr_unita_organizzativa
                                             ,d_data
                                             ,d_ottica);
      loop
         fetch d_ref_cursor
            into d_progr_unor
                ,d_codice_uo
                ,d_descrizione
                ,d_dal
                ,d_al;
         exit when d_ref_cursor%notfound;
         d_id_suddivisione := anagrafe_unita_organizzativa.get_id_suddivisione(d_progr_unor
                                                                              ,d_data);
         if d_id_suddivisione = p_id_suddivisione then
            d_result := d_progr_unor;
         end if;
      end loop;
      --
      return d_result;
      --
   end get_area_unita;
   -------------------------------------------------------------------------------
   function se_componente_unita
   (
      p_ottica     ottiche.ottica%type
     ,p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_ni         componenti.ni%type
     ,p_revisione  revisioni_struttura.revisione%type
     ,p_data       date
   ) return varchar2 is
      /******************************************************************************
       NOME:        se_componente_unita
       DESCRIZIONE: Dati ottica, progr. unita' organizzativa, ni componente, eventuale
                    revisione in modifica e data, restituisce 'Y' se il componente
                    e' assegnato all'unita' indicata alla data indicata
       PARAMETRI:   p_ottica                 ottica per cui eseguire la query
                    p_progr_unor             progr. U.O. per cui eseguire la query
                    p_ni                     componente da ricercare
                    p_revisione              eventuale revisione in modifica
                    p_data                   data a cui eseguire la query
       RITORNA:     varchar2
                    Valori: Y - il componente e' assegnato all'unita'
                            Null - il componente non e' assegnato all'unita'
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0                        Prima emissione.
       1    04/03/2010  VD      Inserimento commento.
      ******************************************************************************/
      d_result varchar2(1);
   begin
      begin
         select 'Y'
           into d_result
           from componenti
          where ottica = p_ottica
            and progr_unita_organizzativa = p_progr_unor
            and ni = p_ni
            and nvl(revisione_assegnazione, -2) != p_revisione
            and p_data between dal and
                nvl(decode(nvl(revisione_cessazione, -2), p_revisione, to_date(null), al)
                   ,p_data);
      exception
         when no_data_found then
            d_result := null;
      end;
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   function se_competenza_unita_org
   (
      p_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_utente     ad4_utenti.utente%type
     ,p_data       date
   ) return varchar2 is
      /******************************************************************************
       NOME:        se_competenza_unita_org
       DESCRIZIONE: Dati progr. unita' organizzativa, utente e data, restituisce 'Y'
                    se l'utente fa parte dell'unita' indicata oppure di una delle
                    unita' discendenti
       PARAMETRI:   p_progr_unor             progr. U.O.
                    p_utente                 utente da ricercare
                    p_data                   data a cui eseguire la query
       RITORNA:     varchar2
                    Valori: Y - il componente e' assegnato all'unita'
                            Null - il componente non e' assegnato all'unita'
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0                        Prima emissione.
       1    04/03/2010  VD      Inserimento commento.
      ******************************************************************************/
      d_data                date;
      d_ottica              ottiche.ottica%type;
      d_revisione           revisioni_struttura.revisione%type;
      d_separatore          varchar2(1);
      d_dati_utente         varchar2(32767);
      d_ni                  number(8);
      d_unita_organizzative afc.t_ref_cursor;
      d_progr_unor          anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_unor         anagrafe_unita_organizzative.codice_uo%type;
      d_descr_unor          anagrafe_unita_organizzative.descrizione%type;
      d_dal_unor            anagrafe_unita_organizzative.dal%type;
      d_al_unor             anagrafe_unita_organizzative.al%type;
      d_messaggio           varchar2(2000);
      d_result              varchar2(1);
      errore exception;
   begin
      d_result := null;
      d_data   := so4_util.set_data_default(p_data);
      --      d_ottica      := anagrafe_unita_organizzativa.get_ottica(p_progr_unor, d_data);
      select min(ottica)
        into d_ottica
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unor;
      if d_ottica is not null then
         d_revisione   := revisione_struttura.get_revisione_mod(d_ottica);
         d_separatore  := '#';
         d_dati_utente := so4_util.ad4_utente_get_dati(p_utente, d_separatore);
         if substr(d_dati_utente, 1, 1) <> '*' then
            d_ni := substr(d_dati_utente, 1, instr(d_dati_utente, d_separatore) - 1);
            /*       else
            d_result :
            d_messaggio := 'L''utente ' || p_utente ||
                           ' non e'' associato a nessuna unita'' organizzativa';
            raise errore;*/
         end if;
         --
         if d_ni is not null then
            d_result := so4_ciweb.se_componente_unita(d_ottica
                                                     ,p_progr_unor
                                                     ,d_ni
                                                     ,d_revisione
                                                     ,d_data);
            --
            if d_result is null then
               d_unita_organizzative := so4_util.get_discendenti(p_progr_unor
                                                                ,d_data
                                                                ,d_ottica);
               loop
                  fetch d_unita_organizzative
                     into d_progr_unor
                         ,d_codice_unor
                         ,d_descr_unor
                         ,d_dal_unor
                         ,d_al_unor;
                  exit when d_unita_organizzative%notfound;
                  d_result := so4_ciweb.se_componente_unita(d_ottica
                                                           ,d_progr_unor
                                                           ,d_ni
                                                           ,d_revisione
                                                           ,d_data);
                  if d_result = 'Y' then
                     exit;
                  end if;
               end loop;
            end if;
         end if;
      end if;
      --
      return d_result;
      --
   exception
      when errore then
         raise_application_error(-20999, d_messaggio);
      when others then
         raise_application_error(-20999
                                ,'SO4_CIWEB.SE_COMPETENZA_UNITA_ORG - ' || sqlerrm);
   end se_competenza_unita_org;
   -------------------------------------------------------------------------------
   function get_id_consegnatario
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_data       componenti.dal%type
   ) return componenti.ni%type is
      /******************************************************************************
       NOME:        get_id_consegnatario
       DESCRIZIONE: Dati ruolo, progr. U.O. e data, restituisce l'ni di anagrafe_soggetti
                    del componente avente ruolo nell'unita' alla data indicata
       PARAMETRI:   p_ruolo                  ruolo da ricercare (consegnatario)
                    p_progr_unor             unita' su cui eseguire la query
                    p_data                   data a cui eseguire la query
       RITORNA:     componente assegnato all'unita' con il ruolo indicato
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    04/03/2010  VD      Prima emissione.
       1    13/12/2010  VD      Modifica gestione errori
       2    16/02/2018  MM      Se non trova consegnatario sulla UO, risale l'albero #800
      ******************************************************************************/
      d_result      componenti.ni%type;
      d_ottica      ottiche.ottica%type;
      d_revisione   revisioni_struttura.revisione%type;
      d_messaggio   varchar2(200);
      d_cur_uo      afc.t_ref_cursor;
      d_dal         date;
      d_al          date;
      d_progressivo unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo   anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione anagrafe_unita_organizzative.descrizione%type;
      errore exception;
   begin
      select min(ottica)
        into d_ottica
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unor;
      --
      if d_ottica is null then
         d_messaggio := 'Ottica non determinabile (' || p_progr_unor || ')';
         raise errore;
      end if;
      --
      begin
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      exception
         when others then
            d_revisione := null;
      end;
      if d_revisione is not null then
         d_cur_uo := get_ascendenti(p_progr_unor, p_data, d_ottica);
         loop
            fetch d_cur_uo
               into d_progressivo
                   ,d_codice_uo
                   ,d_descrizione
                   ,d_dal
                   ,d_al;
            exit when d_cur_uo%notfound;

            begin
               select ni
                 into d_result
                 from componenti       c
                     ,ruoli_componente r
                where c.ottica = d_ottica
                  and c.progr_unita_organizzativa = d_progressivo
                  and nvl(c.revisione_assegnazione, -2) <> d_revisione
                  and p_data between c.dal and
                      nvl(decode(nvl(c.revisione_cessazione, -2)
                                ,d_revisione
                                ,to_date(null)
                                ,c.al)
                         ,to_date(3333333, 'j'))
                  and c.id_componente = r.id_componente
                  and r.ruolo = p_ruolo
                  and p_data between r.dal and nvl(r.al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_result := null;
               when too_many_rows then
                  d_result := null;
            end;
            if d_result is not null then
               exit;
            end if;
         end loop;
      else
         d_result := to_number(null);
      end if;
      --#35474
      if d_result = null then
         select min(ni)
           into d_result
           from vista_ruoli_componente r
          where ottica = d_ottica
            and progr_unita_organizzativa = d_progressivo
            and dal = (select max(dal)
                         from vista_ruoli_componente
                        where progr_unita_organizzativa = d_progressivo
                          and ruolo = r.ruolo
                          and dal <= p_data)
            and ruolo = p_ruolo;
      end if;
      --
      return d_result;
      --
   exception
      when errore then
         raise_application_error(-20999
                                ,'SO4_CIWEB.GET_ID_CONSEGNATARIO - ' || d_messaggio);
      when others then
         raise_application_error(-20999, 'SO4_CIWEB.GET_ID_CONSEGNATARIO - ' || sqlerrm);
   end get_id_consegnatario;
   -------------------------------------------------------------------------------
   function get_consegnatari
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_dal        componenti.dal%type
     ,p_al         componenti.al%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        get_consegnatari
       DESCRIZIONE: Dati ruolo, progr. U.O. e periodo, restituisce un ref_cursor
                    contenente l'elenco dei consegnatari con data fine validita'
       PARAMETRI:   p_ruolo                  ruolo da ricercare (consegnatario)
                    p_progr_unor             unita' in cui eseguire la ricerca
                    p_dal                    data inizio periodo per cui eseguire
                                             la query
                    p_al                     data fine periodo per cui eseguire
                                             la query
       RITORNA:     afc.t_ref_cursor         cursore contenete l'elenco degli ni
                                             dei componenti con ruolo indicato e
                                             relativa data di fine validità
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    04/03/2010  VD      Prima emissione.
       1    30/01/2014  VD      Modificata ricerca ottica di riferimento
      ******************************************************************************/
      d_result    afc.t_ref_cursor;
      d_ottica    ottiche.ottica%type;
      d_revisione revisioni_struttura.revisione%type;
      d_messaggio varchar2(200);
      errore exception;
   begin
      select min(ottica)
        into d_ottica
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unor;
      --
      if d_ottica is null then
         d_messaggio := 'Ottica non determinabile (' || p_progr_unor || ')';
         raise errore;
      end if;
      --
      begin
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      exception
         when others then
            d_revisione := to_number(null);
      end;
      --
      if d_revisione is not null then
         open d_result for
            select ni
                  ,least(p_al, nvl(r.al, p_al)) al
              from componenti       c
                  ,ruoli_componente r
             where c.ottica = d_ottica
               and c.progr_unita_organizzativa = p_progr_unor
               and nvl(c.revisione_assegnazione, -2) <> d_revisione
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and ((r.dal between p_dal and p_al) or
                   (nvl(r.al, to_date(3333333, 'j')) between p_dal and p_al) or
                   (r.dal < p_dal and nvl(r.al, to_date(3333333, 'j')) > p_al))
             order by 2;
      else
         open d_result for
            select to_number(null)
                  ,to_date(null)
              from dual;
      end if;
      --
      return d_result;
      --
   exception
      when errore then
         raise_application_error(-20999, 'SO4_CIWEB.GET_CONSEGNATARI - ' || d_messaggio);
      when others then
         raise_application_error(-20999, 'SO4_CIWEB.GET_CONSEGNATARI - ' || sqlerrm);
   end get_consegnatari;
   -------------------------------------------------------------------------------
   function get_storico_consegnatari
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_dal        componenti.dal%type
     ,p_al         componenti.al%type
   ) return afc.t_ref_cursor is
      /******************************************************************************
       NOME:        get_storico_consegnatari
       DESCRIZIONE: Come la get_consegnatari, con aggiunta della data di decorrenza del periodo
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    09/02/2016  MM      Prima emissione.
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica ottiche.ottica%type;
      --
      tab_storico_consegnatari tab_consegnatari := tab_consegnatari();
      --
      d_ni        componenti.ni%type;
      d_dal       date;
      d_al        date;
      d_inizio    date;
      d_fine      date;
      d_messaggio varchar2(200);
      errore exception;
   begin
      select min(ottica)
        into d_ottica
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unor;
      --
      if d_ottica is null then
         d_messaggio := 'Ottica non determinabile (' || p_progr_unor || ')';
         raise errore;
      end if;
      -- #707
      for periodo in (select p_dal data
                        from dual
                      union
                      select greatest(p_dal, r.dal) dal
                        from vista_ruoli_componente r
                       where r.ottica = d_ottica
                         and r.progr_unita_organizzativa = p_progr_unor
                         and r.ruolo = p_ruolo
                         and nvl(r.al, to_date(3333333, 'j')) >= p_dal
                         and r.dal <= nvl(p_al, to_date(3333333, 'j'))
                      union
                      select least(nvl(p_al, to_date(3333333, 'j'))
                                  ,nvl(r.al, to_date(3333333, 'j'))) + 1 data
                        from vista_ruoli_componente r
                       where r.ottica = d_ottica
                         and r.progr_unita_organizzativa = p_progr_unor
                         and r.ruolo = p_ruolo
                         and nvl(r.al, to_date(3333333, 'j')) >= p_dal
                         and r.dal <= nvl(p_al, to_date(3333333, 'j'))
                       order by 1)
      loop
         select min(nvl(r.al, to_date(3333333, 'j')))
           into d_al
           from vista_ruoli_componente r
          where r.ottica = d_ottica
            and r.progr_unita_organizzativa = p_progr_unor
            and r.ruolo = p_ruolo
            and nvl(r.al, to_date(3333333, 'j')) >= p_dal
            and r.dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(r.al, to_date(3333333, 'j')) >= periodo.data;

         select nvl(min(r.dal - 1), to_date(3333333, 'j'))
           into d_dal
           from vista_ruoli_componente r
          where r.ottica = d_ottica
            and r.progr_unita_organizzativa = p_progr_unor
            and r.ruolo = p_ruolo
            and nvl(r.al, to_date(3333333, 'j')) >= p_dal
            and r.dal <= nvl(p_al, to_date(3333333, 'j'))
            and r.dal > periodo.data;

         --valorizzazione degli estremi del periodo
         d_inizio := periodo.data;
         d_fine   := least(nvl(d_al, to_date(3333333, 'j')), d_dal, p_al);
         if d_inizio <= d_fine then
            begin
               select ni
                 into d_ni
                 from vista_ruoli_componente r
                where r.ottica = d_ottica
                  and r.progr_unita_organizzativa = p_progr_unor
                  and r.ruolo = p_ruolo
                  and nvl(r.al, to_date(3333333, 'j')) >=
                      nvl(d_fine, to_date(3333333, 'j'))
                  and r.dal <= d_inizio;
            exception
               when no_data_found then
                  d_ni := '';
            end;

            tab_storico_consegnatari.extend();
            tab_storico_consegnatari(tab_storico_consegnatari.last) := rec_consegnatario(d_ni
                                                                                        ,d_inizio
                                                                                        ,d_fine);
         end if;
      end loop;
      --

      open d_result for
         select * from table(tab_storico_consegnatari);

      return d_result;
   exception
      when errore then
         raise_application_error(-20999, 'SO4_CIWEB.GET_CONSEGNATARI - ' || d_messaggio);
      when others then
         raise_application_error(-20999, 'SO4_CIWEB.GET_CONSEGNATARI - ' || sqlerrm);
   end get_storico_consegnatari;
   -------------------------------------------------------------------------------
   function get_dati_consegnatario
   (
      p_ni    componenti.ni%type
     ,p_campo varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_dati_consegnatario
       DESCRIZIONE: Dato l'identificativo di un soggetto restituisce il valore
                    del campo indicato nel parametro p_campo
       PARAMETRI:   p_ni                     identificativo del soggetto
                    p_campo
                    valori previsti: nominativo
                                     email
       RITORNA:     varchar2                 valore del campo da restituire
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    04/03/2010  VD      Prima emissione.
      ******************************************************************************/
      d_result varchar2(200);
   begin
      if p_campo = 'NOMINATIVO' then
         d_result := soggetti_get_descr(p_ni, trunc(sysdate), 'COGNOME E NOME');
      else
         d_result := soggetti_rubrica_pkg.get_email(p_ni);
      end if;
      --
      return d_result;
      --
   end get_dati_consegnatario;
   -------------------------------------------------------------------------------
   function get_id_sub_consegnatario
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_progr_unfi unita_fisiche.progr_unita_fisica%type
     ,p_data       componenti.dal%type
   ) return componenti.ni%type is
      /******************************************************************************
       NOME:        get_id_subconsegnatario
       DESCRIZIONE: Dati ruolo, progr. U.O., progr. U.F. e data, restituisce l'ni di
                    anagrafe_soggetti del componente avente ruolo sub-consegnatario
                    nella combinazione U.O. / U.F. alla data indicata
       PARAMETRI:   p_ruolo                  ruolo da ricercare (sub-consegnatario)
                    p_progr_unor             unita' organizzativa su cui eseguire la query
                    p_progr_unfi             unita' fisica su cui eseguire la query
                    p_data                   data a cui eseguire la query
       RITORNA:     componente assegnato all'unita' con il ruolo indicato
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    01/09/2010  VD      Prima emissione.
      ******************************************************************************/
      d_result          componenti.ni%type;
      d_amministrazione ottiche.amministrazione%type;
      d_ottica          ottiche.ottica%type;
      d_revisione       revisioni_struttura.revisione%type;
      d_id_ubun         ubicazioni_unita.id_ubicazione%type;
   begin
      begin
         d_amministrazione := anagrafe_unita_fisica.get_amministrazione(p_progr_unfi
                                                                       ,p_data);
      exception
         when others then
            d_amministrazione := null;
      end;
      --
      begin
         d_ottica := ottica.get_ottica_per_amm(d_amministrazione);
      exception
         when others then
            d_ottica := null;
      end;
      --
      begin
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      exception
         when others then
            d_revisione := null;
      end;
      --
      begin
         select id_ubicazione
           into d_id_ubun
           from ubicazioni_unita u
          where u.progr_unita_organizzativa = p_progr_unor
            and u.progr_unita_fisica = p_progr_unfi
            and p_data between u.dal and nvl(u.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_id_ubun := to_number(null);
         when too_many_rows then
            d_id_ubun := to_number(null);
      end;
      --
      if d_id_ubun is not null then
         begin
            select ni
              into d_result
              from componenti            c
                  ,ubicazioni_componente u
                  ,ruoli_componente      r
             where c.ottica = d_ottica
               and c.progr_unita_organizzativa = p_progr_unor
               and nvl(c.revisione_assegnazione, -2) <> d_revisione
               and p_data between c.dal and
                   nvl(decode(nvl(c.revisione_cessazione, -2)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,to_date(3333333, 'j'))
               and c.id_componente = u.id_componente
               and u.id_ubicazione_unita = d_id_ubun
               and p_data between u.dal and nvl(u.al, to_date(3333333, 'j'))
               and c.id_componente = r.id_componente
               and r.ruolo = p_ruolo
               and p_data between r.dal and nvl(r.al, to_date(3333333, 'j'));
         exception
            when no_data_found then
               d_result := null;
            when too_many_rows then
               d_result := null;
         end;
      else
         d_result := null;
      end if;
      --
      return d_result;
      --
   exception
      when others then
         raise_application_error(-20999
                                ,'SO4_CIWEB.GET_ID_SUB_CONSEGNATARIO - ' || sqlerrm);
   end get_id_sub_consegnatario;
   -------------------------------------------------------------------------------
   function se_esiste_relazione
   (
      p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_progr_unfi unita_fisiche.progr_unita_fisica%type
     ,p_data       componenti.dal%type
     ,p_ottica     ottiche.ottica%type default null
     ,p_ni         componenti.ni%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        se_esiste_relazione
       DESCRIZIONE: Dati progr. U.O., progr. U.F. e data, restituisce 'Y' se esiste
                    l'abbinamento tra U.O. e U.F. alla data indicata, altrimenti 'N'
       PARAMETRI:   p_progr_unor             unita' organizzativa su cui eseguire la query
                    p_progr_unfi             unita' fisica su cui eseguire la query
                    p_data                   data a cui eseguire la query
                    p_ottica                 ottica di riferimento
                    p_ni                     ni del soggetto (facoltativo)
       RITORNA:     'Y'/'N'
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    01/09/2010  VD      Prima emissione.
       1    03/07/2013  VD      Modifica algoritmo di ricerca come da richiesta
                                Regione Marche; aggiunto parametro NI.
      ******************************************************************************/
      d_result          varchar2(1);
      d_data            date;
      d_ottica          ottiche.ottica%type;
      d_amministrazione amministrazioni.codice_amministrazione%type;
      d_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_progr_uf        anagrafe_unita_fisiche.progr_unita_fisica%type;
      d_ref_cursor      afc.t_ref_cursor;
      d_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_codice_uo       anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione     anagrafe_unita_organizzative.descrizione%type;
      d_dal             componenti.dal%type;
      d_al              componenti.al%type;
      d_messaggio       varchar2(200);
      errore exception;
   begin
      if p_data is null then
         d_data := trunc(sysdate);
      else
         d_data := p_data;
      end if;
      --
      if p_ottica is null then
         begin
            d_ottica := anagrafe_unita_organizzativa.get_ottica(p_progr_unor, d_data);
         exception
            when others then
               d_ottica := null;
         end;
      else
         d_ottica := p_ottica;
      end if;
      --
      begin
         d_amministrazione := ottica.get_amministrazione(d_ottica);
      exception
         when others then
            d_amministrazione := null;
      end;
      --
      if d_ottica is null or d_amministrazione is null then
         d_result := 'N';
      else
         -- se il parametro ni e valorizzato, si verifica se la combinazione
         -- soggetto / u.o. / u.f. è valida
         --
         if p_ni is not null then
            d_progr_uf := assegnazioni_fisiche_pkg.get_unita_fisica(p_ni, d_data);
            begin
               select 'Y'
                 into d_result
                 from dual
                where d_progr_uf = p_progr_unfi
                  and exists
                (select 'x'
                         from vista_componenti c
                        where c.ottica = d_ottica
                          and c.ni = p_ni
                          and c.progr_unita_organizzativa = p_progr_unor
                          and d_data between c.dal and nvl(c.al, s_data_limite));
            exception
               when others then
                  d_result := 'N';
            end;
         else
            d_progr_uo := anagrafe_unita_fisica.get_uo_competenza(p_progr_unfi
                                                                 ,d_amministrazione
                                                                 ,p_data);
            if d_progr_uo is null then
               d_progr_uo := ubicazione_unita.get_uo_competenza(p_progr_unfi, p_data);
               if d_progr_uo is null then
                  d_result := 'N';
               elsif d_progr_uo = p_progr_unor then
                  d_result := 'Y';
               end if;
            end if;
            --
            -- Se non si trova l'abbinamento diretto, si esegue la ricerca anche sulle unità
            -- di livello superiore
            --
            if d_progr_uo is not null and d_result = 'N' then
               d_ref_cursor := so4_util.get_ascendenti(p_progr_unor, d_data, d_ottica);
               if d_ref_cursor%isopen then
                  fetch d_ref_cursor
                     into d_progr_unor
                         ,d_codice_uo
                         ,d_descrizione
                         ,d_dal
                         ,d_al;
                  while d_ref_cursor%found
                  loop
                     if d_progr_uo = p_progr_unor then
                        d_result := 'Y';
                        exit;
                     end if;
                     fetch d_ref_cursor
                        into d_progr_unor
                            ,d_codice_uo
                            ,d_descrizione
                            ,d_dal
                            ,d_al;
                  end loop;
                  close d_ref_cursor;
               end if;
            end if;
         end if;
      end if;
      --
      return d_result;
      --
   exception
      when errore then
         raise_application_error(-20999, d_messaggio);
      when others then
         raise_application_error(-20999
                                ,'SO4_CIWEB.GET_SE_ESISTE_RELAZIONE - ' || sqlerrm);
   end se_esiste_relazione;
   -------------------------------------------------------------------------------
   function se_combinazione_valida
   (
      p_ottica     ottiche.ottica%type
     ,p_data       componenti.dal%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_progr_unfi unita_fisiche.progr_unita_fisica%type default null
     ,p_ni         componenti.ni%type default null
   ) return varchar2 is
      /******************************************************************************
       NOME:        se_combinazione_valida
       DESCRIZIONE: Dati ottica, data, progr. uo, progr. uf. e ni, verifica se la
                    combinazione è valida.
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    03/07/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result          varchar2(32767);
      d_ottica_ist      ottiche.ottica%type;
      d_amministrazione ottiche.amministrazione%type;
      d_esiste          varchar2(1);
   begin
      --
      -- Se l'ottica indicata non è quella istituzionale, si seleziona l'ottica
      -- istituzionale per la relativa amministrazione
      --
      begin
         select a.ottica
               ,a.amministrazione
           into d_ottica_ist
               ,d_amministrazione
           from ottiche a
               ,ottiche b
          where a.amministrazione = b.amministrazione
            and b.ottica = p_ottica
            and a.ottica_istituzionale = 'SI';
      exception
         when others then
            d_ottica_ist := null;
      end;
      --
      -- Controllo esistenza unita' in anagrafe_unita_organizzative
      --
      begin
         select 'UO0001 - Unita'' organizzativa non presente o non valida'
           into d_result
           from dual
          where not exists (select 'x'
                   from anagrafe_unita_organizzative
                  where ottica = p_ottica
                    and progr_unita_organizzativa = p_progr_unor
                    and p_data between dal and nvl(al, s_data_limite))
            and not exists
          (select 'x'
                   from anagrafe_unita_organizzative
                  where ottica = d_ottica_ist
                    and progr_unita_organizzativa = p_progr_unor
                    and p_data between dal and nvl(al, s_data_limite));
      exception
         when others then
            null;
      end;
      --
      -- Controllo esistenza unita' in unita_organizzative (struttura)
      --
      begin
         select decode(d_result, null, null, d_result || '#') ||
                'UO0002 - Legame di struttura logica non presente o non valido'
           into d_result
           from dual
          where not exists (select 'x'
                   from unita_organizzative
                  where ottica = p_ottica
                    and progr_unita_organizzativa = p_progr_unor
                    and p_data between dal and nvl(al, s_data_limite));
      exception
         when others then
            null;
      end;
      --
      -- Controllo esistenza unita' in anagrafe_unita_fisiche
      --
      if p_progr_unfi is not null then
         begin
            select decode(d_result, null, null, d_result || '#') ||
                   'UF0001 - Unita'' fisica non presente o non valida'
              into d_result
              from dual
             where not exists
             (select 'x'
                      from anagrafe_unita_fisiche
                     where progr_unita_fisica = p_progr_unfi
                       and p_data between dal and nvl(al, s_data_limite));
         exception
            when others then
               null;
         end;
         --
         -- Controllo esistenza unita' in unita_fisiche (struttura fisica)
         --
         begin
            select decode(d_result, null, null, d_result || '#') ||
                   'UF0002 - Legame di struttura fisica non presente o non valido'
              into d_result
              from dual
             where not exists
             (select 'x'
                      from unita_fisiche
                     where amministrazione = d_amministrazione
                       and progr_unita_fisica = p_progr_unfi
                       and p_data between dal and nvl(al, s_data_limite));
         exception
            when others then
               null;
         end;
         --
         if p_ni is null then
            --
            -- Controllo esistenza abbinamento tra unita fisica e unita organizzativa
            --
            begin
               d_esiste := so4_ciweb.se_esiste_relazione(p_progr_unor
                                                        ,p_progr_unfi
                                                        ,p_ottica);
            exception
               when others then
                  d_esiste := 'N';
            end;
            --
            if d_esiste = 'N' then
               if d_result is not null then
                  d_result := d_result || '#';
               end if;
               d_result := d_result ||
                           'UF003 - Abbinamento unita'' organizzativa / unita'' fisica non presente o non valido';
            end if;
         end if;
      end if;
      --
      if p_ni is not null then
         --
         -- Si controlla l'esistenza dei dati anagrafici
         --
         begin
            select decode(d_result, null, null, d_result || '#') ||
                   'AS0001 - Soggetto non presente o non valido'
              into d_result
              from dual
             where not exists
             (select 'x'
                      from as4_anagrafe_soggetti
                     where ni = p_ni
                       and p_data between dal and nvl(al, s_data_limite));
         exception
            when others then
               null;
         end;
         --
         -- Si controlla se il componente è assegnato all'unita' organizzativa
         --
         begin
            select decode(d_result, null, null, d_result || '#') ||
                   'CO0001 - Componente non assegnato all''unita'' organizzativa'
              into d_result
              from dual
             where not exists
             (select 'x'
                      from componenti
                     where ottica = p_ottica
                       and ni = p_ni
                       and p_data between dal and nvl(al, s_data_limite));
         exception
            when others then
               null;
         end;
         if p_progr_unfi is not null then
            --
            -- Si controlla se il componente è assegnato all'unita' fisica
            --
            begin
               select decode(d_result, null, null, d_result || '#') ||
                      'CO0002 - Componente non assegnato all''unita'' fisica'
                 into d_result
                 from dual
                where not exists
                (select 'x'
                         from assegnazioni_fisiche
                        where ni = p_ni
                          and progr_unita_fisica = p_progr_unfi
                          and p_data between dal and nvl(al, s_data_limite));
            exception
               when others then
                  null;
            end;
         end if;
      end if;
      --
      return d_result;
   end;
   -------------------------------------------------------------------------------
   function get_unita_soggetto
   (
      p_ottica ottiche.ottica%type
     ,p_data   componenti.dal%type
     ,p_ni     componenti.ni%type
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_unita_soggetto
       DESCRIZIONE: Dati l'ni di un soggetto, l'ottica e la data di riferimento,
                    restituisce i progressivi unita organizzativa e unita fisica
                    (concatenati)
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    03/07/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result   varchar2(16);
      d_progr_uf assegnazioni_fisiche.progr_unita_fisica%type;
      d_progr_uo componenti.progr_unita_organizzativa%type;
   begin
      d_progr_uf := assegnazioni_fisiche_pkg.get_unita_fisica(p_ni, p_data);
      begin
         select progr_unita_organizzativa
           into d_progr_uo
           from componenti
          where ottica = p_ottica
            and ni = p_ni
            and p_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_progr_uo := null;
      end;
      --
      d_result := lpad(nvl(d_progr_uo, 0), 8, '0') || lpad(nvl(d_progr_uf, 0), 8, '0');
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   function get_soggetto_matricola
   (
      p_ci              componenti.ci%type
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.ni%type is
      /******************************************************************************
       NOME:        get_soggetto_matricola
       DESCRIZIONE: Dato il CI (matricola) di un dipendente, restituisce l'id_soggetto
                    (ni di as4_anagrafe_soggetto) in relazione all'amministrazione
                    indicata
       PARAMETRI:   p_ci                   componenti.ci%type
                    p_amministrazione      amministrazioni.codice_amministrazione%type
       RITORNA:     componenti.ni%type
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    08/03/2013  VD      Prima emissione.
       1    28/05/2013  VD      Aggiunto parametro per amministrazione
      ******************************************************************************/
      d_result    componenti.ni%type;
      d_ottica    ottiche.ottica%type := null;
      d_revisione revisioni_struttura.revisione%type := to_number(null);
   begin
      if p_amministrazione is not null then
         begin
            d_ottica    := ottica.get_ottica_per_amm(p_amministrazione);
            d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
         exception
            when others then
               d_ottica    := null;
               d_revisione := to_number(null);
         end;
      end if;
      --
      if d_ottica is not null then
         select min(ni)
           into d_result
           from componenti
          where ottica = d_ottica
            and ci = p_ci
            and nvl(revisione_assegnazione, -2) != d_revisione;
      else
         select min(ni) into d_result from componenti where ci = p_ci;
      end if;

      return d_result;

   end;
   -------------------------------------------------------------------------------
   function get_matricola_soggetto
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_data            componenti.dal%type
     ,p_ni              componenti.ni%type
   ) return componenti.ci%type is
      /******************************************************************************
       NOME:        get_matricola_soggetto
       DESCRIZIONE: Dato l'NI (soggetto) di un dipendente, restituisce il CI
                    (matricola) valido alla data indicata
       PARAMETRI:   p_ni                   componenti.ni%type
       RITORNA:     componenti.ci%type
       ANNOTAZIONI: 
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    28/05/2013  VD      Prima emissione.
      ******************************************************************************/
      d_result    componenti.ni%type;
      d_ottica    ottiche.ottica%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      --
      -- Si determinano l ottica istituzionale per l amministrazione
      -- e l eventuale revisione in modifica
      --
      begin
         d_ottica    := ottica.get_ottica_per_amm(p_amministrazione);
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      exception
         when others then
            d_ottica    := null;
            d_revisione := to_number(null);
      end;
      --
      if d_ottica is not null then
      
         select min(ci)
           into d_result
           from componenti
          where ottica = d_ottica
            and ni = p_ni
            and nvl(revisione_assegnazione, -2) != d_revisione
            and p_data between dal and
                nvl(decode(nvl(revisione_cessazione, -2), d_revisione, to_date(null), al)
                   ,to_date(3333333, 'j'));
      else
         d_result := to_number(null);
      end if;
   
      return d_result;
   
   end;
   -------------------------------------------------------------------------------
   function ins_ana_unor
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_ottica          ottiche.ottica%type
     ,p_codice          anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione     anagrafe_unita_organizzative.descrizione%type
     ,p_centro_costo    anagrafe_unita_organizzative.centro%type
     ,p_dal             anagrafe_unita_organizzative.dal%type
     ,p_al              anagrafe_unita_organizzative.al%type
     ,p_id_suddivisione anagrafe_unita_organizzative.id_suddivisione%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        ins_ana_unor
       DESCRIZIONE: Inserisce una riga di anagrafe_unita_organizzative con i dati
                    passati come parametri
       PARAMETRI:   p_amministrazione        amministrazioni.codice_amministrazione%type
                    p_ottica                    ottiche.ottica%type
                    p_codice                    anagrafe_unita_organizzative.codice_uo%type
                    p_descrizione             anagrafe_unita_organizzative.descrizione%type
                    p_centro_costo            anagrafe_unita_organizzative.centro%type
                    p_dal                    anagrafe_unita_organizzative.dal%type
                    p_al                     anagrafe_unita_organizzative.al%type
       RITORNA:     anagrafe_unita_organizzative.progr_unita_organizzativa
                    (inserito o trovato per codice)
       ANNOTAZIONI: 
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    14/03/2011  VD      Prima emissione.
      ******************************************************************************/
      d_result    anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_progr_aoo anagrafe_unita_organizzative.progr_aoo%type;
   begin
      begin
         select progr_unita_organizzativa
           into d_result
           from anagrafe_unita_organizzative
          where ottica = p_ottica
            and amministrazione = p_amministrazione
            and codice_uo = p_codice;
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := -1;
      end;
      --
      if d_result is null then
         begin
            select min(progr_aoo)
              into d_progr_aoo
              from aoo a
             where a.codice_amministrazione = p_amministrazione;
         exception
            when others then
               d_progr_aoo := null;
         end;
         if d_progr_aoo is not null then
            d_result := anagrafe_unita_organizzativa.get_id_unita;
            begin
               insert into anagrafe_unita_organizzative
                  (progr_unita_organizzativa
                  ,dal
                  ,codice_uo
                  ,descrizione
                  ,des_abb
                  ,progr_aoo
                  ,centro
                  ,al
                  ,ottica
                  ,amministrazione
                  ,id_suddivisione
                  ,utente_aggiornamento
                  ,data_aggiornamento)
               values
                  (d_result
                  ,p_dal
                  ,p_codice
                  ,p_descrizione
                  ,p_codice
                  ,d_progr_aoo
                  ,p_centro_costo
                  ,p_al
                  ,p_ottica
                  ,p_amministrazione
                  ,p_id_suddivisione
                  ,'TRASCO'
                  ,trunc(sysdate));
            exception
               when others then
                  d_result := -2;
            end;
         else
            d_result := -3;
         end if;
      end if;
      --
      return d_result;
      --
   end ins_ana_unor;
   -------------------------------------------------------------------------------
   function ins_ana_unfi
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_codice          anagrafe_unita_fisiche.codice_uf%type
     ,p_descrizione     anagrafe_unita_fisiche.denominazione%type
     ,p_dal             anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.progr_unita_fisica%type is
      /******************************************************************************
       NOME:        ins_ana_unfi
       DESCRIZIONE: Inserisce una riga di anagrafe_unita_fisiche con i dati
                    passati come parametri
       PARAMETRI:   p_amministrazione        amministrazioni.codice_amministrazione%type
                    p_codice                    anagrafe_unita_fisiche.codice_uo%type
                    p_descrizione             anagrafe_unita_fisiche.denominazione%type
                    p_dal                    anagrafe_unita_fisiche.dal%type
       RITORNA:     anagrafe_unita_fisiche.progr_unita_fisica
                    (inserito o trovato per codice)
       ANNOTAZIONI: 
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    14/03/2011  VD      Prima emissione.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.progr_unita_fisica%type;
   begin
      begin
         select progr_unita_fisica
           into d_result
           from anagrafe_unita_fisiche
          where amministrazione = p_amministrazione
            and codice_uf = p_codice;
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := -1;
      end;
      --
      if d_result is null then
         d_result := anagrafe_unita_fisica.get_id_unita;
         begin
            insert into anagrafe_unita_fisiche
               (progr_unita_fisica
               ,dal
               ,codice_uf
               ,denominazione
               ,amministrazione
               ,utente_aggiornamento
               ,data_aggiornamento)
            values
               (d_result
               ,p_dal
               ,p_codice
               ,p_descrizione
               ,p_amministrazione
               ,'TRASCO'
               ,trunc(sysdate));
         exception
            when others then
               d_result := -2;
         end;
      end if;
      --
      return d_result;
      --
   end;
   -------------------------------------------------------------------------------
   procedure ins_centri
   (
      p_centro        centri.centro%type
     ,p_descrizione   centri.descrizione%type
     ,p_fine_validita centri.data_validita%type
   ) is
      /******************************************************************************
       NOME:        ins_centri
       DESCRIZIONE: Inserisce una riga di centri con i dati passati come parametri
       PARAMETRI:   p_centro              centri.centro%type
                    p_descrizione         centri.descrizione
                    p_dal                 centri.data_validita
       RITORNA:     anagrafe_unita_fisiche.progr_unita_fisica
                    (inserito o trovato per codice)
       ANNOTAZIONI: 
       REVISIONI:
       Rev. Data        Autore  Descrizione
       ---- ----------  ------  ----------------------------------------------------
       0    23/03/2011  VD      Prima emissione.
      ******************************************************************************/
   begin
      begin
         insert into centri
            (centro
            ,descrizione
            ,data_validita)
            select p_centro
                  ,p_descrizione
                  ,p_fine_validita
              from dual
             where not exists (select 'x' from centri where centro = p_centro);
      exception
         when others then
            raise_application_error(-20999
                                   ,'Errore in inserimento CENTRI: ' || p_centro ||
                                    ' - ' || sqlerrm);
      end;
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
      001   19/06/2019  MM        #35474
      ******************************************************************************/
      d_result afc.t_ref_cursor;
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_ottica := so4_util.set_ottica_default(p_ottica);
      d_data   := so4_util.set_data_default(p_data);
      --
      open d_result for
         select /*+ first_rows */
          progr_unita_organizzativa
         ,anagrafe_unita_organizzativa.get_codice_uo_corrente(progr_unita_organizzativa
                                                             ,d_data) codice_uo
         ,anagrafe_unita_organizzativa.get_descrizione_corrente(progr_unita_organizzativa
                                                               ,d_data) descrizione_uo
         ,dal
         ,al
           from unita_organizzative
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
   end;
end so4_ciweb;
/


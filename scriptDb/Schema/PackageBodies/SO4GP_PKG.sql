CREATE OR REPLACE package body so4gp_pkg is
   /******************************************************************************
   NOME:        SO4GP4.
   DESCRIZIONE: Funzioni e procedures per integrazione SO4/GP4.
                Versione per integrazione simulata con GP4.
   ANNOTAZIONI: .
   REVISIONI:   .
   Rev.  Data        Autore               Descrizione.
   ----  ----------  ------               ---------------------------------------------------.
   000   27/03/2014  ADADAMO/MMONARI      Prima emissione.
   001   17/07/2014  ADADAMO              Modifica a is_struttura_integrata e get_gestione_gp4
                                          in caso di integrazione con GPS
   002   13/08/2014  ADADAMO              Modificate funzioni per determinare se il sistema
                                          e' integrato con GP4 o GPS (Bug#483)
   003   26/09/2014  ADADAMO              Aggiunta set_inmo per gestire chiamata
                                          da trigger ubicazioni_componente_tiu in
                                          caso di integrazione con IRIS Bug#525
                                          #550 nuova funzione sposta_componente_gps
   004   15/04/2015  ADADAMO              Modificata riempi_vista_imputazioni in caso
                                          di integrazione con GPS (Bug#592)
         29/04/2015  MMONARI              Aggiunta aggiorna_imputazione_gps #594
         08/05/2015  MMONARI              Aggiunta get_padre_giuridico #593
         03/11/2015  MMONARI              Corretta chiamata dinamica per acquisizione componenti da GP4 #657
         12/08/2016  MMONARI              #737
   005   09/08/2017  MMONARI              #783
   006   12/10/2020  MMONARI              #45269 disaccoppiamento oggetti integrazione GPs
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '005';
   -- Function and procedure implementations
   ----------------------------------------------------------------------------------
   function versione return varchar2 is
      /******************************************************************************
      NOME:        versione.
      DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
      RITORNA:     varchar2 : stringa contenente versione e revisione.
      NOTE:        Primo numero  : versione compatibilità del Package.
                   Secondo numero: revisione del Package specification.
                   Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;
   ----------------------------------------------------------------------------------
   function is_int_gp4 return boolean is
      d_is_int_gp4    number := 0;
      d_utente_oracle varchar2(2000) := sys_context('userenv', 'CURRENT_USER');
   begin
      begin
         select instr(installazione, 'INTGP4')
           into d_is_int_gp4
           from ad4_istanze
         -- Bug#483
          where user_oracle = d_utente_oracle
            and progetto = 'SI4SO'
            and installazione is not null;
      exception
         when others then
            d_is_int_gp4 := 0;
      end;
      return d_is_int_gp4 != 0;
   end;
   ----------------------------------------------------------------------------------
   function is_int_gps return boolean is
      d_is_int_gps    number := 0;
      d_utente_oracle varchar2(2000) := sys_context('userenv', 'CURRENT_USER');
   begin
      begin
         select instr(installazione, 'GPs')
           into d_is_int_gps
           from ad4_istanze
         -- Bug#483
          where user_oracle = d_utente_oracle
            and progetto = 'SI4SO'
            and installazione is not null;
      exception
         when too_many_rows then
            --#783
            d_is_int_gps := 1;
         when others then
            d_is_int_gps := 0;
            --return true; --forzatura
      end;
      return d_is_int_gps != 0;
   end;
   ----------------------------------------------------------------------------------
   function get_moas_id return number is
      /******************************************************************************
      NOME:        get_moas_id
      DESCRIZIONE: Restituisce nuova chiave per inserimento record p00so4_so4gp4_log
      PARAMETRI:
      RITORNA:     p00so4_modifiche_assegnazioni.moas_id%type
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   11/09/2008  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result    number;
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.get_moas_id;  end;';
         execute immediate d_statement
            using in out d_result;
      else
         d_result := '0';
      end if;
      return d_result;
   end get_moas_id;
   ----------------------------------------------------------------------------------
   function get_id_soggetto_as4(p_ni componenti.ni%type) return componenti.ni%type is
      /******************************************************************************
      NOME:        get_id_soggetto_AS4
      DESCRIZIONE: Dato l'ni di P00.anagrafici, restituisce l'id_soggetto di
                   AS4.anagrafe_soggetti associato mediante la tabella
                   DIPENDENTI_SOGGETTI di P00
      PARAMETRI:   p_ni                  componenti.ni%type
      RITORNA:     id_soggetto           componenti.ni%type
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   25/08/2008  VDAVALLI  Prima emissione.
      001   14/04/2009  VDAVALLI  L'abbinamento avviene attraverso la tabella
                                  DIPENDENTI_SOGGETTI di P00
      ******************************************************************************/
      d_statement varchar2(2000); --#45269
      d_result    componenti.ni%type;
   begin
      --
      -- Si seleziona da P00.DIPENDENTI_SOGGETTI l id_soggetto di AS4.ANAGRAFE_SOGGETTI
      -- associato all ni di P00.anagrafici
      --
      begin
         --#45269
         d_statement := 'select ni_as4 from p00_dipendenti_soggetti where ni_gp4 = ' || p_ni;
         execute immediate d_statement
            into d_result;
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
         when others then
            raise_application_error(-20999
                                   ,'Errore in lettura P00_DIPENDENTI_SOGGETTI - ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
      --
   end get_id_soggetto_as4;
   ----------------------------------------------------------------------------------
   function get_ni_as4(p_ni componenti.ni%type) return componenti.ni%type is
      /******************************************************************************
      NOME:        get_ni_P00
      DESCRIZIONE: Dato l'ni di GPs, restituisce l'ni di AS4
                   associato mediante la tabella P00.dipendenti_soggetti
      PARAMETRI:   p_ni                  componenti.ni%type
      RITORNA:     id_soggetto           componenti.ni%type
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   12/10/2020  MMONARI #45269
      ******************************************************************************/
      d_statement varchar2(2000);
      d_result    componenti.ni%type;
   begin
      begin
         d_statement := 'select ni_as4 from p00_dipendenti_soggetti where ni_gp4 = ' || p_ni;
         execute immediate d_statement
            into d_result;
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
         when others then
            raise_application_error(-20999
                                   ,'Errore in lettura P00_DIPENDENTI_SOGGETTI - ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
      --
   end get_ni_as4;
   ----------------------------------------------------------------------------------
   function get_ni_p00(p_ni componenti.ni%type) return componenti.ni%type is
      /******************************************************************************
      NOME:        get_ni_P00
      DESCRIZIONE: Dato l'ni di componenti, restituisce l'ni di P00.anagrafici
                   associato mediante la tabella P00.dipendenti_soggetti
      PARAMETRI:   p_ni                  componenti.ni%type
      RITORNA:     id_soggetto           componenti.ni%type
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   02/09/2008  VDAVALLI  Prima emissione.
      001   14/04/2009  VDAVALLI  L'abbinamento avviene mediante la tabella
                                  DIPENDENTI_SOGGETTI di P00
      ******************************************************************************/
      d_statement varchar2(2000); --#45269
      d_result    componenti.ni%type;
   begin
      --
      -- Si seleziona dalla tabella DIPENDENTI_SOGGETTI di P00 l ni di anagrafe
      -- soggetti AS4
      --
      begin
         --#45269
         d_statement := 'select ni_gp4 from p00_dipendenti_soggetti where ni_as4 = ' || p_ni;
         execute immediate d_statement
            into d_result;
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
         when others then
            raise_application_error(-20999
                                   ,'Errore in lettura P00_DIPENDENTI_SOGGETTI - ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
      --
   end get_ni_p00;
   ----------------------------------------------------------------------------------
   function get_ci
   (
      p_ni  in componenti.ni%type
     ,p_dal in date default null
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_ci
      DESCRIZIONE: Dato l'ni di as4_anagrafe_soggetti, restituisce il CI
                   associati all'anagrafe in P00.
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   12/10/2020  MMONARI Prima emissione.
      ******************************************************************************/
      d_statement varchar2(2000); --#45269
      d_result    varchar2(2000);
   begin
      if is_int_gp4 or is_int_gps then
         --#45269
         d_statement := 'begin :d_result := p00_dipendenti_soggetti_pkg.get_ci(p00_dipendenti_soggetti_pkg.get_ni_gp4(:p_ni)); end;';
         execute immediate d_statement
            using in out d_result, p_ni;
      else
         d_result := to_number(null);
      end if;
      return d_result;
   end;
   ----------------------------------------------------------------------------------
   function get_ni_unor(p_progr_unor componenti.progr_unita_organizzativa%type)
      return number is
      /******************************************************************************
      NOME:        get_ni_unor
      DESCRIZIONE: Dato il progr. unita organizzativa di SO4, restituisce l'ni di GP4
                   associato, null se l'associazione non esiste
      PARAMETRI:   p_progr_unor          componenti.progr_unita_organizzativa%type
      RITORNA:                           p00so4_unita_so4_gp4.ni_gp4%type
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   13/03/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result    number;
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.get_ni_unor(:p_progr_unor);  end;';
         execute immediate d_statement
            using in out d_result, p_progr_unor;
      else
         d_result := '0';
      end if;
      return d_result;
   end get_ni_unor;
   --------------------------------------------------------------------------------
   function get_padre_giuridico
   (
      p_progr_unita_organizzativa componenti.progr_unita_organizzativa%type
     ,p_dal                       componenti.dal%type
     ,p_ottica                    componenti.ottica%type
   ) return componenti.progr_unita_organizzativa%type is
      /******************************************************************************
      NOME:        get_padre_giuridico.
      DESCRIZIONE: determina il padre giuridico dell'UO data
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   08/05/2015  MMONARI  Prima emissione. #593
      ******************************************************************************/
      d_result       componenti.progr_unita_organizzativa%type;
      d_gerarchia    afc.t_ref_cursor;
      d_progr_unor   componenti.progr_unita_organizzativa%type;
      d_codice_uo    anagrafe_unita_organizzative.codice_uo%type;
      d_descr_uo     anagrafe_unita_organizzative.descrizione%type;
      d_dal          unita_organizzative.dal%type;
      d_al           unita_organizzative.al%type;
      d_se_giuridico anagrafe_unita_organizzative.se_giuridico%type;
      --
   begin
      d_gerarchia := so4_util.get_ascendenti(p_progr_unor => p_progr_unita_organizzativa
                                            ,p_data       => p_dal
                                            ,p_ottica     => p_ottica);
      --
      if d_gerarchia%isopen then
         loop
            fetch d_gerarchia
               into d_progr_unor
                   ,d_codice_uo
                   ,d_descr_uo
                   ,d_dal
                   ,d_al;
            exit when d_gerarchia%notfound;
            d_se_giuridico := anagrafe_unita_organizzativa.get_se_giuridico(d_progr_unor
                                                                           ,p_dal);
            if d_se_giuridico = 'SI' then
               d_result := d_progr_unor;
               exit;
            end if;
         end loop;
      else
         d_progr_unor := to_number(null);
         d_result     := d_progr_unor;
      end if;
      --
      return d_result;
   end;
   --------------------------------------------------------------------------------
   procedure ins_modifiche_assegnazioni
   (
      p_ottica            in ottiche.ottica%type
     ,p_ni                in componenti.ni%type
     ,p_ci                in componenti.ci%type
     ,p_provenienza       in varchar2
     ,p_data_modifica     in date
     ,p_revisione_so4     in componenti.revisione_assegnazione%type
     ,p_utente            in componenti.utente_aggiornamento%type
     ,p_data_acquisizione in date
     ,p_data_cessazione   in date
     ,p_data_eliminazione in date
     ,p_funzionale        in varchar2
   ) is
      /******************************************************************************
      NOME:        ins_modifiche_assegnazioni
      DESCRIZIONE: Inserisce un record in modifiche_assegnazioni quando vengono variate
                   l'assegnazione del componente e/o l'incarico e/o l'imputazione bilancio
      PARAMETRI:
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   11/09/2008  VDAVALLI  Prima emissione.
      001   15/10/2012  VDAVALLI  Versione "fake": non esegue alcuna operazione sul db
      ******************************************************************************/
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.ins_modifiche_assegnazioni(:p_ottica,:p_ni,:p_ci,:p_provenienza,:p_data_modifica,:p_revisione_so4,:p_utente,:p_data_acquisizione,:p_data_cessazione,:p_data_eliminazione,:p_funzionale);  end;';
         execute immediate d_statement
            using in p_ottica, p_ni, p_ci, p_provenienza, p_data_modifica, p_revisione_so4, p_utente, p_data_acquisizione, p_data_cessazione, p_data_eliminazione, p_funzionale;
      end if;
   end ins_modifiche_assegnazioni;
   ----------------------------------------------------------------------------------
   procedure tratta_moas_verifica_revisione
   (
      p_ottica    in ottiche.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   ) is
      /******************************************************************************
      NOME:        tratta_moas_verifica_revisione
      DESCRIZIONE: Se è attiva l'integrazione con GP4, trattiamo le eventuali modifiche di assegnazione di provenienza
                   giuridico (MOAS) generate mentre il componente era già stato movimentato nella revisione in modifica di SO4
      ******************************************************************************/
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.tratta_moas_verifica_revisione(:p_ottica,:p_revisione,:p_data);  end;';
         execute immediate d_statement
            using in p_ottica, p_revisione, p_data;
      end if;
   end;
   ----------------------------------------------------------------------------------
   procedure tratta_most_attivazione_rev
   (
      p_ottica    in ottiche.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   ) is
      /******************************************************************************
      NOME:        tratta_most_attivazione_rev
      DESCRIZIONE: Se l'integrazione e' attiva, si controlla se le modifiche di
                   struttura originano una revisione in GP4 e scrivono le UO modificate
      ******************************************************************************/
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.tratta_most_attivazione_rev(:p_ottica,:p_revisione,:p_data);  end;';
         execute immediate d_statement
            using in p_ottica, p_revisione, p_data;
      end if;
   end;
   ----------------------------------------------------------------------------------
   procedure riempi_vista_imputazioni(p_progr_unor unita_organizzative.progr_unita_organizzativa%type) is
      /******************************************************************************
      NOME:        Riempi vista imputazioni
      DESCRIZIONE: Trasferisce il risultato della function gp4so4.get_sedi_gp4
                   in una tabella temporanea per l'utilizzo in Instant Developer
      PARAMETRI:
      ECCEZIONI:   nnnnn, <ExceptionDescription>.
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   20/10/2008  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.riempi_vista_imputazioni(:p_progr_unor); end;';
         execute immediate d_statement
            using p_progr_unor;
      elsif is_int_gps then
         d_statement := 'begin so4gps_pkg.riempi_vista_imputazioni(:p_progr_unor); end;';
         execute immediate d_statement
            using p_progr_unor;
      else
         delete from temp_vista_imputazioni
          where progr_unita_organizzativa = p_progr_unor;
         --
         commit;
         --
      end if;
   end;
   ----------------------------------------------------------------------------------
   function get_sede_unica(p_ni_gp4 number) return number is
      /******************************************************************************
      NOME:        get_sede_unica
      DESCRIZIONE: Lancia l'analoga funzione del package GP4SO4 di P00SO4
      PARAMETRI:
      ECCEZIONI:   nnnnn, <ExceptionDescription>.
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   02/04/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result            number;
      d_statement         varchar2(2000);
      d_ni_unor           componenti.progr_unita_organizzativa%type;
      d_ci                componenti.ci%type;
      d_dal               componenti.dal%type;
      d_al                componenti.al%type;
      d_tipo_assegnazione varchar2(2);
      d_amministrazione   amministrazioni.codice_amministrazione%type;
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := p00so4_gp4so4.get_sede_unica(:p_ni_gp4); end;';
         execute immediate d_statement
            using in out d_result, p_ni_gp4;
      elsif is_int_gps then
         -- se sono integrato con gps nel parametro p_ni_gp4 ho passato id_componente
         d_ni_unor := componente.get_progr_unita_organizzativa(p_ni_gp4);
         d_ci      := componente.get_ci(p_ni_gp4);
         d_dal     := componente.get_dal(p_ni_gp4);
         d_al      := componente.get_al(p_ni_gp4);
         begin
            select tipo_assegnazione
              into d_tipo_assegnazione
              from attributi_componente
             where id_componente = p_ni_gp4;
         exception
            when others then
               d_tipo_assegnazione := 'I';
         end;
         d_amministrazione := ottica.get_amministrazione(componente.get_ottica(p_ni_gp4));
         d_statement       := 'begin :d_result := p00_assegnazioni_struttura_pkg.get_sede_unica(:d_ni_unor,:d_ci,:d_dal,:d_al,:d_tipo_assegnazione,:d_amministrazione); end;';
         execute immediate d_statement
            using in out d_result, d_ni_unor, d_ci, d_dal, d_al, d_tipo_assegnazione, d_amministrazione;
      else
         d_result := null;
      end if;
      return d_result;
   end;
   ----------------------------------------------------------------------------------
   function get_label_sede return varchar2 is
      /******************************************************************************
      NOME:        get_label_sede
      DESCRIZIONE: Lancia l'analoga funzione del package GP4SO4 di P00SO4.
                   Versione per enti non integrati con GP4: restituisce sempre null.
      PARAMETRI:
      ECCEZIONI:   nnnnn, <ExceptionDescription>.
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   10/09/2009  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_statement varchar2(2000);
      d_result    varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := p00so4_gp4so4.get_label_sede; end;';
         execute immediate d_statement
            using in out d_result;
      else
         if is_int_gps then
            d_statement := 'begin :d_result := aziende_tpk.get_nota_sede(''ENTE''); end;';
            execute immediate d_statement
               using in out d_result;
         else
            d_result := null;
         end if;
      end if;
      return d_result;
   end;
   ----------------------------------------------------------------------------------
   function get_valore_gradazione
   (
      p_tipo_incarico             in tipi_incarico.incarico%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_suddivisione              in suddivisioni_struttura.suddivisione%type default null
     ,p_gradazione                in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_data                      date
   ) return number is
      /******************************************************************************
      NOME:        get_valore_gradazione
      DESCRIZIONE: Lancia l'analoga funzione del package GP4SO4 di P00SO4
                   Versione per enti non integrati con GP4: restituisce sempre null.
      PARAMETRI:   p_tipo incarico                 codice incarico
                   p_suddivisione                  codice suddivisione
                   p_gradazione                    gradazione dell'incarico
                   p_data                          data di riferimento
      ECCEZIONI:   nnnnn, <ExceptionDescription>.
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   16/01/2012  VDAVALLI  Prima emissione.
      001   31/05/2012  VDAVALLI  Aggiunti parametri suddivisione e gradazione
      ******************************************************************************/
      d_result    number;
      d_incarico  tipi_incarico.incarico%type;
      d_revisione revisioni_struttura.revisione%type;
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
         begin
            select a.incarico
              into d_incarico
              from tipi_incarico        i
                  ,componenti           c
                  ,attributi_componente a
             where nvl(responsabile, 'NO') = 'SI'
               and c.ottica = p_ottica
               and c.progr_unita_organizzativa = p_progr_unita_organizzativa
               and p_data between nvl(c.dal, p_data) and
                   nvl(decode(nvl(c.revisione_cessazione, -1)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,p_data)
               and c.id_componente = a.id_componente
               and p_data between nvl(a.dal, p_data) and
                   nvl(decode(nvl(c.revisione_cessazione, -1)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,p_data)
               and nvl(a.tipo_assegnazione, 'I') = 'I'
               and nvl(a.assegnazione_prevalente, 0) in (1, 11, 12, 13)
               and a.incarico = i.incarico;
         exception
            when others then
               d_incarico := null;
         end;
         --
         d_statement := 'begin :d_result := p00_valori_base_voce_pkg.valore_gradazione(:p_data
                                                            ,p00so4_gp4so4.get_tipo_rapporto(nvl(:d_incarico
                                                                                                ,:p_tipo_incarico)
                                                                                            ,:p_suddivisione
                                                                                            ,:p_gradazione
                                                                                            ,'''')); end;';
         execute immediate d_statement
            using in out d_result, p_data, d_incarico, p_tipo_incarico, p_suddivisione, p_gradazione;
         --
      else
         d_result := to_number(null);
      end if;
      return d_result;
   end;
   ----------------------------------------------------------------------------------
   function get_fascia_gradazione
   (
      p_tipo_incarico             in tipi_incarico.incarico%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_suddivisione              in suddivisioni_struttura.suddivisione%type
     ,p_gradazione                in anagrafe_unita_organizzative.tipologia_unita%type
     ,p_data                      date
   ) return varchar2 is
      /******************************************************************************
      NOME:        get_fascia_gradazione
      DESCRIZIONE: Lancia l'analoga funzione del package GP4SO4 di P00SO4
                   Versione per enti non integrati con GP4: restituisce sempre null.
      PARAMETRI:
      ECCEZIONI:   nnnnn, <ExceptionDescription>.
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      ******************************************************************************/
      d_result    varchar2(10);
      d_incarico  tipi_incarico.incarico%type;
      d_revisione revisioni_struttura.revisione%type;
      d_statement varchar2(2000);
   begin
      --
      if is_int_gp4 then
         d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
         begin
            select a.incarico
              into d_incarico
              from tipi_incarico        i
                  ,componenti           c
                  ,attributi_componente a
             where nvl(responsabile, 'NO') = 'SI'
               and c.ottica = p_ottica
               and c.progr_unita_organizzativa = p_progr_unita_organizzativa
               and p_data between nvl(c.dal, p_data) and
                   nvl(decode(nvl(c.revisione_cessazione, -1)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,p_data)
               and c.id_componente = a.id_componente
               and p_data between nvl(a.dal, p_data) and
                   nvl(decode(nvl(c.revisione_cessazione, -1)
                             ,d_revisione
                             ,to_date(null)
                             ,c.al)
                      ,p_data)
               and nvl(a.tipo_assegnazione, 'I') = 'I'
               and nvl(a.assegnazione_prevalente, 0) in (1, 11, 12, 13)
               and a.incarico = i.incarico;
         exception
            when others then
               d_incarico := null;
         end;
         --
         d_statement := 'begin :d_result := p00so4_gp4so4.get_tipo_rapporto(nvl(:d_incarico, :p_tipo_incarico)
                                                                             ,:p_suddivisione
                                                                             ,:p_gradazione
                                                                             ,'''');  end;';
         execute immediate d_statement
            using in out d_result, d_incarico, p_tipo_incarico, p_suddivisione, p_gradazione;
      else
         d_result := null;
      end if;
      --
      return d_result;
   end;
   ----------------------------------------------------------------------------------
   function controllo_modificabilita
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        controllo_modificabilita
       DESCRIZIONE: In presenza di integrazione con GP4, verifica che non ci siano
                    modifiche da acquisire. In caso contrario, la modifica del
                    componente non e' consentita.
       PARAMETRI:   p_ottica
                    p_ni
                    p_ci
       RITORNA:     afc_error.ok, altrimenti codice errore
      ******************************************************************************/
      d_result    afc_error.t_error_number;
      d_contatore number(8);
      d_statement varchar2(2000);
   begin
      ------------------------------------------
      if is_int_gp4 and p_ci is not null then
         d_statement := 'begin :d_result := so4gp4.controllo_modificabilita(:p_ottica,:p_ni,:p_ci);  end;';
         execute immediate d_statement
            using in p_ottica, p_ni, p_ci;
         --
         if d_contatore = 0 then
            d_result := afc_error.ok;
         else
            d_result := afc_error.generic_error_number;
         end if;
      else
         d_result := afc_error.ok;
      end if;
      --
      return d_result;
      --
   end;
   ----------------------------------------------------------------------------------
   function get_numero_ci(p_ni componenti.ni%type) return number is
      /******************************************************************************
      NOME:        get_numero_ci
      DESCRIZIONE: Dato l'ni di as4_anagrafe_soggetti, restituisce il numero di CI
                   associati all'anagrafe in P00.
      PARAMETRI:   p_ni                  componenti.ni%type
      RITORNA:     id_soggetto           componenti.ni%type
      REVISIONI:   .
      Rev.  Data        Autore  Descrizione.
      ----  ----------  ------  ---------------------------------------------------.
      000   12/10/2012  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_statement varchar2(2000); --#45269
      d_result    number;
   begin
      if is_int_gp4 or is_int_gps then
         --#45269
         d_statement := 'select count(*)
           from as4_anagrafe_soggetti    a
               ,p00_dipendenti_soggetti  d
               ,p00_rapporti_individuali r
          where a.ni = d.ni_as4
            and r.ni = d.ni_gp4
            and p00_classi_rapporto_tpk.get_componente(r.rapporto) = ''SI''
            and a.al is null
            and a.ni = ' || p_ni;
         execute immediate d_statement
            into d_result;
      else
         d_result := to_number(null);
      end if;
      return d_result;
   end;
   ----------------------------------------------------------------------------------
   function is_componente_ok
   (
      p_ci            componenti.ci%type
     ,p_data_modifica date
   ) return varchar2 is
      d_result    varchar2(1);
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.is_componente_ok(:p_ci,:p_data_modifica);  end;';
         execute immediate d_statement
            using in out d_result, p_ci, p_data_modifica;
      else
         d_result := '0';
      end if;
      return d_result;
   end;
   --------------------------------------------------------------------------------
   procedure ins_unita_so4_gp4
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) is
      /******************************************************************************
       NOME:        ins_unita_so4_gp4
       DESCRIZIONE: Gestione tabella UNITA_SO4_GP4 per integrazione con GP4
                    p_progr_unita_organizzativa
                    p_dal
                    p_utente_aggiornamento
                    p_amministrazione
       RITORNA:     -
      ******************************************************************************/
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.ins_unita_so4_gp4(:p_progr_unita_organizzativa,:p_dal,:p_utente_aggiornamento,:p_amministrazione);  end;';
         execute immediate d_statement
            using in p_progr_unita_organizzativa, p_dal, p_utente_aggiornamento, p_amministrazione;
      end if;
   end;
   --------------------------------------------------------------------------------
   function is_struttura_integrata
   (
      p_amministrazione in varchar2
     ,p_ottica          in varchar2
   ) return varchar2 is
      d_result    varchar2(2);
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.is_struttura_integrata(:p_amministrazione,:p_ottica);  end;';
         execute immediate d_statement
            using in out d_result, p_amministrazione, p_ottica;
      else
         if is_int_gps then
            d_statement := 'begin :d_result := so4gps_pkg.is_struttura_integrata(:p_amministrazione,:p_ottica);  end;';
            execute immediate d_statement
               using in out d_result, p_amministrazione, p_ottica;
         else
            d_result := 'NO';
         end if;
      end if;
      return(d_result);
   end is_struttura_integrata;
   --------------------------------------------------------------------------------
   function get_data_modifica_moas(p_ci in number) return date is
      d_result    date;
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.get_data_modifica_moas(:p_ci);  end;';
         execute immediate d_statement
            using in out d_result, p_ci;
      else
         d_result := to_date(null);
      end if;
      return(d_result);
   end get_data_modifica_moas;
   --------------------------------------------------------------------------------
   function get_no_elaborazione(p_provenienza in varchar2) return number is
      d_result    number;
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.get_no_elaborazione(:p_provenienza);  end;';
         execute immediate d_statement
            using in out d_result, p_provenienza;
      else
         d_result := to_number(null);
      end if;
      return(d_result);
   end get_no_elaborazione;
   --------------------------------------------------------------------------------
   function get_gestione_gp4(p_amministrazione in varchar2) return varchar2 is
      d_result    varchar2(16);
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin :d_result := so4gp4.get_gestione_gp4(:p_amministrazione);  end;';
         execute immediate d_statement
            using in out d_result, p_amministrazione;
      else
         if is_int_gps then
            d_statement := 'begin :d_result := so4gps_pkg.get_gestione_gp4(:p_amministrazione);  end;';
            execute immediate d_statement
               using in out d_result, p_amministrazione;
         else
            d_result := to_number(null);
         end if;
      end if;
      return(d_result);
   end get_gestione_gp4;
   --------------------------------------------------------------------------------
   procedure set_data_modifica_moas
   (
      p_ci   in number
     ,p_data in date
   ) is
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.set_data_modifica_moas(:p_ci,:p_data);  end;';
         execute immediate d_statement
            using in p_ci, p_data;
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure acquisizione_componenti_gp4
   (
      p_prima_acquisizione varchar2
     ,p_ci                 number default null
     ,p_no_elaborazione    number default null
   ) is
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.acquisizione_componenti_gp4(:p_prima_acquisizione,:p_ci,:p_no_elaborazione);  end;'; --#657
         execute immediate d_statement
            using in p_prima_acquisizione, p_ci, p_no_elaborazione;
      end if;
   end;
   -- Bug#525
   procedure set_inmo
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in ubicazioni_componente.dal%type
   ) is
      d_statement varchar2(2000);
   begin
      if is_int_gp4 then
         d_statement := 'begin so4gp4.set_inmo(:p_id_componente,:p_dal);  end;';
         execute immediate d_statement
            using in p_id_componente, p_dal;
      elsif is_int_gps then
         --#737
         d_statement := 'begin gps_util.set_inmo(:p_id_componente,:p_dal);  end;';
         execute immediate d_statement
            using in p_id_componente, p_dal;
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure sposta_componente_gps
   (
      p_ci                        in componenti.ci%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type
     ,p_assegnazione_prevalente   in attributi_componente.assegnazione_prevalente%type
     ,p_amministrazione           in amministrazioni.codice_amministrazione%type
     ,p_utente                    in componenti.utente_aggiornamento%type
   ) is
      d_statement varchar2(2000);
   begin
      if is_int_gps then
         --#550 (temporaneamente sospesa per distribuzione 1.4.5.1)
         d_statement := 'begin so4gps_pkg.sposta_componente_gps(:p_ci,:p_progr_unita_organizzativa,:p_dal,:p_al,:p_assegnazione_prevalente,:p_amministrazione,:p_utente);  end;';
         execute immediate d_statement
            using in p_ci, p_progr_unita_organizzativa, p_dal, p_al, p_assegnazione_prevalente, p_amministrazione, p_utente;
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure ripristina_componente_gps
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente                  in componenti.utente_aggiornamento%type
   ) is
      d_statement varchar2(2000);
   begin
      if is_int_gps then
         --#550
         d_statement := 'begin so4gps_pkg.ripristina_componente_gps(:p_ci,:p_dal,:p_al,:p_assegnazione_prevalente,:p_utente);  end;';
         execute immediate d_statement
            using in p_ci, p_dal, p_al, p_assegnazione_prevalente, p_utente;
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure aggiorna_imputazione_gps
   (
      p_ci                      in componenti.ci%type
     ,p_dal                     in componenti.dal%type
     ,p_al                      in componenti.al%type
     ,p_old_dal                 in componenti.dal%type
     ,p_old_al                  in componenti.al%type
     ,p_sede                    in imputazioni_bilancio.numero%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_utente                  in imputazioni_bilancio.utente_agg%type
   ) is
      d_statement varchar2(2000);
   begin
      if is_int_gps then
         --#594
         d_statement := 'begin so4gps_pkg.aggiorna_imputazione_gps(:p_ci,:p_dal,:p_al,:p_old_dal,:p_old_al,:p_numero,:p_assegnazione_prevalente,:p_utente);  end;';
         execute immediate d_statement
            using in p_ci, p_dal, p_al, p_old_dal, p_old_al, p_sede, p_assegnazione_prevalente, p_utente;
      end if;
   end;
end so4gp_pkg;
/


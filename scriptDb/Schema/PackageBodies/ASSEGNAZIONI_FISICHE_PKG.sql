CREATE OR REPLACE package body assegnazioni_fisiche_pkg is
   /******************************************************************************
    NOME:        assegnazioni_fisiche_pkg
    DESCRIZIONE: Gestione tabella ASSEGNAZIONI_FISICHE.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   16/08/2012  mmonari     Generazione automatica
    001   03/07/2013  vari        nuova funzione get_unita_fisica Feature#306
    002   11/04/2014  ADADAMO     Introdotto controllo di assegnazione su unita'
                                  in struttura Bug#428
                      MMONARI     Integrato il messaggio s_uf_non_valida_num #386
          02/07/2014  MMONARI     Condizionata l'esecuzione della is_dal_al_ok #371
    003   12/04/2017  MMONARI     #765 - Condizioni di esecuzione sui controlli di chk_ri
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '003 - 12/04/2017';
   -- Variabili di appoggio per i parametri di ins, upd e del   /* SIAPKGen: generazione automatica */
   --   /* SIAPKGen: generazione automatica */
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   --
   s_dummy varchar2(1);
   --------------------------------------------------------------------------------
   function versione return varchar2 is
      /******************************************************************************
       NOME:        versione
       DESCRIZIONE: Versione e revisione di distribuzione del package.
       RITORNA:     varchar2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return afc.version(s_revisione, s_revisione_body);
   end versione; -- assegnazioni_fisiche_pkg.versione
   --------------------------------------------------------------------------------
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      /******************************************************************************
       NOME:        error_message
       DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
       NOTE:        Restituisce il messaggio abbinato al numero indicato nella tabella
                    s_error_table del Package. Se p_error_number non e presente nella
                    tabella s_error_table viene lanciata l'exception -20011 (vedi AFC_Error)
      ******************************************************************************/
      d_result afc_error.t_error_msg;
      d_detail afc_error.t_error_msg;
   begin
      if s_error_detail.exists(p_error_number) then
         d_detail := s_error_detail(p_error_number);
      end if;
      if s_error_table.exists(p_error_number) then
         d_result := s_error_table(p_error_number) || d_detail;
         s_error_detail(p_error_number) := '';
      else
         raise_application_error(afc_error.exception_not_in_table_number
                                ,afc_error.exception_not_in_table_msg);
      end if;
      return d_result;
   end error_message; -- assegnazioni_fisiche_pkg.error_message
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in assegnazioni_fisiche.dal%type
     ,p_al  in assegnazioni_fisiche.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if nvl(p_dal, to_date('01011800', 'ddmmyyyy')) >
         nvl(p_al, to_date('31122200', 'ddmmyyyy')) then
         dbms_output.put_line('verifica dal - al : ' || p_dal || ' ' || p_al);
         d_result := s_dal_al_errato_num;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_dal in assegnazioni_fisiche.dal%type
     ,p_al  in assegnazioni_fisiche.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Function di gestione Data Integrity
       PARAMETRI:   is_dal_al_ok
                    is_tipo_assegnazione_ok
                    is_revisioni_ok
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_dal_al_ok
      if revisione_struttura.s_attivazione <> 1 then
         --#371
         d_result := is_dal_al_ok(p_dal, p_al);
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_dal in assegnazioni_fisiche.dal%type
     ,p_al  in assegnazioni_fisiche.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_di_ok(p_dal, p_al);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- assegnazioni_fisiche_pkg.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                  in assegnazioni_fisiche.dal%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso nella storicita' di UF, UO e Componente
       NOTE:        --
      ******************************************************************************/
      d_dal_uf   anagrafe_unita_fisiche.dal%type;
      d_dal_uo   anagrafe_unita_organizzative.dal%type;
      d_dal_comp componenti.dal%type;
      d_result   afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo dal compreso in storicita' di UF, UO e componente
      d_dal_uf := anagrafe_unita_fisica.get_dal_min(p_progr_unita_fisica => p_progr_uf);
      if p_new_dal < d_dal_uf then
         d_result := s_dal_minore_uf_num;
      end if;
      if d_result = afc_error.ok and p_id_ubicazione_componente is not null then
         d_dal_comp := componente.get_dal(ubicazione_componente.get_id_componente(p_id_ubicazione_componente => p_id_ubicazione_componente));
         if p_new_dal < d_dal_comp then
            d_result := s_dal_minore_comp_num;
         end if;
      end if;
      if d_result = afc_error.ok and p_progr_uo is not null then
         d_dal_uo := anagrafe_unita_organizzativa.get_dal_id(p_progr_uo, p_new_dal);
         if p_new_dal < d_dal_uo then
            d_result := s_dal_minore_uo_num;
         end if;
      end if;
      -- controllo dal sovrapposto ad altri periodi di attributo
      if d_result = afc_error.ok then
         begin
            select 'x'
              into s_dummy
              from assegnazioni_fisiche a
             where a.ni = p_ni
               and p_new_dal between nvl(a.dal, to_date(2222222, 'j')) and
                   nvl(a.al, to_date(3333333, 'j'))
               and a.id_asfi <> p_id_asfi;
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_dal_sovrapposto_num;
         end;
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_al                   in assegnazioni_fisiche.al%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok
       NOTE:        --
      ******************************************************************************/
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo nuovo al compreso nella storicita' di UF
       NOTE:        --
      ******************************************************************************/
      d_al_uf   anagrafe_unita_fisiche.dal%type;
      d_al_uo   anagrafe_unita_organizzative.al%type;
      d_al_comp componenti.al%type;
      d_result  afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo dal compreso in storicita' di UF, UO e componente
      d_al_uf := anagrafe_unita_fisica.get_max_al(p_progr_unita_fisica => p_progr_uf);
      if nvl(p_new_al, to_date(3333333, 'j')) > nvl(d_al_uf, to_date(3333333, 'j')) then
         d_result := s_al_maggiore_uf_num;
      end if;
      if d_result = afc_error.ok and p_id_ubicazione_componente is not null then
         d_al_comp := componente.get_al(ubicazione_componente.get_id_componente(p_id_ubicazione_componente => p_id_ubicazione_componente));
         if nvl(p_new_al, to_date(3333333, 'j')) > nvl(d_al_comp, to_date(3333333, 'j')) then
            d_result := s_al_maggiore_comp_num;
         end if;
      end if;
      if d_result = afc_error.ok and p_progr_uo is not null then
         d_al_uo := anagrafe_unita_organizzativa.get_al(p_progr_uo
                                                       ,anagrafe_unita_organizzativa.get_dal_id(p_progr_uo
                                                                                               ,nvl(p_new_al
                                                                                                   ,to_date(3333333
                                                                                                           ,'j'))));
         if nvl(p_new_al, to_date(3333333, 'j')) > nvl(d_al_uo, to_date(3333333, 'j')) then
            d_result := s_al_maggiore_uo_num;
         end if;
      end if;
      -- controllo dal sovrapposto ad altri periodi di attributo
      if d_result = afc_error.ok then
         begin
            select 'x'
              into s_dummy
              from assegnazioni_fisiche a
             where a.ni = p_ni
               and nvl(p_new_al, to_date(3333333, 'j')) between
                   nvl(a.dal, to_date(2222222, 'j')) and nvl(a.al, to_date(3333333, 'j'))
               and a.id_asfi <> p_id_asfi;
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_al_sovrapposto_num;
         end;
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_dal_ok
   --------------------------------------------------------------------------------
   function is_capienza_uf_ok
   (
      p_id_asfi  in assegnazioni_fisiche.id_asfi%type
     ,p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_capienza_uf_ok
       DESCRIZIONE: Controlla sel e' stata superata la capineza massima prevista per la UF
       NOTE:        --
      ******************************************************************************/
      d_capienza         anagrafe_unita_fisiche.capienza%type;
      d_num_assegnazioni number(4);
      d_data             date := trunc(sysdate);
      d_result           afc_error.t_error_number := afc_error.ok;
   begin
      d_capienza := anagrafe_unita_fisica.get_capienza(p_progr_uf
                                                      ,anagrafe_unita_fisica.get_dal_id(p_progr_uf
                                                                                       ,trunc(d_data)));
      if d_capienza is not null then
         select nvl(count(*), 0)
           into d_num_assegnazioni
           from assegnazioni_fisiche a
          where a.progr_unita_fisica = p_progr_uf
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
         if d_num_assegnazioni > d_capienza then
            d_result := s_superata_capienza_uf_num;
         end if;
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_capienza_uf_ok
   --------------------------------------------------------------------------------
   function is_soggetto_esterno
   (
      p_ni              in assegnazioni_fisiche.ni%type
     ,p_amministrazione in ottiche.amministrazione%type
     ,p_dal             in date
     ,p_al              in date
   ) return varchar2 is
      /******************************************************************************
       NOME:        is_capienza_uf_ok
       DESCRIZIONE: Controlla sel e' stata superata la capineza massima prevista per la UF
       NOTE:        --
      ******************************************************************************/
      d_num_assegnazioni number(4) := 0;
      d_result           varchar2(2) := 'NO';
   begin
      if (p_ni is not null and p_amministrazione is not null and p_dal is not null) then
         select count(*)
           into d_num_assegnazioni
           from componenti
          where ottica in
                (select ottica from ottiche where amministrazione = p_amministrazione)
            and nvl(al, to_date(3333333, 'j')) >= p_dal
            and dal <= nvl(p_al, to_date(3333333, 'j'))
            and ni = p_ni;
         if d_num_assegnazioni = 0 then
            d_result := 'SI';
         end if;
      else
         d_result := 'NO';
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_soggetto_esterno
   --------------------------------------------------------------------------------
   function get_unita_fisica
   (
      p_ni   assegnazioni_fisiche.ni%type
     ,p_data assegnazioni_fisiche.dal%type
   ) return assegnazioni_fisiche.progr_unita_fisica%type is
      /******************************************************************************
       NOME:        get_unita_fisica
       DESCRIZIONE: Dato un ni restituisce l'unita fisica di appartenenza
       NOTE:        --
      ******************************************************************************/
      d_result assegnazioni_fisiche.progr_unita_fisica%type;
      d_data   assegnazioni_fisiche.dal%type;
   begin
      if p_data is null then
         d_data := trunc(sysdate);
      else
         d_data := p_data;
      end if;
      --
      begin
         select progr_unita_fisica
           into d_result
           from assegnazioni_fisiche
          where ni = p_ni
            and d_data between dal and nvl(al, s_data_limite);
      exception
         when others then
            d_result := to_number(null);
      end;
      --
      return d_result;
      --
   end; -- assegnazioni_fisiche_pkg.get_unita_fisica
   --------------------------------------------------------------------------------
   function get_id_asfi return number is
      /******************************************************************************
       NOME:        get_id_asfi
       DESCRIZIONE: restituisce l'id successivo
       NOTE:        --
      ******************************************************************************/
      d_result number;
   begin
      select assegnazioni_fisiche_sq.nextval into d_result from dual;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_soggetto_esterno
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                  in assegnazioni_fisiche.dal%type
     ,p_new_dal                  in assegnazioni_fisiche.dal%type
     ,p_old_al                   in assegnazioni_fisiche.al%type
     ,p_new_al                   in assegnazioni_fisiche.al%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_ubicazione_componente
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result    afc_error.t_error_number := afc_error.ok;
      d_contatore number := 0;
      d_min_dal   varchar2(10);
      d_dummy     varchar2(1);
   begin
      if p_deleting = 0 and p_new_dal <= nvl(p_new_al, to_date(3333333, 'j')) then --#765
         -- is_dal_ok
         if d_result = afc_error.ok then
            d_result := is_dal_ok(p_id_asfi
                                 ,p_ni
                                 ,p_progr_uf
                                 ,p_id_ubicazione_componente
                                 ,p_progr_uo
                                 ,p_new_dal
                                 ,p_rowid
                                 ,p_inserting
                                 ,p_updating);
         end if;
         -- is_al_ok
         if d_result = afc_error.ok then
            d_result := is_al_ok(p_id_asfi
                                ,p_ni
                                ,p_progr_uf
                                ,p_id_ubicazione_componente
                                ,p_progr_uo
                                ,p_new_al
                                ,p_rowid
                                ,p_inserting
                                ,p_updating);
         end if;
         -- controlla la sovrapposizione con altri periodi
         if d_result = afc_error.ok then
            select count(*)
              into d_contatore
              from assegnazioni_fisiche a
             where a.ni = p_ni
               and nvl(p_new_al, to_date(3333333, 'j')) >=
                   nvl(a.dal, to_date(2222222, 'j'))
               and nvl(a.al, to_date(3333333, 'j')) >= p_new_dal
               and a.id_asfi <> p_id_asfi;
            if d_contatore > 0 then
               d_result := s_periodi_sovrapposti_num;
            end if;
         end if;
      else
         -- verifica dell'integrita' storica su attributi unita fisica
         begin
            select s_esistono_attributi_num
              into d_result
              from dual
             where exists (select 'x'
                      from attributi_assegnazione_fisica a
                     where a.id_asfi = p_id_asfi);
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_esistono_attributi_num;
         end;
      end if;
      -- copertura periodo
      -- la UF deve essere valida per l'intero periodo dell'assegnazione
      if d_result = afc_error.ok and p_deleting <> 1 and
         p_new_dal <= nvl(p_new_al, to_date(3333333, 'j')) then
         begin
            select 'x'
              into d_dummy
              from unita_fisiche u
             where u.progr_unita_fisica = p_progr_uf
               and exists (select 'x'
                      from unita_fisiche
                     where progr_unita_fisica = u.progr_unita_fisica
                       and amministrazione = u.amministrazione
                       and nvl(p_new_dal, nvl(dal, to_date(2222222, 'j'))) between
                           nvl(dal, to_date(2222222, 'j')) and
                           nvl(al, to_date(3333333, 'j')))
               and exists (select 'x'
                      from unita_fisiche
                     where progr_unita_fisica = u.progr_unita_fisica
                       and amministrazione = u.amministrazione
                       and nvl(p_new_al, to_date(3333333, 'j')) between
                           nvl(dal, to_date(2222222, 'j')) and
                           nvl(al, to_date(3333333, 'j')));
            raise too_many_rows;
         exception
            when too_many_rows then
               null;
            when no_data_found then
               select to_char(dal, 'dd/mm/yyyy') --#386
                 into d_min_dal
                 from unita_fisiche
                where progr_unita_fisica = p_progr_uf
                  and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'));
               d_result := s_uf_non_valida_num;
               s_error_detail(d_result) := d_min_dal;
         end;
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_ni                       in anagrafe_soggetti.ni%type
     ,p_progr_uf                 in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_progr_uo                 in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                  in assegnazioni_fisiche.dal%type
     ,p_new_dal                  in assegnazioni_fisiche.dal%type
     ,p_old_al                   in assegnazioni_fisiche.al%type
     ,p_new_al                   in assegnazioni_fisiche.al%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_compoennte
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_id_asfi
                          ,p_ni
                          ,p_progr_uf
                          ,p_id_ubicazione_componente
                          ,p_progr_uo
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result)); --#386
      end if;
   end; -- assegnazioni_fisiche_pkg.chk_RI
   ---------------------------------------------------------------------------------------
   -- Spostamento di un individuo da una UF ad un'altra
   procedure sposta_assegnazione
   (
      p_id_elemento_arrivo     in unita_organizzative.id_elemento%type
     ,p_id_asfi                in assegnazioni_fisiche.id_asfi%type
     ,p_dal                    in assegnazioni_fisiche.dal%type
     ,p_al                     in assegnazioni_fisiche.al%type
     ,p_data_aggiornamento     in assegnazioni_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in assegnazioni_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        sposta_legame.
       DESCRIZIONE: Spostamente di un individuo da una UF ad un'altra
       PARAMETRI:   p_id_elemento_partenza
                    p_id_elemento_arrivo
                    p_dal
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_id_elemento_partenza      unita_organizzative.id_elemento%type;
      d_sequenza                  unita_fisiche.sequenza%type;
      d_progr_unita_fisica        unita_organizzative.progr_unita_organizzativa%type;
      d_progr_unita_fisica_arrivo unita_fisiche.progr_unita_fisica%type;
      d_progr_unita_padre         unita_fisiche.id_unita_fisica_padre%type;
      d_dal                       unita_fisiche.dal%type;
      d_amministrazione           unita_fisiche.amministrazione%type;
      d_data                      date := trunc(sysdate);
      d_descr_unita               anagrafe_unita_fisiche.denominazione%type;
      w_asfi                      assegnazioni_fisiche%rowtype;
      d_errore               exception;
      d_errore_non_bloccante exception;
   begin
      begin
         select * into w_asfi from assegnazioni_fisiche where id_asfi = p_id_asfi;
         select sequenza
               ,progr_unita_fisica
               ,id_unita_fisica_padre
               ,dal
               ,amministrazione
               ,d_id_elemento_partenza
           into d_sequenza
               ,d_progr_unita_fisica
               ,d_progr_unita_padre
               ,d_dal
               ,d_amministrazione
               ,d_id_elemento_partenza
           from unita_fisiche
          where progr_unita_fisica = w_asfi.progr_unita_fisica
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := error_message(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      begin
         d_descr_unita := anagrafe_unita_fisica.get_denominazione(d_progr_unita_fisica
                                                                 ,d_dal);
      exception
         when no_data_found then
            d_descr_unita := '*';
      end;
      --
      begin
         select progr_unita_fisica
           into d_progr_unita_fisica_arrivo
           from unita_fisiche
          where id_elemento_fisico = p_id_elemento_arrivo;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := error_message(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      --- Non si può spostare un individuo nell'ambito della stessa UF
      --
      if d_progr_unita_fisica_arrivo = d_progr_unita_padre then
         p_segnalazione := 'Spostamento non significativo';
         raise d_errore_non_bloccante;
      end if;
      /* Gestione dello spostamento:
         Se assegnazioni_fisiche.dal = oggi, eseguiamo l'update del periodo, altrimenti chiudiamo il periodo al giorno precedente
         ed inseriamo la nuova assegnazione con decorrenza oggi
      */
      if d_dal = d_data then
         -- spostamento successivo ad un altro eseguito nella stessa sessione di lavoro
         begin
            update assegnazioni_fisiche
               set progr_unita_fisica   = d_progr_unita_fisica_arrivo
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_asfi = p_id_asfi;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
         --
      else
         begin
            update assegnazioni_fisiche
               set al                   = d_data - 1
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_asfi = p_id_asfi;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
         declare
            v_id_elemento unita_organizzative.id_elemento%type;
         begin
            insert into assegnazioni_fisiche
               (id_asfi
               ,id_ubicazione_componente
               ,ni
               ,progr_unita_fisica
               ,dal
               ,al
               ,progr_unita_organizzativa
               ,utente_aggiornamento
               ,data_aggiornamento)
            values
               (null
               ,null
               ,w_asfi.ni
               ,d_progr_unita_fisica_arrivo
               ,d_data
               ,to_date(null)
               ,null
               ,p_utente_aggiornamento
               ,p_data_aggiornamento)
            returning id_asfi into v_id_elemento;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      end if;
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.F.: ' || d_descr_unita || ' - ' || p_segnalazione;
      when d_errore_non_bloccante then
         null;
   end;
   --------------------------------------------------------------------------------
/*procedure set_fi(p_ < attributo > in assegnazioni_fisiche. < attributo > %type, .. .) is
\******************************************************************************
 NOME:        set_FI.
 DESCRIZIONE: Gestione della Functional Integrity.
 PARAMETRI:  p_<attributo>
             , ...
 NOTE:        --
******************************************************************************\
begin
< statement >
end set_fi; -- assegnazioni_fisiche_pkg.set_FI
--------------------------------------------------------------------------------
*/
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_num) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_num) := s_dal_errato_msg;
   s_error_table(s_dal_minore_uf_num) := s_dal_minore_uf_msg;
   s_error_table(s_dal_minore_uo_num) := s_dal_minore_uo_msg;
   s_error_table(s_dal_minore_comp_num) := s_dal_minore_comp_msg;
   s_error_table(s_al_maggiore_uf_num) := s_al_maggiore_uf_msg;
   s_error_table(s_al_maggiore_uo_num) := s_al_maggiore_uo_msg;
   s_error_table(s_al_maggiore_comp_num) := s_al_maggiore_comp_msg;
   s_error_table(s_dal_sovrapposto_num) := s_dal_sovrapposto_msg;
   s_error_table(s_al_sovrapposto_num) := s_al_sovrapposto_msg;
   s_error_table(s_superata_capienza_uf_num) := s_superata_capienza_uf_msg;
   s_error_table(s_esistono_attributi_num) := s_esistono_attributi_msg;
   s_error_table(s_periodi_sovrapposti_num) := s_periodi_sovrapposti_msg;
   s_error_table(s_uf_non_valida_num) := s_uf_non_valida_msg;
end assegnazioni_fisiche_pkg;
/


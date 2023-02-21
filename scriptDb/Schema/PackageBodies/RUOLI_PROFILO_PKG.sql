CREATE OR REPLACE package body ruoli_profilo_pkg is
   /******************************************************************************
    NOME:        ruoli_profilo_pkg
    DESCRIZIONE: Gestione tabella RUOLI_PROFILO.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   26/08/2014  mmonari  Generazione automatica
    001   19/04/2017  mmonari  #762
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '001 - 19/04/2017';
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   s_nulld        date := to_date(3333333, 'j');
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
   end versione; -- ruoli_profilo_pkg.versione
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
   end error_message; -- ruoli_profilo_pkg.error_message
   --------------------------------------------------------------------------------
   function get_id_ruolo_profilo return number is
      d_id_ruolo_profilo ruoli_profilo.id_ruolo_profilo%type;
   begin
      begin
         select ruoli_profilo_sq.nextval into d_id_ruolo_profilo from dual;
      end;
      return d_id_ruolo_profilo;
   end;
   --------------------------------------------------------------------------------
   function is_profilo_in_uso
   (
      p_profilo in ruoli_profilo.ruolo_profilo%type
     ,p_data    in date default to_date(null)
   ) return boolean is
      d_profilo_in_uso number := 0;
   begin
      begin
         select nvl(count(*), 0)
           into d_profilo_in_uso
           from ruoli_componente
          where ruolo = p_profilo
            and nvl(al, to_date(3333333, 'j')) >= nvl(p_data, to_date(2222222, 'j'));
      end;
      return d_profilo_in_uso != 0;
   end;
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in unita_organizzative.dal%type
     ,p_al  in unita_organizzative.al%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number;
   begin
      if nvl(p_dal, to_date(2222222, 'j')) > nvl(p_al, s_nulld) then
         d_result := s_dal_al_errato_number;
      else
         d_result := afc_error.ok;
      end if;
      return d_result;
   end;

   --------------------------------------------------------------------------------

   procedure chk_di
   (
      p_dal in ruoli_profilo.dal%type
     ,p_al  in ruoli_profilo.al%type
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

   end; -- ruolo_profilo.chk_DI

   --------------------------------------------------------------------------------

   function is_di_ok
   (
      p_dal in ruoli_profilo.dal%type
     ,p_al  in ruoli_profilo.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin

      -- is_dal_al_ok
      d_result := is_dal_al_ok(p_dal, p_al);

      return d_result;

   end; -- ruolo_profilo.is_DI_ok

   --------------------------------------------------------------------------------

   procedure chk_ri
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo    in ruoli_profilo.ruolo_profilo%type
     ,p_old_dal          in ruoli_profilo.dal%type
     ,p_new_dal          in ruoli_profilo.dal%type
     ,p_old_al           in ruoli_profilo.al%type
     ,p_new_al           in ruoli_profilo.al%type
     ,p_new_ruolo        in ruoli_profilo.ruolo%type
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
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin

      d_result := is_ri_ok(p_id_ruolo_profilo
                          ,p_ruolo_profilo
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_new_ruolo);

      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;

   end;

   --------------------------------------------------------------------------------

   function is_ri_ok
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo    in ruoli_profilo.ruolo_profilo%type
     ,p_old_dal          in ruoli_profilo.dal%type
     ,p_new_dal          in ruoli_profilo.dal%type
     ,p_old_al           in ruoli_profilo.al%type
     ,p_new_al           in ruoli_profilo.al%type
     ,p_new_ruolo        in ruoli_profilo.ruolo%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_ruolo_profilo
                    p_ruolo_profilo
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_new_ruolo
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin

      -- is_ruolo_ok
      d_result := is_ruolo_ok(p_id_ruolo_profilo
                             ,p_ruolo_profilo
                             ,p_new_dal
                             ,p_new_al
                             ,p_new_ruolo);

      if (d_result = afc_error.ok) then
         d_result := is_relazione_ok(p_new_dal, p_new_al);
      end if;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function is_ruolo_ok
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo    in ruoli_profilo.ruolo_profilo%type
     ,p_new_dal          in ruoli_profilo.dal%type
     ,p_new_al           in ruoli_profilo.al%type
     ,p_new_ruolo        in ruoli_profilo.ruolo%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_ruolo_ok.
       DESCRIZIONE: Si controlla se il ruolo è già stato inserito per il
                    profilo nel periodo indicato
       PARAMETRI:   p_id_profilo
                    p_new_dal
                    p_new_al
                    p_new_ruolo
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number := afc_error.ok;
      d_select_result number;

   begin
      begin
         select count(*)
           into d_select_result
           from ruoli_profilo
          where id_ruolo_profilo != p_id_ruolo_profilo
            and ruolo_profilo = p_ruolo_profilo
            and ruolo = p_new_ruolo
            and dal <= nvl(al, to_date(3333333, 'j'))
            and p_new_dal <= nvl(al, to_date('3333333', 'j'))
            and nvl(p_new_al, to_date('3333333', 'j')) >= p_new_dal;
      exception
         when others then
            d_select_result := 1;
      end;

      if d_select_result > 0 then
         d_result := s_ruolo_presente_num;
      else
         d_result := afc_error.ok;
      end if;

      return d_result;

   end; -- ruolo_profilo.is_ruolo_ok

   --------------------------------------------------------------------------------
   function is_relazione_ok
   (
      p_dal in ruoli_profilo.dal%type
     ,p_al  in ruoli_profilo.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_relazione_ok.
       DESCRIZIONE: verifica la presenza di relazioni circolari nella gerarchia ruoli/profili
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number := afc_error.ok;
      d_select_result number;

   begin
      begin
         select count(*)
           into d_select_result
           from ruoli_profilo r
          where dal <= nvl(p_al, to_date(3333333, 'j'))
            and nvl(al, to_date(3333333, 'j')) >= p_dal
         connect by prior ruolo = ruolo_profilo;
      exception
         when others then
            d_result := s_loop_relazioni_num;
      end;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function is_ruolo_assegnato
   (
      p_ruolo_profilo in ruoli_profilo.ruolo_profilo%type
     ,p_ruolo         in ruoli_profilo.ruolo%type
   ) return boolean is
      /* Verifica se il ruolo previsto nel profilo e' gia' stato assegnato ad almeno un componente
      */
      d_result        boolean := false;
      d_select_result number;
   begin
      begin
         select count(*)
           into d_select_result
           from ruoli_componente r
          where ruolo = p_ruolo_profilo
            and exists
          (select id_ruolo_componente
                   from ruoli_componente r1
                  where id_componente = r.id_componente
                    and ruolo = p_ruolo
                    and exists
                  (select 'x'
                           from ruoli_derivati
                          where id_profilo = r.id_ruolo_componente
                            and id_ruolo_componente = r1.id_ruolo_componente));
      exception
         when others then
            d_select_result := 1;
      end;

      if d_select_result > 0 then
         d_result := true;
      end if;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function is_profilo
   (
      p_ruolo in ruoli_componente.ruolo%type
     ,p_data  in ruoli_componente.dal%type
   ) return number is
      /******************************************************************************
       NOME:        is_profilo
       DESCRIZIONE: Controllo is_profilo
       PARAMETRI:   p_ruolo
                    p_data
       NOTE:        Verifica se un RUOLO e' anche profilo alla data indicata
      ******************************************************************************/
      d_result    number(1) := 0;
      d_contatore number(10) := 0;
   begin
      if p_ruolo is not null then
         select count(*)
           into d_contatore
           from ruoli_profilo p
          where p.ruolo_profilo = p_ruolo
            and nvl(ruolo, 'def') <> 'def'
            and (p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j')) or p_data is null);

         if d_contatore > 0 then
            d_result := 1;
         end if;
      end if;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   procedure set_fi
   (
      p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type
     ,p_old_dal              in ruoli_profilo.dal%type
     ,p_new_dal              in ruoli_profilo.dal%type
     ,p_old_al               in ruoli_profilo.al%type
     ,p_new_al               in ruoli_profilo.al%type
     ,p_ruolo                in ruoli_profilo.ruolo%type
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   ) is
      /******************************************************************************
       NOME:        set_fi.

       NOTE:        creata per #430
      ******************************************************************************/
      d_id_ruco                ruoli_componente.id_ruolo_componente%type;
      d_descr_profilo          ad4_ruoli.descrizione%type;
      d_data                   date := nvl(p_new_dal, trunc(sysdate));
      d_count                  number := 0;
      d_segnalazione           varchar2(2000);
      d_segnalazione_bloccante varchar2(2);
   begin
      -------------------------------------------------------------------------------------------
      d_segnalazione_bloccante := 'N';
      select ad4_ruoli_tpk.get_descrizione(nvl(p_ruolo_profilo, 'def'))
        into d_descr_profilo
        from dual;
      --gestione dei ruoli_componente a seguito delle modifiche al profilo
      if p_inserting = 1 then
         if p_ruolo is null then
            --creazione di un nuovo profilo
            --verifichiamo se il ruolo da aggiungere e' gia' usato come profilo
            select count(*)
              into d_count
              from ruoli_profilo
             where ruolo_profilo = p_ruolo_profilo
               and nvl(al, to_date(3333333, 'j')) >= d_data
               and id_ruolo_profilo <> p_id_ruolo_profilo;

            if d_count >= 1 then
               d_segnalazione           := 'Il Ruolo selezionato è gia'' utilizzato come Profilo.';
               d_segnalazione_bloccante := 'Y';
            end if;
         elsif p_ruolo_profilo = p_ruolo then
            d_segnalazione_bloccante := 'Y';
            d_segnalazione           := 'Ruolo e Profilo non possono essere uguali.';
         else
            --verifichiamo se il ruolo da aggiungere e' gia' usato come profilo
            select count(*)
              into d_count
              from ruoli_profilo
             where ruolo_profilo = p_ruolo_profilo
               and ruolo = p_ruolo
               and nvl(al, to_date(3333333, 'j')) >= d_data
               and id_ruolo_profilo <> p_id_ruolo_profilo;

            if d_count >= 1 then
               d_segnalazione           := 'Ruolo ' ||
                                           ad4_ruoli_tpk.get_descrizione(p_ruolo) ||
                                           ' gia'' previsto nel profilo ' ||
                                           d_descr_profilo;
               d_segnalazione_bloccante := 'Y';
            end if;
         end if;
         --eliminazione dell'eventuale primo record con ruolo predefinito
         if nvl(p_ruolo, 'def') <> 'def' then
            delete from ruoli_profilo r
             where ruolo_profilo = p_ruolo_profilo
               and nvl(ruolo, 'def') = 'def'
               and exists (select 'x'
                      from ruoli_profilo
                     where ruolo_profilo = p_ruolo_profilo
                       and nvl(ruolo, 'def') <> 'def');
         end if;
         --creazione di un nuovo record per il profilo; aggiungiamo il ruolo su ruoli_componente
         for ruco in (select r.*
                            ,decode(least(nvl(r.al, to_date(3333333, 'j'))
                                         ,nvl(p_new_al, to_date(3333333, 'j')))
                                   ,s_nulld
                                   ,to_date(null)
                                   ,least(nvl(r.al, to_date(3333333, 'j'))
                                         ,nvl(p_new_al, to_date(3333333, 'j')))) w_al
                        from ruoli_componente r
                       where ruolo = p_ruolo_profilo
                         and dal <= nvl(p_new_al, to_date(3333333, 'j'))
                         and nvl(al, to_date(3333333, 'j')) >= p_new_dal
                         and dal <= nvl(al, to_date(3333333, 'j')))
         loop
            ruolo_componente.s_gestione_profili := 1;
            --#38152
            d_count                             := 0;
            --controlla se il ruolo è gia' stato assegnato al componente
            select nvl(min(id_ruolo_componente), 0) --#36282
              into d_count
              from ruoli_componente r
             where id_componente = ruco.id_componente
               and dal <= nvl(al, to_date(3333333, 'j'))
               and dal <= nvl(ruco.w_al, to_date(3333333, 'j'))
               and nvl(al, to_date(3333333, 'j')) >= greatest(ruco.dal, p_new_dal)
               and ruolo = p_ruolo;

            if d_count = 0 then --#38152
               select ruoli_componente_sq.nextval into d_id_ruco from dual;

               ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                   ,p_id_componente        => ruco.id_componente
                                   ,p_ruolo                => p_ruolo
                                   ,p_dal                  => greatest(ruco.dal
                                                                      ,p_new_dal)
                                   ,p_al                   => ruco.w_al
                                   ,p_dal_pubb             => greatest(ruco.dal
                                                                      ,p_new_dal
                                                                      ,trunc(sysdate))
                                   ,p_al_pubb              => ruco.w_al
                                   ,p_utente_aggiornamento => p_utente_aggiornamento
                                   ,p_data_aggiornamento   => p_data_aggiornamento);
            end if;

            ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                  ,p_id_ruolo_componente => nvl(d_id_ruco, d_count)
                                  ,p_id_profilo          => ruco.id_ruolo_componente);
            ruolo_componente.s_gestione_profili := 0;
         end loop;
      elsif p_updating = 1 then
         -- modifiche ad un ruolo associato al profilo possono variare le date; la modifica del ruolo viene controllata da trigger
         ruolo_componente.s_gestione_profili    := 1;
         ruolo_componente.s_eliminazione_logica := 1;
         for ruco in (select rupr.id_ruolo_componente id_profilo
                            ,rupr.dal                 dal_profilo
                            ,rupr.al                  al_profilo
                            ,ruco.id_ruolo_componente id_ruolo
                            ,ruco.dal                 dal_ruolo
                            ,ruco.al                  al_ruolo
                        from ruoli_componente rupr
                            ,ruoli_derivati   rude
                            ,ruoli_componente ruco
                       where rupr.ruolo = p_ruolo_profilo
                         and rude.id_profilo = rupr.id_ruolo_componente
                         and rude.id_ruolo_componente = ruco.id_ruolo_componente
                         and ruco.ruolo = p_ruolo)
         loop
            begin
               -- modifica data dal
               if p_new_dal <> p_old_dal then
                  update ruoli_componente
                     set dal = p_new_dal
                   where id_ruolo_componente = ruco.id_ruolo;
               end if;
               -- modifica data al
               if nvl(p_new_al, to_date(3333333, 'j')) <>
                  nvl(p_old_al, to_date(3333333, 'j')) then
                  update ruoli_componente
                     set al = p_new_al
                   where id_ruolo_componente = ruco.id_ruolo;
               end if;
            exception
               when others then
                  null;
            end;
         end loop;
         if componente.s_modifica_componente = 0 then
            ruolo_componente.s_gestione_profili    := 0;
            ruolo_componente.s_eliminazione_logica := 0;
         end if;
      else
         --eliminazione di un ruolo dal profilo; eliminazione logica dei RUCO relativi
         ruolo_componente.s_gestione_profili := 1;
         for ruco in (select r.*
                            ,(select id_ruolo_componente
                                from ruoli_componente r1
                               where id_componente = r.id_componente
                                 and ruolo = p_ruolo
                                 and exists
                               (select 'x'
                                        from ruoli_derivati
                                       where id_profilo = r.id_ruolo_componente
                                         and id_ruolo_componente = r1.id_ruolo_componente)) id_ruco_wrk
                        from ruoli_componente r
                       where ruolo = p_ruolo_profilo
                         and dal <= nvl(p_old_al, to_date(3333333, 'j'))
                         and nvl(al, to_date(3333333, 'j')) >= p_old_dal
                         and dal <= nvl(al, to_date(3333333, 'j')))
         loop
            begin
               if ruco.id_ruco_wrk is not null then
                  --#762
                  ruolo_componente.eliminazione_logica_ruolo(p_id_ruolo_componente    => ruco.id_ruco_wrk
                                                            ,p_segnalazione_bloccante => d_segnalazione_bloccante
                                                            ,p_segnalazione           => d_segnalazione);
               end if;
            exception
               when others then
                  null;
            end;
         end loop;
         ruolo_componente.s_gestione_profili := 0;
      end if;

      if d_segnalazione_bloccante = 'Y' then
         raise_application_error(-20999, d_segnalazione);
      end if;

   end;

   -----------------------------------------------------------------------------------------------------------------

   procedure inserisci_ruolo
   (
      p_ruolo_profilo          in ruoli_profilo.ruolo_profilo%type
     ,p_ruolo                  in ruoli_profilo.ruolo%type
     ,p_dal                    in ruoli_profilo.dal%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        inserisci_ruolo.
       DESCRIZIONE: aggiunge un ruolo a un profilo o crea un nuovo profilo

       NOTE:        --
      ******************************************************************************/
      d_descr_profilo ad4_ruoli.descrizione%type;
      d_count         number := 0;
      d_data          date := nvl(p_dal, trunc(sysdate));
      d_errore                  exception;
      d_errore_profilo_presente exception;
      d_errore_non_bloccante    exception;
   begin
      p_segnalazione_bloccante := 'N';
      select ad4_ruoli_tpk.get_descrizione(nvl(p_ruolo_profilo, 'def'))
        into d_descr_profilo
        from dual;
      if p_ruolo is null then
         --creazione di un nuovo profilo
         --verifichiamo se il ruolo da aggiungere e' gia' usato come profilo
         select count(*)
           into d_count
           from ruoli_profilo
          where ruolo_profilo = p_ruolo_profilo
            and nvl(al, to_date(3333333, 'j')) >= d_data;

         if d_count >= 1 then
            p_segnalazione           := 'Il Ruolo selezionato è gia'' utilizzato come Profilo.';
            p_segnalazione_bloccante := 'Y';
         else
            --inserimento del ruolo nei profili con "def" come ruolo associato provvisorio.
            --la query dell'albero dell'interfaccia non deve evidenziare le foglie "def"
            begin
               ruoli_profilo_tpk.ins(p_id_ruolo_profilo     => ''
                                    ,p_ruolo_profilo        => p_ruolo_profilo
                                    ,p_ruolo                => 'def' --ruolo predefinito di AD4
                                    ,p_dal                  => d_data
                                    ,p_al                   => to_date(null)
                                    ,p_utente_aggiornamento => p_utente_aggiornamento
                                    ,p_data_aggiornamento   => d_data);
               p_segnalazione := 'Create nuovo profilo';
            exception
               when others then
                  p_segnalazione_bloccante := 'Y';
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := error_message(sqlcode);
                  else
                     p_segnalazione := 'Errore in inserimento su RUOLI_PROFILO : ' ||
                                       sqlerrm;
                  end if;
            end;
         end if;
      elsif p_ruolo_profilo = p_ruolo then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Ruolo e Profilo non possono essere uguali.';
      else
         --inserimento del ruolo nel profilo
         --verifichiamo se il ruolo da aggiungere e' gia' usato come profilo
         select count(*)
           into d_count
           from ruoli_profilo
          where ruolo_profilo = p_ruolo_profilo
            and ruolo = p_ruolo
            and nvl(al, to_date(3333333, 'j')) >= d_data;

         if d_count >= 1 then
            p_segnalazione           := 'Ruolo ' ||
                                        ad4_ruoli_tpk.get_descrizione(p_ruolo) ||
                                        ' gia'' previsto nel profilo ' || d_descr_profilo;
            p_segnalazione_bloccante := 'Y';
         else
            --inserimento del ruolo nei profili con "def" come ruolo associato provvisorio.
            --la query dell'albero dell'interfaccia non deve evidenziare le foglie "def"
            begin
               ruoli_profilo_tpk.ins(p_id_ruolo_profilo     => ''
                                    ,p_ruolo_profilo        => p_ruolo_profilo
                                    ,p_ruolo                => p_ruolo
                                    ,p_dal                  => d_data
                                    ,p_al                   => to_date(null)
                                    ,p_utente_aggiornamento => p_utente_aggiornamento
                                    ,p_data_aggiornamento   => d_data);
               p_segnalazione := 'Ruolo ' || ad4_ruoli_tpk.get_descrizione(p_ruolo) ||
                                 ' aggiunto al profilo ' || d_descr_profilo;
               --eliminazione eventuale del ruolo di default
               select count(*)
                 into d_count
                 from ruoli_profilo
                where ruolo_profilo = p_ruolo_profilo
                  and ruolo = 'def'
                  and nvl(al, to_date(3333333, 'j')) >= d_data;

               if d_count >= 1 then
                  delete from ruoli_profilo
                   where ruolo_profilo = p_ruolo_profilo
                     and ruolo = 'def';
               end if;

            exception
               when others then
                  p_segnalazione_bloccante := 'Y';
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := error_message(sqlcode);
                  else
                     p_segnalazione := 'Errore in inserimento su RUOLI_PROFILO : ' ||
                                       sqlerrm;
                  end if;
            end;
         end if;
      end if;
      --commit;
   end;

   -----------------------------------------------------------------------------------------------------------------

   procedure elimina_ruolo
   (
      p_ruolo_profilo          in ruoli_profilo.ruolo_profilo%type
     ,p_ruolo                  in ruoli_profilo.ruolo%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        inserisci_ruolo.
       DESCRIZIONE: elimina un ruolo da un profilo chiudendo la validita' alla sysdate

       NOTE:        --
      ******************************************************************************/
      d_descr_profilo ad4_ruoli.descrizione%type := ad4_ruoli_tpk.get_descrizione(nvl(p_ruolo_profilo
                                                                                     ,'def'));
      d_descr_ruolo   ad4_ruoli.descrizione%type := ad4_ruoli_tpk.get_descrizione(nvl(p_ruolo
                                                                                     ,'def'));
      d_data          date := trunc(sysdate);
      d_errore                  exception;
      d_errore_profilo_presente exception;
      d_errore_non_bloccante    exception;
   begin
      p_segnalazione_bloccante := 'N';
      if p_ruolo_profilo is not null and p_ruolo is not null then
         begin
            if is_profilo_in_uso(p_ruolo_profilo) then
               update ruoli_profilo
                  set al = d_data
                where ruolo_profilo = p_ruolo_profilo
                  and ruolo = p_ruolo
                  and nvl(al, to_date(3333333, 'j')) >= d_data;

               delete from ruoli_profilo
                where ruolo_profilo = p_ruolo_profilo
                  and ruolo = p_ruolo
                  and dal > d_data;

               p_segnalazione := 'Ruolo ' || d_descr_ruolo || ' eliminato dal profilo ' ||
                                 d_descr_profilo;
            else
               delete from ruoli_profilo
                where ruolo_profilo = p_ruolo_profilo
                  and ruolo = p_ruolo;
            end if;
         exception
            when others then
               p_segnalazione_bloccante := 'Y';
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := 'Errore in eliminazione da RUOLI_PROFILO : ' ||
                                    sqlerrm;
               end if;
         end;
      elsif p_ruolo_profilo is not null and p_ruolo is null then
         begin
            if is_profilo(p_ruolo_profilo, '') = 0 then
               delete from ruoli_profilo
                where ruolo_profilo = p_ruolo_profilo
                  and (ruolo is null or ruolo = 'def');
               p_segnalazione := 'Profilo ' || d_descr_profilo || ' eliminato';
            else
               p_segnalazione_bloccante := 'Y';
               p_segnalazione           := 'Profilo ' || d_descr_profilo ||
                                           ' non eliminabile, esistono ruoli associati';
            end if;
         exception
            when others then
               p_segnalazione_bloccante := 'Y';
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := 'Errore in eliminazione da RUOLI_PROFILO : ' ||
                                    sqlerrm;
               end if;
         end;
      else
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Parametri errati';
      end if;
      --commit;
   end;
   -------------------------------------------------------------------------------------------------------
   function get_icona_ruolo(p_ruolo in ruoli_profilo.ruolo_profilo%type) return varchar2 is
   begin
      return null;
   end;
   --------------------------------------------------------------------------------
   function get_numero_utenti
   (
      p_ruolo_profilo in ruoli_profilo.ruolo_profilo%type
     ,p_data          in date default to_date(null)
   ) return number is
      d_utenti number := 0;
   begin
      begin
         select count(distinct ni)
           into d_utenti
           from vista_ruoli_profili
          where profilo = p_ruolo_profilo
            and (p_data between dal_ruolo and nvl(al_ruolo, to_date(3333333, 'j')) or
                p_data is null);
      end;
      return d_utenti;
   end;
   --------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_number) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_number) := s_dal_errato_ins_msg;
   s_error_table(s_al_errato_number) := s_al_errato_msg;
   s_error_table(s_dal_minore_num) := s_dal_minore_msg;
   s_error_table(s_al_maggiore_num) := s_al_maggiore_msg;
   s_error_table(s_ruolo_presente_num) := s_ruolo_presente_msg;
   s_error_table(s_loop_relazioni_num) := s_loop_relazioni_msg;

end ruoli_profilo_pkg;
/


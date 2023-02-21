CREATE OR REPLACE procedure copia_operatore
(
   p_cognome                in anagrafe_soggetti.cognome%type
  ,p_nome                   in anagrafe_soggetti.nome%type
  ,p_codice_fiscale         in anagrafe_soggetti.codice_fiscale%type
  ,p_data_nascita           in anagrafe_soggetti.data_nas%type
  ,p_nominativo             in ad4_utenti.nominativo%type default null
  ,p_ni_modello             in componenti.ni%type default null
  ,p_nominativo_modello     in ad4_utenti.nominativo%type default null
  ,p_ottica                 in componenti.ottica%type default null
  ,p_data_assegnazione      in componenti.dal%type default null
  ,p_copia_assegnazioni     in varchar2 default 'SI'
  ,p_copia_ruoli            in varchar2 default 'SI'
  ,p_segnalazione_bloccante in out varchar2
  ,p_segnalazione           in out varchar2
  ,p_sessione               in out number
) is
   d_error_session  key_error_log.error_session%type;
   d_error_date     key_error_log.error_date%type := sysdate;
   d_error_user     key_error_log.error_user%type := 'SO4_CO';
   d_data_nascita   date := p_data_nascita;
   d_utente         ad4_utenti.utente%type;
   d_codice_fiscale anagrafe_soggetti.codice_fiscale%type;
   d_ni             anagrafe_soggetti.ni%type;
   d_ni_modello     anagrafe_soggetti.ni%type := p_ni_modello;
   d_sesso          anagrafe_soggetti.sesso%type;
   d_data_nas       varchar2(10);
   d_provincia_nas  anagrafe_soggetti.provincia_nas%type;
   d_comune_nas     anagrafe_soggetti.comune_nas%type;
   d_id_componente  componenti.id_componente%type;
   d_id_utente      ad4_utenti.id_utente%type;
   d_usertext       key_error_log.error_usertext%type := 'CREAZIONE NUOVO OPERATORE SERT: ' ||
                                                         p_cognome || ' ' || p_nome;
   d_errore         number(1);
   d_contatore      number(6) := 0;
   --
   errore_in_elaborazione exception;
begin
   --
   -- Verifica dei parametri
   --
   begin
      --
      -- determinazione del numero di sessione
      --
      select nvl(max(error_session), 0) + 1
        into d_error_session
        from key_error_log
       where error_user = d_error_user;
      p_sessione := d_error_session;
      --
      -- Eliminazione messaggi elaborazione precedente
      --
      begin
         delete from key_error_log
          where error_user = d_error_user
            and error_session = d_error_session;
      exception
         when others then
            raise_application_error(-20999
                                   ,'Errore in eliminazione messaggi: ' || sqlerrm);
      end;
      begin
         select 0
           into d_errore
           from dual
          where (p_ni_modello is null and p_nominativo_modello is null)
             or (p_copia_assegnazioni <> 'SI' and p_copia_ruoli <> 'SI');
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            raise errore_in_elaborazione;
      end;
      -- inizio elaborazione
      key_error_log_tpk.ins(p_error_session  => d_error_session
                           ,p_error_user     => d_error_user
                           ,p_error_date     => d_error_date
                           ,p_error_text     => 'Creazione nuovo operatore ' || p_cognome || ' ' ||
                                                p_nome
                           ,p_error_type     => 'I'
                           ,p_error_usertext => d_usertext);
      --
      -- esecuzione dei controlli preliminari
      --
      -- valori obbligatori nulli
      if p_codice_fiscale is null then
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Codice Fiscale non indicato'
                              ,p_error_type     => 'E'
                              ,p_error_usertext => d_usertext);
      end if;
      if p_cognome is null then
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Cognome non indicato'
                              ,p_error_type     => 'E'
                              ,p_error_usertext => d_usertext);
      end if;
      if p_nome is null then
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Nome non indicato'
                              ,p_error_type     => 'E'
                              ,p_error_usertext => d_usertext);
      end if;
      if d_data_nascita is null then
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Data di nascita non indicata'
                              ,p_error_type     => 'I'
                              ,p_error_usertext => d_usertext);
      end if;
      -- univocita' codice fiscale
      select count(distinct ni)
        into d_contatore
        from anagrafe_soggetti
       where codice_fiscale = p_codice_fiscale;
      if d_contatore > 1 then
         d_contatore := -1;
         raise errore_in_elaborazione;
      end if;
      --correttezza formale del codice fiscale
      if ad4_codice_fiscale.controllo(p_codice_fiscale) <> 0 then
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Codice fiscale mal formato'
                              ,p_error_type     => 'I'
                              ,p_error_usertext => d_usertext);
      end if;
      -- verifiche sul nominativo utente
      if p_nominativo is not null then
         begin
            select utente
              into d_utente
              from ad4_utenti u
             where u.nominativo = p_nominativo;
            begin
               select codice_fiscale
                 into d_codice_fiscale
                 from anagrafe_soggetti
                where ni = (select u.soggetto
                              from ad4_utenti_soggetti u
                             where u.utente = d_utente);
            exception
               when no_data_found then
                  null;
            end;
            if nvl(d_codice_fiscale, p_codice_fiscale) <> p_codice_fiscale then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'Nominativo utente gia'' associato ad un altro soggetto'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
            end if;
         exception
            when no_data_found then
               null;
         end;
      end if;
      -- verifica dell'ottica, se indicata
      if p_ottica is not null then
         begin
            select 1 into d_contatore from ottiche where ottica = p_ottica;
         exception
            when no_data_found then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'Ottica inesistente'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
         end;
      end if;
      -- verifiche sul componente modello
      if p_ni_modello is not null and p_nominativo_modello is not null then
         begin
            select utente
              into d_utente
              from ad4_utenti u
             where u.nominativo = p_nominativo_modello;
            begin
               select soggetto
                 into d_ni_modello
                 from ad4_utenti_soggetti u
                where u.utente = d_utente;
            exception
               when no_data_found then
                  null;
            end;
            if nvl(d_ni_modello, p_ni_modello) <> p_ni_modello then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'Nominativo utente modello ed NI modello incompatibili'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
            end if;
         exception
            when no_data_found then
               null;
         end;
         d_ni_modello := p_ni_modello;
         begin
            select 1 into d_contatore from anagrafe_soggetti where ni = d_ni_modello;
         exception
            when no_data_found then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'NI modello inesistente'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
         end;
         select count(*)
           into d_contatore
           from componenti
          where ni = d_ni_modello
            and (p_ottica is null or ottica = p_ottica);
         if d_contatore = 0 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Non esistono assegnazioni per il modello indicato'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => d_usertext);
         end if;
      elsif p_ni_modello is not null then
         d_ni_modello := p_ni_modello;
         begin
            select 1 into d_contatore from anagrafe_soggetti where ni = d_ni_modello;
         exception
            when no_data_found then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'NI modello inesistente'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
         end;
         select count(*)
           into d_contatore
           from componenti
          where ni = d_ni_modello
            and (p_ottica is null or ottica = p_ottica)
            and nvl(al, to_date(3333333, 'j')) >=
                nvl(p_data_assegnazione, trunc(sysdate));
         if d_contatore = 0 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Non esistono assegnazioni valide per il modello indicato'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => d_usertext);
         end if;
      elsif p_nominativo_modello is not null then
         begin
            select soggetto
              into d_ni_modello
              from ad4_utenti_soggetti
             where utente =
                   (select utente from ad4_utenti where nominativo = p_nominativo_modello);
            select count(*)
              into d_contatore
              from componenti
             where ni = d_ni_modello
               and (p_ottica is null or ottica = p_ottica)
               and nvl(al, to_date(3333333, 'j')) >=
                   nvl(p_data_assegnazione, trunc(sysdate));
            if d_contatore = 0 then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'Non esistono assegnazioni valide per il modello indicato'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
            end if;
         exception
            when no_data_found then
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'Utente modello non associato ad alcun soggetto'
                                    ,p_error_type     => 'E'
                                    ,p_error_usertext => d_usertext);
         end;
      end if;
      commit;
      --
      --Processo di inserimento
      --
      -- verifica la presenza di errori bloccanti generati dal processo di verifica
      select count(*)
        into d_contatore
        from key_error_log
       where error_session = d_error_session
         and error_user = d_error_user
         and error_type = 'E';
      if d_contatore = 0 then
         -- crea il nuovo soggetto
         begin
            if ad4_codice_fiscale.controllo(p_codice_fiscale) = 0 then
               ad4_codice_fiscale.get_dati(p_codice_fiscale
                                          ,d_sesso
                                          ,d_data_nas
                                          ,d_provincia_nas
                                          ,d_comune_nas);
            else
               d_sesso         := null;
               d_data_nas      := to_char(null);
               d_provincia_nas := to_number(null);
               d_comune_nas    := to_number(null);
            end if;
            --verifica dell'esistenza del soggetto
            begin
               select ni
                 into d_ni
                 from anagrafe_soggetti
                where codice_fiscale = p_codice_fiscale;
            exception
               when no_data_found then
                  null;
            end;
            --verifichiamo se il soggetto esiste gia' per nominativo di utente
            if d_ni is null then
               begin
                  select soggetto
                    into d_ni
                    from ad4_utenti_soggetti
                   where utente =
                         (select utente from ad4_utenti where nominativo = p_nominativo);
                  update as4_anagrafe_soggetti
                     set codice_fiscale = p_codice_fiscale
                   where ni = d_ni
                     and codice_fiscale is null;
               exception
                  when no_data_found then
                     null;
               end;
            end if;
         exception
            when others then
               d_sesso         := null;
               d_data_nas      := to_date(null);
               d_provincia_nas := to_number(null);
               d_comune_nas    := to_number(null);
         end;
         --Se non gia' presente inserisce il nuovo NI
         if d_ni is null then
            d_ni := as4_anagrafe_soggetti_pkg.init_ni;
            begin
               if d_data_nascita is null and d_data_nas is not null then
                  d_data_nascita := d_data_nas;
               else
                  d_data_nascita := nvl(p_data_assegnazione, trunc(sysdate));
               end if;
               as4_anagrafe_soggetti_tpk.ins(p_ni             => d_ni
                                            ,p_dal            => d_data_nascita
                                            ,p_cognome        => p_cognome
                                            ,p_nome           => p_nome
                                            ,p_sesso          => d_sesso
                                            ,p_data_nas       => d_data_nascita
                                            ,p_provincia_nas  => d_provincia_nas
                                            ,p_comune_nas     => d_comune_nas
                                            ,p_codice_fiscale => p_codice_fiscale
                                            ,p_competenza     => 'SI4SO'
                                            ,p_utente         => 'SO4'
                                            ,p_data_agg       => trunc(sysdate)
                                            ,p_tipo_soggetto  => 'I');
            exception
               when others then
                  d_contatore := -2;
                  raise errore_in_elaborazione;
            end;
         end if;
         --crea i periodi di assegnazione replicandoli in tutto e per tutto dal modello indicato
         for comp in (select (select codice_uo || ' : ' || descrizione || ' (ottica : ' ||
                                     c.ottica || ')'
                                from anagrafe_unita_organizzative
                               where progr_unita_organizzativa =
                                     c.progr_unita_organizzativa
                                 and nvl(c.al, to_date(3333333, 'j')) between dal and
                                     nvl(al, to_date(3333333, 'j'))) uo
                            ,c.*
                        from vista_componenti c
                       where ni = d_ni_modello
                         and nvl(al, to_date(3333333, 'j')) >=
                             nvl(p_data_assegnazione, trunc(sysdate))
                         and (p_ottica is null or c.ottica = p_ottica)
                         and exists
                       (select 'x'
                                from unita_organizzative
                               where progr_unita_organizzativa =
                                     c.progr_unita_organizzativa
                                 and ottica = c.ottica
                                 and c.dal between dal and nvl(al, to_date(3333333, 'j')))
                         and exists (select 'x'
                                from unita_organizzative
                               where progr_unita_organizzativa =
                                     c.progr_unita_organizzativa
                                 and ottica = c.ottica
                                 and nvl(c.al, to_date(3333333, 'j')) between dal and
                                     nvl(al, to_date(3333333, 'j')))
                       order by id_componente)
         loop
            select count(*)
              into d_contatore
              from componenti
             where ottica = comp.ottica
               and progr_unita_organizzativa = comp.progr_unita_organizzativa
               and dal <= to_date(3333333, 'j')
               and nvl(al, to_date(3333333, 'j')) >=
                   nvl(p_data_assegnazione, trunc(sysdate))
               and dal <= nvl(al, to_date(3333333, 'j'))
               and ni = d_ni;
            if d_contatore = 0 then
               begin
                  if p_copia_assegnazioni = 'SI' then
                     select componenti_sq.nextval into d_id_componente from dual;
                     componente.ins(p_id_componente             => d_id_componente
                                   ,p_progr_unita_organizzativa => comp.progr_unita_organizzativa
                                   ,p_dal                       => nvl(p_data_assegnazione
                                                                      ,trunc(sysdate))
                                   ,p_ni                        => d_ni
                                   ,p_stato                     => 'P'
                                   ,p_ottica                    => comp.ottica
                                   ,p_dal_pubb                  => nvl(p_data_assegnazione
                                                                      ,trunc(sysdate))
                                   ,p_revisione_assegnazione    => ''
                                   ,p_utente_aggiornamento      => 'SO4.co'
                                   ,p_data_aggiornamento        => trunc(sysdate));
                     update attributi_componente
                        set incarico                = comp.incarico
                           ,tipo_assegnazione       = 'F'
                           ,assegnazione_prevalente = 88/*decode(comp.tipo_assegnazione
                                                            ,'I'
                                                            ,1
                                                            ,88)*/
                      where id_componente = d_id_componente;
                     --aggiornamento dell'utente
                     if p_nominativo is not null then
                        begin
                           d_utente    := null;
                           d_id_utente := to_number(null);
                           begin
                              select utente
                                into d_utente
                                from ad4_utenti
                               where nominativo = p_nominativo;
                           exception
                              when no_data_found then
                                 d_utente := null;
                           end;
                           if d_utente is not null then
                              insert into ad4_utenti_soggetti
                                 (utente
                                 ,soggetto)
                                 select d_utente
                                       ,d_ni
                                   from dual
                                  where not exists (select 'x'
                                           from ad4_utenti_soggetti
                                          where utente = d_utente
                                            and soggetto = d_ni);
                           else
                              update ad4_utenti
                                 set nominativo = p_nominativo
                               where utente = (select utente
                                                 from ad4_utenti_soggetti
                                                where soggetto = d_ni);
                           end if;
                        exception
                           when others then
                              d_contatore := -3;
                              raise errore_in_elaborazione;
                        end;
                     end if;
                     key_error_log_tpk.ins(p_error_session  => d_error_session
                                          ,p_error_user     => d_error_user
                                          ,p_error_date     => d_error_date
                                          ,p_error_text     => 'Assegnato alla UO ' ||
                                                               comp.uo
                                          ,p_error_type     => 'I'
                                          ,p_error_usertext => d_usertext);
                  end if;
               exception
                  when others then
                     d_contatore := -5;
                     raise errore_in_elaborazione;
               end;
            else
               key_error_log_tpk.ins(p_error_session  => d_error_session
                                    ,p_error_user     => d_error_user
                                    ,p_error_date     => d_error_date
                                    ,p_error_text     => 'Soggetto gia'' assegnato alla UO ' ||
                                                         comp.uo
                                    ,p_error_type     => 'I'
                                    ,p_error_usertext => d_usertext);
            end if;
            if p_copia_ruoli = 'SI' then
               -- creazione dei ruoli applicativi
               if d_id_componente is null then
                  --determinazione dell'id_componente nel caso di copia dei soli ruoli applicativi
                  begin
                     select id_componente
                       into d_id_componente
                       from componenti c
                      where ni = d_ni
                        and ottica = comp.ottica
                        and progr_unita_organizzativa = comp.progr_unita_organizzativa
                        and nvl(al, to_date(3333333, 'j')) >=
                            nvl(p_data_assegnazione, trunc(sysdate));
                  exception
                     when others then
                        d_contatore := -6;
                        raise errore_in_elaborazione;
                  end;
               end if;
               for ruco in (select *
                              from ruoli_componente r
                             where id_componente = comp.id_componente
                               and dal <= nvl(al, to_date(3333333, 'j'))
                               and nvl(al, to_date(3333333, 'j')) >=
                                   nvl(p_data_assegnazione, trunc(sysdate))
                               and exists
                             (select 'x'
                                      from componenti
                                     where ottica = comp.ottica
                                       and ni = d_ni
                                       and progr_unita_organizzativa =
                                           comp.progr_unita_organizzativa
                                       and dal <= nvl(r.al, to_date(3333333, 'j'))
                                       and nvl(al, to_date(3333333, 'j')) >= r.dal)
                             order by id_ruolo_componente)
               loop
                  select count(*)
                    into d_contatore
                    from ruoli_componente
                   where id_componente = d_id_componente
                     and ruolo = ruco.ruolo
                     and dal <= to_date(3333333, 'j')
                     and nvl(al, to_date(3333333, 'j')) >=
                         nvl(p_data_assegnazione, trunc(sysdate))
                     and dal <= nvl(al, to_date(3333333, 'j'));
                  if d_contatore = 0 then
                     begin
                        ruolo_componente.ins(p_id_ruolo_componente  => ''
                                            ,p_id_componente        => d_id_componente
                                            ,p_ruolo                => ruco.ruolo
                                            ,p_dal                  => nvl(p_data_assegnazione
                                                                          ,trunc(sysdate))
                                            ,p_al                   => ''
                                            ,p_utente_aggiornamento => 'SO4.co'
                                            ,p_data_aggiornamento   => '');
                        key_error_log_tpk.ins(p_error_session  => d_error_session
                                             ,p_error_user     => d_error_user
                                             ,p_error_date     => d_error_date
                                             ,p_error_text     => '    Attribuito ruolo ' ||
                                                                  ruco.ruolo
                                             ,p_error_type     => 'I'
                                             ,p_error_usertext => d_usertext);
                     exception
                        when others then
                           d_contatore := -4;
                           raise errore_in_elaborazione;
                     end;
                  end if;
               end loop;
            end if;
         end loop;
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Creato nuovo operatore ' || p_cognome || ' ' ||
                                                   p_nome || ' - NI: ' || d_ni
                              ,p_error_type     => 'I'
                              ,p_error_usertext => d_usertext);
      else
         key_error_log_tpk.ins(p_error_session  => d_error_session
                              ,p_error_user     => d_error_user
                              ,p_error_date     => d_error_date
                              ,p_error_text     => 'Rilevati errori bloccanti nella fase di controllo dei dati di input. Operazione non eseguita'
                              ,p_error_type     => 'E'
                              ,p_error_usertext => d_usertext);
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Rilevati errori bloccanti nella fase di controllo dei dati di input. Operazione non eseguita';
      end if;
      commit;
   exception
      when errore_in_elaborazione then
         rollback;
         if d_contatore = 0 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Parametri errati: Operatore modello non indicato o richieste di copia non attivate'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => d_usertext);
         elsif d_contatore = -1 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Parametri errati: Codice Fiscale soggetto non univoco'
                                 ,p_error_usertext => d_usertext);
         elsif d_contatore = -2 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore nella la creazione del componente ' ||
                                                      p_cognome || ' ' || p_nome || ' (' ||
                                                      p_codice_fiscale ||
                                                      ') durante l''inserimento su ANAGRAFE_SOGGETTI'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => d_usertext);
         elsif d_contatore = -3 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore nella la creazione del componente ' ||
                                                      p_cognome || ' ' || p_nome || ' (' ||
                                                      p_codice_fiscale ||
                                                      ') durante l''inserimento su AD4_UTENTI'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
         elsif d_contatore = -4 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore nella la creazione dei ruoli applicativi di ' ||
                                                      p_cognome || ' ' || p_nome || ' (' ||
                                                      p_codice_fiscale
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
         elsif d_contatore = -5 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore fatale e misterioso durante la creazione del componente ' ||
                                                      p_cognome || ' ' || p_nome || ' (' ||
                                                      p_codice_fiscale ||
                                                      ') durante l''inserimento su AD4_UTENTI'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
         elsif d_contatore = -6 then
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'UO di assegnazione non determinabile ' ||
                                                      p_cognome || ' ' || p_nome || ' (' ||
                                                      p_codice_fiscale ||
                                                      ') durante la copia dei SOLI ruoli applicativi'
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
         end if;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Rilevati errori bloccanti durante l''elaborazione. Operazione non eseguita';
         commit;
   end;
end;
/


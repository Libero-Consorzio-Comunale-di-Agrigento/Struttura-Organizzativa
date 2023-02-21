CREATE OR REPLACE procedure aggiorna_relazioni_struttura
(
   p_ottica                 in ottiche.ottica%type default null
  ,p_revisione              in revisioni_struttura.revisione%type default null
  ,p_revisione_modifica     in varchar2 default 'NO'
  ,p_aggiorna_dati          in varchar2 default 'NO'
  ,p_segnalazione_bloccante in out varchar2
  ,p_segnalazione           in out varchar2
) is
   d_id                          relazioni_unita_organizzative.id_relazioni_struttura%type;
   d_revisione_mod               revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(p_ottica);
   d_descrizione_amministrazione anagrafe_soggetti.denominazione%type;
   d_blocco                      varchar2(2) := 'NO';
   d_data_inizio                 date;
   d_data                        date;
   d_fine                        date;
   d_dal_anuo                    date;
   d_al_anuo                     date;
   d_dal_unor                    date;
   d_al_unor                     date;
   /*  Genera la relazioni_unita_organizzative, una revisione alla volta
       NOTA : il campo ordinamento NON viene gestito, in quanto non piu' utilizzato
              dai report. In caso di necessita' valorizzarlo con :
              so4_util.get_ordinamento_2(u.progr_unita_organizzativa,u.dal,u.ottica,1)
     REVISIONI:
       Rev.  Data        Autore      Descrizione.
       001   07/01/2015  MMONARI     Determinazione dei periodi da trattare #560
             07/01/2015  MMONARI     Determinazione delle informazioni del nodo figlio in revisione in modifica #557
             12/10/2015  MMONARI     Determinazione delle d_data_inizio #652
             16/12/2015  MMONARI     Determinazione del periodo di competenza della revisione in modifica #665
             16/12/2015  MMONARI     Dettaglio dei periodi storici delle UO ascendenti #667
             11/01/2016  MMONARI     #670
             17/02/2016  MMONARI     #684 sostituzione della relazioni_struttura con la relazioni_unita_organizzative
   */
begin
   begin
      --#652
      select nvl(min(dal), to_date(2222222, 'j'))
        into d_data_inizio
        from revisioni_struttura
       where stato = 'A'
         and ottica = p_ottica;
   
      if p_revisione_modifica = 'SI' and d_revisione_mod = -1 then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Non esiste una revisione in modifica per l''ottica indicata';
      elsif p_aggiorna_dati = 'SI' and p_ottica is null then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Ottica richiesta per refresh descrizioni';
      elsif p_revisione_modifica = 'SI' and p_ottica is null then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Ottica richiesta per report della revisione in modifica';
      elsif d_blocco = 'SI' then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Esistono revisioni retroattive successive a quella richiesta';
      else
         if p_aggiorna_dati = 'SI' then
            /* Forza l'aggiornamento dei campi che possono essere modificati al di fuori del contesto
               di una revisione in modifica
            */
            -- aggiornamento dati nodi figli
            for rest in (select progr_figlio
                               ,al_figlio
                               ,ottica
                               ,revisione
                               ,dal_figlio
                           from relazioni_unita_organizzative
                          where ottica = p_ottica
                            and revisione <> d_revisione_mod
                          order by progr_figlio
                                  ,revisione
                                  ,dal_figlio)
            loop
               begin
                  update relazioni_unita_organizzative r
                     set (sudd_figlio, sequenza_figlio, descr_figlio) =
                         (select suddivisione_struttura.get_suddivisione(a.id_suddivisione)
                                ,u.sequenza sequenza_figlio
                                ,a.descrizione
                            from anagrafe_unita_organizzative a
                                ,unita_organizzative          u
                           where a.progr_unita_organizzativa = r.progr_figlio
                             and a.revisione_istituzione <> d_revisione_mod
                             and r.al_figlio between a.dal and
                                 nvl(decode(a.revisione_cessazione
                                           ,d_revisione_mod
                                           ,to_date(null)
                                           ,a.al)
                                    ,to_date(3333333, 'j'))
                             and u.progr_unita_organizzativa = a.progr_unita_organizzativa
                             and u.ottica = p_ottica
                             and u.revisione <> d_revisione_mod
                             and r.al_figlio between u.dal and
                                 nvl(decode(u.revisione_cessazione
                                           ,d_revisione_mod
                                           ,to_date(null)
                                           ,u.al)
                                    ,to_date(3333333, 'j')))
                   where r.ottica = p_ottica
                     and r.revisione <> d_revisione_mod
                     and nvl(r.al_figlio, to_date(3333333, 'j')) >= d_data_inizio
                     and r.progr_figlio = rest.progr_figlio
                     and r.revisione = rest.revisione
                     and r.dal_figlio = rest.dal_figlio;
                  -- aggiornamento dati nodi padri
                  update relazioni_unita_organizzative r
                     set (sudd_padre, sequenza_padre, descr_padre) =
                         (select suddivisione_struttura.get_suddivisione(a.id_suddivisione)
                                ,u.sequenza sequenza_padre
                                ,a.descrizione
                            from anagrafe_unita_organizzative a
                                ,unita_organizzative          u
                           where a.progr_unita_organizzativa = r.progr_padre
                             and a.revisione_istituzione <> d_revisione_mod
                             and r.al_padre between a.dal and
                                 nvl(decode(a.revisione_cessazione
                                           ,d_revisione_mod
                                           ,to_date(null)
                                           ,a.al)
                                    ,to_date(3333333, 'j'))
                             and u.progr_unita_organizzativa = a.progr_unita_organizzativa
                             and u.ottica = p_ottica
                             and u.revisione <> d_revisione_mod
                             and r.al_figlio between u.dal and
                                 nvl(decode(u.revisione_cessazione
                                           ,d_revisione_mod
                                           ,to_date(null)
                                           ,u.al)
                                    ,to_date(3333333, 'j')))
                   where ottica = p_ottica
                     and revisione <> d_revisione_mod
                     and nvl(al_figlio, to_date(3333333, 'j')) >= d_data_inizio
                     and r.progr_figlio = rest.progr_figlio
                     and r.revisione = rest.revisione
                     and r.dal_figlio = rest.dal_figlio;
               exception
                  when others then
                     update relazioni_unita_organizzative r
                        set descr_figlio = substr('[Dati non aggiornati] ' ||
                                                  r.descr_figlio
                                                 ,1
                                                 ,240)
                           ,descr_padre  = substr('[Dati non aggiornati] ' ||
                                                  r.descr_padre
                                                 ,1
                                                 ,240)
                      where r.ottica = p_ottica
                        and r.revisione <> d_revisione_mod
                        and nvl(r.al_figlio, to_date(3333333, 'j')) >= d_data_inizio
                        and r.progr_figlio = rest.progr_figlio
                        and r.revisione = rest.revisione
                        and r.dal_figlio = rest.dal_figlio;
               end;
            end loop;
            /* esegue un refresh della descrizione dell'amministrazione (non si sa mai) */
            select substr(denominazione, 1, 240)
              into d_descrizione_amministrazione
              from anagrafe_soggetti
             where ni =
                   (select ni
                      from amministrazioni
                     where codice_amministrazione =
                           (select amministrazione from ottiche where ottica = p_ottica));
            update relazioni_unita_organizzative
               set descr_amministrazione = d_descrizione_amministrazione
             where ottica = p_ottica;
         end if;
         if p_revisione_modifica = 'SI' then
            begin
               for rest in (select r.revisione
                                  ,r.ottica
                                  ,o.descrizione descr_ottica
                                  ,a.codice_amministrazione amministrazione
                                  ,soggetti_get_descr(a.ni, sysdate, 'DESCRIZIONE') descr_amministrazione
                                  ,nvl(r.dal, trunc(sysdate)) dal --#665
                                  ,to_date(null) al
                              from revisioni_struttura r
                                  ,ottiche             o
                                  ,amministrazioni     a
                             where stato = 'M'
                               and r.ottica = o.ottica
                               and a.codice_amministrazione = o.amministrazione
                               and o.ottica = p_ottica
                               and r.revisione = d_revisione_mod
                             order by r.ottica
                                     ,r.dal)
               loop
                  -- pulizia preventiva dei dati preesistenti
                  delete from relazioni_unita_organizzative
                   where ottica = rest.ottica
                     and revisione = rest.revisione;
                  -- esegue per la revisione richieste
                  for anuo in (select a.progr_unita_organizzativa padre
                                     ,a.codice_uo codice_padre
                                     ,suddivisione_struttura.get_suddivisione(a.id_suddivisione) suddivisione_padre
                                     ,rest.amministrazione
                                     ,a.descrizione descrizione_padre
                                     ,greatest(rest.dal
                                              ,nvl(a.dal, to_date(2222222, 'j'))) dal_padre
                                     ,least(nvl(rest.al, to_date(3333333, 'j'))
                                           ,nvl(a.al, to_date(3333333, 'j'))) al_padre
                                     ,get_livello(a.id_suddivisione) livello_padre
                                     ,aoo_pkg.get_codice_aoo(a.progr_aoo, a.dal) cod_aoo
                                     ,aoo_pkg.get_descrizione(a.progr_aoo, a.dal) descr_aoo
                                 from anagrafe_struttura a --anagrafe_unita_organizzative a
                                where a.ottica = rest.ottica
                                  and a.amministrazione = rest.amministrazione
                                  and rest.dal <= nvl(a.al, to_date(3333333, 'j'))
                                  and nvl(rest.al, to_date(3333333, 'j')) >= a.dal
                                order by a.progr_unita_organizzativa
                                        ,a.dal)
                  loop
                     -- #557 le informazioni vengono determinate alla data della revisione (rest.dal)
                     for unor in (select u.progr_unita_organizzativa figlio
                                        ,anagrafe_unita_organizzativa.get_codice_uo_corrente(u.progr_unita_organizzativa
                                                                                            ,rest.dal) codice_figlio
                                        ,suddivisione_struttura.get_suddivisione(anagrafe_unita_organizzativa.get_id_suddivisione_corrente(u.progr_unita_organizzativa
                                                                                                                                          ,rest.dal)) suddivisione_figlio
                                        ,anagrafe_unita_organizzativa.get_descrizione_corrente(u.progr_unita_organizzativa
                                                                                              ,rest.dal) descrizione_figlio
                                        ,level livello_figlio
                                        ,greatest(anuo.dal_padre, nvl(u.dal, rest.dal)) dal_figlio
                                        ,least(nvl(anuo.al_padre, to_date(3333333, 'j'))
                                              ,nvl(u.al, to_date(3333333, 'j'))) al_figlio
                                        ,'' sequenza_padre
                                        ,u.sequenza sequenza_figlio
                                        ,so4_util.get_ordinamento_2(u.progr_unita_organizzativa
                                                                   ,rest.dal
                                                                   ,u.ottica
                                                                   ,'') ordinamento
                                        ,id_unita_padre
                                    from unita_organizzative u
                                   where u.ottica = rest.ottica
                                     and rest.dal <= nvl(u.al, to_date(3333333, 'j'))
                                     and nvl(rest.al, to_date(3333333, 'j')) >=
                                         nvl(u.dal, rest.dal)
                                     and nvl(u.revisione_cessazione, -1) <>
                                         d_revisione_mod
                                   start with u.progr_unita_organizzativa = anuo.padre
                                          and u.ottica = rest.ottica
                                  connect by prior u.progr_unita_organizzativa =
                                              u.id_unita_padre --u.id_elemento = u.id_unita_padre
                                         and u.ottica = rest.ottica
                                         and rest.dal <= nvl(u.al, to_date(3333333, 'j'))
                                         and nvl(rest.al, to_date(3333333, 'j')) >=
                                             nvl(u.dal, rest.dal)
                                         and nvl(u.revisione_cessazione, -1) <>
                                             d_revisione_mod)
                     loop
                        select nvl(max(id_relazioni_struttura) + 1, 1)
                          into d_id
                          from relazioni_unita_organizzative;
                        insert into relazioni_unita_organizzative
                           (revisione
                           ,amministrazione
                           ,ottica
                           ,progr_padre
                           ,cod_padre
                           ,sudd_padre
                           ,progr_figlio
                           ,cod_figlio
                           ,sudd_figlio
                           ,descr_figlio
                           ,descr_padre
                           ,liv_figlio
                           ,liv_padre
                           ,dal_padre
                           ,al_padre
                           ,dal_figlio
                           ,al_figlio
                           ,descr_amministrazione
                           ,cod_aoo
                           ,descr_aoo
                           ,descr_ottica
                           ,sequenza_padre
                           ,sequenza_figlio
                           ,ordinamento
                           ,id_relazioni_struttura
                           ,progr_padre_effettivo)
                           select rest.revisione
                                 ,rest.amministrazione
                                 ,rest.ottica
                                 ,anuo.padre
                                 ,anuo.codice_padre
                                 ,anuo.suddivisione_padre
                                 ,unor.figlio
                                 ,unor.codice_figlio
                                 ,unor.suddivisione_figlio
                                 ,unor.descrizione_figlio
                                 ,anuo.descrizione_padre
                                 ,unor.livello_figlio
                                 ,anuo.livello_padre
                                 ,anuo.dal_padre
                                 ,anuo.al_padre
                                 ,unor.dal_figlio
                                 ,unor.al_figlio
                                 ,rest.descr_amministrazione
                                 ,anuo.cod_aoo
                                 ,anuo.descr_aoo
                                 ,rest.descr_ottica
                                 ,unor.sequenza_padre
                                 ,unor.sequenza_figlio
                                 ,unor.ordinamento
                                 ,d_id
                                 ,unor.id_unita_padre
                             from dual
                            where not exists
                            (select 'x'
                                     from relazioni_unita_organizzative
                                    where revisione = rest.revisione
                                      and amministrazione = rest.amministrazione
                                      and ottica = rest.ottica
                                      and progr_padre = anuo.padre
                                      and cod_padre = anuo.codice_padre
                                      and sudd_padre = anuo.suddivisione_padre
                                      and progr_figlio = unor.figlio
                                      and cod_figlio = unor.codice_figlio
                                      and sudd_figlio = unor.suddivisione_figlio
                                      and dal_padre = anuo.dal_padre
                                      and al_padre = anuo.al_padre
                                      and dal_figlio = unor.dal_figlio
                                      and al_figlio = unor.al_figlio);
                     end loop;
                  end loop;
               end loop;
            end;
         elsif p_revisione is not null then
            --------------------   situazione normale  ---------------------------
            --pulizia della table relazioni_unita_organizzative #684
            delete from relazioni_unita_organizzative where ottica = p_ottica;
            --preparazione della tabella di lavoro temporanea #684
            insert into temp_unor  --#52548
               select id_elemento
                     ,ottica
                     ,revisione
                     ,revisione_cessazione
                     ,sequenza
                     ,progr_unita_organizzativa
                     ,dal
                     ,al
                     ,id_unita_padre
                     ,progr_unita_padre
                     ,utente_aggiornamento
                     ,data_aggiornamento
                     ,codice_uo
                     ,descrizione
                     ,id_suddivisione
                     ,suddivisione
                     ,descr_suddivisione
                     ,rev_ist_anag
                     ,rev_cess_anag
                     ,tipologia_unita
                     ,se_giuridico
                     ,assegnazione_componenti
                     ,amministrazione
                     ,aoo
                     ,centro
                     ,centro_responsabilita
                     ,aggregatore
                     ,utente_ad4
                     ,utente_agg_anag
                     ,data_agg_anag
                     ,note
                     ,tipo_unita
                     ,etichetta
                     ,tag_mail
                 from vista_unita_organizzative
                where ottica = p_ottica;
            --elaborazione delle relazioni #684
            begin
               for rest in (select 0 revisione
                                  ,o.ottica
                                  ,o.descrizione descr_ottica
                                  ,a.codice_amministrazione amministrazione
                                  ,soggetti_get_descr(a.ni, sysdate, 'DESCRIZIONE') descr_amministrazione
                                  ,d_data_inizio
                                  ,'N' tipo_revisione
                                  ,to_date(3333333, 'j') al
                              from ottiche         o
                                  ,amministrazioni a
                             where a.codice_amministrazione = o.amministrazione
                               and o.ottica = nvl(p_ottica, o.ottica)
                             order by o.ottica)
               loop
                  d_data := d_data_inizio;
                  -- determinazione dei periodi di riferimento significativi
                  for cur_date in (select distinct dal
                                     from anagrafe_unita_organizzative
                                    where ottica = p_ottica
                                      and dal >= d_data_inizio
                                   union
                                   select distinct dal
                                     from unita_organizzative
                                    where ottica = p_ottica
                                      and dal >= d_data_inizio
                                   union
                                   select distinct al + 1
                                     from unita_organizzative
                                    where ottica = p_ottica
                                      and nvl(al, to_date(3333333, 'j')) >= d_data_inizio --#684
                                      and al is not null
                                   union
                                   select distinct al + 1
                                     from anagrafe_unita_organizzative
                                    where ottica = p_ottica
                                      and nvl(al, to_date(3333333, 'j')) >= d_data_inizio --#684
                                      and al is not null)
                  loop
                     select min(nvl(al, to_date(3333333, 'j')))
                       into d_al_unor
                       from unita_organizzative
                      where ottica = p_ottica
                        and al >= cur_date.dal;
                     select min(nvl(al, to_date(3333333, 'j')))
                       into d_al_anuo
                       from anagrafe_unita_organizzative
                      where ottica = p_ottica
                        and al >= cur_date.dal;
                     select nvl(min(dal - 1), to_date(3333333, 'j'))
                       into d_dal_unor
                       from unita_organizzative
                      where ottica = p_ottica
                        and dal > cur_date.dal;
                     select nvl(min(dal - 1), to_date(3333333, 'j'))
                       into d_dal_anuo
                       from anagrafe_unita_organizzative
                      where ottica = p_ottica
                        and dal > cur_date.dal;
                     --valorizzazione degli estremi del periodo
                     d_data := cur_date.dal;
                     d_fine := least(nvl(d_al_anuo, to_date(3333333, 'j'))
                                    ,nvl(d_al_unor, to_date(3333333, 'j'))
                                    ,d_dal_anuo
                                    ,d_dal_unor);
                     --analisi delle relazioni alla data  --#684
                     for anuo in (select a.progr_unita_organizzativa padre
                                        ,a.codice_uo codice_padre
                                        ,suddivisione_struttura.get_suddivisione(a.id_suddivisione) suddivisione_padre
                                        ,rest.amministrazione
                                        ,a.descrizione descrizione_padre
                                        ,a.dal
                                        ,a.al
                                        ,greatest(a.dal, d_data) dal_padre
                                        ,least(nvl(a.al, to_date(3333333, 'j'))
                                              ,nvl(d_fine, to_date(3333333, 'j'))) al_padre
                                         --#667
                                        ,get_livello_rs(a.progr_unita_organizzativa
                                                       ,a.ottica
                                                       ,greatest(a.dal, d_data)) livello_padre
                                        ,a.revisione revisione_istituzione
                                        ,a.revisione_cessazione
                                        ,a.aoo cod_aoo
                                        ,'aoo' descr_aoo
                                        ,(select max(sequenza)
                                            from unita_organizzative u1
                                           where u1.progr_unita_organizzativa =
                                                 a.progr_unita_organizzativa
                                             and ottica = rest.ottica
                                             and revisione_struttura.get_dal(rest.ottica
                                                                            ,rest.revisione) between
                                                 u1.dal and
                                                 nvl(u1.al, to_date(3333333, 'j'))) sequenza_padre
                                    from temp_unor a --#684
                                   where a.ottica = rest.ottica
                                     and a.amministrazione = rest.amministrazione
                                     and nvl(a.al, to_date(3333333, 'j')) >= d_data_inizio
                                     and nvl(a.al, to_date(3333333, 'j')) >= d_data
                                     and a.dal <= d_fine
                                   order by a.progr_unita_organizzativa
                                           ,a.dal)
                     loop
                        for unor in (select u.progr_unita_organizzativa figlio --#684
                                           ,u.codice_uo codice_figlio
                                           ,u.suddivisione suddivisione_figlio
                                           ,u.descrizione descrizione_figlio
                                           ,level livello_figlio
                                           ,greatest(anuo.dal_padre, u.dal) dal_figlio
                                           ,least(nvl(u.al, to_date(3333333, 'j'))
                                                 ,nvl(anuo.al_padre
                                                     ,to_date(3333333, 'j'))) al_figlio
                                           ,anuo.sequenza_padre sequenza_padre
                                           ,u.sequenza sequenza_figlio
                                           ,'' ordinamento
                                           ,u.id_unita_padre
                                           ,u.revisione
                                           ,u.revisione_cessazione
                                           ,u.progr_unita_padre
                                       from temp_unor u --#684
                                      where u.ottica = rest.ottica
                                        and u.dal <= nvl(u.al, to_date(3333333, 'j'))
                                        and u.dal <=
                                            least(nvl(u.al, to_date(3333333, 'j'))
                                                 ,nvl(anuo.al_padre, to_date(3333333, 'j')))
                                        and nvl(u.al, to_date(3333333, 'j')) >=
                                            greatest(anuo.dal_padre, u.dal)
                                      start with u.progr_unita_organizzativa = anuo.padre
                                             and u.ottica = rest.ottica
                                             and u.dal <=
                                                 least(nvl(u.al, to_date(3333333, 'j'))
                                                      ,nvl(anuo.al_padre
                                                          ,to_date(3333333, 'j')))
                                             and nvl(u.al, to_date(3333333, 'j')) >=
                                                 greatest(anuo.dal_padre, u.dal)
                                     connect by prior u.progr_unita_organizzativa =
                                                 u.progr_unita_padre
                                            and u.ottica = rest.ottica
                                            and u.dal <=
                                                least(nvl(u.al, to_date(3333333, 'j'))
                                                     ,nvl(anuo.al_padre
                                                         ,to_date(3333333, 'j')))
                                            and nvl(u.al, to_date(3333333, 'j')) >=
                                                greatest(anuo.dal_padre, u.dal))
                        loop
                           d_id := to_number(null);
                           -- compatta periodi omogenei consecutivi
                           begin
                              --#667
                              select id_relazioni_struttura
                                into d_id
                                from relazioni_unita_organizzative
                               where revisione + 0 = rest.revisione --#684
                                 and amministrazione = rest.amministrazione
                                 and descr_amministrazione = rest.descr_amministrazione
                                 and nvl(cod_aoo, 'x') = nvl(anuo.cod_aoo, 'x')
                                 and ottica = rest.ottica
                                 and descr_ottica = rest.descr_ottica
                                 and nvl(progr_padre, -1) = nvl(anuo.padre, -1)
                                 and nvl(cod_padre, 'a') = nvl(anuo.codice_padre, 'a')
                                 and nvl(descr_padre, 'b') =
                                     nvl(anuo.descrizione_padre, 'b')
                                 and nvl(sudd_padre, 'c') =
                                     nvl(anuo.suddivisione_padre, 'c')
                                 and nvl(sequenza_padre, -1) =
                                     nvl(anuo.sequenza_padre, -1)
                                 and nvl(liv_padre, 0) = nvl(anuo.livello_padre, 0)
                                 and progr_figlio = unor.figlio
                                 and cod_figlio || '' = unor.codice_figlio --#684
                                 and descr_figlio = unor.descrizione_figlio
                                 and sudd_figlio = unor.suddivisione_figlio
                                 and nvl(sequenza_figlio, -1) =
                                     nvl(unor.sequenza_figlio, -1)
                                 and nvl(liv_figlio, -1) = nvl(unor.livello_figlio, -1)
                                    /*and nvl(progr_padre_effettivo, -1) =
                                    nvl(unor.id_unita_padre, -1)*/
                                 and nvl(progr_padre_effettivo, -1) =
                                     nvl(unor.progr_unita_padre, -1)
                                 and al_padre = anuo.dal_padre - 1
                                 and al_figlio = unor.dal_figlio - 1;
                           exception
                              when no_data_found then
                                 d_id := to_number(null);
                           end;
                           if d_id is null then
                              select nvl(max(id_relazioni_struttura) + 1, 1)
                                into d_id
                                from relazioni_unita_organizzative;
                              insert into relazioni_unita_organizzative
                                 (revisione
                                 ,amministrazione
                                 ,ottica
                                 ,progr_padre
                                 ,cod_padre
                                 ,sudd_padre
                                 ,progr_figlio
                                 ,cod_figlio
                                 ,sudd_figlio
                                 ,descr_figlio
                                 ,descr_padre
                                 ,liv_figlio
                                 ,liv_padre
                                 ,dal_padre
                                 ,al_padre
                                 ,dal_figlio
                                 ,al_figlio
                                 ,descr_amministrazione
                                 ,cod_aoo
                                 ,descr_aoo
                                 ,descr_ottica
                                 ,sequenza_padre
                                 ,sequenza_figlio
                                 ,ordinamento
                                 ,id_relazioni_struttura
                                 ,progr_padre_effettivo)
                                 select rest.revisione
                                       ,rest.amministrazione
                                       ,rest.ottica
                                       ,anuo.padre
                                       ,anuo.codice_padre
                                       ,anuo.suddivisione_padre
                                       ,unor.figlio
                                       ,unor.codice_figlio
                                       ,unor.suddivisione_figlio
                                       ,unor.descrizione_figlio
                                       ,anuo.descrizione_padre
                                       ,unor.livello_figlio
                                       ,anuo.livello_padre
                                       ,anuo.dal_padre
                                       ,anuo.al_padre
                                       ,unor.dal_figlio
                                       ,unor.al_figlio
                                       ,rest.descr_amministrazione
                                       ,anuo.cod_aoo
                                       ,anuo.descr_aoo
                                       ,rest.descr_ottica
                                       ,unor.sequenza_padre
                                       ,unor.sequenza_figlio
                                       ,unor.ordinamento
                                       ,d_id
                                       ,unor.progr_unita_padre
                                   from dual
                                  where not exists
                                  (select 'x'
                                           from relazioni_unita_organizzative
                                          where revisione + 0 = rest.revisione --#684
                                            and amministrazione = rest.amministrazione
                                            and ottica = rest.ottica
                                            and progr_padre = anuo.padre
                                            and cod_padre || '' = anuo.codice_padre
                                            and sudd_padre = anuo.suddivisione_padre
                                            and progr_figlio = unor.figlio
                                            and cod_figlio || '' = unor.codice_figlio --#684
                                            and sudd_figlio = unor.suddivisione_figlio
                                               --#670
                                            and dal_padre <= anuo.dal_padre
                                            and al_padre >= anuo.al_padre
                                            and dal_figlio <= unor.dal_figlio
                                            and al_figlio >= unor.al_figlio);
                           else
                              update relazioni_unita_organizzative
                                 set al_figlio = unor.al_figlio
                                    ,al_padre  = anuo.al_padre
                               where id_relazioni_struttura = d_id;
                           end if;
                        end loop; --loop figli
                     end loop; --loop padri
                     d_data := d_fine + 1;
                  end loop; --loop date significative
                  commit;
               end loop; --loop revisioni
            end;
         end if;
         p_segnalazione_bloccante := 'N';
         p_segnalazione           := 'Elaborazione completata';
      end if;
   exception
      when others then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Elaborazione fallita : ' || sqlerrm;
   end;
end aggiorna_relazioni_struttura;
/


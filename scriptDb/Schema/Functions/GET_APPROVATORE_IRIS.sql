CREATE OR REPLACE function get_approvatore_iris
(
   p_ni              componenti.ni%type
  ,p_data            componenti.dal%type default null
  ,p_amministrazione amministrazioni.codice_amministrazione%type default null
) return componenti.ni%type is
   /******************************************************************************
    NOME:        dipendente_get_approvatore.
    DESCRIZIONE: Dato l'ni di un componente, restituisce l'ni del soggetto avente
                 ruolo di approvatore nella U.O. di appartenenza. Se il responsabile
                 coincide con l'ni indicato, si cerca il responsabile a livello
                 superiore.
    PARAMETRI:   p_id_soggetto        ni del dipendente
                 p_data               data a cui eseguire la ricerca (facoltativa -
                                      se non specificata si considera la data di sistema)
                 p_amministrazione    amministrazione di ricerca nella struttura (facoltativa
                                      - alternativa all'ottica per la definizione
                                      dell'ottica istituzionale

                 codici di errore: -1 l'individuo richiesto ha più di una assegnazione prevalente alla data
                                   -2 l'individuo richiesto non ha assegnazioni prevalenti alla data
                                   -3 non esiste un solo responsabile
                                   -4 non esiste alcun responsabile
   ******************************************************************************/
   d_result       componenti.ni%type;
   d_ottica       componenti.ottica%type := so4_util.set_ottica_default(''
                                                                       ,p_amministrazione);
   d_progr_unor   componenti.progr_unita_organizzativa%type;
   d_ref_cursor   afc.t_ref_cursor;
   d_ni           componenti.ni%type;
   d_ni_as4       componenti.ni%type;
   d_progr_padre  anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   d_codice_uo    anagrafe_unita_organizzative.codice_uo%type;
   d_descrizione  anagrafe_unita_organizzative.descrizione%type;
   d_responsabile tipi_incarico.responsabile%type;
   d_dal          date;
   d_al           date;
   d_data         date := nvl(p_data, trunc(sysdate));
begin
   -- Identifichiamo il soggetto anagrafico si AS4
   d_ni_as4 := so4gp_pkg.get_ni_as4(p_ni); --#45269
   -- Determiniamo l'UO di assegnazione giuridica del soggetto
   begin
      select c.progr_unita_organizzativa
            ,c.responsabile
        into d_progr_unor
            ,d_responsabile
        from vista_componenti c
       where c.ottica = d_ottica
         and c.ni = d_ni_as4
         and d_data between c.dal and nvl(c.al, to_date(3333333, 'j'))
         and nvl(c.tipo_assegnazione, 'I') = 'I';
   exception
      when too_many_rows then
         -- se abbiamo piu' di una assegnazione istituzionale, prendiamo quella prevalente
         begin
            select c.progr_unita_organizzativa
                  ,c.responsabile
              into d_progr_unor
                  ,d_responsabile
              from vista_componenti c
             where c.ottica = d_ottica
               and c.ni = d_ni_as4
               and d_data between c.dal and nvl(c.al, to_date(3333333, 'j'))
               and substr(nvl(c.assegnazione_prevalente, 0), 1, 1) like '1%'
               and nvl(c.tipo_assegnazione, 'I') = 'I';
         exception
            when too_many_rows then
               return(-1);
         end;
      when no_data_found then
         return(-2);
   end;
   -- Troviamo il responsabile (giuridico o funzionale) della UO di assegnazione, escludendo il soggetto stesso
   begin
      begin
         select ni
           into d_ni
           from componenti c
          where progr_unita_organizzativa = d_progr_unor
            and ottica = d_ottica
            and d_data between dal and nvl(al, to_date(3333333, 'j'))
            and ni <> d_ni_as4
            and exists (select 'x'
                   from attributi_componente a
                  where id_componente = c.id_componente
                    and d_data between dal and nvl(al, to_date(3333333, 'j'))
                    and exists (select 'x'
                           from tipi_incarico
                          where incarico = a.incarico
                            and responsabile = 'SI'));
      exception
         when no_data_found then
            --non esiste alcun responsabile
            d_ni := '';
         when too_many_rows then
            -- Troviamo il responsabile giuridico della UO di assegnazione, escludendo il soggetto stesso
            begin
               select ni
                 into d_ni
                 from componenti c
                where progr_unita_organizzativa = d_progr_unor
                  and ottica = d_ottica
                  and d_data between dal and nvl(al, to_date(3333333, 'j'))
                  and ni <> d_ni_as4
                  and exists
                (select 'x'
                         from attributi_componente a
                        where id_componente = c.id_componente
                          and d_data between dal and nvl(al, to_date(3333333, 'j'))
                          and substr(nvl(assegnazione_prevalente, 0), 1, 1) like '1%'
                          and nvl(tipo_assegnazione, 'I') = 'I'
                          and exists (select 'x'
                                 from tipi_incarico
                                where incarico = a.incarico
                                  and responsabile = 'SI'));
            exception
               when no_data_found then
                  -- in mancanza di un responsabile giuridico per la UO, ne cerchiamo uno funzionale
                  begin
                     select ni
                       into d_ni
                       from componenti c
                      where progr_unita_organizzativa = d_progr_unor
                        and ottica = d_ottica
                        and d_data between dal and nvl(al, to_date(3333333, 'j'))
                        and ni <> d_ni_as4
                        and exists
                      (select 'x'
                               from attributi_componente a
                              where id_componente = c.id_componente
                                and d_data between dal and nvl(al, to_date(3333333, 'j'))
                                and not (substr(nvl(assegnazione_prevalente, 0), 1, 1) like '1%' and
                                     nvl(tipo_assegnazione, 'I') = 'I')
                                and exists (select 'x'
                                       from tipi_incarico
                                      where incarico = a.incarico
                                        and responsabile = 'SI'));
                  exception
                     when no_data_found then
                        --non esiste alcun responsabile
                        d_ni := '';
                     when too_many_rows then
                        --non esiste un solo responsabile
                        return(-3);
                  end;
               when too_many_rows then
                  --non esiste un solo responsabile
                  return(-3);
            end;
      end;
      /*
	  Se non si trova l'approvatore nell'unita' di appartenenza, si ricerca
       l'approvatore nelle unita' di livello superiore
      */
      if d_ni is null or d_ni = d_ni_as4 then
         d_ref_cursor := so4_util.get_ascendenti(d_progr_unor, d_data, d_ottica);
         loop
            fetch d_ref_cursor
               into d_progr_unor
                   ,d_codice_uo
                   ,d_descrizione
                   ,d_dal
                   ,d_al;
            exit when d_ref_cursor%notfound;
            begin
               select ni
                 into d_ni
                 from componenti c
                where progr_unita_organizzativa = d_progr_unor
                  and ottica = d_ottica
                  and d_data between dal and nvl(al, to_date(3333333, 'j'))
                  and ni <> d_ni_as4
                  and exists
                (select 'x'
                         from attributi_componente a
                        where id_componente = c.id_componente
                          and d_data between dal and nvl(al, to_date(3333333, 'j'))
                          and exists (select 'x'
                                 from tipi_incarico
                                where incarico = a.incarico
                                  and responsabile = 'SI'));
            exception
               when no_data_found then
                  --non esiste alcun responsabile
                  d_ni := '';
               when too_many_rows then
                  -- Troviamo il responsabile giuridico della UO di assegnazione, escludendo il soggetto stesso
                  begin
                     select ni
                       into d_ni
                       from componenti c
                      where progr_unita_organizzativa = d_progr_unor
                        and ottica = d_ottica
                        and d_data between dal and nvl(al, to_date(3333333, 'j'))
                        and ni <> d_ni_as4
                        and exists
                      (select 'x'
                               from attributi_componente a
                              where id_componente = c.id_componente
                                and d_data between dal and nvl(al, to_date(3333333, 'j'))
                                and substr(nvl(assegnazione_prevalente, 0), 1, 1) like '1%'
                                and nvl(tipo_assegnazione, 'I') = 'I'
                                and exists (select 'x'
                                       from tipi_incarico
                                      where incarico = a.incarico
                                        and responsabile = 'SI'));
                  exception
                     when no_data_found then
                        -- in mancanza di un responsabile giuridico per la UO, ne cerchiamo uno funzionale
                        begin
                           select ni
                             into d_ni
                             from componenti c
                            where progr_unita_organizzativa = d_progr_unor
                              and ottica = d_ottica
                              and d_data between dal and nvl(al, to_date(3333333, 'j'))
                              and ni <> d_ni_as4
                              and exists
                            (select 'x'
                                     from attributi_componente a
                                    where id_componente = c.id_componente
                                      and d_data between dal and
                                          nvl(al, to_date(3333333, 'j'))
                                      and not (substr(nvl(assegnazione_prevalente, 0), 1, 1) like '1%' and
                                           nvl(tipo_assegnazione, 'I') = 'I')
                                      and exists (select 'x'
                                             from tipi_incarico
                                            where incarico = a.incarico
                                              and responsabile = 'SI'));
                        exception
                           when no_data_found then
                              --non esiste alcun responsabile
                              d_ni := '';
                           when too_many_rows then
                              --non esiste un solo responsabile
                              return(-3);
                        end;
                     when too_many_rows then
                        --non esiste un solo responsabile
                        return(-3);
                  end;
            end;
         
            if d_ni is not null and d_ni <> d_ni_as4 and d_ni <> -99999999 then
               exit;
            end if;
         end loop;
      end if;
      --
      if d_ni is not null and d_ni <> d_ni_as4 and d_ni <> -99999999 then
         d_result := so4gp_pkg.get_ni_p00(d_ni); --#45269
         return d_result;
      else
         --return(-4);
         return null;
      end if;
      --
   end;
end;
/


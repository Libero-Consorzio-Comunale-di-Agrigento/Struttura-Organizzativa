CREATE OR REPLACE function soggetti_get_descr
(
   p_soggetto_ni  number
  ,p_soggetto_dal date
  ,p_colonna      varchar2
) return varchar2 as
   d_descrizione  varchar2(240) := null;
   d_min_dal      date;
   d_max_dal      date;
   d_max_al       date;
   d_soggetto_dal date;
   d_stringa      varchar2(25);
   d_data_limite  date := to_date(3333333, 'j');
   d_data         date := nvl(p_soggetto_dal, trunc(sysdate));
begin
   if p_soggetto_ni is not null then
      if p_colonna = 'UTENTE' then
         begin
            select d.utente
              into d_descrizione
              from as4_anagrafe_soggetti s
                  ,ad4_utenti_soggetti   d
             where s.ni = d.soggetto
               and s.ni = p_soggetto_ni
               and d_data between s.dal and nvl(s.al, to_date(3333333, 'j'));
         exception
            when others then
               d_descrizione := null;
         end;
      elsif p_colonna = 'NOMINATIVO' then
         begin
            select u.nominativo
              into d_descrizione
              from as4_anagrafe_soggetti s
                  ,ad4_utenti_soggetti   d
                  ,ad4_utenti            u
             where s.ni = d.soggetto
               and d.utente = u.utente
               and s.ni = p_soggetto_ni
               and d_data between s.dal and nvl(s.al, to_date(3333333, 'j'));
         exception
            when others then
               d_descrizione := null;
         end;
      else
         begin
            select decode(p_colonna
                         ,'DESCRIZIONE'
                         ,d_stringa || denominazione
                         ,'COGNOME E NOME'
                         ,d_stringa || cognome || ' ' || nome
                         ,'COGNOME'
                         ,cognome
                         ,'NOME'
                         ,nome
                         ,'CODICE FISCALE'
                         ,codice_fiscale
                         ,'DAL'
                         ,to_char(dal, 'dd/mm/yyyy')
                         ,'DATA NASCITA'
                         ,to_char(data_nas, 'dd/mm/yyyy')
                         ,'LUOGO NASCITA'
                         ,ad4_comune.get_denominazione(provincia_nas, comune_nas)
                         ,'SESSO'
                         ,sesso
                         ,'INDIRIZZO COMPLETO'
                         ,indirizzo_res || ' ' || cap_res || ' ' ||
                          ad4_comune.get_denominazione(provincia_res, comune_res))
              into d_descrizione
              from as4_anagrafe_soggetti
             where ni = p_soggetto_ni
               and d_data between dal and nvl(al, to_date(3333333, 'j'));
         exception
            when others then
               d_descrizione := null;
         end;
      end if;
   else
      d_descrizione := null;
   end if;

   -- se il soggetto non è valido alla data indicata, lo cerchiamo
   if d_descrizione is null then
      --
      --  Si ricerca il dal valido per la data indicata
      --
      begin
         select dal
           into d_soggetto_dal
           from as4_anagrafe_soggetti
          where ni = p_soggetto_ni
            and nvl(p_soggetto_dal, trunc(sysdate)) between dal and
                nvl(al, d_data_limite);
      exception
         when others then
            d_soggetto_dal := to_date(null);
      end;
      --
      -- Si selezionano il min(dal), il max(dal) e il max(al)
      --
      begin
         select min(dal)
               ,max(dal)
               ,max(nvl(al, d_data_limite))
           into d_min_dal
               ,d_max_dal
               ,d_max_al
           from as4_anagrafe_soggetti
          where ni = p_soggetto_ni
          group by ni;
      exception
         when others then
            d_min_dal      := to_date(null);
            d_soggetto_dal := to_date(null);
      end;
      --
      -- Se dal non trovato, si ricerca il max(dal)
      --
      if d_soggetto_dal is null then
         --
         -- Se il min(dal) è uguale al max(dal), significa che esiste un solo
         -- record per il soggetto, la cui validità è successiva alla data
         -- di riferimento
         --
         -- Modifica del 29/11/2013: non consideriamo la data di inizio validità
         --
         d_soggetto_dal := d_max_dal;
         --     if d_min_dal = d_max_dal then
         --        d_stringa := 'Valido dal '||to_char(d_soggetto_dal,'dd/mm/yyyy')||' - ';
         --     else
         --        d_stringa := null;
         --     end if;
      end if;
      --
      -- Se il max(al) non è nullo, significa che anagrafica è chiusa
      --
      if d_max_al < d_data_limite and p_soggetto_dal > d_max_al then
         d_stringa := 'Scaduto il ' || to_char(d_max_al, 'dd/mm/yyyy') || ' - ';
      end if;
      --
      if d_soggetto_dal is not null then
         if p_colonna = 'UTENTE' then
            begin
               select d.utente
                 into d_descrizione
                 from as4_anagrafe_soggetti s
                     ,ad4_utenti_soggetti   d
                where s.ni = d.soggetto
                  and s.ni = p_soggetto_ni
                  and s.dal = d_soggetto_dal;
            exception
               when others then
                  d_descrizione := null;
            end;
         elsif p_colonna = 'NOMINATIVO' then
            begin
               select u.nominativo
                 into d_descrizione
                 from as4_anagrafe_soggetti s
                     ,ad4_utenti_soggetti   d
                     ,ad4_utenti            u
                where s.ni = d.soggetto
                  and d.utente = u.utente
                  and s.ni = p_soggetto_ni
                  and s.dal = d_soggetto_dal;
            exception
               when others then
                  d_descrizione := null;
            end;
         else
            begin
               select decode(p_colonna
                            ,'DESCRIZIONE'
                            ,d_stringa || denominazione
                            ,'COGNOME E NOME'
                            ,d_stringa || cognome || ' ' || nome
                            ,'COGNOME'
                            ,cognome
                            ,'NOME'
                            ,nome
                            ,'CODICE FISCALE'
                            ,codice_fiscale
                            ,'DAL'
                            ,to_char(dal, 'dd/mm/yyyy')
                            ,'DATA NASCITA'
                            ,to_char(data_nas, 'dd/mm/yyyy')
                            ,'LUOGO NASCITA'
                            ,ad4_comune.get_denominazione(provincia_nas, comune_nas)
                            ,'SESSO'
                            ,sesso
                            ,'INDIRIZZO COMPLETO'
                            ,indirizzo_res || ' ' || cap_res || ' ' ||
                             ad4_comune.get_denominazione(provincia_res, comune_res))
                 into d_descrizione
                 from as4_anagrafe_soggetti
                where ni = p_soggetto_ni
                  and dal = d_soggetto_dal;
            exception
               when others then
                  d_descrizione := null;
            end;
         end if;
      else
         d_descrizione := null;
      end if;
   end if;
   --
   return d_descrizione;
end;
/


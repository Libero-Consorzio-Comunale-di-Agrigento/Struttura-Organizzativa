CREATE OR REPLACE procedure aggiorna_work_rubrica is
   d_oggi               date := trunc(sysdate);
   d_integrazione_gps   number(1) := 0;
   d_progr_unita_fisica number := 0;
   d_descr_sede         varchar2(4000);
   d_descr_rapporto     varchar2(200);
   d_descr_figura       varchar2(200);
   d_descr_qualifica    varchar2(200);
   d_indirizzo_sede     varchar2(4000);
   d_contatto1          varchar2(200);
   d_contatto2          varchar2(200);
   d_statement          varchar2(2000);
   d_ci                 number(8);
   --creata con la #53411: popola la table dei contatti per il portale del personale
begin
   --svuotamento preliminare
   delete from work_rubrica;
   --verifica integrazione con GP
   if so4gp_pkg.is_int_gp4 or so4gp_pkg.is_int_gps then
      d_integrazione_gps := 1;
   end if;
   --tutte le assegnazioni (I&F) valide ad oggi delle amministrazioni interne
   for comp in (select c.nominativo
                      ,c.ente
                      ,c.descrizione
                      ,c.tipo_assegnazione
                      ,c.ni
                      ,c.ci
                  from vista_assegnazioni c
                      ,amministrazioni    a
                      ,ottiche            o
                 where a.codice_amministrazione = c.ente
                   and a.ente = 'SI'
                   and o.ottica = c.ottica
                   and o.ottica_istituzionale = 'SI'
                   and d_oggi between c.dal and nvl(c.al, to_date(3333333, 'j')))
   loop
      d_descr_sede      := '';
      d_descr_rapporto  := '';
      d_descr_figura    := '';
      d_descr_qualifica := '';
      d_indirizzo_sede  := '';
      d_contatto1       := '';
      d_contatto2       := '';
      d_ci              := comp.ci;

      --contatti per visualizzazione preliminare
      begin
         select sr.contatto
           into d_contatto1
           from soggetti_rubrica sr
          where sr.tipo_contatto = 10
            and comp.ni = sr.ni;
      exception
         when others then
            null;
      end;
      begin
         select sr.contatto
           into d_contatto2
           from soggetti_rubrica sr
          where sr.tipo_contatto = 40
            and comp.ni = sr.ni;
      exception
         when others then
            null;
      end;

      if comp.tipo_assegnazione = 'I' then
         --eventuale assegnazione fisica
         d_progr_unita_fisica := '';
         begin
            select max(progr_unita_fisica)
              into d_progr_unita_fisica
              from assegnazioni_fisiche
             where ni = comp.ni
               and d_oggi between dal and nvl(al, to_date(3333333, 'j'));

            if d_progr_unita_fisica is not null then
               d_descr_sede     := so4_util_fis.get_stringa_ascendenti(d_progr_unita_fisica
                                                                      ,d_oggi
                                                                      ,comp.ente
                                                                      ,0);
               d_indirizzo_sede := so4_util_fis.get_recapito_ascendenti(d_progr_unita_fisica
                                                                       ,d_oggi
                                                                       ,comp.ente);
            end if;
         exception
            when others then
               dbms_output.put_line(d_progr_unita_fisica);
         end;

         --eventuali attributi giuridici di provenienza GP
         if d_integrazione_gps = 1 and comp.ci is not null then

            d_statement := 'begin SELECT figure_giuridiche_pkg.get_descrizione_between(periodi_giuridici_pkg.get_figura_between(:d_ci,''Q'',:d_oggi),:d_oggi) INTO :d_descr_figura FROM dual; EXCEPTION WHEN OTHERS THEN NULL;   end;';
            execute immediate d_statement
               using in out d_descr_figura, d_ci, d_oggi;

            d_statement := 'begin SELECT qualifiche_giuridiche_pkg.get_descrizione_between(periodi_giuridici_pkg.get_qualifica_between(:d_ci,''S'',:d_oggi),:d_oggi) INTO :d_descr_qualifica FROM dual; EXCEPTION WHEN OTHERS THEN NULL;   end;';
            execute immediate d_statement
               using in out d_descr_qualifica, d_ci, d_oggi;

            d_statement := 'begin SELECT posizioni_tpk.get_descrizione(periodi_giuridici_pkg.get_posizione_between(:d_ci,''Q'',:d_oggi)) INTO :d_descr_rapporto FROM dual; EXCEPTION WHEN OTHERS THEN NULL;   end;';
            execute immediate d_statement
               using in out d_descr_rapporto, d_ci, d_oggi;

         end if;
      end if;

      --inserimento delle righe di assegnazione
      insert into work_rubrica
         (nominativo
         ,amministrazione
         ,descr_uo
         ,tipo_assegnazione
         ,descr_sede
         ,indirizzo_sede
         ,descr_figura
         ,descr_qualifica
         ,descr_rapporto
         ,tipo
         ,ni
         ,contatto1
         ,contatto2
         ,ricerca)
      values
         (comp.nominativo
         ,comp.ente
         ,comp.descrizione
         ,comp.tipo_assegnazione
         ,d_descr_sede
         ,d_indirizzo_sede
         ,d_descr_figura
         ,d_descr_qualifica
         ,d_descr_rapporto
         ,'A'
         ,comp.ni
         ,d_contatto1
         ,d_contatto2
         ,comp.nominativo || '#' || comp.ente || '#' || comp.descrizione || '#' ||
          d_descr_sede || '#' || d_indirizzo_sede || '#' || d_descr_figura || '#' ||
          d_descr_qualifica || '#' || d_descr_rapporto || '#' || d_contatto1 || '#' ||
          d_contatto2);

      --contatti; vengono legati all'assegnazione istituzionale per evitare ripetizioni
      --prevedere un giro di recupero per i soggetti che hanno solo assegnazioni funzionali
      --idem per l'assegnazione fisica ed eventuali attributi giuridici di provenienza GPS
      if comp.tipo_assegnazione = 'I' then
         --contatti del soggetto
         for cont in (select sc.descrizione
                            ,sr.contatto
                        from soggetti_rubrica sr
                            ,so4_codifiche    sc
                       where sr.tipo_contatto = sc.valore
                         and sc.dominio = 'SOGGETTI_RUBRICA.TIPO_CONTATTO'
                         and sc.valore is not null
                         and comp.ni = sr.ni)
         loop
            --inserimento delle righe dei contatti
            insert into work_rubrica
               (nominativo
               ,amministrazione
               ,descr_contatto
               ,contatto
               ,descr_uo
               ,tipo_assegnazione
               ,tipo
               ,ni
               ,ricerca)
            values
               (comp.nominativo
               ,comp.ente
               ,cont.descrizione
               ,cont.contatto
               ,comp.descrizione
               ,comp.tipo_assegnazione
               ,'C'
               ,comp.ni
               ,comp.nominativo || '#' || comp.ente || '#' || cont.descrizione || '#' ||
                cont.contatto || '#' || comp.descrizione);
         end loop;
      end if;
   end loop;

   --unita' organizzative
   for uo in (select u.amministrazione
                    ,u.descrizione descr_uo
                    ,u.progr_unita_organizzativa
                from anagrafe_unita_organizzative u
                    ,amministrazioni              a
                    ,ottiche                      o
               where a.codice_amministrazione = u.amministrazione
                 and a.ente = 'SI'
                 and o.ottica = u.ottica
                 and o.ottica_istituzionale = 'SI'
                    --    and c.ni=3114
                 and d_oggi between u.dal and nvl(u.al, to_date(3333333, 'j')))
   loop
      d_contatto1 := '';
      d_contatto2 := '';
      --contatto per griglia
      begin
         select it.indirizzo
           into d_contatto2
           from indirizzi_telematici         it
               ,anagrafe_unita_organizzative uo
               ,ottiche                      ot
          where tipo_entita = 'UO'
            and uo.progr_unita_organizzativa = it.id_unita_organizzativa
            and tipo_indirizzo = 'I';
      exception
         when others then
            null;
      end;
      --inserimento delle righe della UO
      insert into work_rubrica
         (amministrazione
         ,descr_uo
         ,tipo
         ,tipo_assegnazione
         ,ni
         ,contatto2
         ,ricerca)
      values
         (uo.amministrazione
         ,uo.descr_uo
         ,'U'
         ,'I'
         ,uo.progr_unita_organizzativa
         ,d_contatto2
         ,uo.amministrazione || '#' || uo.descr_uo || '#' || d_contatto2);

      --indirizzi della UO
      for inte in (select decode(it.tipo_indirizzo
                                ,'G'
                                ,'Indirizzo Generico'
                                ,'I'
                                ,'Indirizzo Istituzionale'
                                ,'P'
                                ,'Indirizzo PEC'
                                ,'C'
                                ,'Contatto'
                                ,'R'
                                ,'Risposta automatica'
                                ,'M'
                                ,'Protocollo manuale') descrizione
                         ,it.indirizzo contatto
                     from indirizzi_telematici it
                    where tipo_entita = 'UO'
                      and uo.progr_unita_organizzativa = it.id_unita_organizzativa)
      loop
         --inserimento delle righe dei contatti
         insert into work_rubrica
            (amministrazione
            ,descr_uo
            ,tipo
            ,tipo_assegnazione
            ,descr_contatto
            ,contatto
            ,ni
            ,ricerca)
         values
            (uo.amministrazione
            ,uo.descr_uo
            ,'I'
            ,'I'
            ,inte.descrizione
            ,inte.contatto
            ,uo.progr_unita_organizzativa
            ,uo.amministrazione || '#' || uo.descr_uo || '#' || inte.descrizione || '#' ||
             inte.contatto);

      end loop;
   end loop;
end aggiorna_work_rubrica;
/


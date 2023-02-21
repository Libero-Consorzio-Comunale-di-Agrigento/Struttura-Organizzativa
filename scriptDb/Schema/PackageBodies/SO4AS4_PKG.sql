CREATE OR REPLACE package body so4as4_pkg is
   /******************************************************************************
   NOME:        SO4AS4_PKG.
   DESCRIZIONE: Procedure e Funzioni di utilita' per interagire con AS4 nella
                versione 4,4 o successive
   ANNOTAZIONI: .
   REVISIONI: .
   Rev.  Data        Autore  Descrizione.
   00    28/05/2018  AD      Prima emissione.
   01    03/04/2019  SN      Aggiunta procedure trasco_iniziale
   02    15/03/2022  MM      #54239
   03    25/01/2023  MM      #60713
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '003';
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
   procedure allinea_uo
   (
      p_ni_as4                    in as4_anagrafe_soggetti.ni%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type
     ,p_comune                    in anagrafe_unita_organizzative.comune%type
     ,p_cap                       in anagrafe_unita_organizzative.cap%type
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type
     ,p_fax                       in anagrafe_unita_organizzative.fax%type
     ,p_utente_agg                in anagrafe_unita_organizzative.utente_aggiornamento%type
   ) is
      d_ni_as4 as4_anagrafe_soggetti.ni%type;
   begin
      d_ni_as4 := as4so4_pkg.set_soggetto_uo(p_dal
                                            ,p_old_dal
                                            ,p_descrizione
                                            ,p_indirizzo
                                            ,p_provincia
                                            ,p_comune
                                            ,p_cap
                                            ,p_telefono
                                            ,p_fax
                                            ,p_progr_unita_organizzativa  --#54239
                                            ,p_ni_as4
                                            ,p_utente_agg);
/*      if d_ni_as4 != nvl(p_ni_as4, -1) then
         insert into soggetti_unita
            (progr_unita_organizzativa
            ,ni)
         values
            (p_progr_unita_organizzativa
            ,d_ni_as4);
      end if;*/
   end;
   procedure allinea_aoo
   (
      p_ni_as4      in as4_anagrafe_soggetti.ni%type
     ,p_progr_aoo   in aoo.progr_aoo%type
     ,p_dal         in aoo.dal%type
     ,p_old_dal     in aoo.dal%type
     ,p_descrizione in aoo.descrizione%type
     ,p_indirizzo   in aoo.indirizzo%type
     ,p_provincia   in aoo.provincia%type
     ,p_comune      in aoo.comune%type
     ,p_cap         in aoo.cap%type
     ,p_telefono    in aoo.telefono%type
     ,p_fax         in aoo.fax%type
     ,p_utente_agg  in aoo.utente_aggiornamento%type
   ) is
      d_ni_as4 as4_anagrafe_soggetti.ni%type;
   begin
      d_ni_as4 := as4so4_pkg.set_soggetto_aoo(p_dal
                                             ,p_old_dal
                                             ,p_descrizione
                                             ,p_indirizzo
                                             ,p_provincia
                                             ,p_comune
                                             ,p_cap
                                             ,p_telefono
                                             ,p_fax
                                             ,p_ni_as4
                                             ,p_progr_aoo --#60726
                                             ,p_utente_agg);
      /*if d_ni_as4 != nvl(p_ni_as4, -1) then --60726
         insert into soggetti_aoo
            (progr_aoo
            ,ni)
         values
            (p_progr_aoo
            ,d_ni_as4);
      end if;*/
   end;
   procedure allinea_indirizzo_telematico
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_old_indirizzo          in indirizzi_telematici.indirizzo%type
     ,p_utente_agg             in indirizzi_telematici.utente_aggiornamento%type
      --,P_INSERTING                IN NUMBER
   ) is
      d_ni_as4        number;
      d_tipo_contatto relazioni_indirizzo_contatto.tipo_contatto%type;
      d_statement     varchar2(2000);
   begin
      if p_tipo_entita = 'AM' then
         -- AMMINISTRAZIONE
         d_ni_as4 := p_id_amministrazione;
      elsif p_tipo_entita = 'AO' then
         begin
            select ni into d_ni_as4 from soggetti_aoo where progr_aoo = p_id_aoo;
         exception
            when no_data_found then
               d_ni_as4 := null;
         end;
      elsif p_tipo_entita = 'UO' then
         begin
            select ni
              into d_ni_as4
              from soggetti_unita
             where progr_unita_organizzativa = p_id_unita_organizzativa;
         exception
            when no_data_found then
               d_ni_as4 := null;
         end;
      end if;
      if d_ni_as4 is not null then
         begin
            select tipo_contatto
              into d_tipo_contatto
              from relazioni_indirizzo_contatto
             where tipo_indirizzo = p_tipo_indirizzo;
         exception
            when no_data_found then
               d_tipo_contatto := 3; -- vado in maniera fissa sul contatto MAIL
         end;
         as4so4_pkg.allinea_indirizzo_telematico(p_ni_as4           => d_ni_as4
                                                ,p_id_tipo_contatto => d_tipo_contatto
                                                ,p_indirizzo        => p_indirizzo
                                                ,p_old_indirizzo    => p_old_indirizzo
                                                ,p_utente_agg       => p_utente_agg);
      end if;
   end;

   procedure allinea_amm
   (
      p_ni_as4     in as4_anagrafe_soggetti.ni%type
     ,p_codice_amm in amministrazioni.codice_amministrazione%type
   ) is
   begin
      as4so4_pkg.allinea_amm(p_ni_as4, p_codice_amm);
   end;

   procedure trasco_iniziale is
      /******************************************************************************
      NOME:        TRASCO_INIZIALE.
      DESCRIZIONE: Procedure per allineamento da So4 a AS4 quando viene installato
                   il componente AS4NEW in so4.
      ANNOTAZIONI: .
      REVISIONI: .
      Rev.  Data        Autore  Descrizione.
      01    03/04/2019   AD      Prima emissione.
      ******************************************************************************/
      d_ni              number;
      d_codice_aoo_orig varchar2(80);
      d_codice_amm_orig varchar2(80);
      d_codice_uo_orig  varchar2(80);
   begin
      as4so4_pkg.s_trasco_on := 1;
      for sel_ammi in (select *
                         from amministrazioni
                        where not exists (select 1
                         from soggetti_struttura
                        where tipo_entita in ('AO','UO'))
                      )
      loop
         for sel_aoo in (select *
                           from aoo
                          where trunc(sysdate) between dal and
                                nvl(al, to_date(3333333, 'j'))
                            and codice_amministrazione = sel_ammi.codice_amministrazione
                            and not exists
                          (select 1 from soggetti_aoo where progr_aoo = aoo.progr_aoo))
         loop
            begin
               begin
                  select codice_originale
                    into d_codice_aoo_orig
                    from codici_ipa
                   where progressivo = sel_aoo.progr_aoo
                     and tipo_entita = 'AO';
               exception
                  when no_data_found then
                     d_codice_aoo_orig := sel_aoo.codice_aoo;
               end;
               begin
                  select codice_originale
                    into d_codice_amm_orig
                    from codici_ipa --, amministrazioni
                   where progressivo = sel_ammi.ni
                     and tipo_entita = 'AM'
                  --    and codice_amministrazione = sel_aoo.codice_amministrazione
                  ;
               exception
                  when no_data_found then
                     d_codice_amm_orig := sel_aoo.codice_amministrazione;
               end;

               --                dbms_output.put_line('Allineo aoo con questi dati: '||substr(rtrim(sel_aoo.descrizione),1,240-length(' ('||d_codice_amm_orig||':'||d_codice_aoo_orig||')'))||' ('||d_codice_amm_orig||':'||d_codice_aoo_orig||')');
               so4as4_pkg.allinea_aoo(null
                                     ,sel_aoo.progr_aoo
                                     ,sel_aoo.dal
                                     ,null
                                     ,substr(rtrim(sel_aoo.descrizione)
                                            ,1
                                            ,240 -
                                             length(' (' || d_codice_amm_orig || ':' ||
                                                    d_codice_aoo_orig || ')')) || ' (' ||
                                      d_codice_amm_orig || ':' || d_codice_aoo_orig || ')'
                                     ,afc.decode_value(upper(sel_aoo.indirizzo)
                                                      ,'NULL'
                                                      ,null
                                                      ,sel_aoo.indirizzo)
                                     ,sel_aoo.provincia
                                     ,sel_aoo.comune
                                     ,sel_aoo.cap
                                     ,afc.decode_value(upper(sel_aoo.telefono)
                                                      ,'NULL'
                                                      ,null
                                                      ,sel_aoo.telefono)
                                     ,afc.decode_value(upper(sel_aoo.fax)
                                                      ,'NULL'
                                                      ,null
                                                      ,sel_aoo.fax)
                                     ,'SO4');

            exception
               when others then
                  key_error_log_tpk.ins(p_error_id       => ''
                                       ,p_error_session  => userenv('sessionid')
                                       ,p_error_date     => sysdate
                                       ,p_error_text     => 'Errore in allineamento su anagrafica centralizzata per AOO ' ||
                                                            sel_aoo.progr_aoo ||
                                                            ', decorrenza ' ||
                                                            to_char(sel_aoo.dal
                                                                   ,'DD/MM/YYYY')
                                       ,p_error_user     => 'SO4'
                                       ,p_error_usertext => sqlerrm
                                       ,p_error_type     => 'E');
            end;
            for sel_inmo in (select *
                               from indirizzi_telematici
                              where tipo_entita = 'AO'
                                and id_aoo = sel_aoo.progr_aoo)
            loop
               begin
                  so4as4_pkg.allinea_indirizzo_telematico(p_tipo_entita            => 'AO'
                                                         ,p_tipo_indirizzo         => sel_inmo.tipo_indirizzo
                                                         ,p_id_amministrazione     => null
                                                         ,p_id_aoo                 => sel_inmo.id_aoo
                                                         ,p_id_unita_organizzativa => null
                                                         ,p_indirizzo              => sel_inmo.indirizzo
                                                         ,p_old_indirizzo          => null
                                                         ,p_utente_agg             => 'SO4');
               exception
                  when others then
                     key_error_log_tpk.ins(p_error_id       => ''
                                          ,p_error_session  => userenv('sessionid')
                                          ,p_error_date     => sysdate
                                          ,p_error_text     => 'Errore in allineamento indirizzo telematico ' ||
                                                               sel_inmo.indirizzo ||
                                                               ' su anagrafica centralizzata '
                                          ,p_error_user     => 'SO4'
                                          ,p_error_usertext => sqlerrm
                                          ,p_error_type     => 'E');
               end;
            end loop;
         end loop;
         for sel_anuo in (select anuo.*
                            from anagrafe_unita_organizzative anuo
                           where sysdate between dal and nvl(al, to_date(3333333, 'j'))
                             and not exists
                           (select 1
                                    from soggetti_unita
                                   where progr_unita_organizzativa =
                                         anuo.progr_unita_organizzativa)
                             and amministrazione = sel_ammi.codice_amministrazione)
         loop
            begin
               begin
                  select codice_originale
                    into d_codice_uo_orig
                    from codici_ipa
                   where progressivo = sel_anuo.progr_unita_organizzativa
                     and tipo_entita = 'UO';
               exception
                  when no_data_found then
                     d_codice_uo_orig := sel_anuo.codice_uo;
               end;
               begin
                  select codice_originale
                    into d_codice_aoo_orig
                    from codici_ipa
                   where progressivo = sel_anuo.progr_aoo
                     and tipo_entita = 'AO';
               exception
                  when no_data_found then
                     begin
                        select codice_aoo
                          into d_codice_aoo_orig
                          from aoo
                         where progr_aoo = sel_anuo.progr_aoo;
                     exception
                        when no_data_found then
                           d_codice_aoo_orig := null;
                     end;
               end;
               begin
                  select codice_originale
                    into d_codice_amm_orig
                    from codici_ipa
                        ,amministrazioni
                   where progressivo = ni
                     and tipo_entita = 'AM'
                     and codice_amministrazione = sel_anuo.amministrazione;
               exception
                  when no_data_found then
                     d_codice_amm_orig := sel_anuo.amministrazione;
               end;
               --               dbms_output.put_line('Allineo uo con questi dati: '||substr(rtrim(sel_anuo.descrizione),1,240-length(' ('||d_codice_amm_orig||':'||d_codice_aoo_orig||':'||d_codice_uo_orig||')' ))||' ('||d_codice_amm_orig||':'||d_codice_aoo_orig||':'||d_codice_uo_orig||')');
               so4as4_pkg.allinea_uo(null
                                    ,sel_anuo.progr_unita_organizzativa
                                    ,sel_anuo.dal
                                    ,null
                                    ,substr(rtrim(sel_anuo.descrizione)
                                           ,1
                                           ,240 - length(' (' || d_codice_amm_orig || ':' ||
                                                         d_codice_aoo_orig || ':' ||
                                                         d_codice_uo_orig || ')')) || ' (' ||
                                     d_codice_amm_orig || ':' || d_codice_aoo_orig || ':' ||
                                     d_codice_uo_orig || ')'
                                    ,afc.decode_value(upper(sel_anuo.indirizzo)
                                                     ,'NULL'
                                                     ,null
                                                     ,sel_anuo.indirizzo) -- se arrivano schifezze da scarico IPA
                                    ,sel_anuo.provincia
                                    ,sel_anuo.comune
                                    ,sel_anuo.cap
                                    ,afc.decode_value(upper(sel_anuo.telefono)
                                                     ,'NULL'
                                                     ,null
                                                     ,sel_anuo.telefono)
                                    ,afc.decode_value(upper(sel_anuo.fax)
                                                     ,'NULL'
                                                     ,null
                                                     ,sel_anuo.fax)
                                    ,'SO4');
            exception
               when others then
                  key_error_log_tpk.ins(p_error_id       => ''
                                       ,p_error_session  => userenv('sessionid')
                                       ,p_error_date     => sysdate
                                       ,p_error_text     => 'Errore in allineamento su anagrafica centralizzata per Unità Organizzativa ' ||
                                                            sel_anuo.progr_unita_organizzativa ||
                                                            ', decorrenza ' ||
                                                            to_char(sel_anuo.dal
                                                                   ,'DD/MM/YYYY')
                                       ,p_error_user     => 'SO4'
                                       ,p_error_usertext => sqlerrm
                                       ,p_error_type     => 'E');
            end;
            for sel_inmo in (select *
                               from indirizzi_telematici
                              where tipo_entita = 'UO'
                                and id_unita_organizzativa =
                                    sel_anuo.progr_unita_organizzativa)
            loop
               begin
                  so4as4_pkg.allinea_indirizzo_telematico(p_tipo_entita            => 'UO'
                                                         ,p_tipo_indirizzo         => sel_inmo.tipo_indirizzo
                                                         ,p_id_amministrazione     => null
                                                         ,p_id_aoo                 => null
                                                         ,p_id_unita_organizzativa => sel_inmo.id_unita_organizzativa
                                                         ,p_indirizzo              => sel_inmo.indirizzo
                                                         ,p_old_indirizzo          => null
                                                         ,p_utente_agg             => 'SO4');
               exception
                  when others then
                     key_error_log_tpk.ins(p_error_id       => ''
                                          ,p_error_session  => userenv('sessionid')
                                          ,p_error_date     => sysdate
                                          ,p_error_text     => 'Errore in allineamento indirizzo telematico ' ||
                                                               sel_inmo.indirizzo ||
                                                               ' su anagrafica centralizzata '
                                          ,p_error_user     => 'SO4'
                                          ,p_error_usertext => sqlerrm
                                          ,p_error_type     => 'E');
               end;
            end loop;
         end loop;
         for sel_inmo in (select *
                            from indirizzi_telematici
                           where tipo_entita = 'AM'
                             and id_amministrazione = sel_ammi.ni)
         loop
            begin
               so4as4_pkg.allinea_indirizzo_telematico(p_tipo_entita            => 'AM'
                                                      ,p_tipo_indirizzo         => sel_inmo.tipo_indirizzo
                                                      ,p_id_amministrazione     => sel_inmo.id_amministrazione
                                                      ,p_id_aoo                 => null
                                                      ,p_id_unita_organizzativa => null
                                                      ,p_indirizzo              => sel_inmo.indirizzo
                                                      ,p_old_indirizzo          => null
                                                      ,p_utente_agg             => 'SO4');
            exception
               when others then
                  key_error_log_tpk.ins(p_error_id       => ''
                                       ,p_error_session  => userenv('sessionid')
                                       ,p_error_date     => sysdate
                                       ,p_error_text     => 'Errore in allineamento indirizzo telematico ' ||
                                                            sel_inmo.indirizzo ||
                                                            ' su anagrafica centralizzata '
                                       ,p_error_user     => 'SO4'
                                       ,p_error_usertext => sqlerrm
                                       ,p_error_type     => 'E');
            end;

         end loop;
         commit; -- faccio il commit per amministrazione
         begin
            select codice_originale
              into d_codice_amm_orig
              from codici_ipa
             where progressivo = sel_ammi.ni
               and tipo_entita = 'AM';
         exception
            when no_data_found then
               d_codice_amm_orig := sel_ammi.codice_amministrazione;
         end;
         --dbms_output.put_line('Allineo amm con questi dati: '||d_codice_amm_orig);
         so4as4_pkg.allinea_amm(sel_ammi.ni, d_codice_amm_orig);
      end loop;
      as4so4_pkg.s_trasco_on := 0;
   end;

end so4as4_pkg;
/


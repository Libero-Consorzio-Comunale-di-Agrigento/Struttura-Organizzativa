CREATE OR REPLACE procedure allinea_anagrafe_uo_differito is
   d_statement varchar2(2000);
begin
   --#54239
   key_error_log_tpk.ins(p_error_id       => ''
                        ,p_error_session  => userenv('sessionid')
                        ,p_error_date     => sysdate
                        ,p_error_text     => 'Inizio allineamento su anagrafica centralizzata per Unità Organizzativa '
                        ,p_error_user     => 'wmm'
                        ,p_error_usertext => ''
                        ,p_error_type     => 'I');
   for allas4 in (select operazione
                        ,ni_as4
                        ,progr_unita_organizzativa
                        ,dal
                        ,old_dal
                        ,descrizione
                        ,decode(indirizzo, '""', '', indirizzo) indirizzo
                        ,provincia
                        ,comune
                        ,decode(cap, '""', '', cap) cap
                        ,telefono
                        ,fax
                        ,utente_agg
                    from work_allinea_uo_as4
                  -- where progr_unita_organizzativa = 99458
                   order by progr_unita_organizzativa)
   loop
      begin
         if allas4.operazione = 'I' then
            d_statement := 'begin so4as4_pkg.allinea_uo(:p_ni_as4,:p_progr_unita_organizzativa,:p_dal, :p_old_dal, :p_descrizione , :p_indirizzo, :p_provincia , :p_comune, :p_cap , :p_telefono, :p_fax, :p_utente_agg); end; ';
            execute immediate d_statement
               using in allas4.ni_as4, allas4.progr_unita_organizzativa, allas4.dal, allas4.old_dal, allas4.descrizione, allas4.indirizzo, allas4.provincia, allas4.comune, allas4.cap, allas4.telefono, allas4.fax, allas4.utente_agg;
         else
            d_statement := 'begin so4as4_pkg.allinea_uo(:p_ni_as4,:p_progr_unita_organizzativa,:p_dal, :p_old_dal, :p_descrizione , :p_indirizzo, :p_provincia , :p_comune, :p_cap , :p_telefono, :p_fax, :p_utente_agg); end; ';
            execute immediate d_statement
               using in allas4.ni_as4, allas4.progr_unita_organizzativa, allas4.dal, allas4.old_dal, allas4.descrizione, allas4.indirizzo, allas4.provincia, allas4.comune, allas4.cap, allas4.telefono, allas4.fax, allas4.utente_agg;
         end if;
         --riallinea gli indirizzi telematici della UO trattata --#60713
         for inte in (select *
                        from indirizzi_telematici i
                       where i.tipo_entita = 'UO'
                         and i.id_unita_organizzativa = allas4.progr_unita_organizzativa
                       order by i.id_indirizzo)
         loop
            begin
               so4as4_pkg.allinea_indirizzo_telematico(inte.tipo_entita
                                                      ,inte.tipo_indirizzo
                                                      ,inte.id_amministrazione
                                                      ,inte.id_aoo
                                                      ,inte.id_unita_organizzativa
                                                      ,inte.indirizzo
                                                      ,''
                                                      ,inte.utente_aggiornamento);
            exception
               when others then
                  key_error_log_tpk.ins(p_error_id       => ''
                                       ,p_error_session  => userenv('sessionid')
                                       ,p_error_date     => trunc(sysdate)
                                       ,p_error_text     => 'Errore in allineamento indirizzo telematico ' ||
                                                            inte.indirizzo ||
                                                            ' su anagrafica centralizzata '
                                       ,p_error_user     => inte.utente_aggiornamento
                                       ,p_error_usertext => sqlerrm
                                       ,p_error_type     => 'E');
            end;
         end loop;

         delete from work_allinea_uo_as4
          where progr_unita_organizzativa = allas4.progr_unita_organizzativa;
      exception
         when others then
            key_error_log_tpk.ins(p_error_id       => ''
                                 ,p_error_session  => userenv('sessionid')
                                 ,p_error_date     => trunc(sysdate)
                                 ,p_error_text     => 'Errore in allineamento su anagrafica centralizzata per Unità Organizzativa ' ||
                                                      allas4.progr_unita_organizzativa ||
                                                      ', decorrenza ' ||
                                                      to_char(allas4.dal, 'DD/MM/YYYY')
                                 ,p_error_user     => allas4.utente_agg
                                 ,p_error_usertext => sqlerrm
                                 ,p_error_type     => 'E');
      end;
      commit;
   end loop;
   key_error_log_tpk.ins(p_error_id       => ''
                        ,p_error_session  => userenv('sessionid')
                        ,p_error_date     => sysdate
                        ,p_error_text     => 'Fine allineamento su anagrafica centralizzata per Unità Organizzativa '
                        ,p_error_user     => 'wmm'
                        ,p_error_usertext => ''
                        ,p_error_type     => 'I');
   commit;
end;
/


CREATE OR REPLACE procedure chiudi_anagrafe_struttura
(
   p_progressivo in anagrafe_unita_organizzative.progr_unita_organizzativa%type
  ,p_tipo        in varchar2
  ,p_data        in date
) is
   /* MMonari 24/11/2021 issue #53727
   */
   d_ni            anagrafe_soggetti.ni%type;
   d_error_session key_error_log.error_session%type;
   d_error_date    key_error_log.error_date%type := sysdate;
   d_error_user    key_error_log.error_user%type := 'SO4_CAS';
   --
   errore_in_elaborazione exception;
begin
   if p_tipo = 'UO' then
      begin
         update unita_organizzative
            set al                 = p_data
               ,data_aggiornamento = trunc(sysdate)
          where progr_unita_organizzativa = p_progressivo
            and ottica = 'EXTRAISTITUZIONALE'
            and al is null;
         update anagrafe_unita_organizzative
            set al                 = p_data
               ,data_aggiornamento = trunc(sysdate)
          where progr_unita_organizzativa = p_progressivo
            and ottica = 'EXTRAISTITUZIONALE'
            and al is null;
      exception
         when others then
            -- registra errore su key_error_log
            select nvl(max(error_session), 0) + 1
              into d_error_session
              from key_error_log
             where error_user = d_error_user;
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore chiusura unita organizzativa ' ||
                                                      p_progressivo || ' : ' || p_data
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
      end;
   elsif p_tipo = 'AO' then
      begin
         update aoo
            set al                 = p_data
               ,data_aggiornamento = trunc(sysdate)
          where progr_aoo = p_progressivo
            and al is null;
      exception
         when others then
            -- registra errore su key_error_log
            select nvl(max(error_session), 0) + 1
              into d_error_session
              from key_error_log
             where error_user = d_error_user;
            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore chiusura AOO ' ||
                                                      p_progressivo || ' : ' || p_data
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
      end;

   end if;
   if d_error_session is null then
      begin
         select ni
           into d_ni
           from soggetti_struttura
          where tipo_entita = p_tipo
            and progr_entita = p_progressivo;

         as4_anagrafici_pkg.chiusura_anagrafica(d_ni, p_data);
      exception
         when others then
            -- registra errore su key_error_log
            select nvl(max(error_session), 0) + 1
              into d_error_session
              from key_error_log
             where error_user = d_error_user;

            key_error_log_tpk.ins(p_error_session  => d_error_session
                                 ,p_error_user     => d_error_user
                                 ,p_error_date     => d_error_date
                                 ,p_error_text     => 'Errore chiusura anagrafica di struttura ' ||
                                                      p_tipo || ' - ' || p_progressivo ||
                                                      ' : ' || p_data
                                 ,p_error_type     => 'E'
                                 ,p_error_usertext => sqlerrm);
      end;
   end if;
end;
/


CREATE OR REPLACE procedure schedula_allinea_anagrafe_uo is
   d_job number;
begin
   --#54239
   d_job := job_utility.crea('begin allinea_anagrafe_uo_differito; end;'
                            ,sysdate + 10 / 86400);
   commit;
exception
   when others then
      key_error_log_tpk.ins(p_error_id       => ''
                           ,p_error_session  => userenv('sessionid')
                           ,p_error_date     => trunc(sysdate)
                           ,p_error_text     => 'Errore in creazione job allineamento su anagrafica centralizzata per Unità Organizzativa '
                           ,p_error_user     => 'ipa'
                           ,p_error_usertext => sqlerrm
                           ,p_error_type     => 'E');
      commit;
end;
/


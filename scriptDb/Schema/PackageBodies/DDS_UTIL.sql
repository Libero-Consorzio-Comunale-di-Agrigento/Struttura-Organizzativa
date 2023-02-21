CREATE OR REPLACE PACKAGE BODY DDS_UTIL is

d_statement afc.t_statement;

procedure SET_OWNER
/* Attua su DDS_OWNERS le modifiche ad una AMMINISTRAZIONE */
( in_codice_amministrazione in varchar2
 ,in_denominazione          in varchar2
)
is
begin
  -- verifica se l'amministrazione esiste come owner. Se NO, inserisce
  d_statement := 'begin dds_ad4so4_util.set_owner('|| in_codice_amministrazione||', '||in_denominazione||' ); end;';
  afc.sql_execute(d_statement);
end;

procedure INITIALIZE_OWNERS
/* Popolamento iniziale della tabelle DDS_OWNERS con le amministrazioni interne di SO4 */
(in_clean_up in number default 0 -- se 1, elimina tutti gli owner preesistenti
)
is
begin
  if in_clean_up = 1 then
    /*  Esegue, se richiesta, la pulizia preliminare di DDS_OWNERS */
    d_statement := 'begin dds_ad4so4_util.reset_owners; end;';
    afc.sql_execute(d_statement);
  end if;
  for ammi           in ( select upper(a.codice_amministrazione) codice_amministrazione
                                 ,( select replace(denominazione,'''','')
                                      from as4_anagrafe_soggetti
                                     where ni=a.ni
                                       and al is null
                                  )                              denominazione
                             from amministrazioni a
                            where ente='SI'
                         )
  loop
    if ammi.denominazione is not null then
      d_statement := 'begin dds_ad4so4_util.set_owner('''|| ammi.codice_amministrazione||''', '''||ammi.denominazione||''' ); end;';
      afc.sql_execute(d_statement);
    end if;
  end loop;
  commit;
end;

function IS_MEMBER_ACTIVE
(in_user                in varchar2
,in_owner               in varchar2
) return number
is
  out_status number := 0;
begin
  begin
    select 1
      into out_status
      from componenti c
     where ni                         = ( select soggetto
                                            from ad4_utenti_soggetti
                                           where utente              = in_user
                                        )
       and ottica                    in ( select  ottica
                                            from ottiche
                                           where amministrazione     = in_owner
                                        )
       and trunc(sysdate)       between dal and nvl(al,to_date(3333333,'j'))
       and rownum                     = 1;
  exception when no_data_found then
    out_status := 0;
  end;
  return out_status;
end;

procedure SET_MEMBER
/* Attua su DDS_MEMBERS le modifiche ai componenti di SO4 */
( in_user   in varchar2
 ,in_owner  in varchar2
)
is
  d_member_active number(1) := IS_MEMBER_ACTIVE ( in_user, in_owner );
begin
  -- verifica se l'utente esiste come membro dell'owner. Se NO, inserisce
  d_statement := 'begin dds_ad4so4_util.set_member('''||in_user||''', '''||in_owner||''','||d_member_active||' ); end;';
  afc.sql_execute(d_statement);
end;

procedure SET_ROLE
/* Attua su DDS_ROLES le modifiche ai componenti/ruoli di SO4 */
( in_user     in varchar2
 ,in_project  in varchar2
 ,in_admin    in varchar2
 ,in_observer in varchar2
)
is
begin
  --verifica se l'utente esiste nel progetto. Se NO, inserisce
  d_statement := 'begin dds_ad4so4_util.set_role('''||in_user||''', '''||in_project||''','||in_admin||','||in_observer||' ); end;';
  afc.sql_execute(d_statement);
end;

procedure INITIALIZE_MEMBERS
/* Popolamento iniziale della tabella DDS_MEMBERS con i componenti di SO4 */
( in_clean_up    in number   default 0   -- se 1, elimina tutti gli owner preesistenti
 ,in_owner       in varchar2 default '%' -- codice amministrazione, in like
 ,in_active_only in number   default 1   -- se 1, aggiorna solo i componenti attivi ad oggi
)
is
begin
  if in_clean_up = 1 then
    d_statement := 'begin dds_ad4so4_util.reset_members; end;';
    afc.sql_execute(d_statement);
  end if;
  for componenti in ( select distinct s.utente                                         utente
                                     ,o.amministrazione                                owner
                                     ,IS_MEMBER_ACTIVE ( s.utente, o.amministrazione ) is_active
                                 from ad4_utenti_soggetti          s
                                     ,ottiche                      o
                                     ,componenti                   c
                                where c.ni = s.soggetto
                                  and c.ottica  = o.ottica
                                  and o.amministrazione like in_owner
                                  and (    dds_util.IS_MEMBER_ACTIVE(s.utente, o.amministrazione)  = in_active_only
                                        or in_active_only                                         <> 1
                                      )
                                order by s.utente, o.amministrazione
                     )
  loop
    d_statement := 'begin dds_ad4so4_util.set_member('''||componenti.utente||''', '''||componenti.owner||''','||componenti.is_active||' ); end;';
    afc.sql_execute(d_statement);
  end loop;
  commit;
end;

procedure SET_USER
/* Attua su DDS_USERS le modifiche ad un UTENTE/COMPONENTE */
( in_user  in varchar2
 ,in_admin in varchar2 default 0
)
is
/* I dati di DDS_USERS vengono generati secondo i seguenti criteri:
  u_user           AD4.UTENTI.UTENTE
  u_name           AD4.UTENTI.NOMINATIVO
  u_mail           ANAGRAFE_SOGGETTI.INDIRIZZO_WEB
  u_tel            --
  u_info           dati del soggetto: cognome, nome, CF
  u_admin          0
  u_log_sql        1
  u_log_url        1
  u_log_html       0
  u_pos_date       0
  u_pos_latlong    0
  u_project        null
  u_log_ajax       null
*/
begin
  d_statement := 'begin dds_ad4so4_util.set_user('''||in_user||''','||in_admin||' ); end;';
  afc.sql_execute(d_statement);
end;

procedure INITIALIZE_USERS
/* Popolamento iniziale della tabella DDS_USERS con gli uetnti applicativi di AD4 */
(in_clean_up in number default 0 -- se 1, elimina tutti gli user preesistenti
)
is
begin
  if in_clean_up = 1 then
    d_statement := 'begin dds_ad4so4_util.reset_users; end;';
    afc.sql_execute(d_statement);
  end if;
  for utenti in ( select utente
                    from ad4_utenti
                   where tipo_utente = 'U'
                     and stato       = 'U'
                )
  loop
    d_statement := 'begin dds_ad4so4_util.set_user('''||utenti.utente||''' ); end;';
    --dbms_output.put_line(d_statement);
    afc.sql_execute(d_statement);
  end loop;
end;

procedure RESET_GRANTS
/* Pulisce DDS_GRANTS per utente e table */
( in_user          in varchar2
 ,in_table         in varchar2
)
is
begin
  d_statement := 'begin dds_ad4so4_util.reset_grants('''||in_user||''','''||in_table||''' ); end;';
  afc.sql_execute(d_statement);
end;

procedure SET_GRANTS
/* Attua su DDS_GRANTS le modifiche ai ruoli dei componenti di SO4 */
( in_user          in varchar2
 ,in_role          in varchar2
 ,in_owner         in varchar2
 ,in_project       in varchar2
 ,in_table         in varchar2
)
is
begin
  d_statement := 'begin dds_ad4so4_util.set_grants('''||in_user||''','''||in_role||''','''||in_owner||''','''||in_project||''','''||in_table||''' ); end;';
  afc.sql_execute(d_statement);
end;

procedure ANALYZE_ROLE
/* Analisi della descrizione del ruolo per estrarre progetto,tabella e profilo di utilizzo */
( in_role        in     varchar2
 ,out_project    in out varchar2
 ,out_table      in out varchar2
 ,out_profile    in out varchar2
)
is
begin
  select case
          when instr(descrizione,'::',1,2) = 0 and instr(descrizione,'::',1,3) = 0 then
           to_char(null)
          when instr(descrizione,'::',1,2) <> 0 and instr(descrizione,'::',1,3) = 0 then
           upper(substr(descrizione,instr(descrizione,'::',1,2)+2,2))
          when instr(descrizione,'::',1,2) <> 0 and instr(descrizione,'::',1,3) <> 0 then
           upper(substr(descrizione,instr(descrizione,'::',1,2)+2,2))
         end as progetto
        ,case
          when instr(descrizione,'::',1,2) = 0 or instr(descrizione,'::',1,3) = 0 then
           to_char(null)
          when instr(descrizione,'::',1,2) <> 0 and instr(descrizione,'::',1,3) <> 0 then
           upper(substr(descrizione,instr(descrizione,'::',1,3)+2))
         end as tabella
        ,substr(ruolo,4,1) profilo
    into out_project
        ,out_table
        ,out_profile
    from ad4_ruoli
   where ruolo = in_role
  ;
end;

end;
/


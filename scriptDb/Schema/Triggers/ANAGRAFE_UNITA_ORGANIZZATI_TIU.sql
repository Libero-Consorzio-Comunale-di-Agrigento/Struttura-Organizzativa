CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_ORGANIZZATI_TIU
/******************************************************************************
    NOME:        ANAGRAFE_UNITA_ORGANIZZATI_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table ANAGRAFE_UNITA_ORGANIZZATIVE
   ******************************************************************************/
   before insert or update or delete ON ANAGRAFE_UNITA_ORGANIZZATIVE    for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno                  integer;
   errmsg                 char(200);
   dummy                  integer;
   found                  boolean;
   d_revisione_mod        revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(nvl(:new.ottica
                                                                                                         ,:old.ottica));
   d_data_pubb            revisioni_struttura.data_pubblicazione%type;
   d_ottica_istituzionale ottiche.ottica_istituzionale%type;
   d_nominativo           varchar2(40);
   d_dal_aoo              date;
   d_codice_aoo           AOO.CODICE_AOO%type;
   d_codice_uo            ANAGRAFE_UNITA_ORGANIZZATIVE.CODICE_UO%type;
   d_messaggio            varchar2(200);
begin
   functionalnestlevel := integritypackage.getnestlevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __
    1  21/03/2019  SNeg  verifica su amministrazione con upper e trim
   ***************************************************************************/
   begin
      -- Check / Set DATA Integrity
      -- Column "PROGR_UNITA_ORGANIZZATIVA" uses GET_ID_AREA function
      if :new.progr_unita_organizzativa is null and not deleting then
         select anagrafe_unita_organizzativa.get_id_unita
           into :new.progr_unita_organizzativa
           from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := substr(user, 1, 8); --#53979
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
      if inserting or updating then -- ipotizzo che da scarico IPA mi venga passato il codice così come è
        d_codice_uo := :new.codice_uo;
        :new.codice_uo := upper(:new.codice_uo);
        if upper(:new.fax) = 'NULL' then -- per evitare eventuali dati da scarico ipa sporchi
            :new.fax := '';
        end if;
        if upper(:new.telefono) = 'NULL' then -- per evitare eventuali dati da scarico ipa sporchi
            :new.telefono := '';
        end if;  
        if upper(:new.indirizzo) = 'NULL' then -- per evitare eventuali dati da scarico ipa sporchi
            :new.indirizzo := '';
        end if;         
      end if;      
   end;
   -- determinazione delle date di pubblicazione per le operazioni non correlate ad una revisione in modifica
   if anagrafe_unita_organizzativa.s_eliminazione_logica = 0 then
      --#703
      if inserting and :new.revisione_istituzione <> d_revisione_mod then
         -- storicizzazione
         select decode(greatest(trunc(sysdate), nvl(:new.dal, to_date(3333333, 'j')))
                      ,to_date(3333333, 'j')
                      ,to_date(null)
                      ,greatest(trunc(sysdate), nvl(:new.dal, to_date(3333333, 'j'))))
           into :new.dal_pubb
           from dual;
         select decode(greatest(trunc(sysdate), nvl(:new.al, to_date(3333333, 'j')))
                      ,to_date(3333333, 'j')
                      ,to_date(null)
                      ,greatest(trunc(sysdate), nvl(:new.al, to_date(3333333, 'j'))))
           into :new.al_pubb
           from dual;
      elsif updating and (nvl(:new.revisione_cessazione, -2) <> d_revisione_mod or
            (nvl(:new.revisione_cessazione, -2) = d_revisione_mod and
            :old.dal_pubb is not null and :new.dal_pubb is null)) then
         -- rettifica
         if :old.dal_pubb is not null then
            :new.dal_pubb := :old.dal_pubb;
         end if;
         if nvl(:new.revisione_cessazione, :old.revisione_cessazione) is not null then
            d_data_pubb := revisione_struttura.get_data_pubblicazione(nvl(:new.ottica
                                                                         ,:old.ottica)
                                                                     ,nvl(:new.revisione_cessazione
                                                                         ,:old.revisione_cessazione));
         else
            d_data_pubb := trunc(sysdate);
         end if;
         if :old.al_pubb is null then
            select decode(greatest(trunc(sysdate) - 1
                                  ,nvl(:new.al, to_date(3333333, 'j'))
                                  ,d_data_pubb - 1)
                         ,to_date(3333333, 'j')
                         ,to_date(null)
                         ,greatest(trunc(sysdate) - 1
                                  ,nvl(:new.al, to_date(3333333, 'j'))
                                  ,d_data_pubb - 1))
              into :new.al_pubb
              from dual;
         else
            :new.al_pubb := :old.al_pubb;
         end if;
      end if;
   end if;
   if inserting then
      if :new.ottica is not null and :new.dal is not null and :new.codice_uo is not null then
         if anagrafe_unita_organizzativa.s_eliminazione_logica = 0 then
            --#703
            begin
               anagrafe_unita_organizzativa.chk_ins(:new.ottica
                                                   ,:new.progr_unita_organizzativa
                                                   ,:new.dal
                                                   ,:new.codice_uo);
            end;
         end if;
         if :new.revisione_istituzione is null then
            :new.revisione_istituzione := revisione_struttura.get_revisione_mod(:new.ottica);
         end if;
      end if;
   end if;
   if not deleting then
      begin
         anagrafe_unita_organizzativa.chk_di(:new.dal
                                            ,:new.al
                                            ,:new.ottica
                                            ,:new.des_abb
                                            ,:new.progr_aoo
                                            ,:new.amministrazione
                                            ,:new.indirizzo
                                            ,:new.cap
                                            ,:new.provincia
                                            ,:new.comune
                                            ,:new.telefono
                                            ,:new.fax
                                            ,:new.revisione_istituzione
                                            ,:new.revisione_cessazione);
      end;
   end if;
   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "ANAGRAFE_UNITA_ORGANIZZATIVE"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_anagrafe_unita_organizza
               (
                  var_progr_unita_organizzativa number
                 ,var_dal                       date
               ) is
                  select 1
                    from anagrafe_unita_organizzative
                   where progr_unita_organizzativa = var_progr_unita_organizzativa
                     and dal = var_dal;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.progr_unita_organizzativa is not null and :new.dal is not null then
                  open cpk_anagrafe_unita_organizza(:new.progr_unita_organizzativa
                                                   ,:new.dal);
                  fetch cpk_anagrafe_unita_organizza
                     into dummy;
                  found := cpk_anagrafe_unita_organizza%found;
                  close cpk_anagrafe_unita_organizza;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.progr_unita_organizzativa || ' ' ||
                               :new.dal ||
                               '" gia'' presente in Anagrafe unita organizzative. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when mutating then
                  null; -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
      declare
         a_istruzione varchar2(2000);
         d_inserting  number := afc.to_number(inserting);
         d_updating   number := afc.to_number(updating);
         d_deleting   number := afc.to_number(deleting);
         d_nest_level integer := integritypackage.getnestlevel;
      begin
         --#634
         a_istruzione := 'begin Anagrafe_unita_organizzativa.chk_RI( ''' ||
                         nvl(:new.progr_unita_organizzativa
                            ,:old.progr_unita_organizzativa) || '''' || ', ' ||
                         afc.quote(:new.codice_uo) || ', ' || afc.quote(:new.descrizione) || ', ' ||
                         afc.quote(:new.des_abb) || ', ' ||
                         afc.quote(:new.amministrazione) || ', to_date( ''' ||
                         to_char(:old.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:new.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:old.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:new.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', ''' || :new.ottica || '''' || ', ' ||
                         afc.quote(:new.aggregatore) || '' || ', ''' || :new.rowid || '''' ||
                         ', ''' || to_char(d_inserting) || '''' || ', ''' ||
                         to_char(d_updating) || '''' || ', ''' || to_char(d_deleting) || '''' ||
                         ', ''' || to_char(d_nest_level) || '''' || ');' || 'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;
   begin
      -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional and
            anagrafe_unita_organizzativa.s_eliminazione_logica = 0
         --#703
          then
            -- Switched functional Integrity
            declare
               a_istruzione varchar2(2000);
               d_inserting  number := afc.to_number(inserting);
               d_updating   number := afc.to_number(updating);
               d_deleting   number := afc.to_number(deleting);
            begin
               a_istruzione := 'begin Anagrafe_unita_organizzativa.set_FI( ''' ||
                               :new.progr_unita_organizzativa || '''' || ', ''' ||
                               :old.progr_unita_organizzativa || '''' || ', to_date( ''' ||
                               to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', ''' || :new.ottica || '''' ||
                               ', ''' || :new.utente_ad4 || '''' || ', ''' ||
                               :new.id_suddivisione || '''' || ', ''' ||
                               :old.id_suddivisione || '''' || ', ''' ||
                               :new.revisione_istituzione || '''' || ', ''' ||
                               :new.progr_aoo || '''' || ', ''' || :old.progr_aoo || '''' || ', ' ||
                               afc.quote(:new.des_abb) || ', ' || afc.quote(:old.des_abb) || ', ' ||
                               afc.quote(:new.amministrazione) || ', ' ||
                               afc.quote(:new.utente_aggiornamento) || ', ''' ||
                               to_char(d_inserting) || '''' || ', ''' ||
                               to_char(d_updating) || '''' || ', ''' ||
                               to_char(d_deleting) || '''' || ');' || 'end;';
               integritypackage.set_postevent(a_istruzione, ' ');
            end;
         end if;
      end;
      -- #793 eventuale notifica mail ai gestori di GPs della modifica extrarevisione
      declare
         d_descr_uo            varchar2(200);
         d_name                varchar2(200);
         d_sender_email        varchar2(2000);
         d_recipient           varchar2(2000);
         d_subject             varchar2(2000);
         d_text_msg            varchar2(2000);
         d_next_date           date;
         d_job                 number;
         d_statement           varchar2(2000);
      begin
         if (inserting and nvl(:new.revisione_istituzione, -2) <> d_revisione_mod) or
            (deleting and d_revisione_mod = -1) or
            ((updating and nvl(:new.revisione_istituzione, -2) <> d_revisione_mod) and
            (:new.codice_uo <> :old.codice_uo or :new.descrizione <> :old.descrizione or
            nvl(:new.id_suddivisione, -1) <> nvl(:old.id_suddivisione, -1))) then
            if so4gp_pkg.is_int_gps and
               registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                             ,'IndirizziMailModificheUO'
                                             ,0) is not null then
               -- oggetto della modifica
               d_descr_uo := :new.codice_uo || ' : ' || :new.descrizione;
               -- compone il messaggio della mail
               d_name         := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                               ,'NomeMessaggioModificheUO'
                                                               ,0);
               d_sender_email := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                               ,'MittenteMessaggioModificheUO'
                                                               ,0);
               d_recipient    := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                               ,'IndirizziMailModificheUO'
                                                               ,0);
               d_subject      := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                               ,'TestoOggettoModificheUO'
                                                               ,0);
               d_text_msg     := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                               ,'TestoMessaggioModificheUO'
                                                               ,0);
               d_text_msg     := replace(d_text_msg, '<UO>', d_descr_uo);
               begin
                  select sysdate + (select (count(*) + 1) * 0.0001
                                      from user_jobs
                                     where what like '%so4_pkg.notifica_mail%'
                                       and broken = 'N')
                    into d_next_date
                    from dual;
                  d_job := job_utility.crea('declare d_segnalazione varchar2(2000);
                                          d_segnalazione_bloccante varchar2(2);
                                          begin
                                          aggiorna_relazioni_struttura(P_OTTICA => '''||:new.ottica||
                                          ''', p_revisione => null, p_revisione_modifica => null, p_aggiorna_dati => ''SI'', p_segnalazione_bloccante => d_segnalazione_bloccante,p_segnalazione => d_segnalazione);
                                          so4_pkg.notifica_mail(p_name =>''' ||
                                            d_name || ''',p_sender_email=>''' ||
                                            d_sender_email || ''',p_recipient=>''' ||
                                            d_recipient || ''',p_subject=>''' ||
                                            d_subject || ''',p_text_msg=>''' ||
                                            d_text_msg ||
                                            ''');exception when others then null;end;'
                                           ,d_next_date);
               exception
                  when no_data_found then
                     null;
               end;
            end if;
         end if;
      end;
      declare
         d_statement varchar2(32000);
         d_ni_as4    number := null;
         d_dett_nome varchar2(1000);
      begin
         if nvl(so4_pkg.get_integrazione_as4new, 'NO') = 'SI' then
         --#54239
           -- if amministrazione.get_ente(:new.amministrazione) = 'SI' then
               -- UNITA' DELL'ENTE DEVON CONCATENARE AMM:AOO:UO
               select ' (' || :new.amministrazione || ':' ||
                      (select codice_originale
                         from codici_ipa
                        where progressivo = :new.progr_aoo
                          and tipo_entita = 'AO') || ':' || d_codice_uo || ')'
                 into d_dett_nome
                 from dual;
            /*else
               begin
                  -- rev. 1
                  begin
                     select ' (' || codice_originale || '::' || d_codice_uo || ')'
                       into d_dett_nome
                       from codici_ipa
                           ,amministrazioni
                      where progressivo = ni
                        and tipo_entita = 'AM'
                        and codice_amministrazione = upper(trim(:new.amministrazione)); -- rev. 1 considero la maiuscola
                  exception
                     when no_data_found then
                        d_dett_nome := '(' || trim(:new.amministrazione) || '::' ||
                                       d_codice_uo || ')';
                     when others then
                        raise;
                  end;
               exception
                  when others then
                     raise_application_error(-20999
                                            ,' Errore in ricerca codice originale amministrazione (' ||
                                             upper(trim(:new.amministrazione)) || ')'
                                            ,true);
               end;
               -- rev. 1 fine
            end if;*/
            begin
               -- provo a recuperare comunque l'ni
               select ni
                 into d_ni_as4
                 from soggetti_unita
                where progr_unita_organizzativa = :new.progr_unita_organizzativa;
            exception
               when others then
                  d_ni_as4 := null;
            end;
            if inserting then
               if :new.ottica <> 'EXTRAISTITUZIONALE' then
                  --#54239
                  d_statement := 'begin so4as4_pkg.allinea_uo(:p_ni_as4,:p_progr_unita_organizzativa,:p_dal, :p_old_dal, :p_descrizione , :p_indirizzo, :p_provincia , :p_comune, :p_cap , :p_telefono, :p_fax, :p_utente_agg); end; ';
                  execute immediate d_statement
                     using in d_ni_as4, :new.progr_unita_organizzativa, :new.dal, :old.dal, substr(rtrim(:new.descrizione), 1, 240 - length(d_dett_nome)) || d_dett_nome, :new.indirizzo, :new.provincia, :new.comune, :new.cap, :new.telefono, :new.fax, :new.utente_aggiornamento;
               else
                  --#54239 inserimento in tabella per elaborazione differita
                  insert into work_allinea_uo_as4
                     (operazione
                     ,ni_as4
                     ,progr_unita_organizzativa
                     ,dal
                     ,old_dal
                     ,descrizione
                     ,indirizzo
                     ,provincia
                     ,comune
                     ,cap
                     ,telefono
                     ,fax
                     ,utente_agg)
                  values
                     ('I'
                     ,d_ni_as4
                     ,:new.progr_unita_organizzativa
                     ,:new.dal
                     ,:old.dal
                     ,substr(rtrim(:new.descrizione), 1, 240 - length(d_dett_nome)) ||
                      d_dett_nome
                     ,:new.indirizzo
                     ,:new.provincia
                     ,:new.comune
                     ,:new.cap
                     ,:new.telefono
                     ,:new.fax
                     ,:new.utente_aggiornamento);
               end if;
            elsif updating then
               -- aggiorno solo se ho modificato un dato significativo
               if (:new.dal != :old.dal) or (:new.descrizione != :old.descrizione) or
                  (nvl(:new.indirizzo
                      ,'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') !=
                  nvl(:old.indirizzo
                      ,'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')) or
                  (nvl(:new.provincia, -1) != nvl(:old.provincia, -1)) or
                  (nvl(:new.comune, -1) != nvl(:old.comune, -1)) or
                  (nvl(:new.cap, 'XXXXXX') != nvl(:old.cap, 'XXXXXX')) or
                  (nvl(:new.telefono, 'XXXXXXXXXXXXXXX') !=
                  nvl(:old.telefono, 'XXXXXXXXXXXXXXX')) or
                  (nvl(:new.fax, 'XXXXXXXXXXXXXXX') != nvl(:old.fax, 'XXXXXXXXXXXXXXX')) then
                  if :new.ottica <> 'EXTRAISTITUZIONALE' then
                     --#54239
                     d_statement := 'begin so4as4_pkg.allinea_uo(:p_ni_as4,:p_progr_unita_organizzativa,:p_dal, :p_old_dal, :p_descrizione , :p_indirizzo, :p_provincia , :p_comune, :p_cap , :p_telefono, :p_fax, :p_utente_agg); end; ';
                     execute immediate d_statement
                        using in d_ni_as4, :new.progr_unita_organizzativa, :new.dal, :old.dal, substr(rtrim(:new.descrizione), 1, 240 - length(d_dett_nome)) || d_dett_nome, :new.indirizzo, :new.provincia, :new.comune, :new.cap, :new.telefono, :new.fax, :new.utente_aggiornamento;
                  else
                     --#54239 inserimento in tabella per elaborazione differita
                     insert into work_allinea_uo_as4
                        (operazione
                        ,ni_as4
                        ,progr_unita_organizzativa
                        ,dal
                        ,old_dal
                        ,descrizione
                        ,indirizzo
                        ,provincia
                        ,comune
                        ,cap
                        ,telefono
                        ,fax
                        ,utente_agg)
                     values
                        ('U'
                        ,d_ni_as4
                        ,:new.progr_unita_organizzativa
                        ,:new.dal
                        ,:old.dal
                        ,substr(rtrim(:new.descrizione), 1, 240 - length(d_dett_nome)) ||
                         d_dett_nome
                        ,:new.indirizzo
                        ,:new.provincia
                        ,:new.comune
                        ,:new.cap
                        ,:new.telefono
                        ,:new.fax
                        ,:new.utente_aggiornamento);
                  end if;
               end if;
            end if;
         end if;
      exception
         when others then
            key_error_log_tpk.ins(p_error_id       => ''
                                 ,p_error_session  => userenv('sessionid')
                                 ,p_error_date     => trunc(sysdate)
                                 ,p_error_text     => 'Errore in allineamento su anagrafica centralizzata per Unità Organizzativa ' ||
                                                      :new.progr_unita_organizzativa ||
                                                      ', decorrenza ' ||
                                                      to_char(:new.dal, 'DD/MM/YYYY')
                                 ,p_error_user     => :new.utente_aggiornamento
                                 ,p_error_usertext => sqlerrm
                                 ,p_error_type     => 'E');
      end;
      if functionalnestlevel = 0 then
         integritypackage.nextnestlevel;
         begin
            -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */
            null;
         end;
         integritypackage.previousnestlevel;
      end if;
      integritypackage.nextnestlevel;
      begin
         -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */
         null;
      end;
      integritypackage.previousnestlevel;
   end;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/



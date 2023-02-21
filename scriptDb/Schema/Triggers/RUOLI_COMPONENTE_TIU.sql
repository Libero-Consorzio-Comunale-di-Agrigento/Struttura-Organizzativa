CREATE OR REPLACE TRIGGER ruoli_componente_tiu
/******************************************************************************
    NOME:        RUOLI_COMPONENTE_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table RUOLI_COMPONENTE
   ******************************************************************************/
   before insert or update or delete on ruoli_componente
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno                  integer;
   errmsg                 char(200);
   dummy                  integer;
   found                  boolean;
   d_data                 date;
   d_al                   date;
   d_oggi                 date := trunc(sysdate);
   d_ottica               componenti.ottica%type;
   d_revisione_cessazione componenti.revisione_cessazione%type;
   d_progr_uo             componenti.progr_unita_organizzativa%type := componente.get_progr_unita_organizzativa(nvl(:new.id_componente
                                                                                                                   ,:old.id_componente));
   d_unita_chiusa         integer := 0;
   d_new                  number(8) := :new.id_componente;
   d_old                  number(8) := :old.id_componente;
begin
   functionalnestlevel := integritypackage.getnestlevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __
   ***************************************************************************/
   begin
      -- Check / Set DATA Integrity
      --  Column "ID_RUOLO_COMPONENTE" uses sequence RUOLI_COMPONENTE_SQ
      if :new.id_ruolo_componente is null and not deleting then
         select ruoli_componente_sq.nextval into :new.id_ruolo_componente from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := d_oggi;
      end if;
      --
      -- Gestione delle date di pubblicazione per assegnazioni non relative a revisioni in modifica
      -- Se la revisione di assegnazione è nulla le date di pubblicazione vengono attivate immediatamente
      --
      -- verifica se assegnazione inserita/modificata è relativa ad una UO già chiusa
      if not deleting then
         begin
            select 1
              into d_unita_chiusa
              from dual
             where not exists
             (select 'x'
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = d_progr_uo
                       and nvl(al, to_date(3333333, 'j')) > trunc(sysdate));
         exception
            when no_data_found then
               null;
         end;
      end if;
      if :new.dal_pubb is null and inserting then
         -- determina la data di pubblicazione del componente del ruolo
         begin
            select nvl(dal_pubb, to_date(2222222, 'j'))
                  ,nvl(al_pubb, to_date(3333333, 'j'))
              into d_data
                  ,d_al
              from componenti
             where id_componente = :new.id_componente;
         end;
         --
         if d_unita_chiusa = 0 then
            :new.dal_pubb := greatest(d_oggi
                                     ,d_data
                                     ,nvl(:new.dal, to_date(2222222, 'j')));
            select decode(least(d_al, nvl(:new.al, to_date(3333333, 'j')))
                         ,to_date(3333333, 'j')
                         ,to_date(null)
                         ,least(d_al, nvl(:new.al, to_date(3333333, 'j'))))
              into :new.al_pubb
              from dual;
         else
            /* assegnazione relativa ad UO gia' chiusa */
            :new.dal_pubb := :new.dal;
            :new.al_pubb  := :new.al;
         end if;
      end if;
      --
      if updating then
         -- Si determinano ottica e revisione di cessazione del componente (bug 239: in presenza di revisione le date di pubblicazione venivano comunque valorizzate
         select ottica
               ,nvl(revisione_cessazione, -2)
           into d_ottica
               ,d_revisione_cessazione
           from componenti
          where id_componente = :new.id_componente;
         --
         if d_unita_chiusa = 0 then
            if nvl(revisione_struttura.s_attivazione, 0) = 0 and
               d_revisione_cessazione <> revisione_struttura.get_revisione_mod(d_ottica) then
               :new.dal_pubb := :old.dal_pubb;
               :new.al_pubb  := :old.al_pubb;
               if (nvl(:new.dal, to_date(2222222, 'j')) <>
                  nvl(:old.dal, to_date(2222222, 'j')) or
                  nvl(:new.al, to_date(3333333, 'j')) <>
                  nvl(:old.al, to_date(3333333, 'j'))) then
                  -- determina la data di pubblicazione del componente del ruolo
                  begin
                     select nvl(dal_pubb, to_date(2222222, 'j'))
                           ,nvl(al_pubb, to_date(3333333, 'j'))
                       into d_data
                           ,d_al
                       from componenti
                      where id_componente = :new.id_componente;
                  end;
                  --
                  if nvl(:old.dal, to_date(2222222, 'j')) <= d_oggi then
                     if nvl(:new.dal, to_date(2222222, 'j')) > d_oggi then
                        :new.dal_pubb := :old.dal_pubb;
                     end if;
                  else
                     if :new.dal > d_oggi then
                        :new.dal_pubb := least(:old.dal_pubb, greatest(:new.dal, d_data));
                     elsif :new.dal <= d_oggi then
                        :new.dal_pubb := least(:old.dal_pubb, greatest(d_oggi, d_data));
                     end if;
                  end if;
                  --
                  if nvl(:old.al, to_date(3333333, 'j')) <= d_oggi then
                     if nvl(:new.al, to_date(3333333, 'j')) > d_oggi then
                        select decode(least(d_al, nvl(:new.al, to_date(3333333, 'j')))
                                     ,to_date(3333333, 'j')
                                     ,to_date(null)
                                     ,least(d_al, nvl(:new.al, to_date(3333333, 'j'))))
                          into :new.al_pubb
                          from dual;
                     end if;
                  else
                     if nvl(:new.al, to_date(3333333, 'j')) > d_oggi then
                        select decode(least(d_al, nvl(:new.al, to_date(3333333, 'j')))
                                     ,to_date(3333333, 'j')
                                     ,to_date(null)
                                     ,least(d_al, nvl(:new.al, to_date(3333333, 'j'))))
                          into :new.al_pubb
                          from dual;
                     else
                        select decode(least(d_al, d_oggi)
                                     ,to_date(3333333, 'j')
                                     ,to_date(null)
                                     ,least(d_al, d_oggi))
                          into :new.al_pubb
                          from dual;
                     end if;
                  end if;
               end if;
            else
               --#548
               :new.dal_pubb := so4_pkg.dal_pubblicazione('U'
                                                         ,'R'
                                                         ,:old.dal_pubb
                                                         ,:new.dal
                                                         ,:old.dal
                                                         ,'');
               if :new.al <= d_oggi and :new.al_pubb >= d_oggi then --#55960
                  :new.al_pubb := so4_pkg.al_pubblicazione('U'
                                                          ,'R'
                                                          ,:old.al_pubb
                                                          ,:new.al_pubb
                                                          ,:old.al
                                                          ,'');
               else
                  :new.al_pubb := so4_pkg.al_pubblicazione('U'
                                                          ,'R'
                                                          ,:old.al_pubb
                                                          ,:new.al
                                                          ,:old.al
                                                          ,'');
               end if;
            end if;
         else
            /* assegnazione relativa ad UO già chiusa */
            :new.dal_pubb := :new.dal;
            :new.al_pubb  := :new.al;
         end if;
      end if;
      /* Impedisce eliminazione di ruoli pregressi potenzialmente già utilizzati */
      if deleting and nvl(:old.al, to_date(3333333, 'j')) <= d_oggi and
         componente.exists_id(:old.id_componente) = 1 and
         ruolo_componente.s_gestione_profili = 0 /* #762 */
       then
         errno  := -20008;
         errmsg := 'Ruolo non piu'' valido. Non eliminabile';
         raise integrity_error;
      end if;
      --Impedisce la modifica del codice del ruolo #472
      if updating and :old.ruolo <> :new.ruolo and :old.dal <= d_oggi then
         errno  := -20012;
         errmsg := 'Codice Ruolo non modificabile. Eliminare e reinserire';
         raise integrity_error;
      end if;
      --Impedisce la modifica di ruoli derivati da profili #430
      if updating and
         ruolo_componente.get_id_profilo_origine(:new.id_ruolo_componente) <> -1 and
         ruolo_componente.s_gestione_profili = 0 and componente.s_origine_gp <> 1 --#804
       then
         errno  := -20009;
         errmsg := 'Ruolo derivato da Profilo. Non modificabile';
         raise integrity_error;
      end if;
      /* Impedisce eliminazione di ruoli derivati da profili #430 */
      if deleting and
         ruolo_componente.get_id_profilo_origine(:old.id_ruolo_componente) <> -1 and
         ruolo_componente.s_gestione_profili = 0 then
         errno  := -20010;
         errmsg := 'Ruolo derivato da Profilo. Non eliminabile';
         raise integrity_error;
      end if;
      /* Impedisce eliminazione di ruoli che determinano un profilo #430 */
      if deleting and
         ruolo_componente.is_profilo(:old.ruolo, nvl(:old.al, to_date(3333333, 'j'))) and
         ruolo_componente.s_gestione_profili = 0 then
         errno  := -20011;
         errmsg := 'Ruolo che identifica Profilo. Non eliminabile';
         raise integrity_error;
      end if;
      --Impedisce la modifica di ruoli automatici #634
      if updating and
         ruolo_componente.get_id_relazione_origine(:new.id_ruolo_componente) <> -1 and
         revisione_struttura.s_attivazione <> 1 and --#764
         ruolo_componente.s_ruoli_automatici = 0 then
         errno  := -20014;
         errmsg := 'Ruolo attribuito automaticamente. Non modificabile';
         raise integrity_error;
      end if;
      /* Impedisce eliminazione di ruoli automatici #634 */
      if deleting and
         ruolo_componente.get_id_relazione_origine(:old.id_ruolo_componente) <> -1 and
         revisione_struttura.s_attivazione <> 1 and --#764
         ruolo_componente.s_ruoli_automatici = 0 then
         errno  := -20013;
         errmsg := 'Ruolo attribuito automaticamente. Non eliminabile';
         raise integrity_error;
      end if;
   end;
   if not deleting and revisione_struttura.s_attivazione <> 1 --#764
    then
      begin
         ruolo_componente.chk_di(:new.dal, :new.al);
      end;
   end if;
   begin
      -- Check FUNCTIONAL Integrity
      -- Verifica la completezza degli attributi del ruolo #430
      if inserting and
         nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'ProfiliPerProgetto', '')
            ,'NO') = 'SI' and
         ruolo_componente.is_profilo(:new.ruolo, nvl(:new.al, to_date(3333333, 'j'))) and
         not ruolo_componente.is_ruolo_progetto(:new.ruolo) and
         ruolo_componente.s_gestione_profili = 0 then
         errno  := -20012;
         errmsg := 'Profilo non correlato ad un Progetto/Modulo. Non attribuibile';
         raise integrity_error;
      end if;
      begin
         -- Check UNIQUE Integrity on PK of "RUOLI_COMPONENTE"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_ruoli_componente(var_id_ruolo_componente number) is
                  select 1
                    from ruoli_componente
                   where id_ruolo_componente = var_id_ruolo_componente;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_ruolo_componente is not null then
                  open cpk_ruoli_componente(:new.id_ruolo_componente);
                  fetch cpk_ruoli_componente
                     into dummy;
                  found := cpk_ruoli_componente%found;
                  close cpk_ruoli_componente;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_ruolo_componente ||
                               '" gia'' presente in Ruoli componente. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when mutating then
                  null; -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      declare
         d_inserting  number := afc.to_number(inserting);
         d_updating   number := afc.to_number(updating);
         d_deleting   number := afc.to_number(deleting);
         a_istruzione varchar2(2000);
      begin
         a_istruzione := 'begin ruolo_componente.chk_RI( ''' || :new.id_ruolo_componente || '''' ||
                         ', ''' || nvl(:new.id_componente, :old.id_componente) || '''' ||
                         ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', ''' || :new.ruolo || '''' || ');' || 'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;
   declare
      d_inserting  number := afc.to_number(inserting);
      d_updating   number := afc.to_number(updating);
      d_deleting   number := afc.to_number(deleting);
      a_istruzione varchar2(2000);
   begin
      -- Set FUNCTIONAL Integrity
      if integritypackage.functional then
         a_istruzione := 'begin ruolo_componente.set_FI( ''' ||
                         nvl(:new.id_ruolo_componente, :old.id_ruolo_componente) || '''' ||
                         ', ''' || nvl(:new.id_componente, :old.id_componente) || '''' ||
                         ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', ''' || nvl(:new.ruolo, :old.ruolo) || '''' || ', to_date( ''' ||
                         to_char(:new.dal_pubb, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:new.al_pubb, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.data_aggiornamento, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', ''' || :new.utente_aggiornamento || '''' ||
                         ', ''' || to_char(d_inserting) || '''' || ', ''' ||
                         to_char(d_updating) || '''' || ', ''' || to_char(d_deleting) || '''' || ');' ||
                         'end;';
         --dbms_output.put_line(a_istruzione);
         integritypackage.set_postevent(a_istruzione, ' ');
      end if;
      integritypackage.nextnestlevel;
      begin
         -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */
         null;
      end;
      integritypackage.previousnestlevel;
   end;
   begin
      -- Set FUNCTIONAL Integrity
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
   declare
      d_jobno  number;
      d_utente varchar2(8);
   begin
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'Rigenera Struttura', 0)
            ,'NO') = 'SI' then
         d_utente := nvl(so4_util.comp_get_utente(componente.get_ni(nvl(:new.id_componente
                                                                       ,:old.id_componente)))
                        ,'%'); /* se non riesco a determinare utente rigenero per tutti */
         if d_utente is not null and revisione_struttura.s_attivazione <> 1 and
            nvl(:new.dal_pubb, :old.dal_pubb) is not null then
            /*begin --precedente chiamata alla rigenera_so
               select max(job)
                 into d_jobno
                 from user_jobs
                where upper(what) like
                      'BEGIN AD4_UTENTE.RIGENERA_SO(''' || d_utente || '''); END;'
                  and broken = 'N'
                  and schema_user = user
                  and priv_user = user
                  and log_user = user
                  and nvl(total_time, 0) = 0; -- considero solo i job non ancora in esecuzione
            end;
            if d_jobno is null then
               -- esiste una richiesta di elaborazione per lo stesso utente
               dbms_job.submit(d_jobno
                              ,'BEGIN AD4_UTENTE.RIGENERA_SO(''' || d_utente ||
                               '''); END;'
                              ,sysdate + 1 / 5760);
            end if;*/
            -- Feature #45341 modificata la chiamata all'oggetto di AD4
            ad4_schedula_rigenera_so(d_utente);
         end if;
      end if;
   exception
      when others then
         null;
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



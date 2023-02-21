CREATE OR REPLACE TRIGGER componenti_tiu
/******************************************************************************
    NOME:        COMPONENTI_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table COMPONENTI
   ******************************************************************************/
   before insert or update or delete on componenti
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno           integer;
   errmsg          char(200);
   dummy           integer;
   found           boolean;
   d_data          date;
   d_al            date;
   d_oggi          date := trunc(sysdate);
   d_unita_chiusa  integer := 0;
   d_al_anuo       date; --#38333
   d_revisione_mod revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(nvl(:new.ottica
                                                                                                  ,:old.ottica));
begin
   functionalnestlevel := integritypackage.getnestlevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore  Descrizione
    ---- ---------- ------- ---------------------------------------------------
    0    11/01/2016 MMONARI #672
   ***************************************************************************/
   begin
      -- Check / Set DATA Integrity
      --  Column "ID_COMPONENTE" uses sequence COMPONENTI_SQ
      if :new.id_componente is null and not deleting then
         select componenti_sq.nextval into :new.id_componente from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := d_oggi;
      end if;
      --
      -- Previene le modifiche ai record gia' chiusi nella revisione in modifica Bug #138
      --
      if updating and nvl(revisione_struttura.s_attivazione, 0) = 0 and
         nvl(:new.revisione_cessazione, -2) = d_revisione_mod and
         nvl(:old.revisione_cessazione, -2) = d_revisione_mod then
         errno  := -20008;
         errmsg := 'ID Componente : "' || :new.id_componente ||
                   '" gia'' eliminata nella revisione in modifica. La registrazione  non puo'' essere modificata.';
         raise integrity_error;
      end if;
      --
      -- Gestione delle date di pubblicazione per assegnazioni non relative a revisioni in modifica
      -- Se la revisione di assegnazione è nulla le date di pubblicazione vengono attivate immediatamente
      --
      begin
         -- verifica se l'assegnazione inserita/modificata è relativa ad una UO gia' chiusa
         if not deleting then
            begin
               select 1
                 into d_unita_chiusa
                 from dual
                where not exists
                (select 'x'
                         from anagrafe_unita_organizzative
                        where progr_unita_organizzativa = :new.progr_unita_organizzativa
                          and nvl(al, to_date(3333333, 'j')) > trunc(sysdate));
               --#38333
               select max(al)
                 into d_al_anuo
                 from vista_pubb_anuo
                where progr_unita_organizzativa = :new.progr_unita_organizzativa;
            exception
               when no_data_found then
                  null;
            end;
         end if;
         if :new.revisione_assegnazione is null and :new.dal_pubb is null and inserting then
            -- determina la data di pubblicazione dell'unita_organizzativa di assegnazione dai periodi
            -- che intersencano gli estremi del nuovo componente
            begin
               --#672
               -- dal_pubb
               select nvl(dal_pubb, to_date(2222222, 'j'))
                 into d_data
                 from unita_organizzative u
                where progr_unita_organizzativa = :new.progr_unita_organizzativa
                  and nvl(u.revisione, -2) != d_revisione_mod
                  and nvl(u.dal, to_date(2222222, 'j')) <=
                      nvl(u.al, to_date(3333333, 'j'))
                  and nvl(:new.dal, to_date(2222222, 'j')) between
                      nvl(u.dal, to_date(2222222, 'j')) and
                      nvl(decode(u.revisione_cessazione
                                ,d_revisione_mod
                                ,to_date(null)
                                ,u.al)
                         ,to_date(3333333, 'j'))
                  and ottica = :new.ottica;
               -- al_pubb 
               select nvl(al_pubb, to_date(3333333, 'j'))
                 into d_al
                 from unita_organizzative u
                where progr_unita_organizzativa = :new.progr_unita_organizzativa
                  and nvl(u.revisione, -2) != d_revisione_mod
                  and nvl(u.dal, to_date(2222222, 'j')) <=
                      nvl(u.al, to_date(3333333, 'j'))
                  and nvl(:new.al, to_date(3333333, 'j')) between
                      nvl(u.dal, to_date(2222222, 'j')) and
                      nvl(decode(u.revisione_cessazione
                                ,d_revisione_mod
                                ,to_date(null)
                                ,u.al)
                         ,to_date(3333333, 'j'))
                  and ottica = :new.ottica;
            exception
               when no_data_found then
                  begin
                     select nvl(dal_pubb, to_date(2222222, 'j'))
                           ,nvl(al_pubb, to_date(3333333, 'j'))
                       into d_data
                           ,d_al
                       from anagrafe_unita_organizzative a
                      where progr_unita_organizzativa = :new.progr_unita_organizzativa
                        and ottica = :new.ottica
                        and nvl(revisione_istituzione, -2) <> d_revisione_mod --#493
                        and dal = (select max(dal)
                                     from anagrafe_unita_organizzative a1
                                    where progr_unita_organizzativa =
                                          :new.progr_unita_organizzativa
                                      and (a1.revisione_istituzione != d_revisione_mod or
                                          a1.revisione_istituzione is null)
                                      and nvl(:new.dal, to_date(2222222, 'j')) <=
                                          nvl(decode(a1.revisione_cessazione
                                                    ,d_revisione_mod
                                                    ,to_date(null)
                                                    ,a1.al)
                                             ,to_date(3333333, 'j'))
                                      and nvl(:new.al, to_date(3333333, 'j')) >=
                                          nvl(a1.dal, to_date(2222222, 'j'))
                                      and a1.ottica = :new.ottica);
                  exception
                     when no_data_found then
                        errno  := -20008;
                        errmsg := 'Unita'' Organizzativa non prevista nella struttura dell''ottica, per il periodo indicato';
                        raise integrity_error;
                  end;
            end;
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
               -- se l'assegnazione e' relativa ad una UO gia' chiusa, le date di pubblicazione coincidono con le date di validita'
               :new.dal_pubb := :new.dal;
               :new.al_pubb  := d_al_anuo; --#38333
            end if;
         end if;
         --
         if updating then
            if ((      nvl(nvl(:new.revisione_assegnazione, :old.revisione_assegnazione), -2) <> d_revisione_mod and
               nvl(nvl(:new.revisione_cessazione, :old.revisione_cessazione), -2) <>
               d_revisione_mod) or (:new.revisione_assegnazione is null and
               :old.revisione_assegnazione is not null)
               --#55855
               or
               (:old.dal_pubb is not null and :new.dal_pubb is null and
                :old.revisione_cessazione is null and :new.revisione_cessazione is not null
               )
               or
               (:old.dal_pubb is not null and :new.dal_pubb is null and
                :old.revisione_cessazione is not null and :new.revisione_cessazione is  null
               )
               ) then
               if nvl(revisione_struttura.s_attivazione, 0) = 0 then
                  :new.dal_pubb := :old.dal_pubb;
                  :new.al_pubb  := :old.al_pubb;
                  if ((:new.revisione_assegnazione is null and
                     (nvl(:new.dal, to_date(2222222, 'j')) <>
                     nvl(:old.dal, to_date(2222222, 'j')))) or
                     (:new.revisione_cessazione is null and
                     nvl(:new.al, to_date(3333333, 'j')) <>
                     nvl(:old.al, to_date(3333333, 'j'))) or
                     (:new.revisione_assegnazione is null and
                     :old.revisione_assegnazione is not null) or
                     (:new.revisione_cessazione is null and
                     :old.revisione_cessazione is not null)) then
                     -- determina la data di pubblicazione dell'unita_organizzativa di assegnazione
                     begin
                        select nvl(dal_pubb, to_date(2222222, 'j'))
                              ,nvl(al_pubb, to_date(3333333, 'j'))
                          into d_data
                              ,d_al
                          from unita_organizzative u
                         where progr_unita_organizzativa = :new.progr_unita_organizzativa
                           and dal < nvl(al, to_date(3333333, 'j'))
                           and revisione <> d_revisione_mod --#493
                           and nvl(al, to_date(3333333, 'j')) =
                               (select max(nvl(al, to_date(3333333, 'j')))
                                  from unita_organizzative
                                 where progr_unita_organizzativa =
                                       u.progr_unita_organizzativa
                                   and ottica = u.ottica
                                   and revisione <> d_revisione_mod --#493
                                   and (nvl(:new.al, to_date(2222222, 'j')) between dal and
                                       nvl(al, to_date(3333333, 'j')) or
                                       trunc(sysdate) between dal and
                                       nvl(al, to_date(3333333, 'j'))))
                           and ottica = :new.ottica;
                     exception
                        when no_data_found then
                           begin
                              select nvl(dal_pubb, to_date(2222222, 'j'))
                                    ,nvl(al_pubb, to_date(3333333, 'j'))
                                into d_data
                                    ,d_al
                                from anagrafe_unita_organizzative a
                               where progr_unita_organizzativa =
                                     :new.progr_unita_organizzativa
                                 and ottica = :new.ottica
                                 and nvl(revisione_istituzione, d_revisione_mod) <>
                                     d_revisione_mod --#493
                                 and dal =
                                     (select max(dal)
                                        from anagrafe_unita_organizzative
                                       where progr_unita_organizzativa =
                                             :new.progr_unita_organizzativa
                                         and revisione_istituzione <> d_revisione_mod --#493
                                         and ottica = :new.ottica);
                           exception
                              when no_data_found then
                                 errno  := -20008;
                                 errmsg := 'Unita'' Organizzativa non prevista nella struttura dell''ottica indicata';
                                 raise integrity_error;
                           end;
                     end;
                     -- se l'unita' organizzativa è ancora valida ad oggi, la data di pubblicazione presunta sara' oggi
                     if d_unita_chiusa = 0 then
                        -- UO valida a tutt'oggi
                        if nvl(:old.dal, to_date(2222222, 'j')) <= d_oggi then
                           if nvl(:new.dal, to_date(2222222, 'j')) > d_oggi then
                              :new.dal_pubb := :new.dal;
                           else
                              -- issue 413
                              :new.dal_pubb := least(nvl(:old.dal_pubb
                                                        ,to_date(3333333, 'j'))
                                                    ,greatest(d_oggi, d_data));
                           end if;
                        else
                           if :new.dal > d_oggi then
                              :new.dal_pubb := least(nvl(:old.dal_pubb
                                                        ,to_date(3333333, 'j'))
                                                    ,greatest(:new.dal, d_data));
                           elsif :new.dal <= d_oggi then
                              :new.dal_pubb := least(nvl(:old.dal_pubb
                                                        ,to_date(3333333, 'j'))
                                                    ,greatest(d_oggi, d_data));
                           end if;
                        end if;
                        --
                        if nvl(:old.al, to_date(3333333, 'j')) <= d_oggi then
                           if nvl(:new.al, to_date(3333333, 'j')) > d_oggi then
                              select decode(least(d_al
                                                 ,nvl(:new.al, to_date(3333333, 'j')))
                                           ,to_date(3333333, 'j')
                                           ,to_date(null)
                                           ,least(d_al
                                                 ,nvl(:new.al, to_date(3333333, 'j'))))
                                into :new.al_pubb
                                from dual;
                           end if;
                        else
                           if nvl(:new.al, to_date(3333333, 'j')) > d_oggi then
                              select decode(least(d_al
                                                 ,nvl(:new.al, to_date(3333333, 'j')))
                                           ,to_date(3333333, 'j')
                                           ,to_date(null)
                                           ,least(d_al
                                                 ,nvl(:new.al, to_date(3333333, 'j'))))
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
                     else
                        -- se l'assegnazione e' relativa ad una UO gia' chiusa, le date di pubblicazione coincidono con le date di validita'
                        :new.dal_pubb := :new.dal;
                        :new.al_pubb  := d_al_anuo; --#38333
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end;
   end;
   if not deleting then
      begin
         componente.chk_di(:new.dal
                          ,:new.al
                          ,:new.ottica
                          ,:new.revisione_assegnazione
                          ,:new.revisione_cessazione);
      end;
   end if;
   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "COMPONENTI"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_componenti(var_id_componente number) is
                  select 1 from componenti where id_componente = var_id_componente;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_componente is not null then
                  open cpk_componenti(:new.id_componente);
                  fetch cpk_componenti
                     into dummy;
                  found := cpk_componenti%found;
                  close cpk_componenti;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_componente ||
                               '" gia'' presente in Componenti. La registrazione  non puo'' essere inserita.';
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
      begin
         a_istruzione := 'begin componente.chk_RI( ''' ||
                         nvl(:new.id_componente, :old.id_componente) || '''' || ', ''' ||
                         nvl(:new.ottica, :old.ottica) || '''' || ', ''' ||
                         nvl(:new.ni, :old.ni) || '''' || ', ''' || nvl(:new.ci, :old.ci) || '''' || ', ' ||
                         afc.quote(nvl(:new.denominazione, :old.denominazione)) || ', ''' ||
                         :old.progr_unita_organizzativa || '''' || ', ''' ||
                         :new.progr_unita_organizzativa || '''' || ', to_date( ''' ||
                         to_char(:old.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:new.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:old.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:new.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', ''' || :old.revisione_cessazione || '''' ||
                         ', ''' || :new.revisione_cessazione || '''' || ', ''' ||
                         :new.utente_aggiornamento || '''' || ', ''' ||
                         nvl(:new.rowid, :old.rowid) || '''' || ', ''' ||
                         to_char(d_inserting) || '''' || ', ''' || to_char(d_updating) || '''' ||
                         ', ''' || to_char(d_deleting) || '''' || ');' || 'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;
   begin
      -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional then
            -- Switched functional Integrity
            declare
               a_istruzione varchar2(2000);
               d_inserting  number := afc.to_number(inserting);
               d_updating   number := afc.to_number(updating);
               d_deleting   number := afc.to_number(deleting);
            begin
               a_istruzione := 'begin componente.set_FI( ''' ||
                               nvl(:new.id_componente, :old.id_componente) || '''' ||
                               ', ''' || :new.ottica || '''' || ', ''' || :old.ottica || '''' ||
                               ', ''' || :old.revisione_assegnazione || '''' || ', ''' ||
                               :new.revisione_assegnazione || '''' || ', ''' ||
                               :old.revisione_cessazione || '''' || ', ''' ||
                               :new.revisione_cessazione || '''' || ', ''' ||
                               nvl(:new.ni, :old.ni) || '''' || ', ''' ||
                               nvl(:new.ci, :old.ci) || '''' || ', ''' ||
                               :new.progr_unita_organizzativa || '''' || ', ''' ||
                               :old.progr_unita_organizzativa || '''' || ', ' ||
                               afc.quote(nvl(:new.denominazione, :old.denominazione)) ||
                               ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:old.dal_pubb, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.dal_pubb, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:old.al_pubb, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.al_pubb, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:old.al_prec, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.al_prec, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.data_aggiornamento, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', ''' ||
                               :new.utente_aggiornamento || '''' || ', ''' ||
                               to_char(d_inserting) || '''' || ', ''' ||
                               to_char(d_updating) || '''' || ', ''' ||
                               to_char(d_deleting) || '''' || ');' || 'end;';
               integritypackage.set_postevent(a_istruzione, ' ');
            end;
         end if;
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
   -- Feature #45341 modificata la chiamata all'oggetto di AD4
   declare
      d_utente varchar2(8);
   begin
      if ((updating and :new.progr_unita_organizzativa <> :old.progr_unita_organizzativa) or
         inserting or deleting) and
         nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'Rigenera Struttura', 0)
            ,'NO') = 'SI' then
         d_utente := nvl(so4_util.comp_get_utente(nvl(:new.ni, :old.ni)), '%'); /* se non riesco a determinare utente rigenero per tutti */
         if d_utente is not null and revisione_struttura.s_attivazione <> 1 and
            nvl(:new.dal_pubb, :old.dal_pubb) is not null then
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



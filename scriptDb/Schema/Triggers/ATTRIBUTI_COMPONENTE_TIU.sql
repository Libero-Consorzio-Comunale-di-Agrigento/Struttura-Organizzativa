CREATE OR REPLACE TRIGGER attributi_componente_tiu
/******************************************************************************
    NOME:        ATTRIBUTI_COMPONENTE_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table ATTRIBUTI_COMPONENTE
   ******************************************************************************/
   before insert or update or delete on attributi_componente
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
   d_progr_uo      componenti.progr_unita_organizzativa%type := componente.get_progr_unita_organizzativa(nvl(:new.id_componente
                                                                                                            ,:old.id_componente));
   d_unita_chiusa  integer := 0;
   d_revisione_mod revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(:new.ottica);
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
      --  Column "ID_ATTR_COMPONENTE" uses sequence ATTR_COMP_SQ
      if :new.id_attr_componente is null and not deleting then
         select attr_comp_sq.nextval into :new.id_attr_componente from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := d_oggi;
      end if;
      if :new.assegnazione_prevalente = 1 and not deleting then
         if :new.tipo_assegnazione is null then
            :new.tipo_assegnazione := 'I';
         end if;
      end if;
      --#631
      if nvl(:new.revisione_assegnazione, -2) = d_revisione_mod and not deleting then
         if :new.dal is not null then
            :new.dal := to_date(null);
         end if;
      end if;
      --
      -- Gestione delle date di pubblicazione per assegnazioni non relative a revisioni in modifica
      -- Se la revisione di assegnazione è nulla le date di pubblicazione vengono attivate immediatamente
      --
      if (nvl(revisione_struttura.s_attivazione, 0) = 0 and
         nvl(:new.revisione_assegnazione, -2) <> d_revisione_mod /* #631 */
         ) or (revisione_struttura.s_attivazione = 1 and
         revisione_struttura.s_revisione_in_attivazione = :new.revisione_cessazione and
         revisione_struttura.s_ottica_in_attivazione = :new.ottica) then
         /* verifica se l'assegnazione inserita/modificata ¿ relativa ad una UO gia' chiusa */
         --#38333
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
         -- determina la data di pubblicazione del componente dell'attributo
         if not deleting then --#42731
         begin
            select nvl(dal_pubb, to_date(2222222, 'j'))
                  ,nvl(al_pubb, to_date(3333333, 'j'))
              into d_data
                  ,d_al
              from componenti
                where id_componente = nvl(:new.id_componente, :old.id_componente);
         end;
         end if;
         --#38333
         if :new.dal_pubb is null and inserting then
            :new.dal_pubb := greatest(d_oggi
                                     ,d_data
                                     ,nvl(:new.dal, to_date(2222222, 'j')));
            select decode(least(d_al, nvl(:new.al, to_date(3333333, 'j')))
                         ,to_date(3333333, 'j')
                         ,to_date(null)
                         ,least(d_al, nvl(:new.al, to_date(3333333, 'j'))))
              into :new.al_pubb
              from dual;
         elsif d_unita_chiusa = 1 and inserting then
            --#38333
            :new.al_pubb := d_al;
         end if;
         --
         if updating then
            -- verifica se l'assegnazione inserita/modificata è relativa ad una UO gia' chiusa
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
            -- forziamo l'old perchè la attributo_componente.upd la sovrascrive erroneamente
            if nvl(revisione_struttura.s_attivazione, 0) = 0 and
              --#36269
               not (:old.revisione_assegnazione is not null and
                    :new.revisione_assegnazione is null) then
               :new.dal_pubb := :old.dal_pubb;
               :new.al_pubb  := :old.al_pubb;
            end if;
            if d_unita_chiusa = 0 then
               if (nvl(:new.dal, to_date(2222222, 'j')) <>
                  nvl(:old.dal, to_date(2222222, 'j')) or
                  nvl(:new.al, to_date(3333333, 'j')) <>
                  nvl(:old.al, to_date(3333333, 'j'))) or
                  (revisione_struttura.s_attivazione = 1 and revisione_struttura.s_revisione_in_attivazione =
                  :new.revisione_cessazione and
                  revisione_struttura.s_ottica_in_attivazione = :new.ottica) then
                  /* determina la data di pubblicazione del componente del'attributo */
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
                        :new.dal_pubb := :new.dal;
                     end if;
                  else
                     if :new.dal > d_oggi then
                        :new.dal_pubb := least(:old.dal_pubb, greatest(:new.dal, d_data));
                     elsif :new.dal <= d_oggi then
                        :new.dal_pubb := least(:old.dal_pubb, greatest(d_oggi, d_data));
                     end if;
                  end if;
                  --
                  if revisione_struttura.s_attivazione = 0 then
                     if nvl(:old.al, to_date(3333333, 'j')) <= d_oggi then
                        if nvl(:new.al, to_date(3333333, 'j')) > d_oggi then
                           select decode(least(d_al, nvl(:new.al, to_date(3333333, 'j')))
                                        ,to_date(3333333, 'j')
                                        ,to_date(null)
                                        ,least(d_al, nvl(:new.al, to_date(3333333, 'j'))))
                             into :new.al_pubb
                             from dual;
                        else
                           :new.al_pubb := :old.al_pubb;
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
                  if (revisione_struttura.s_attivazione = 1 and revisione_struttura.s_revisione_in_attivazione =
                     :new.revisione_cessazione and
                     revisione_struttura.s_ottica_in_attivazione = :new.ottica) then
                     select revisione_struttura.s_data_pubb_in_attivazione - 1
                       into :new.al_pubb
                       from dual;
                  end if;
               end if;
            else
               /* assegnazione relativa ad UO gia' chiusa */
               :new.dal_pubb := :new.dal;
               :new.al_pubb  := d_al; --#38333
               --  :new.al_pubb  := :new.al;
            end if;
         end if;
      end if;
   end;
   if not deleting then
      begin
         attributo_componente.chk_di(:new.dal
                                    ,:new.al
                                    ,:new.ottica
                                    ,:new.assegnazione_prevalente
                                    ,:new.tipo_assegnazione
                                    ,:new.revisione_assegnazione
                                    ,:new.revisione_cessazione);
      end;
   end if;
   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "ATTRIBUTI_COMPONENTE"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_attributi_componente(var_id_attr_componente number) is
                  select 1
                    from attributi_componente
                   where id_attr_componente = var_id_attr_componente;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_attr_componente is not null then
                  open cpk_attributi_componente(:new.id_attr_componente);
                  fetch cpk_attributi_componente
                     into dummy;
                  found := cpk_attributi_componente%found;
                  close cpk_attributi_componente;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_attr_componente ||
                               '" gia'' presente in Attributi componente. La registrazione  non puo'' essere inserita.';
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
         a_istruzione varchar2(2000);
         d_inserting  number := afc.to_number(inserting);
         d_updating   number := afc.to_number(updating);
         d_deleting   number := afc.to_number(deleting);
         d_livello    number := integritypackage.getnestlevel;
      begin
         a_istruzione := 'begin attributo_componente.chk_RI(''' ||
                         nvl(:new.id_componente, :old.id_componente) || '''' ||
                         ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', ''' || nvl(:new.rowid, :old.rowid) || '''' || ', ''' ||
                         to_char(d_inserting) || '''' || ', ''' || to_char(d_updating) || '''' ||
                         ', ''' || to_char(d_deleting) || '''' || ', ''' ||
                         to_char(nvl(nvl(:new.assegnazione_prevalente
                                        ,:old.assegnazione_prevalente)
                                    ,0)) || '''' || ', ''' ||
                         to_char(nvl(:old.assegnazione_prevalente, 0)) || '''' || ', ''' ||
                         to_char(nvl(nvl(:new.id_attr_componente, :old.id_attr_componente)
                                    ,0)) || '''' || ', ''' ||
                         nvl(nvl(:new.tipo_assegnazione, :old.tipo_assegnazione), 'x') || '''' ||
                         ', ''' || nvl(nvl(:new.ottica, :old.ottica), 'x') || '''' ||
                         ', ''' || :new.revisione_assegnazione || ''', ''' ||
                         :old.revisione_assegnazione || ''', ' || d_livello || '' || ');' ||
                         'end;';
--         dbms_output.put_line(a_istruzione);
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
               a_istruzione := 'begin attributo_componente.set_FI( ''' ||
                               nvl(:new.id_componente, :old.id_componente) || '''' ||
                               ', ''' || nvl(:new.revisione_assegnazione
                                            ,:old.revisione_assegnazione) || '''' ||
                               ', ''' || :old.revisione_assegnazione || '''' || ', ''' ||
                               :new.revisione_cessazione || '''' || ', ''' ||
                               :old.revisione_cessazione || '''' || ', to_date( ''' ||
                               to_char(:old.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:new.dal, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:old.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:new.al, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', ''' ||
                               nvl(:new.tipo_assegnazione, 'I') || '''' || ', ''' ||
                               to_char(:new.assegnazione_prevalente) || '''' || ', ''' ||
                               to_char(:old.incarico) || '''' || ', ''' || --#634
                               to_char(:new.incarico) || '''' || ', ''' ||
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
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/



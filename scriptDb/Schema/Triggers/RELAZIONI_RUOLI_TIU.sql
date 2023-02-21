CREATE OR REPLACE TRIGGER relazioni_ruoli_tiu
/******************************************************************************
    NOME:        relazioni_ruoli_TIU #634
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table relazioni_ruoli
   ******************************************************************************/
   before insert or update or delete on relazioni_ruoli
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno        integer;
   errmsg       char(200);
   dummy        integer;
   found        boolean;
   d_inserting  number := afc.to_number(inserting);
   d_updating   number := afc.to_number(updating);
   d_deleting   number := afc.to_number(deleting);
   a_istruzione varchar2(2000);
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
      --  Column "ID_SUDDIVISIONE" uses sequence relazioni_ruoli_SQ
      if :new.id_relazione is null and not deleting then
         select relazioni_ruoli_sq.nextval into :new.id_relazione from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
   end;
   --verifica se la modifica determina una eliminazione logica della regola
   if updating and :new.data_eliminazione is not null and :old.data_eliminazione is null then
      d_deleting := 1;
      d_updating := 0;
   end if;
   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "relazioni_ruoli"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_relazioni_ruoli(var_id_relazione number) is
                  select 1 from relazioni_ruoli where id_relazione = var_id_relazione;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_relazione is not null then
                  open cpk_relazioni_ruoli(:new.id_relazione);
                  fetch cpk_relazioni_ruoli
                     into dummy;
                  found := cpk_relazioni_ruoli%found;
                  close cpk_relazioni_ruoli;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_relazione ||
                               '" gia'' presente in Relazioni Ruoli. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when mutating then
                  null; -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      begin
         a_istruzione := 'begin relazioni_ruoli_pkg.chk_ri( ''' ||
                         nvl(:new.id_relazione, :old.id_relazione) || '''' || ', ''' ||
                         :old.ottica || '''' || ', ''' || :new.ottica || '''' || ', ''' ||
                         :old.codice_uo || '''' || ', ''' || :new.codice_uo || '''' ||
                         ', ''' || :old.uo_discendenti || '''' || ', ''' ||
                         :new.uo_discendenti || '''' || ', ''' || :old.suddivisione || '''' ||
                         ', ''' || :new.suddivisione || '''' || ', ''' || :old.incarico || '''' ||
                         ', ''' || :new.incarico || '''' || ', ''' || :old.responsabile || '''' ||
                         ', ''' || :new.responsabile || '''' || ', ''' || :old.dipendente || '''' ||
                         ', ''' || :new.dipendente || '''' || ', ''' || :old.ruolo || '''' ||
                         ', ''' || :new.ruolo || '''' || ', ''' || to_char(d_inserting) || '''' ||
                         ', ''' || to_char(d_updating) || '''' || ', ''' ||
                         to_char(d_deleting) || '''' || ');' || 'end;';
         dbms_output.put_line(a_istruzione);
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;
   begin
      -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional then
            -- Switched functional Integrity
            if d_inserting = 1 or d_deleting = 1 or
               (d_updating = 1 and
               (:old.ottica <> :new.ottica or :old.codice_uo <> :new.codice_uo or
               :old.uo_discendenti <> :new.uo_discendenti or
               :old.suddivisione <> :new.suddivisione or
               :old.responsabile <> :new.responsabile or
               :old.dipendente <> :new.dipendente or :old.ruolo <> :new.ruolo)) then
               begin
                  a_istruzione := 'begin relazioni_ruoli_pkg.set_FI( ''' ||
                                  nvl(:new.id_relazione, :old.id_relazione) || '''' ||
                                  ', ''' || :old.ottica || '''' || ', ''' || :new.ottica || '''' ||
                                  ', ''' || :old.codice_uo || '''' || ', ''' ||
                                  :new.codice_uo || '''' || ', ''' || :old.uo_discendenti || '''' ||
                                  ', ''' || :new.uo_discendenti || '''' || ', ''' ||
                                  :old.suddivisione || '''' || ', ''' ||
                                  :new.suddivisione || '''' || ', ''' || :old.incarico || '''' ||
                                  ', ''' || :new.incarico || '''' || ', ''' ||
                                  :old.responsabile || '''' || ', ''' ||
                                  :new.responsabile || '''' || ', ''' || :old.dipendente || '''' ||
                                  ', ''' || :new.dipendente || '''' || ', ''' ||
                                  :old.ruolo || '''' || ', ''' || :new.ruolo || '''' ||
                                  ', ''' || to_char(d_inserting) || '''' || ', ''' ||
                                  to_char(d_updating) || '''' || ', ''' ||
                                  to_char(d_deleting) || '''' || ');' || 'end;';
                  dbms_output.put_line(a_istruzione);
                  integritypackage.set_postevent(a_istruzione, ' ');
               end;
            end if;
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



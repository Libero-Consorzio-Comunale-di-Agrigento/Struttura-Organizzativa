CREATE OR REPLACE TRIGGER ruoli_profilo_tiu
/******************************************************************************
    NOME:        RUOLI_PROFILO_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table RUOLI_PROFILO
   ******************************************************************************/
   before insert or update or delete on ruoli_profilo
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;
   d_oggi date := trunc(sysdate);
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
      --  Column "ID_RUOLO_PROFILO" uses sequence RUOLI_profilo_SQ
      if :new.id_ruolo_profilo is null and not deleting then
         select ruoli_profilo_sq.nextval into :new.id_ruolo_profilo from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := d_oggi;
      end if;
      if :new.dal is null and not deleting then
         :new.dal := d_oggi;
      end if;
      --Impedisce la modifica del ruoli associato al profilo se già attribuito a un componente
      if updating and :new.ruolo <> :old.ruolo and
         ruoli_profilo_pkg.is_ruolo_assegnato(:new.ruolo_profilo, :old.ruolo) then
         errno  := -20009;
         errmsg := 'Ruolo derivato da Profilo gia'' assegnato a componenti. Non modificabile';
         raise integrity_error;
      end if;
      if not deleting then
         begin
            ruoli_profilo_pkg.chk_di(:new.dal, :new.al);
         end;
      end if;
      begin
         -- Check FUNCTIONAL Integrity
         begin
            -- Check UNIQUE Integrity on PK of "RUOLI_profilo"
            if integritypackage.getnestlevel = 0 and not deleting then
               declare
                  cursor cpk_ruoli_profilo(var_id_ruolo_profilo number) is
                     select 1
                       from ruoli_profilo
                      where id_ruolo_profilo = var_id_ruolo_profilo;
                  mutating exception;
                  pragma exception_init(mutating, -4091);
               begin
                  if :new.id_ruolo_profilo is not null then
                     open cpk_ruoli_profilo(:new.id_ruolo_profilo);
                     fetch cpk_ruoli_profilo
                        into dummy;
                     found := cpk_ruoli_profilo%found;
                     close cpk_ruoli_profilo;
                     if found then
                        errno  := -20007;
                        errmsg := 'Identificazione "' || :new.id_ruolo_profilo ||
                                  '" gia'' presente in Ruoli profilo. La registrazione  non puo'' essere inserita.';
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
            a_istruzione := 'begin ruoli_profilo_pkg.chk_RI( ''' || :new.id_ruolo_profilo || '''' ||
                            ', ''' || nvl(:new.ruolo_profilo, :old.ruolo_profilo) || '''' ||
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
                  a_istruzione := 'begin ruoli_profilo_pkg.set_FI( ''' ||
                                  :new.id_ruolo_profilo || '''' || ', ''' ||
                                  nvl(:new.ruolo_profilo, :old.ruolo_profilo) || '''' ||
                                  ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                                  ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                                  to_char(:new.dal, 'dd/mm/yyyy') ||
                                  ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                                  to_char(:old.al, 'dd/mm/yyyy') ||
                                  ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                                  to_char(:new.al, 'dd/mm/yyyy') ||
                                  ''', ''dd/mm/yyyy'' ) ' || ', ''' ||
                                  nvl(:new.ruolo, :old.ruolo) || '''' || ', to_date( ''' ||
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
   exception
      when integrity_error then
         integritypackage.initnestlevel;
         raise_application_error(errno, errmsg);
      when others then
         integritypackage.initnestlevel;
         raise;
   end;
end;
/



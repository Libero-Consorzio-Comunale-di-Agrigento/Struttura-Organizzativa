CREATE OR REPLACE TRIGGER task_funzioni_tiu
/******************************************************************************
    NOME:        task_funzioni_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table task_funzioni
   ******************************************************************************/
   before insert or update or delete ON TASK_FUNZIONI
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;
   d_oggi timestamp := systimestamp;
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
      if inserting then
         :new.data_elaborazione := systimestamp;
         if :new.utente is null then
            :new.utente := user;
         end if;
      end if;
      --Eventuale gestione in deleting delle relative registrazioni su key_error_log
      null;
   end;

   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "task_funzioni"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_task_funzioni(var_id_task number) is
                  select 1 from task_funzioni t where t.id_task = var_id_task;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_task is not null then
                  open cpk_task_funzioni(:new.id_task);
                  fetch cpk_task_funzioni
                     into dummy;
                  found := cpk_task_funzioni%found;
                  close cpk_task_funzioni;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_task ||
                               '" gia'' presente in Task_funzioni. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when mutating then
                  null; -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      /*declare
         d_inserting  number := afc.to_number(inserting);
         d_updating   number := afc.to_number(updating);
         d_deleting   number := afc.to_number(deleting);
         a_istruzione varchar2(2000);
      begin
         a_istruzione := 'begin so4_task_pkg.chk_RI( ... );' || 'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;*/
   end;
   declare
      d_inserting  number := afc.to_number(inserting);
      d_updating   number := afc.to_number(updating);
      d_deleting   number := afc.to_number(deleting);
      a_istruzione varchar2(2000);
   begin
      -- Set FUNCTIONAL Integrity
      if integritypackage.functional and inserting then
         a_istruzione := 'begin so4_task_pkg.esegui_task(' || :new.id_task || '' || ');' ||
                         'end;';
         dbms_output.put_line(a_istruzione);
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
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/



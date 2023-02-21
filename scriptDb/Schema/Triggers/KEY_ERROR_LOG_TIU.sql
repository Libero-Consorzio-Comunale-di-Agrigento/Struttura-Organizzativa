CREATE OR REPLACE TRIGGER key_error_log_tiu
/******************************************************************************
    NOME:        KEY_ERROR_LOG_TIU
    DESCRIZIONE: Trigger for Set DATA Integrity
                             Set FUNCTIONAL Integrity
                          on Table KEY_ERROR_LOG
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
       0 30/01/2004 MM     Creazione.
       1 21/04/2006 MM     Recupero dell'id da associare al record tramite sequence
                           KEEL_SQ invece che tramite si4.next_id.
   ******************************************************************************/
   before insert or update on key_error_log
   for each row
declare
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   found  boolean;
begin
   begin
      -- Set FUNCTIONAL Integrity
      if integritypackage.getnestlevel = 0 then
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
         if :new.error_id is null then
            select keel_sq.nextval into :new.error_id from dual;
         end if;
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



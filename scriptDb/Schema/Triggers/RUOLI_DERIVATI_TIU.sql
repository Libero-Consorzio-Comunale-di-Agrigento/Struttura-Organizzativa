CREATE OR REPLACE TRIGGER ruoli_derivati_tiu
/******************************************************************************
    NOME:        ruoli_derivati_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table ruoli_derivati
   ******************************************************************************/
   before insert or update or delete on ruoli_derivati
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;
begin
   functionalnestlevel := integritypackage.getnestlevel;

   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __
   ***************************************************************************/
   -- Check / Set DATA Integrity
   declare
   begin
      if not deleting then
         if :new.id_ruolo_derivato is null then
            select ruoli_profilo_sq.nextval into :new.id_ruolo_derivato from dual;
         end if;
         begin
            null;
            --ruoli_derivati_pkg.chk_di(:new.dal, :new.al);
         end;
      end if;
   end;

   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "ruoli_derivati"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_ruoli_derivati(var_id_ruolo_derivato number) is
                  select 1
                    from ruoli_derivati
                   where id_ruolo_derivato = var_id_ruolo_derivato;

               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_ruolo_derivato is not null then
                  open cpk_ruoli_derivati(:new.id_ruolo_derivato);

                  fetch cpk_ruoli_derivati
                     into dummy;

                  found := cpk_ruoli_derivati%found;

                  close cpk_ruoli_derivati;

                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_ruolo_derivato ||
                               '" gia'' presente in ruoli_derivati. La registrazione  non puo'' essere inserita.';
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



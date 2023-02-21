CREATE OR REPLACE TRIGGER deleghe_tiu
/******************************************************************************
    NOME:        deleghe_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table deleghe
   ******************************************************************************/
   before insert or update or delete on deleghe
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
      if :new.id_delega is null and not deleting then
         -- SELECT deleghe_sq.NEXTVAL INTO :new.id_delega FROM DUAL;
         :new.id_delega := deleghe_pkg.get_id_delega;
      end if;
   
      if :new.dal is null and not deleting then
         :new.dal := trunc(sysdate);
      end if;
   
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
   
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
   end;

   --
   -- Previene che il delegante deleghi se stesso
   --
   if (updating or inserting) and :new.delegante = :new.delegato then
      errno  := -20001;
      errmsg := 'Il soggetto delegato non puo'' coincidere con il soggetto delegante';
      raise integrity_error;
   end if;

   if (updating or inserting) and :new.dal > :new.al then
      errno  := -20002;
      errmsg := 'Date errate';
      raise integrity_error;
   end if;

   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "deleghe"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_deleghe(var_id_delega number) is
                  select 1 from deleghe where id_delega = var_id_delega;
            
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_delega is not null then
                  open cpk_deleghe(:new.id_delega);
               
                  fetch cpk_deleghe
                     into dummy;
               
                  found := cpk_deleghe%found;
               
                  close cpk_deleghe;
               
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_delega ||
                               '" gia'' presente in Deleghe. La registrazione  non puo'' essere inserita.';
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
         /*a_istruzione := 'begin deleghe_pkg.chk_ri( ''' ||
         nvl(:new.id_delega, :old.id_delega) || '''' || ', ''' || ||
         to_char(d_inserting) || '''' || ', ''' || to_char(d_updating) || '''' ||
         ', ''' || to_char(d_deleting) || '''' || ');' || 'end;';*/
      
         dbms_output.put_line(a_istruzione);
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;

   begin
      -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional then
            -- Switched functional Integrity
            /*a_istruzione := 'begin deleghe_pkg.set_fi( ''' ||
            nvl(:new.id_delega, :old.id_delega) || '''' || ', ''' || ||
            to_char(d_inserting) || '''' || ', ''' || to_char(d_updating) || '''' ||
            ', ''' || to_char(d_deleting) || '''' || ');' || 'end;';*/
            null;
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



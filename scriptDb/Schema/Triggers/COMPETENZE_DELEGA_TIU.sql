CREATE OR REPLACE TRIGGER competenze_delega_tiu
/******************************************************************************
    NOME:        competenze_delega_tiu
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table competenze_delega_tiu
   ******************************************************************************/
   before insert or update or delete on competenze_delega
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
   begin
      -- Check / Set DATA Integrity
      if :new.id_competenza_delega is null and not deleting then
         :new.id_competenza_delega := deleghe_pkg.get_id_competenza_delega;
         --         SELECT competenze_delega_sq.NEXTVAL
         --           INTO :new.id_competenza_delega
         --           FROM DUAL;
      end if;
   end;

   functionalnestlevel := integritypackage.getnestlevel;

   begin
      -- Check FUNCTIONAL Integrity
      begin
         /*a_istruzione := 'begin deleghe_pkg.chk_ri( ''' ||
         nvl(:new.id_delega, :old.id_delega) || '''' || ', ''' || ||
         to_char(d_inserting) || '''' || ', ''' || to_char(d_updating) || '''' ||
         ', ''' || to_char(d_deleting) || '''' || ');' || 'end;';*/
      
         dbms_output.put_line(a_istruzione);
         --integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;

   begin
      -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional then
            -- Switched functional Integrity
            a_istruzione := 'begin competenze_delega_pkg.set_fi( ''' ||
                            nvl(:new.codice, :old.codice) || ''', to_date( ''' ||
                            to_char(:new.fine_validita, 'dd/mm/yyyy') ||
                            ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                            to_char(:old.fine_validita, 'dd/mm/yyyy') ||
                            ''', ''dd/mm/yyyy'' )' || ',''' ||
                            to_char(:new.id_competenza_delega) || '''' || ',''' ||
                            to_char(d_inserting) || '''' || ', ''' || to_char(d_updating) || '''' ||
                            ', ''' || to_char(d_deleting) || '''' || ');' || 'end;';
            dbms_output.put_line(a_istruzione);
            integritypackage.set_postevent(a_istruzione, ' ');
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



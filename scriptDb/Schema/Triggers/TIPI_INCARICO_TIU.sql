CREATE OR REPLACE TRIGGER tipi_incarico_tiu
/******************************************************************************
    NOME:        tipi_incarico_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table tipi_incarico
   ******************************************************************************/
   before insert or update or delete on tipi_incarico
   for each row
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno        integer;
   errmsg       char(200);
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
      -- Set FUNCTIONAL Integrity
      if integritypackage.functional and updating and
         :old.responsabile <> :new.responsabile and
         nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AttribuzioneAutomaticaRuoli'
                                           ,0)
            ,'NO') = 'SI' then
         --#634
         a_istruzione := 'begin tipo_incarico.set_FI( ''' || :new.responsabile || '''' ||
                         ', ''' || :old.responsabile || '''' || ', ''' || :new.incarico || '''' || ');' ||
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



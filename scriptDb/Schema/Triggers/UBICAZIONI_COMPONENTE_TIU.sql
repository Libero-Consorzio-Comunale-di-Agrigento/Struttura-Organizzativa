CREATE OR REPLACE TRIGGER ubicazioni_componente_tiu
/******************************************************************************
    NOME:        UBICAZIONI_COMPONENTE_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table UBICAZIONI_COMPONENTE
   ******************************************************************************/
   before insert or update or delete on ubicazioni_componente
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
   begin
      -- Check / Set DATA Integrity
      --  Column "ID_UBICAZIONE_COMPONENTE" uses sequence UBCO_SQ
      if :new.id_ubicazione_componente is null and not deleting then
         select ubco_sq.nextval into :new.id_ubicazione_componente from dual;
      end if;
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
   end;

   --Impedisce la modifica del DAL da not null a null #544
   if updating and :old.dal is not null and :new.dal is null then
      errno  := -20001;
      errmsg := 'Data di decorrenza non annullabile';
      raise integrity_error;
   end if;

   if not deleting then
      begin
         ubicazione_componente.chk_di(:new.dal, :new.al);
      end;
   end if;

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SO4', 'AssegnazioniFisicheIRIS', 0)
         ,'NO') = 'SI' then
      declare
         d_statement afc.t_statement;
      begin
         d_statement := 'begin' || chr(10) || '   so4gp_pkg.set_inmo(' ||
                        nvl(:new.id_componente, :old.id_componente) || ', ' ||
                        'to_date( ''' ||
                        to_char(nvl(:new.dal, :old.dal), afc.date_format) ||
                        ''', afc.date_format ));' || chr(10) || 'end;';
         afc.sql_execute(d_statement);
      exception
         when others then
            null;
      end;
   end if;

   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "UBICAZIONI_COMPONENTE"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_ubicazioni_componente(var_id_ubicazione_componente number) is
                  select 1
                    from ubicazioni_componente
                   where id_ubicazione_componente = var_id_ubicazione_componente;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_ubicazione_componente is not null then
                  open cpk_ubicazioni_componente(:new.id_ubicazione_componente);
                  fetch cpk_ubicazioni_componente
                     into dummy;
                  found := cpk_ubicazioni_componente%found;
                  close cpk_ubicazioni_componente;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_ubicazione_componente ||
                               '" gia'' presente in Ubicazioni componente. La registrazione  non puo'' essere inserita.';
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
      begin
         a_istruzione := 'begin ubicazione_componente.chk_RI( ''' ||
                         nvl(:new.id_ubicazione_componente, :old.id_ubicazione_componente) || '''' ||
                         ', ''' || nvl(:new.id_componente, :old.id_componente) || '''' ||
                         ', ''' ||
                         nvl(:new.id_ubicazione_unita, :old.id_ubicazione_unita) || '''' ||
                         ', to_date( ''' || to_char(:new.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', ''' || to_char(d_inserting) || '''' || ', ''' ||
                         to_char(d_updating) || '''' || ');' || 'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
      declare
         a_istruzione varchar2(2000);
         d_inserting  number := afc.to_number(inserting);
         d_updating   number := afc.to_number(updating);
         d_deleting   number := afc.to_number(deleting);
      begin
         a_istruzione := 'begin ubicazione_componente.set_fi( ''' ||
                         nvl(:new.id_ubicazione_componente, :old.id_ubicazione_componente) || '''' ||
                         ', ''' || nvl(:new.id_componente, :old.id_componente) || '''' ||
                         ', ''' ||
                         nvl(:new.id_ubicazione_unita, :old.id_ubicazione_unita) || '''' ||
                         ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' || ', ' ||
                         ' to_date( ''' || to_char(:new.data_aggiornamento, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ',''' || :new.utente_aggiornamento ||
                         ''',''' || to_char(d_inserting) || '''' || ', ''' ||
                         to_char(d_updating) || '''' || ', ''' || to_char(d_deleting) || '''' || ');' ||
                         'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   
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



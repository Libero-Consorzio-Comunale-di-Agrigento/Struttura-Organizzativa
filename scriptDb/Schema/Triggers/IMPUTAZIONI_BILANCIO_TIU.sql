CREATE OR REPLACE TRIGGER imputazioni_bilancio_tiu
/******************************************************************************
    NOME:        IMPUTAZIONI_BILANCIO_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table IMPUTAZIONI_BILANCIO
   ******************************************************************************/
   before insert or update or delete on imputazioni_bilancio
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
      --  Column "ID_IMPUTAZIONE" uses sequence IMBI_SQ
      if :new.id_imputazione is null and not deleting then
         select imbi_sq.nextval into :new.id_imputazione from dual;
      end if;
      if :new.utente_agg is null and not deleting then
         :new.utente_agg := user;
      end if;
      if :new.data_agg is null and not deleting then
         :new.data_agg := trunc(sysdate);
      end if;
   end;
   if not deleting and revisione_struttura.s_attivazione <> 1
     and imputazione_bilancio.s_origine_gps <> 1 --#37219
     then --#760 #764
      begin
         imputazione_bilancio.chk_di(:new.dal, :new.al);
      end;
   end if;
   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "IMPUTAZIONI_BILANCIO"
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_imputazioni_bilancio(var_id_imputazione number) is
                  select 1
                    from imputazioni_bilancio
                   where id_imputazione = var_id_imputazione;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.id_imputazione is not null then
                  open cpk_imputazioni_bilancio(:new.id_imputazione);
                  fetch cpk_imputazioni_bilancio
                     into dummy;
                  found := cpk_imputazioni_bilancio%found;
                  close cpk_imputazioni_bilancio;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.id_imputazione ||
                               '" gia'' presente in Imputazioni bilancio. La registrazione  non puo'' essere inserita.';
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
         d_nest_level integer := integritypackage.getnestlevel;
      begin
         a_istruzione := 'begin Imputazione_bilancio.chk_RI( ''' ||
                         nvl(:new.id_componente, :old.id_componente) || '''' ||
                         ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                         ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                         to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                         ', ''' || :new.rowid || '''' || ', ''' || to_char(d_inserting) || '''' ||
                         ', ''' || to_char(d_updating) || '''' || ', ''' ||
                         to_char(d_deleting) || '''' || ', ''' || to_char(d_nest_level) || '''' || ');' ||
                         'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;
   begin
      -- Set FUNCTIONAL Integrity
      begin
         if functionalnestlevel = 0 then
            integritypackage.nextnestlevel;
            declare
               a_istruzione varchar2(2000);
               d_inserting  number := afc.to_number(inserting);
               d_updating   number := afc.to_number(updating);
               d_deleting   number := afc.to_number(deleting);
            begin
               a_istruzione := 'begin Imputazione_bilancio.set_FI( ''' ||
                               nvl(:new.id_componente, :old.id_componente) || '''' ||
                               ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') ||
                               ''', ''dd/mm/yyyy'' ) ' || ', to_date( ''' ||
                               to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' || ', ' ||
                               afc.quote(nvl(:new.numero, :old.numero)) || ', ' ||
                               afc.quote(:new.utente_agg) || ', ''' ||
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



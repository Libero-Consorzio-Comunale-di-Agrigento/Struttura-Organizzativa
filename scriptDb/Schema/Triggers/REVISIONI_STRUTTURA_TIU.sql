CREATE OR REPLACE TRIGGER revisioni_struttura_tiu
/******************************************************************************
    NOME:        REVISIONI_STRUTTURA_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table REVISIONI_STRUTTURA
   ******************************************************************************/
   before insert or update or delete on revisioni_struttura
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
      -- Column "Revisione" uses GET_ID_REVISIONE function
      if :new.revisione is null and not deleting then
         select revisione_struttura.get_id_revisione(:new.ottica)
           into :new.revisione
           from dual;
      end if;
   
      if :new.utente_aggiornamento is null and not deleting then
         :new.utente_aggiornamento := user;
      end if;
   
      if :new.data_aggiornamento is null and not deleting then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
   
      if :new.provenienza is null and inserting then
         :new.provenienza := 'SO4';
      end if;
   
      if :new.tipo_revisione is null and inserting then
         :new.tipo_revisione := 'N';
      end if;
   
      -- la data di pubblicazione non può essere precedente la sysdate
      -- in fase di attivazione ne controlliamo (e sistemiamo) il valore
      if (:new.stato = 'A' and :old.stato = 'M') and
         nvl(:old.data_pubblicazione, to_date(2222222, 'j')) < trunc(sysdate) or
         :old.data_pubblicazione = :new.dal then
      
         :new.data_pubblicazione := greatest(trunc(sysdate), :new.dal);
      
      end if;
      --impedisce la modifica del dal di una revisione retroattiva se ci sono già modifiche #791
      if updating and :new.tipo_revisione = 'R' and :new.dal <> :old.dal and
         revisione_struttura.is_revisione_modificabile(:new.ottica, :new.revisione) <>
         afc_error.ok then
         errno  := -20001;
         errmsg := 'Sono gia'' state effettuate modifiche in questa revisione. Data non modificabile';
         raise integrity_error;
      end if;
      --impedisce la modifica dello stato di una revisione se ci sono già modifiche #54302
      if updating and :new.stato = 'M' and :old.stato = 'A' and
         revisione_struttura.is_revisione_modificabile(:new.ottica, :new.revisione) <>
         afc_error.ok then
         errno  := -20001;
         errmsg := 'Sono state effettuate modifiche in questa revisione. Stato non modificabile';
         raise integrity_error;
      end if;

      if not deleting then
         begin
            declare
               a_istruzione varchar2(2000);
            begin
               a_istruzione := 'begin Revisione_struttura.chk_RI( ''' || :new.ottica || '''' ||
                               '                                , ''' || :new.revisione || '''' ||
                               '                                , to_date( ''' ||
                               to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               '                                , ''' || :new.stato || '''' ||
                               '                                , ''' || :old.stato || '''' ||
                               '                                , ''' ||
                               :new.tipo_revisione || '''' ||
                               '                                , ''' ||
                               :old.tipo_revisione || '''' ||
                               '                                );' || 'end;';
               integritypackage.set_postevent(a_istruzione, ' ');
            end;
         end;
      end if;
   end;
   begin
      -- Check FUNCTIONAL Integrity
      begin
         -- Check UNIQUE Integrity on PK of "REVISIONI_STRUTTURA" 
         if integritypackage.getnestlevel = 0 and not deleting then
            declare
               cursor cpk_revisioni_struttura
               (
                  var_ottica    varchar
                 ,var_revisione number
               ) is
                  select 1
                    from revisioni_struttura
                   where ottica = var_ottica
                     and revisione = var_revisione;
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :new.ottica is not null and :new.revisione is not null then
                  open cpk_revisioni_struttura(:new.ottica, :new.revisione);
                  fetch cpk_revisioni_struttura
                     into dummy;
                  found := cpk_revisioni_struttura%found;
                  close cpk_revisioni_struttura;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "' || :new.ottica || ' ' ||
                               :new.revisione ||
                               '" gia'' presente in Revisioni Struttura. La registrazione  non puo'' essere inserita.';
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
   begin
      -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional then
            -- Switched functional integrity
            declare
               a_istruzione varchar2(2000);
               d_inserting  number := afc.to_number(inserting);
               d_updating   number := afc.to_number(updating);
               d_deleting   number := afc.to_number(deleting);
            begin
               a_istruzione := 'begin Revisione_struttura.set_FI( ''' || :new.ottica || '''' ||
                               '                                , ''' || :new.revisione || '''' ||
                               '                                , to_date( ''' ||
                               to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' ||
                               '                                , ''' || :new.stato || '''' ||
                               '                                , ''' || :old.stato || '''' ||
                               '                                , ''' ||
                               to_char(d_inserting) || '''' ||
                               '                                , ''' ||
                               to_char(d_updating) || '''' ||
                               '                                , ''' ||
                               to_char(d_deleting) || '''' ||
                               '                                );' || 'end;';
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



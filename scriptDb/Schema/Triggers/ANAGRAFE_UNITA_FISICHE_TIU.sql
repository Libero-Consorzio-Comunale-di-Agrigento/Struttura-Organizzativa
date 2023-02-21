CREATE OR REPLACE TRIGGER ANAGRAFE_UNITA_FISICHE_TIU
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table ANAGRAFE_UNITA_FISICHE
******************************************************************************/
   before INSERT or UPDATE or DELETE on ANAGRAFE_UNITA_FISICHE
for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __     
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      if :new.progr_unita_fisica is null and not DELETING then
         select anagrafe_unita_fisica.get_id_unita
           into :new.progr_unita_fisica
           from dual;
      end if;
      if :new.utente_aggiornamento is null and not DELETING then
         :new.utente_aggiornamento := user;
      end if;
      if :new.data_aggiornamento is null and not DELETING then
         :new.data_aggiornamento := trunc(sysdate);
      end if;
   end;
   if NOT deleting then
      begin 
        anagrafe_unita_fisica.chk_di( :new.dal
                                    , :new.al
                                    );
      end;
   end if;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "ANAGRAFE_UNITA_FISICHE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_anagrafe_unita_fisiche(var_PROGR_UNITA_FISICA number,
                            var_DAL date) is
               select 1
                 from   ANAGRAFE_UNITA_FISICHE
                where  PROGR_UNITA_FISICA = var_PROGR_UNITA_FISICA and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.PROGR_UNITA_FISICA is not null and
                  :new.DAL is not null then
                  open  cpk_anagrafe_unita_fisiche(:new.PROGR_UNITA_FISICA,
                                 :new.DAL);
                  fetch cpk_anagrafe_unita_fisiche into dummy;
                  found := cpk_anagrafe_unita_fisiche%FOUND;
                  close cpk_anagrafe_unita_fisiche;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.PROGR_UNITA_FISICA||' '||
                               :new.DAL||
                               '" gia'' presente in Anagrafe unita fisiche. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      declare
         a_istruzione varchar2(2000);
         d_inserting  number := afc.to_number(inserting);
         d_updating   number := afc.to_number(updating);
         d_deleting   number := afc.to_number(deleting);
      begin
         a_istruzione := 'begin anagrafe_unita_fisica.chk_RI( ''' 
                      || nvl(:new.progr_unita_fisica, :old.progr_unita_fisica) || '''' || ', ''' 
                      || nvl(:new.codice_uf, :old.codice_uf) || '''' || ', ''' 
                      || nvl(:new.capienza, :old.capienza) || '''' || ', '
                      || afc.quote(nvl(:new.denominazione, :old.denominazione)) || ', ''' 
                      || nvl(:new.amministrazione, :old.amministrazione) || '''' 
                      || ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                      || ', to_date( ''' || to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                      || ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                      || ', to_date( ''' || to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                      || ', ''' ||:old.assegnabile ||''''
                      || ', ''' ||:new.assegnabile ||''''
                      || ', ''' || nvl(:new.rowid, :old.rowid) || '''' 
                      || ', ''' || to_char(d_inserting) || '''' 
                      || ', ''' || to_char(d_updating) || '''' 
                      || ', ''' || to_char(d_deleting) || '''' 
                      || ');' 
                      || 'end;';
         integritypackage.set_postevent(a_istruzione, ' ');
      end;
   end;
   begin  -- Set FUNCTIONAL Integrity
      begin
         if integritypackage.functional then
            -- Switched functional Integrity
            declare
               a_istruzione varchar2(2000);
               d_inserting  number := afc.to_number(inserting);
               d_updating   number := afc.to_number(updating);
               d_deleting   number := afc.to_number(deleting);
            begin
               a_istruzione := 'begin anagrafe_unita_fisica.set_fi( ''' 
                            || nvl(:new.progr_unita_fisica, :old.progr_unita_fisica) || '''' || ', ''' 
                            || nvl(:new.codice_uf, :old.codice_uf) || '''' || ', ''' 
                            || nvl(:new.capienza, :old.capienza) || '''' || ', ' 
                            || afc.quote(nvl(:new.denominazione, :old.denominazione)) || ', ''' 
                            || nvl(:new.amministrazione, :old.amministrazione) || '''' 
                            || ', to_date( ''' || to_char(:old.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                            || ', to_date( ''' || to_char(:new.dal, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                            || ', to_date( ''' || to_char(:old.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                            || ', to_date( ''' || to_char(:new.al, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'' ) ' 
                            || ', ''' || nvl(:new.rowid, :old.rowid) || '''' 
                            || ', ''' || to_char(d_inserting) || '''' 
                            || ', ''' || to_char(d_updating) || '''' 
                            || ', ''' || to_char(d_deleting) || '''' 
                            || ');' 
                            || 'end;';
               integritypackage.set_postevent(a_istruzione, ' ');
            end;
         end if;
      end;      
      if functionalNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
        IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/



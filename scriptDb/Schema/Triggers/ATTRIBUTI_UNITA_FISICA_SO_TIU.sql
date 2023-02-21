CREATE OR REPLACE TRIGGER ATTRIBUTI_UNITA_FISICA_SO_TIU
/******************************************************************************
 NOME:        ATTRIBUTI_UNITA_FISICA_SO_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table ATTRIBUTI_UNITA_FISICA_SO
******************************************************************************/
   before INSERT or UPDATE or DELETE on ATTRIBUTI_UNITA_FISICA_SO
for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   d_oggi date := trunc(sysdate);
begin
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    __/__/____ __     
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      if not deleting then
         if :new.utente_aggiornamento is null then
            :new.utente_aggiornamento := user;
         end if;
         if :new.data_aggiornamento is null then
            :new.data_aggiornamento := d_oggi;
         end if;
      
         begin
            attributi_unita_fisica_so_pkg.chk_di(:new.dal, :new.al);
         end;
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "ATTRIBUTI_UNITA_FISICA_SO" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_attributi_unita_fisica_s(var_PROGR_UNITA_FISICA number,
                            var_ATTRIBUTO varchar,
                            var_DAL date) is
               select 1
                 from   ATTRIBUTI_UNITA_FISICA_SO
                where  PROGR_UNITA_FISICA = var_PROGR_UNITA_FISICA and
                       ATTRIBUTO = var_ATTRIBUTO and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.PROGR_UNITA_FISICA is not null and
                  :new.ATTRIBUTO is not null and
                  :new.DAL is not null then
                  open  cpk_attributi_unita_fisica_s(:new.PROGR_UNITA_FISICA,
                                 :new.ATTRIBUTO,
                                 :new.DAL);
                  fetch cpk_attributi_unita_fisica_s into dummy;
                  found := cpk_attributi_unita_fisica_s%FOUND;
                  close cpk_attributi_unita_fisica_s;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.PROGR_UNITA_FISICA||' '||
                               :new.ATTRIBUTO||' '||
                               :new.DAL||
                               '" gia'' presente in Attributi unita fisica so. La registrazione  non puo'' essere inserita.';
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
      
         a_istruzione := 'begin attributi_unita_fisica_so_pkg.chk_RI( ''' 
                      || nvl(:new.progr_unita_fisica, :old.progr_unita_fisica) || '''' 
                      || ', ''' || nvl(:new.attributo, :old.attributo) || '''' 
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
   end;
   begin  -- Set FUNCTIONAL Integrity
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



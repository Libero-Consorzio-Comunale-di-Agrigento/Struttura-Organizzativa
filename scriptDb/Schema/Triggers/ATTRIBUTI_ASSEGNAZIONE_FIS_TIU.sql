CREATE OR REPLACE TRIGGER ATTRIBUTI_ASSEGNAZIONE_FIS_TIU
/******************************************************************************
 NOME:        ATTRIBUTI_ASSEGNAZIONE_FIS_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table ATTRIBUTI_ASSEGNAZIONE_FISICA
******************************************************************************/
   before INSERT or UPDATE or DELETE on ATTRIBUTI_ASSEGNAZIONE_FISICA
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
            attr_assegnazione_fisica_pkg.chk_di(:new.dal, :new.al);
         end;
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "ATTRIBUTI_ASSEGNAZIONE_FISICA" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_attributi_assegnazione_f(var_ID_ASFI number,
                            var_ATTRIBUTO varchar,
                            var_DAL date) is
               select 1
                 from   ATTRIBUTI_ASSEGNAZIONE_FISICA
                where  ID_ASFI = var_ID_ASFI and
                       ATTRIBUTO = var_ATTRIBUTO and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_ASFI is not null and
                  :new.ATTRIBUTO is not null and
                  :new.DAL is not null then
                  open  cpk_attributi_assegnazione_f(:new.ID_ASFI,
                                 :new.ATTRIBUTO,
                                 :new.DAL);
                  fetch cpk_attributi_assegnazione_f into dummy;
                  found := cpk_attributi_assegnazione_f%FOUND;
                  close cpk_attributi_assegnazione_f;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_ASFI||' '||
                               :new.ATTRIBUTO||' '||
                               :new.DAL||
                               '" gia'' presente in Attributi assegnazione fisica. La registrazione  non puo'' essere inserita.';
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
         a_istruzione := 'begin attr_assegnazione_fisica_pkg.chk_RI( ''' 
                      || nvl(:new.id_asfi, :old.id_asfi) || '''' 
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



CREATE OR REPLACE TRIGGER ASSEGNAZIONI_FISICHE_TIU
/******************************************************************************
 NOME:        ASSEGNAZIONI_FISICHE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table ASSEGNAZIONI_FISICHE
******************************************************************************/
   before INSERT or UPDATE or DELETE on ASSEGNAZIONI_FISICHE
for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   d_data date;
   d_al   date;
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
      --  Column "ID_ASFI" uses sequence ASSEGNAZIONI_FISICHE_SQ
      if :NEW.ID_ASFI IS NULL and not DELETING then
         select ASSEGNAZIONI_FISICHE_SQ.NEXTVAL
           into :new.ID_ASFI
           from dual;
      end if;
      if not deleting then
         if :new.utente_aggiornamento is null then
            :new.utente_aggiornamento := user;
         end if;
         if :new.data_aggiornamento is null then
            :new.data_aggiornamento := d_oggi;
         end if;
      
         begin
            assegnazioni_fisiche_pkg.chk_di(:new.dal, :new.al);
         end;
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "ASSEGNAZIONI_FISICHE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_assegnazioni_fisiche(var_ID_ASFI number) is
               select 1
                 from   ASSEGNAZIONI_FISICHE
                where  ID_ASFI = var_ID_ASFI;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_ASFI is not null then
                  open  cpk_assegnazioni_fisiche(:new.ID_ASFI);
                  fetch cpk_assegnazioni_fisiche into dummy;
                  found := cpk_assegnazioni_fisiche%FOUND;
                  close cpk_assegnazioni_fisiche;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_ASFI||
                               '" gia'' presente in Assegnazioni fisiche. La registrazione  non puo'' essere inserita.';
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
         a_istruzione := 'begin assegnazioni_fisiche_pkg.chk_RI( '''
                      || :new.id_asfi|| ''''
                      || ', ''' || nvl(:new.ni, :old.ni) || ''''
                      || ', ''' || nvl(:new.progr_unita_fisica, :old.progr_unita_fisica) || ''''
                      || ', ''' || nvl(:new.id_ubicazione_componente,:old.id_ubicazione_componente) || ''''
                      || ', ''' || nvl(:new.progr_unita_organizzativa,:old.progr_unita_organizzativa) || ''''
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



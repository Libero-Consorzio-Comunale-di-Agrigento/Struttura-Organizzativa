CREATE OR REPLACE TRIGGER OTTICHE_TIU
/******************************************************************************
 NOME:        OTTICHE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table OTTICHE
******************************************************************************/
   before INSERT or UPDATE or DELETE on OTTICHE
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
      if :NEW.utente_aggiornamento is null and not DELETING then
         :NEW.utente_aggiornamento := user;
      end if;
      if :NEW.data_aggiornamento is null and not DELETING then
         :NEW.data_aggiornamento := trunc(sysdate);
      end if;
   end;
        
   if NOT deleting then
      begin 
        ottica.chk_di( :new.ottica
                     , :new.amministrazione
                     , :new.ottica_istituzionale
                     , :new.gestione_revisioni
                     );
      end;
   end if;

   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "OTTICHE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_ottiche(var_OTTICA varchar) is
               select 1
                 from   OTTICHE
                where  OTTICA = var_OTTICA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.OTTICA is not null then
                  open  cpk_ottiche(:new.OTTICA);
                  fetch cpk_ottiche into dummy;
                  found := cpk_ottiche%FOUND;
                  close cpk_ottiche;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.OTTICA||
                               '" gia'' presente in Ottiche. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
      if :new.ottica_istituzionale = 'SI' then
         declare
            a_istruzione                varchar2(2000);
            d_inserting number := AFC.to_number( inserting );
            d_updating  number := AFC.to_number( updating );
            d_deleting  number := AFC.to_number( deleting );
         begin
            a_istruzione:= 'begin Ottica.chk_RI( ''' || nvl(:new.ottica,:old.ottica) || ''''
                        ||                    ', ''' || nvl(:new.amministrazione,:old.amministrazione) || ''''
                        ||                    ');'
                        || 'end;'
                        ;
            IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
         end;
      end if;
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



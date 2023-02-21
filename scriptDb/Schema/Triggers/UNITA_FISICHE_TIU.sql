CREATE OR REPLACE TRIGGER UNITA_FISICHE_TIU
/******************************************************************************
 NOME:        UNITA_FISICHE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table UNITA_FISICHE
******************************************************************************/
   before INSERT or UPDATE or DELETE on UNITA_FISICHE
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
      --  Column "ID_ELEMENTO_FISICO" uses sequence UNITA_FISICHE_SQ
      if :NEW.ID_ELEMENTO_FISICO IS NULL and not DELETING then
         select UNITA_FISICHE_SQ.NEXTVAL
           into :new.ID_ELEMENTO_FISICO
           from dual;
      end if;
      if :NEW.utente_aggiornamento is null and not DELETING then
         :NEW.utente_aggiornamento := user;
      end if;
      if :NEW.data_aggiornamento is null and not DELETING then
         :NEW.data_aggiornamento := trunc(sysdate);
      end if;
      null;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "UNITA_FISICHE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_unita_fisiche(var_ID_ELEMENTO_FISICO number) is
               select 1
                 from   UNITA_FISICHE
                where  ID_ELEMENTO_FISICO = var_ID_ELEMENTO_FISICO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_ELEMENTO_FISICO is not null then
                  open  cpk_unita_fisiche(:new.ID_ELEMENTO_FISICO);
                  fetch cpk_unita_fisiche into dummy;
                  found := cpk_unita_fisiche%FOUND;
                  close cpk_unita_fisiche;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_ELEMENTO_FISICO||
                               '" gia'' presente in Unita fisiche. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
   end;
   -- Set PostEvent Check REFERENTIAL Integrity on INSERT or UPDATE
   DECLARE a_istruzione  varchar2(2000);
           a_messaggio   varchar2(2000);
   BEGIN
      IF IntegrityPackage.GetNestLevel = 0 THEN 
         --
         -- Integrità Referenziale di Esistenza FK
         --
         IF INSERTING THEN
            --
            -- Integrità Referenziale di Esistenza su insert FK
            --
            IF :new.id_unita_fisica_padre is NOT null THEN
               a_istruzione := 'select 1 from UNITA_FISICHE where progr_unita_fisica = '
                            || :new.id_unita_fisica_padre;
               a_messaggio := 'Impossibile inserire, non esiste il padre';

               IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
            END IF;
         ELSIF UPDATING THEN 
            IF nvl(:new.id_unita_fisica_padre,-1) != nvl(:old.id_unita_fisica_padre ,-1) THEN
               --
               -- Integrità Referenziale di Esistenza su update FK
               --
               IF :new.id_unita_fisica_padre is NOT null THEN
                  a_istruzione := 'select 1 from unita_fisiche where progr_unita_fisica = '
                               || :new.id_unita_fisica_padre; 
                  a_messaggio := 'Impossibile aggiornare, non esiste il padre';

                  IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
               END IF;
            END IF;
         END IF;
      END IF; 
      IF UPDATING THEN 
         IF :new.id_elemento_fisico != :old.id_elemento_fisico THEN
            --
            -- Integrità Referenziale su update PK
            --

            /* Caso di RESTRICT UPDATE */
   
            a_istruzione := 'select 0 from UNITA_FISICHE where id_unita_fisica_padre = '
                         || :old.progr_unita_fisica;
            a_messaggio := 'Impossibile aggiornare, ci sono figli';

            IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);

            /* Caso di CASCADE UPDATE

            a_istruzione := 'update tabella set riferimento ='
                         || :new.codice
                         || ' where riferimento = '
                         || :old.codice;
            a_messaggio := '';

            IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
            */
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
           IntegrityPackage.InitNestLevel;
           raise;
   END;
   declare
      a_istruzione                varchar2(2000);
      d_inserting number := AFC.to_number( inserting );
      d_updating  number := AFC.to_number( updating );
   begin
      a_istruzione:= 'begin Unita_fisica.chk_RI( ''' 
                  || :new.progr_unita_fisica || ''''
                  || ', ''' || :old.id_unita_fisica_padre || ''''
                  || ', ''' || :new.id_unita_fisica_padre || ''''
                  || ', to_date( ''' || to_char( :old.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                  || ', to_date( ''' || to_char( :new.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                  || ', ''' || to_char( d_inserting ) || ''''
                  || ', ''' || to_char( d_updating ) || ''''
                  || ');'
                  || 'end;'
                  ;
      IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
   end;
   -- Set PostEvent Check REFERENTIAL Integrity on DELETE
   IF DELETING THEN
      DECLARE a_istruzione  varchar2(2000);
              a_messaggio   varchar2(2000);
      BEGIN
         --
         -- Integrità Referenziale su delete PK
         --
      /* Caso di RESTRICT DELETE */

         a_istruzione := 'select 0 from UNITA_FISICHE where id_unita_fisica_padre = '
                      || :old.id_elemento_fisico;
         a_messaggio := 'Impossibile cancellare, ci sono figli';

         IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);

      /* Caso di CASCADE DELETE

      a_istruzione := 'select 0 from tabella where riferimento in(select '
                   || 'codice from tabella where riferimento = '
                   || :old.codice ||')';
      a_messaggio := 'Impossibile cancellare, esistono riferimenti incrociati';

      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);

      a_istruzione := 'delete from tabella where riferimento = '
                   || :old.codice;
      a_messaggio := '';

      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
      */
      EXCEPTION
         WHEN OTHERS THEN
           IntegrityPackage.InitNestLevel;
           raise;
      END;
   END IF;
   
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



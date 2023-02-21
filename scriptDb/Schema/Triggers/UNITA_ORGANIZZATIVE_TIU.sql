CREATE OR REPLACE TRIGGER UNITA_ORGANIZZATIVE_TIU
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table UNITA_ORGANIZZATIVE
******************************************************************************/
   before INSERT or UPDATE or DELETE on UNITA_ORGANIZZATIVE
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
      -- Column ID_ELEMENTO uses sequence 
      if :NEW.ID_ELEMENTO is null and not DELETING then
         select UNITA_ORGANIZZATIVE_SQ.nextval
           into :new.id_elemento
           from dual;
      end if;
      if :NEW.utente_aggiornamento is null and not DELETING then
         :NEW.utente_aggiornamento := user;
      end if;
      if :NEW.data_aggiornamento is null and not DELETING then
         :NEW.data_aggiornamento := trunc(sysdate);
      end if;
   end;
   
   if NOT deleting then
      begin 
        unita_organizzativa.chk_di( :new.dal
                                  , :new.al
                                  , :new.ottica
                                  , :new.revisione
                                  , :new.revisione_cessazione
                                  );
      end;
   end if;

   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "UNITA_ORGANIZZATIVE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_unita_organizzative(var_ID_ELEMENTO number) is
               select 1
                 from   UNITA_ORGANIZZATIVE
                where  ID_ELEMENTO = var_ID_ELEMENTO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_ELEMENTO is not null then
                  open  cpk_unita_organizzative(:new.ID_ELEMENTO);
                  fetch cpk_unita_organizzative into dummy;
                  found := cpk_unita_organizzative%FOUND;
                  close cpk_unita_organizzative;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_ELEMENTO||
                               '" gia'' presente in Unita Organizzative. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
      declare
        a_istruzione                varchar2(2000);
        d_inserting number := AFC.to_number( inserting );
        d_updating  number := AFC.to_number( updating );
        d_deleting  number := AFC.to_number( deleting );
      begin
        a_istruzione:= 'begin Unita_organizzativa.chk_RI( ''' || nvl(:new.ottica,:old.ottica) || ''''
                    ||                                  ', ''' || nvl(:new.progr_unita_organizzativa,:old.progr_unita_organizzativa) || ''''
                    ||                                  ', to_date( ''' || to_char( :old.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                    ||                                  ', to_date( ''' || to_char( :new.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                    ||                                  ', to_date( ''' || to_char( :old.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                    ||                                  ', to_date( ''' || to_char( :new.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                    ||                                  ', ''' || nvl(:new.id_elemento,:old.id_elemento) || ''''
                    ||                                  ', ''' || :old.revisione_cessazione || ''''
                    ||                                  ', ''' || :new.revisione_cessazione || ''''
                    ||                                  ', ''' || :new.rowid ||''''
                    ||                                  ', ''' || to_char( d_inserting ) || ''''
                    ||                                  ', ''' || to_char( d_updating ) || ''''
                    ||                                  ', ''' || to_char( d_deleting ) || ''''
                    ||                                  ');'
                    || 'end;'
                    ;
        IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
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
            IF :new.id_unita_padre is NOT null THEN
               a_istruzione := 'select 1 from UNITA_ORGANIZZATIVE where ottica = '''
                            || :new.ottica 
                            || ''' and progr_unita_organizzativa = '
                            || :new.id_unita_padre;
               a_messaggio := 'Impossibile inserire, non esiste il padre';

               IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
            END IF;
         ELSIF UPDATING THEN 
            IF nvl(:new.id_unita_padre,-1) != nvl(:old.id_unita_padre ,-1) THEN
               --
               -- Integrità Referenziale di Esistenza su update FK
               --
               IF :new.id_unita_padre is NOT null THEN
                  a_istruzione := 'select 1 from unita_organizzative where ottica = '''
                            || :new.ottica 
                            || ''' and progr_unita_organizzativa = '
                            || :new.id_unita_padre;
                  a_messaggio := 'Impossibile aggiornare, non esiste il padre';

                  IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
               END IF;
            END IF;
         END IF;
      END IF; 
      IF UPDATING THEN 
         IF :new.ottica != :old.ottica or
            :new.progr_unita_organizzativa != :old.progr_unita_organizzativa THEN
            --
            -- Integrità Referenziale su update PK
            --

            /* Caso di RESTRICT UPDATE */
   
            a_istruzione := 'select 0 from UNITA_ORGANIZZATIVE where ottica = '''
                            || :old.ottica 
                            || ''' and id_unita_padre = '
                            || :old.progr_unita_organizzativa;
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

   -- Set PostEvent Check REFERENTIAL Integrity on DELETE
   /* IF DELETING THEN
      DECLARE a_istruzione  varchar2(2000);
              a_messaggio   varchar2(2000);
      BEGIN
         --
         -- Integrità Referenziale su delete PK
         --
       /* Caso di RESTRICT DELETE 

         a_istruzione := 'select 0 from UNITA_ORGANIZZATIVE where id_unita_padre = '
                      || :old.progr_unita_organizzativa
                      || ' and ottica = '''
                      || :old.ottica ||'''';
         a_messaggio := 'Impossibile cancellare, ci sono figli';

         IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio); */

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
      
      EXCEPTION
         WHEN OTHERS THEN
           IntegrityPackage.InitNestLevel;
           raise;
      END;
   END IF; */

   begin  -- Set FUNCTIONAL Integrity
      begin
         if Integritypackage.functional
         then
            declare
              a_istruzione          varchar2(2000);
              d_inserting number := AFC.to_number ( inserting );
              d_updating  number := AFC.to_number ( updating );
              d_deleting  number := AFC.to_number ( deleting );
            begin
              a_istruzione:= 'begin Unita_organizzativa.set_FI( ''' || nvl(:new.ottica,:old.ottica) || ''''
                          ||                                  ','''|| :old.progr_unita_organizzativa || ''''
                          ||                                  ','''|| :new.progr_unita_organizzativa || ''''
                          ||                                  ','''|| nvl(:new.revisione,:old.revisione) || ''''
                          ||                                  ','''|| nvl(:new.revisione_cessazione,:old.revisione_cessazione) || ''''
                          ||                                  ', to_date( ''' || to_char( :old.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                          ||                                  ', to_date( ''' || to_char( :new.dal, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                          ||                                  ', to_date( ''' || to_char( :old.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                          ||                                  ', to_date( ''' || to_char( :new.al, 'dd/mm/yyyy' ) || ''', ''dd/mm/yyyy'' ) '
                          ||                                  ', ''' || to_char( d_inserting ) || ''''
                          ||                                  ', ''' || to_char( d_updating ) || ''''
                          ||                                  ', ''' || to_char( d_deleting ) || ''''
                          ||                                  ');'
                          || 'end;'
                          ;
              IntegrityPackage.Set_PostEvent(a_istruzione, ' ' );
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



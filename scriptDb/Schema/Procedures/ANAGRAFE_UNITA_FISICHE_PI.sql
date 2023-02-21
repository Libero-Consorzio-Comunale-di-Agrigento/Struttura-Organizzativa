CREATE OR REPLACE procedure ANAGRAFE_UNITA_FISICHE_PI
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ANAGRAFE_UNITA_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFE_UNITA_FISICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_progr_unita_fisica IN number
, new_dal IN date
, new_id_suddivisione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "SUDDIVISIONI_FISICHE"
   cursor cpk1_anagrafe_unita_fisiche(var_id_suddivisione number) is
      select 1
        from SUDDIVISIONI_FISICHE
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "SUDDIVISIONI_FISICHE" deve esistere quando si inserisce su "ANAGRAFE_UNITA_FISICHE"
      
         if NEW_ID_SUDDIVISIONE is not null
         then
            open  cpk1_anagrafe_unita_fisiche(NEW_ID_SUDDIVISIONE);
            fetch cpk1_anagrafe_unita_fisiche into dummy;
            found := cpk1_anagrafe_unita_fisiche%FOUND; /* %FOUND */
            close cpk1_anagrafe_unita_fisiche;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Suddivisioni fisiche. La registrazione Anagrafe unita fisiche non puo'' essere inserita. (ANAGRAFE_UNITA_FISICHE.ANUF_SUFI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
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


CREATE OR REPLACE procedure UBICAZIONI_UNITA_PI
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table UBICAZIONI_UNITA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger UBICAZIONI_UNITA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_ubicazione IN number
, new_progr_unita_organizzativa IN number
, new_progr_unita_fisica IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk1_ubicazioni_unita(var_progr_unita_organizzativa number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_progr_unita_organizzativa
         and var_progr_unita_organizzativa is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "ANAGRAFE_UNITA_FISICHE"
   cursor cpk2_ubicazioni_unita(var_progr_unita_fisica number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si inserisce su "UBICAZIONI_UNITA"
      
         if NEW_PROGR_UNITA_ORGANIZZATIVA is not null
         then
            open  cpk1_ubicazioni_unita(NEW_PROGR_UNITA_ORGANIZZATIVA);
            fetch cpk1_ubicazioni_unita into dummy;
            found := cpk1_ubicazioni_unita%FOUND; /* %FOUND */
            close cpk1_ubicazioni_unita;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Ubicazioni unita non puo'' essere inserita. (UBICAZIONI_UNITA.UBUN_ANUO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_FISICHE" deve esistere quando si inserisce su "UBICAZIONI_UNITA"
      
         if NEW_PROGR_UNITA_FISICA is not null
         then
            open  cpk2_ubicazioni_unita(NEW_PROGR_UNITA_FISICA);
            fetch cpk2_ubicazioni_unita into dummy;
            found := cpk2_ubicazioni_unita%FOUND; /* %FOUND */
            close cpk2_ubicazioni_unita;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Anagrafe unita fisiche. La registrazione Ubicazioni unita non puo'' essere inserita. (UBICAZIONI_UNITA.UBUN_ANUF_FK)';
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


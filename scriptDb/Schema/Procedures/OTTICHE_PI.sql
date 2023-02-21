CREATE OR REPLACE procedure OTTICHE_PI
/******************************************************************************
 NOME:        OTTICHE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table OTTICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger OTTICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_ottica IN varchar
, new_amministrazione IN varchar
, new_ottica_origine IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "OTTICHE"
   cursor cpk1_ottiche(var_ottica_origine varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica_origine
         and var_ottica_origine is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk2_ottiche(var_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_amministrazione
         and var_amministrazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "OTTICHE" deve esistere quando si inserisce su "OTTICHE"
      
         if NEW_OTTICA_ORIGINE is not null
         then
            open  cpk1_ottiche(NEW_OTTICA_ORIGINE);
            fetch cpk1_ottiche into dummy;
            found := cpk1_ottiche%FOUND; /* %FOUND */
            close cpk1_ottiche;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Ottiche non puo'' essere inserita. (OTTICHE.OTTI_OTTI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si inserisce su "OTTICHE"
      
         if NEW_AMMINISTRAZIONE is not null
         then
            open  cpk2_ottiche(NEW_AMMINISTRAZIONE);
            fetch cpk2_ottiche into dummy;
            found := cpk2_ottiche%FOUND; /* %FOUND */
            close cpk2_ottiche;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Ottiche non puo'' essere inserita. (OTTICHE.OTTI_AMMI_FK)';
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


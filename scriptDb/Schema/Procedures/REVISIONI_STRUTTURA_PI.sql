CREATE OR REPLACE procedure REVISIONI_STRUTTURA_PI
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table REVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_ottica IN varchar
, new_revisione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "OTTICHE"
   cursor cpk1_revisioni_struttura(var_ottica varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "OTTICHE" deve esistere quando si inserisce su "REVISIONI_STRUTTURA"
      
         if NEW_OTTICA is not null
         then
            open  cpk1_revisioni_struttura(NEW_OTTICA);
            fetch cpk1_revisioni_struttura into dummy;
            found := cpk1_revisioni_struttura%FOUND; /* %FOUND */
            close cpk1_revisioni_struttura;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Revisioni Struttura non puo'' essere inserita. (REVISIONI_STRUTTURA.REST_OTTI_FK)';
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


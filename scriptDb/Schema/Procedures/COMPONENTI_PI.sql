CREATE OR REPLACE procedure COMPONENTI_PI
/******************************************************************************
 NOME:        COMPONENTI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table COMPONENTI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger COMPONENTI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_componente IN number
, new_progr_unita_organizzativa IN number
, new_ni IN number
, new_ottica IN varchar
, new_revisione_assegnazione IN number
, new_revisione_cessazione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk1_componenti(var_progr_unita_organizzativa number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_progr_unita_organizzativa
         and var_progr_unita_organizzativa is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "REVISIONI_STRUTTURA"
   cursor cpk2_componenti(var_ottica varchar,
                   var_revisione_assegnazione number) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and REVISIONE = var_revisione_assegnazione
         and var_ottica is not null
         and var_revisione_assegnazione is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "REVISIONI_STRUTTURA"
   cursor cpk3_componenti(var_ottica varchar,
                   var_revisione_cessazione number) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and REVISIONE = var_revisione_cessazione
         and var_ottica is not null
         and var_revisione_cessazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si inserisce su "COMPONENTI"
      
         if NEW_PROGR_UNITA_ORGANIZZATIVA is not null
         then
            open  cpk1_componenti(NEW_PROGR_UNITA_ORGANIZZATIVA);
            fetch cpk1_componenti into dummy;
            found := cpk1_componenti%FOUND; /* %FOUND */
            close cpk1_componenti;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Componenti non puo'' essere inserita. (COMPONENTI.COMP_UNOR_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si inserisce su "COMPONENTI"
      
         if NEW_OTTICA is not null and
            NEW_REVISIONE_ASSEGNAZIONE is not null
         then
            open  cpk2_componenti(NEW_OTTICA,
                           NEW_REVISIONE_ASSEGNAZIONE);
            fetch cpk2_componenti into dummy;
            found := cpk2_componenti%FOUND; /* %FOUND */
            close cpk2_componenti;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Componenti non puo'' essere inserita. (COMPONENTI.COMP_REST_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si inserisce su "COMPONENTI"
      
         if NEW_OTTICA is not null and
            NEW_REVISIONE_CESSAZIONE is not null
         then
            open  cpk3_componenti(NEW_OTTICA,
                           NEW_REVISIONE_CESSAZIONE);
            fetch cpk3_componenti into dummy;
            found := cpk3_componenti%FOUND; /* %FOUND */
            close cpk3_componenti;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Componenti non puo'' essere inserita. (COMPONENTI.COMP_REST_2_FK)';
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


CREATE OR REPLACE procedure UNITA_ORGANIZZATIVE_PU
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table UNITA_ORGANIZZATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UNITA_ORGANIZZATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_elemento IN number
, old_ottica IN varchar
, old_revisione IN number
, old_progr_unita_organizzativa IN number
, old_id_unita_padre IN number
, old_revisione_cessazione IN number
, new_id_elemento IN number
, new_ottica IN varchar
, new_revisione IN number
, new_progr_unita_organizzativa IN number
, new_id_unita_padre IN number
, new_revisione_cessazione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "UNITA_ORGANIZZATIVE"
   cursor cpk1_unita_organizzative(var_ottica varchar,
                   var_id_unita_padre number) is
      select 1
        from UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and PROGR_UNITA_ORGANIZZATIVA = var_id_unita_padre
         and var_ottica is not null
         and var_id_unita_padre is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "REVISIONI_STRUTTURA"
   cursor cpk2_unita_organizzative(var_ottica varchar,
                   var_revisione_cessazione number) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and REVISIONE = var_revisione_cessazione
         and var_ottica is not null
         and var_revisione_cessazione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk3_unita_organizzative(var_progr_unita_organizzativa number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_progr_unita_organizzativa
         and var_progr_unita_organizzativa is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "REVISIONI_STRUTTURA"
   cursor cpk4_unita_organizzative(var_ottica varchar,
                   var_revisione number) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and REVISIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "OTTICHE"
   cursor cpk5_unita_organizzative(var_ottica varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk6_unita_organizzative(var_id_unita_padre number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_id_unita_padre
         and var_id_unita_padre is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "UNITA_ORGANIZZATIVE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and
             NEW_ID_UNITA_PADRE is not null and ( seq = 0 )
         then
            open  cpk1_unita_organizzative(NEW_OTTICA,
                           NEW_ID_UNITA_PADRE);
            fetch cpk1_unita_organizzative into dummy;
            found := cpk1_unita_organizzative%FOUND; /* %FOUND */
            close cpk1_unita_organizzative;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Unita Organizzative. La registrazione Unita Organizzative non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_UNOR_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and
             NEW_REVISIONE_CESSAZIONE is not null and ( seq = 0 )
         then
            open  cpk2_unita_organizzative(NEW_OTTICA,
                           NEW_REVISIONE_CESSAZIONE);
            fetch cpk2_unita_organizzative into dummy;
            found := cpk2_unita_organizzative%FOUND; /* %FOUND */
            close cpk2_unita_organizzative;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Unita Organizzative non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_REST_2_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
      
         if  NEW_PROGR_UNITA_ORGANIZZATIVA is not null and ( seq = 0 )
         then
            open  cpk3_unita_organizzative(NEW_PROGR_UNITA_ORGANIZZATIVA);
            fetch cpk3_unita_organizzative into dummy;
            found := cpk3_unita_organizzative%FOUND; /* %FOUND */
            close cpk3_unita_organizzative;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Unita Organizzative non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_ANUO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and
             NEW_REVISIONE is not null and ( seq = 0 )
         then
            open  cpk4_unita_organizzative(NEW_OTTICA,
                           NEW_REVISIONE);
            fetch cpk4_unita_organizzative into dummy;
            found := cpk4_unita_organizzative%FOUND; /* %FOUND */
            close cpk4_unita_organizzative;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Unita Organizzative non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_REST_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and ( seq = 0 )
         then
            open  cpk5_unita_organizzative(NEW_OTTICA);
            fetch cpk5_unita_organizzative into dummy;
            found := cpk5_unita_organizzative%FOUND; /* %FOUND */
            close cpk5_unita_organizzative;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Unita Organizzative non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_OTTI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
      
         if  NEW_ID_UNITA_PADRE is not null and ( seq = 0 )
         then
            open  cpk6_unita_organizzative(NEW_ID_UNITA_PADRE);
            fetch cpk6_unita_organizzative into dummy;
            found := cpk6_unita_organizzative%FOUND; /* %FOUND */
            close cpk6_unita_organizzative;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Unita Organizzative non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_ANUO_2_FK)';
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


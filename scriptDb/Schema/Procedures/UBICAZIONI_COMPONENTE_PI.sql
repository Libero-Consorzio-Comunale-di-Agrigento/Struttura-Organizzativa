CREATE OR REPLACE procedure UBICAZIONI_COMPONENTE_PI
/******************************************************************************
 NOME:        UBICAZIONI_COMPONENTE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table UBICAZIONI_COMPONENTE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger UBICAZIONI_COMPONENTE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_ubicazione_componente IN number
, new_id_componente IN number
, new_id_ubicazione_unita IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "UBICAZIONI_UNITA"
   cursor cpk1_ubicazioni_componente(var_id_ubicazione_unita number) is
      select 1
        from UBICAZIONI_UNITA
       where ID_UBICAZIONE = var_id_ubicazione_unita
         and var_id_ubicazione_unita is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk2_ubicazioni_componente(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "UBICAZIONI_UNITA" deve esistere quando si inserisce su "UBICAZIONI_COMPONENTE"
      
         if NEW_ID_UBICAZIONE_UNITA is not null
         then
            open  cpk1_ubicazioni_componente(NEW_ID_UBICAZIONE_UNITA);
            fetch cpk1_ubicazioni_componente into dummy;
            found := cpk1_ubicazioni_componente%FOUND; /* %FOUND */
            close cpk1_ubicazioni_componente;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Ubicazioni unita. La registrazione Ubicazioni componente non puo'' essere inserita. (UBICAZIONI_COMPONENTE.UBCO_UBUN_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "COMPONENTI" deve esistere quando si inserisce su "UBICAZIONI_COMPONENTE"
      
         if NEW_ID_COMPONENTE is not null
         then
            open  cpk2_ubicazioni_componente(NEW_ID_COMPONENTE);
            fetch cpk2_ubicazioni_componente into dummy;
            found := cpk2_ubicazioni_componente%FOUND; /* %FOUND */
            close cpk2_ubicazioni_componente;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Ubicazioni componente non puo'' essere inserita. (UBICAZIONI_COMPONENTE.UBCO_COMP_FK)';
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


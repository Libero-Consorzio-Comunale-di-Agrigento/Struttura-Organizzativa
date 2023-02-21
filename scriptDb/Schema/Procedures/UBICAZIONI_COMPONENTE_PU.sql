CREATE OR REPLACE procedure UBICAZIONI_COMPONENTE_PU
/******************************************************************************
 NOME:        UBICAZIONI_COMPONENTE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table UBICAZIONI_COMPONENTE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UBICAZIONI_COMPONENTE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ubicazione_componente IN number
, old_id_componente IN number
, old_id_ubicazione_unita IN number
, new_id_ubicazione_componente IN number
, new_id_componente IN number
, new_id_ubicazione_unita IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "UBICAZIONI_UNITA"
   cursor cpk1_ubicazioni_componente(var_id_ubicazione_unita number) is
      select 1
        from UBICAZIONI_UNITA
       where ID_UBICAZIONE = var_id_ubicazione_unita
         and var_id_ubicazione_unita is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk2_ubicazioni_componente(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "UBICAZIONI_UNITA" deve esistere quando si modifica "UBICAZIONI_COMPONENTE"
      
         if  NEW_ID_UBICAZIONE_UNITA is not null and ( seq = 0 )
         then
            open  cpk1_ubicazioni_componente(NEW_ID_UBICAZIONE_UNITA);
            fetch cpk1_ubicazioni_componente into dummy;
            found := cpk1_ubicazioni_componente%FOUND; /* %FOUND */
            close cpk1_ubicazioni_componente;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ubicazioni unita. La registrazione Ubicazioni componente non e'' modificabile. (UBICAZIONI_COMPONENTE.UBCO_UBUN_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "COMPONENTI" deve esistere quando si modifica "UBICAZIONI_COMPONENTE"
      
         if  NEW_ID_COMPONENTE is not null and ( seq = 0 )
         then
            open  cpk2_ubicazioni_componente(NEW_ID_COMPONENTE);
            fetch cpk2_ubicazioni_componente into dummy;
            found := cpk2_ubicazioni_componente%FOUND; /* %FOUND */
            close cpk2_ubicazioni_componente;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Ubicazioni componente non e'' modificabile. (UBICAZIONI_COMPONENTE.UBCO_COMP_FK)';
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


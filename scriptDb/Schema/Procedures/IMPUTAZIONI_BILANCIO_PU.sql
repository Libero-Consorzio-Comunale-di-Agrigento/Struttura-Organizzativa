CREATE OR REPLACE procedure IMPUTAZIONI_BILANCIO_PU
/******************************************************************************
 NOME:        IMPUTAZIONI_BILANCIO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table IMPUTAZIONI_BILANCIO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger IMPUTAZIONI_BILANCIO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_imputazione IN number
, old_id_componente IN number
, new_id_imputazione IN number
, new_id_componente IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk1_imputazioni_bilancio(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "COMPONENTI" deve esistere quando si modifica "IMPUTAZIONI_BILANCIO"
      
         if  NEW_ID_COMPONENTE is not null and ( seq = 0 )
         then
            open  cpk1_imputazioni_bilancio(NEW_ID_COMPONENTE);
            fetch cpk1_imputazioni_bilancio into dummy;
            found := cpk1_imputazioni_bilancio%FOUND; /* %FOUND */
            close cpk1_imputazioni_bilancio;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Imputazioni bilancio non e'' modificabile. (IMPUTAZIONI_BILANCIO.IMBI_COMP_FK)';
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


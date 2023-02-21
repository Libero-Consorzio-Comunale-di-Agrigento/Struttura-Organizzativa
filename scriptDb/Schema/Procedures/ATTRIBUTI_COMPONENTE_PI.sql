CREATE OR REPLACE procedure ATTRIBUTI_COMPONENTE_PI
/******************************************************************************
 NOME:        ATTRIBUTI_COMPONENTE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ATTRIBUTI_COMPONENTE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ATTRIBUTI_COMPONENTE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_attr_componente IN number
, new_id_componente IN number
, new_incarico IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "TIPI_INCARICO"
   cursor cpk1_attributi_componente(var_incarico varchar) is
      select 1
        from TIPI_INCARICO
       where INCARICO = var_incarico
         and var_incarico is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk2_attributi_componente(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "TIPI_INCARICO" deve esistere quando si inserisce su "ATTRIBUTI_COMPONENTE"
      
         if NEW_INCARICO is not null
         then
            open  cpk1_attributi_componente(NEW_INCARICO);
            fetch cpk1_attributi_componente into dummy;
            found := cpk1_attributi_componente%FOUND; /* %FOUND */
            close cpk1_attributi_componente;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Tipi Incarico. La registrazione Attributi componente non puo'' essere inserita. (ATTRIBUTI_COMPONENTE.ATCO_TIIN_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "COMPONENTI" deve esistere quando si inserisce su "ATTRIBUTI_COMPONENTE"
      
         if NEW_ID_COMPONENTE is not null
         then
            open  cpk2_attributi_componente(NEW_ID_COMPONENTE);
            fetch cpk2_attributi_componente into dummy;
            found := cpk2_attributi_componente%FOUND; /* %FOUND */
            close cpk2_attributi_componente;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Attributi componente non puo'' essere inserita. (ATTRIBUTI_COMPONENTE.ATCO_COMP_FK)';
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


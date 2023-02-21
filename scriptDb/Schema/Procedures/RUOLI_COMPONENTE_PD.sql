CREATE OR REPLACE procedure RUOLI_COMPONENTE_PD
/******************************************************************************
 NOME:        RUOLI_COMPONENTE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table RUOLI_COMPONENTE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RUOLI_COMPONENTE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ruolo_componente IN number
, old_id_componente IN number
, old_ruolo IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "RUOLI_DERIVATI"
   cursor cfk1_ruoli_derivati(var_id_ruolo_componente number) is
      select 1
        from RUOLI_DERIVATI
       where ID_RUOLO_COMPONENTE = var_id_ruolo_componente
         and var_id_ruolo_componente is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "RUOLI_DERIVATI"
   cursor cfk2_ruoli_derivati(var_id_ruolo_componente number) is
      select 1
        from RUOLI_DERIVATI
       where ID_PROFILO = var_id_ruolo_componente
         and var_id_ruolo_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "RUOLI_COMPONENTE" if children still exist in "RUOLI_DERIVATI"
      open  cfk1_ruoli_derivati(OLD_ID_RUOLO_COMPONENTE);
      fetch cfk1_ruoli_derivati into dummy;
      found := cfk1_ruoli_derivati%FOUND; /* %FOUND */
      close cfk1_ruoli_derivati;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su RUOLI_DERIVATI. La registrazione di Ruoli componente non e'' eliminabile. (RUOLI_DERIVATI.REFERENCE_51_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "RUOLI_COMPONENTE" if children still exist in "RUOLI_DERIVATI"
      open  cfk2_ruoli_derivati(OLD_ID_RUOLO_COMPONENTE);
      fetch cfk2_ruoli_derivati into dummy;
      found := cfk2_ruoli_derivati%FOUND; /* %FOUND */
      close cfk2_ruoli_derivati;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su RUOLI_DERIVATI. La registrazione di Ruoli componente non e'' eliminabile. (RUOLI_DERIVATI.REFERENCE_52_FK)';
         raise integrity_error;
      end if;
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


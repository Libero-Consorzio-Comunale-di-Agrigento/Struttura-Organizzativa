CREATE OR REPLACE TRIGGER deleghe_tmb
/******************************************************************************
    NOME:        DELEGHE_TMB
    DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                          at INSERT or UPDATE on Table DELEGHE
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generato in automatico.
   ******************************************************************************/
   before insert or update on deleghe
   for each row
declare
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;

   --  Declaration of InsertChildParentExist constraint for the parent "COMPETENZE_DELEGHE_1"
   cursor cpk1_deleghe
   (
      var_id_competenza number
     ,var_dal           date
     ,var_al            date
   ) is
      select 1
        from competenze_delega
       where id_competenza_delega = var_id_competenza
         and nvl(var_dal, to_date(2222222, 'j')) <= nvl(var_al, to_date(3333333, 'j'))
         and nvl(var_al, to_date(3333333, 'j')) <=
             nvl(fine_validita, to_date(3333333, 'j'))
         and var_id_competenza is not null;

   --  Declaration of InsertChildParentExist constraint for the parent "OTTICHE"
   cursor cpk4_deleghe(var_ottica varchar) is
      select 1
        from ottiche
       where ottica = var_ottica
         and var_ottica is not null;

   --  Declaration of InsertChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk5_deleghe
   (
      var_progr_unita_organizzativa number
     ,var_dal                       date
     ,var_al                        date
   ) is
      select 1
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = var_progr_unita_organizzativa
         and nvl(var_dal, to_date(2222222, 'j')) between dal and
             nvl(al, to_date(3333333, 'j'))
         and nvl(var_al, to_date(3333333, 'j')) between dal and
             nvl(al, to_date(3333333, 'j'))
         and var_progr_unita_organizzativa is not null;

   --  Declaration of InsertChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk6_deleghe(var_ruolo varchar) is
      select 1
        from ad4_ruoli
       where ruolo = var_ruolo
         and var_ruolo is not null;

   --  Declaration of InsertChildParentExist constraint for the parent "ANAGRAFE_SOGGETTI"
   cursor cpk7_deleghe(var_delegato varchar) is
      select 1
        from anagrafe_soggetti
       where ni = var_delegato
         and var_delegato is not null;

   --  Declaration of InsertChildParentExist constraint for the parent "ANAGRAFE_SOGGETTI"
   cursor cpk8_deleghe(var_delegante varchar) is
      select 1
        from anagrafe_soggetti
       where ni = var_delegante
         and var_delegante is not null;
begin
   begin
      --  Parent "COMPETENZE_DELEGHE_1" must exist when inserting a child in "DELEGHE"
      if :new.id_competenza_delega is not null then
         open cpk1_deleghe(:new.id_competenza_delega, :new.dal, :new.al);
      
         fetch cpk1_deleghe
            into dummy;
      
         found := cpk1_deleghe%found;
      
         close cpk1_deleghe;
      
         if not found then
            errno  := -20002;
            errmsg := 'Competenza non prevista in "COMPETENZE_DELEGA".' || ' ' ||
                      :new.id_competenza_delega || ' ' || :new.dal;
            raise integrity_error;
         end if;
      end if;
   
      --  Parent "OTTICHE" must exist when inserting a child in "DELEGHE"
      if :new.ottica is not null then
         open cpk4_deleghe(:new.ottica);
      
         fetch cpk4_deleghe
            into dummy;
      
         found := cpk4_deleghe%found;
      
         close cpk4_deleghe;
      
         if not found then
            errno  := -20002;
            errmsg := 'Ottica non prevista in "OTTICHE".';
            raise integrity_error;
         end if;
      end if;
   
      --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" must exist when inserting a child in "DELEGHE"
      if :new.progr_unita_organizzativa is not null and :new.dal is not null then
         open cpk5_deleghe(:new.progr_unita_organizzativa, :new.dal, :new.al);
      
         fetch cpk5_deleghe
            into dummy;
      
         found := cpk5_deleghe%found;
      
         close cpk5_deleghe;
      
         if not found then
            errno  := -20002;
            errmsg := 'Unità non presente in "ANAGRAFE_UNITA_ORGANIZZATIVE" per il periodo indicato';
            raise integrity_error;
         end if;
      end if;
   
      --  Parent "AD4_RUOLI" must exist when inserting a child in "DELEGHE"
      if :new.ruolo is not null then
         open cpk6_deleghe(:new.ruolo);
      
         fetch cpk6_deleghe
            into dummy;
      
         found := cpk6_deleghe%found;
      
         close cpk6_deleghe;
      
         if not found then
            errno  := -20002;
            errmsg := 'Ruolo non presente in "AD4_RUOLI".';
            raise integrity_error;
         end if;
      end if;
   
      --  Parent "ANAGRAFE_SOGGETTI" must exist when inserting a child in "DELEGHE"
      if :new.ruolo is not null then
         open cpk7_deleghe(:new.delegato);
      
         fetch cpk7_deleghe
            into dummy;
      
         found := cpk7_deleghe%found;
      
         close cpk7_deleghe;
      
         if not found then
            errno  := -20002;
            errmsg := 'Soggetto delegato non presente in "ANAGRAFE_SOGGETTI".';
            raise integrity_error;
         end if;
      end if;
   
      --  Parent "ANAGRAFE_SOGGETTI" must exist when inserting a child in "DELEGHE"
      if :new.ruolo is not null then
         open cpk8_deleghe(:new.delegante);
      
         fetch cpk8_deleghe
            into dummy;
      
         found := cpk8_deleghe%found;
      
         close cpk8_deleghe;
      
         if not found then
            errno  := -20002;
            errmsg := 'Soggetto delegante non presente in "ANAGRAFE_SOGGETTI".';
            raise integrity_error;
         end if;
      end if;
   end;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/



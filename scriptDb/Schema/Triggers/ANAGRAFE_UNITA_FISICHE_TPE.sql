CREATE OR REPLACE TRIGGER anagrafe_unita_fisiche_tpe
/******************************************************************************
    NOME:        ANAGRAFE_UNITA_FISICHE_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table ANAGRAFE_UNITA_FISICHE
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on anagrafe_unita_fisiche
   for each row
declare
   d_new_anagrafe_unita_fisiche anagrafe_unita_fisiche_b%rowtype;
   d_old_anagrafe_unita_fisiche anagrafe_unita_fisiche_b%rowtype;
   d_operazione                 varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_anagrafe_unita_fisiche.progr_unita_fisica   := :new.progr_unita_fisica;
            d_new_anagrafe_unita_fisiche.dal                  := :new.dal;
            d_new_anagrafe_unita_fisiche.codice_uf            := :new.codice_uf;
            d_new_anagrafe_unita_fisiche.denominazione        := :new.denominazione;
            d_new_anagrafe_unita_fisiche.denominazione_al1    := :new.denominazione_al1;
            d_new_anagrafe_unita_fisiche.denominazione_al2    := :new.denominazione_al2;
            d_new_anagrafe_unita_fisiche.des_abb              := :new.des_abb;
            d_new_anagrafe_unita_fisiche.des_abb_al1          := :new.des_abb_al1;
            d_new_anagrafe_unita_fisiche.des_abb_al2          := :new.des_abb_al2;
            d_new_anagrafe_unita_fisiche.indirizzo            := :new.indirizzo;
            d_new_anagrafe_unita_fisiche.cap                  := :new.cap;
            d_new_anagrafe_unita_fisiche.provincia            := :new.provincia;
            d_new_anagrafe_unita_fisiche.comune               := :new.comune;
            d_new_anagrafe_unita_fisiche.nota_indirizzo       := :new.nota_indirizzo;
            d_new_anagrafe_unita_fisiche.nota_indirizzo_al1   := :new.nota_indirizzo_al1;
            d_new_anagrafe_unita_fisiche.nota_indirizzo_al2   := :new.nota_indirizzo_al2;
            d_new_anagrafe_unita_fisiche.amministrazione      := :new.amministrazione;
            d_new_anagrafe_unita_fisiche.id_suddivisione      := :new.id_suddivisione;
            d_new_anagrafe_unita_fisiche.generico             := :new.generico;
            d_new_anagrafe_unita_fisiche.al                   := :new.al;
            d_new_anagrafe_unita_fisiche.utente_aggiornamento := :new.utente_aggiornamento;
            d_new_anagrafe_unita_fisiche.data_aggiornamento   := :new.data_aggiornamento;
            d_new_anagrafe_unita_fisiche.capienza             := :new.capienza;
            d_new_anagrafe_unita_fisiche.assegnabile          := :new.assegnabile;
            d_new_anagrafe_unita_fisiche.note                 := :new.note;
            d_new_anagrafe_unita_fisiche.numero_civico        := :new.numero_civico;
            d_new_anagrafe_unita_fisiche.esponente_civico_1   := :new.esponente_civico_1;
            d_new_anagrafe_unita_fisiche.esponente_civico_2   := :new.esponente_civico_2;
            d_new_anagrafe_unita_fisiche.tipo_civico          := :new.tipo_civico;
            d_new_anagrafe_unita_fisiche.id_documento         := :new.id_documento;
            d_new_anagrafe_unita_fisiche.link_planimetria     := :new.link_planimetria;
            d_new_anagrafe_unita_fisiche.immagine_planimetria := :new.immagine_planimetria;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_anagrafe_unita_fisiche.progr_unita_fisica   := :old.progr_unita_fisica;
            d_old_anagrafe_unita_fisiche.dal                  := :old.dal;
            d_old_anagrafe_unita_fisiche.codice_uf            := :old.codice_uf;
            d_old_anagrafe_unita_fisiche.denominazione        := :old.denominazione;
            d_old_anagrafe_unita_fisiche.denominazione_al1    := :old.denominazione_al1;
            d_old_anagrafe_unita_fisiche.denominazione_al2    := :old.denominazione_al2;
            d_old_anagrafe_unita_fisiche.des_abb              := :old.des_abb;
            d_old_anagrafe_unita_fisiche.des_abb_al1          := :old.des_abb_al1;
            d_old_anagrafe_unita_fisiche.des_abb_al2          := :old.des_abb_al2;
            d_old_anagrafe_unita_fisiche.indirizzo            := :old.indirizzo;
            d_old_anagrafe_unita_fisiche.cap                  := :old.cap;
            d_old_anagrafe_unita_fisiche.provincia            := :old.provincia;
            d_old_anagrafe_unita_fisiche.comune               := :old.comune;
            d_old_anagrafe_unita_fisiche.nota_indirizzo       := :old.nota_indirizzo;
            d_old_anagrafe_unita_fisiche.nota_indirizzo_al1   := :old.nota_indirizzo_al1;
            d_old_anagrafe_unita_fisiche.nota_indirizzo_al2   := :old.nota_indirizzo_al2;
            d_old_anagrafe_unita_fisiche.amministrazione      := :old.amministrazione;
            d_old_anagrafe_unita_fisiche.id_suddivisione      := :old.id_suddivisione;
            d_old_anagrafe_unita_fisiche.generico             := :old.generico;
            d_old_anagrafe_unita_fisiche.al                   := :old.al;
            d_old_anagrafe_unita_fisiche.utente_aggiornamento := :old.utente_aggiornamento;
            d_old_anagrafe_unita_fisiche.data_aggiornamento   := :old.data_aggiornamento;
            d_old_anagrafe_unita_fisiche.capienza             := :old.capienza;
            d_old_anagrafe_unita_fisiche.assegnabile          := :old.assegnabile;
            d_old_anagrafe_unita_fisiche.note                 := :old.note;
            d_old_anagrafe_unita_fisiche.numero_civico        := :old.numero_civico;
            d_old_anagrafe_unita_fisiche.esponente_civico_1   := :old.esponente_civico_1;
            d_old_anagrafe_unita_fisiche.esponente_civico_2   := :old.esponente_civico_2;
            d_old_anagrafe_unita_fisiche.tipo_civico          := :old.tipo_civico;
            d_old_anagrafe_unita_fisiche.id_documento         := :old.id_documento;
            d_old_anagrafe_unita_fisiche.link_planimetria     := :old.link_planimetria;
            d_old_anagrafe_unita_fisiche.immagine_planimetria := :old.immagine_planimetria;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_anagrafe_unita_fis(d_new_anagrafe_unita_fisiche
                                                                ,d_old_anagrafe_unita_fisiche
                                                                ,d_operazione);
      end;
   end if;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/



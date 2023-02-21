CREATE OR REPLACE TRIGGER unita_fisiche_tpe
/******************************************************************************
    NOME:        UNITA_FISICHE_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table UNITA_FISICHE
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on unita_fisiche
   for each row
declare
   d_new_unita_fisiche unita_fisiche_b%rowtype;
   d_old_unita_fisiche unita_fisiche_b%rowtype;
   d_operazione        varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_unita_fisiche.id_elemento_fisico    := :new.id_elemento_fisico;
            d_new_unita_fisiche.amministrazione       := :new.amministrazione;
            d_new_unita_fisiche.progr_unita_fisica    := :new.progr_unita_fisica;
            d_new_unita_fisiche.id_unita_fisica_padre := :new.id_unita_fisica_padre;
            d_new_unita_fisiche.sequenza              := :new.sequenza;
            d_new_unita_fisiche.dal                   := :new.dal;
            d_new_unita_fisiche.al                    := :new.al;
            d_new_unita_fisiche.utente_aggiornamento  := :new.utente_aggiornamento;
            d_new_unita_fisiche.data_aggiornamento    := :new.data_aggiornamento;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_unita_fisiche.id_elemento_fisico    := :old.id_elemento_fisico;
            d_old_unita_fisiche.amministrazione       := :old.amministrazione;
            d_old_unita_fisiche.progr_unita_fisica    := :old.progr_unita_fisica;
            d_old_unita_fisiche.id_unita_fisica_padre := :old.id_unita_fisica_padre;
            d_old_unita_fisiche.sequenza              := :old.sequenza;
            d_old_unita_fisiche.dal                   := :old.dal;
            d_old_unita_fisiche.al                    := :old.al;
            d_old_unita_fisiche.utente_aggiornamento  := :old.utente_aggiornamento;
            d_old_unita_fisiche.data_aggiornamento    := :old.data_aggiornamento;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_unita_fisica(d_new_unita_fisiche
                                                          ,d_old_unita_fisiche
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



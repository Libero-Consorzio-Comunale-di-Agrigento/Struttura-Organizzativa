CREATE OR REPLACE TRIGGER assegnazioni_fisiche_tpe
/******************************************************************************
    NOME:        ASSEGNAZIONI_FISICHE_TPE
    DESCRIZIONE: Trigger pe pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table ASSEGNAZIONI_FISICHE
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on assegnazioni_fisiche
   for each row
declare
   d_new_assegnazioni_fisiche assegnazioni_fisiche_b%rowtype;
   d_old_assegnazioni_fisiche assegnazioni_fisiche_b%rowtype;
   d_operazione               varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_assegnazioni_fisiche.id_asfi                   := :new.id_asfi;
            d_new_assegnazioni_fisiche.id_ubicazione_componente  := :new.id_ubicazione_componente;
            d_new_assegnazioni_fisiche.ni                        := :new.ni;
            d_new_assegnazioni_fisiche.progr_unita_fisica        := :new.progr_unita_fisica;
            d_new_assegnazioni_fisiche.dal                       := :new.dal;
            d_new_assegnazioni_fisiche.al                        := :new.al;
            d_new_assegnazioni_fisiche.progr_unita_organizzativa := :new.progr_unita_organizzativa;
            d_new_assegnazioni_fisiche.utente_aggiornamento      := :new.utente_aggiornamento;
            d_new_assegnazioni_fisiche.data_aggiornamento        := :new.data_aggiornamento;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_assegnazioni_fisiche.id_asfi                   := :old.id_asfi;
            d_old_assegnazioni_fisiche.id_ubicazione_componente  := :old.id_ubicazione_componente;
            d_old_assegnazioni_fisiche.ni                        := :old.ni;
            d_old_assegnazioni_fisiche.progr_unita_fisica        := :old.progr_unita_fisica;
            d_old_assegnazioni_fisiche.dal                       := :old.dal;
            d_old_assegnazioni_fisiche.al                        := :old.al;
            d_old_assegnazioni_fisiche.progr_unita_organizzativa := :old.progr_unita_organizzativa;
            d_old_assegnazioni_fisiche.utente_aggiornamento      := :old.utente_aggiornamento;
            d_old_assegnazioni_fisiche.data_aggiornamento        := :old.data_aggiornamento;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_assegnazione_fisica(d_new_assegnazioni_fisiche
                                                                 ,d_old_assegnazioni_fisiche
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



CREATE OR REPLACE TRIGGER unita_organizzative_tpe
/******************************************************************************
    NOME:        unita_organizzative_TPE
    DESCRIZIONE: Trigger for Set REFERENTIAL Integrity
                          at INSERT or UPDATE or DELETE on Table unita_organizzative
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on unita_organizzative
   for each row
declare
   d_new_unita_organizzative unita_organizzative_b%rowtype;
   d_old_unita_organizzative unita_organizzative_b%rowtype;
   d_operazione              varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_unita_organizzative.id_elemento               := :new.id_elemento;
            d_new_unita_organizzative.ottica                    := :new.ottica;
            d_new_unita_organizzative.revisione                 := :new.revisione;
            d_new_unita_organizzative.sequenza                  := :new.sequenza;
            d_new_unita_organizzative.progr_unita_organizzativa := :new.progr_unita_organizzativa;
            d_new_unita_organizzative.id_unita_padre            := :new.id_unita_padre;
            d_new_unita_organizzative.revisione_cessazione      := :new.revisione_cessazione;
            d_new_unita_organizzative.dal                       := :new.dal;
            d_new_unita_organizzative.al                        := :new.al;
            d_new_unita_organizzative.utente_aggiornamento      := :new.utente_aggiornamento;
            d_new_unita_organizzative.data_aggiornamento        := :new.data_aggiornamento;
            d_new_unita_organizzative.dal_pubb                  := :new.dal_pubb;
            d_new_unita_organizzative.al_pubb                   := :new.al_pubb;
            d_new_unita_organizzative.al_prec                   := :new.al_prec;
            d_new_unita_organizzative.revisione_cess_prec       := :new.revisione_cess_prec;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_unita_organizzative.id_elemento               := :old.id_elemento;
            d_old_unita_organizzative.ottica                    := :old.ottica;
            d_old_unita_organizzative.revisione                 := :old.revisione;
            d_old_unita_organizzative.sequenza                  := :old.sequenza;
            d_old_unita_organizzative.progr_unita_organizzativa := :old.progr_unita_organizzativa;
            d_old_unita_organizzative.id_unita_padre            := :old.id_unita_padre;
            d_old_unita_organizzative.revisione_cessazione      := :old.revisione_cessazione;
            d_old_unita_organizzative.dal                       := :old.dal;
            d_old_unita_organizzative.al                        := :old.al;
            d_old_unita_organizzative.utente_aggiornamento      := :old.utente_aggiornamento;
            d_old_unita_organizzative.data_aggiornamento        := :old.data_aggiornamento;
            d_old_unita_organizzative.dal_pubb                  := :old.dal_pubb;
            d_old_unita_organizzative.al_pubb                   := :old.al_pubb;
            d_old_unita_organizzative.al_prec                   := :old.al_prec;
            d_old_unita_organizzative.revisione_cess_prec       := :old.revisione_cess_prec;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_unita_organizzativa(d_new_unita_organizzative
                                                                 ,d_old_unita_organizzative
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



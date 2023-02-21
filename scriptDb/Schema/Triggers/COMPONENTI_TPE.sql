CREATE OR REPLACE TRIGGER componenti_tpe
/******************************************************************************
    NOME:        COMPONENTI_TPE
    DESCRIZIONE: Trigger di pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table COMPONENTI
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on componenti
   for each row
declare
   d_new_componenti componenti_b%rowtype;
   d_old_componenti componenti_b%rowtype;
   d_operazione     varchar2(1);

   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin
   begin
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
            ,'NO') = 'SI' then
         begin
            if inserting or updating then
               d_new_componenti.id_componente             := :new.id_componente;
               d_new_componenti.progr_unita_organizzativa := :new.progr_unita_organizzativa;
               d_new_componenti.dal                       := :new.dal;
               d_new_componenti.al                        := :new.al;
               d_new_componenti.ni                        := :new.ni;
               d_new_componenti.ci                        := :new.ci;
               d_new_componenti.denominazione             := :new.denominazione;
               d_new_componenti.denominazione_al1         := :new.denominazione_al1;
               d_new_componenti.denominazione_al2         := :new.denominazione_al2;
               d_new_componenti.stato                     := :new.stato;
               d_new_componenti.ottica                    := :new.ottica;
               d_new_componenti.revisione_assegnazione    := :new.revisione_assegnazione;
               d_new_componenti.revisione_cessazione      := :new.revisione_cessazione;
               d_new_componenti.utente_aggiornamento      := :new.utente_aggiornamento;
               d_new_componenti.data_aggiornamento        := :new.data_aggiornamento;
               d_new_componenti.codice_fiscale            := :new.codice_fiscale;
               d_new_componenti.dal_pubb                  := :new.dal_pubb;
               d_new_componenti.al_pubb                   := :new.al_pubb;
               d_new_componenti.al_prec                   := :new.al_prec;
            
               if inserting then
                  d_operazione := 'I';
               end if;
            end if;
            if updating or deleting then
               d_old_componenti.id_componente             := :old.id_componente;
               d_old_componenti.progr_unita_organizzativa := :old.progr_unita_organizzativa;
               d_old_componenti.dal                       := :old.dal;
               d_old_componenti.al                        := :old.al;
               d_old_componenti.ni                        := :old.ni;
               d_old_componenti.ci                        := :old.ci;
               d_old_componenti.denominazione             := :old.denominazione;
               d_old_componenti.denominazione_al1         := :old.denominazione_al1;
               d_old_componenti.denominazione_al2         := :old.denominazione_al2;
               d_old_componenti.stato                     := :old.stato;
               d_old_componenti.ottica                    := :old.ottica;
               d_old_componenti.revisione_assegnazione    := :old.revisione_assegnazione;
               d_old_componenti.revisione_cessazione      := :old.revisione_cessazione;
               d_old_componenti.utente_aggiornamento      := :old.utente_aggiornamento;
               d_old_componenti.data_aggiornamento        := :old.data_aggiornamento;
               d_old_componenti.codice_fiscale            := :old.codice_fiscale;
               d_old_componenti.dal_pubb                  := :old.dal_pubb;
               d_old_componenti.al_pubb                   := :old.al_pubb;
               d_old_componenti.al_prec                   := :old.al_prec;
            
               if updating then
                  d_operazione := 'U';
               else
                  d_operazione := 'D';
               end if;
            end if;
         
            if inserting or deleting or
               (updating and
               (d_old_componenti.id_componente <> :new.id_componente or
               d_old_componenti.progr_unita_organizzativa <>
               :new.progr_unita_organizzativa or d_old_componenti.dal <> :new.dal or
               d_old_componenti.al <> :new.al or d_old_componenti.ni <> :new.ni or
               d_old_componenti.ci <> :new.ci or
               d_old_componenti.denominazione <> :new.denominazione or
               d_old_componenti.denominazione_al1 <> :new.denominazione_al1 or
               d_old_componenti.denominazione_al2 <> :new.denominazione_al2 or
               d_old_componenti.stato <> :new.stato or
               d_old_componenti.ottica <> :new.ottica or
               d_old_componenti.revisione_assegnazione <> :new.revisione_assegnazione or
               d_old_componenti.revisione_cessazione <> :new.revisione_cessazione or
               d_old_componenti.utente_aggiornamento <> :new.utente_aggiornamento or
               d_old_componenti.data_aggiornamento <> :new.data_aggiornamento or
               d_old_componenti.codice_fiscale <> :new.codice_fiscale or
               d_old_componenti.dal_pubb <> :new.dal_pubb or
               d_old_componenti.al_pubb <> :new.al_pubb or
               d_old_componenti.al_prec <> :new.al_prec)) then
               
               so4_pubblicazione_modifiche.registra_componente(d_new_componenti
                                                              ,d_old_componenti
                                                              ,d_operazione);
            end if;
         
         end;
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



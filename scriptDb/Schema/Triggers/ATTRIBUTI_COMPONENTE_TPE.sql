CREATE OR REPLACE TRIGGER attributi_componente_tpe
/******************************************************************************
    NOME:        attributi_componente_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table attributi_componente
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on attributi_componente
   for each row
declare
   d_new_attributi_componente attributi_componente_b%rowtype;
   d_old_attributi_componente attributi_componente_b%rowtype;
   d_operazione               varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_attributi_componente.id_attr_componente      := :new.id_attr_componente;
            d_new_attributi_componente.id_componente           := :new.id_componente;
            d_new_attributi_componente.dal                     := :new.dal;
            d_new_attributi_componente.al                      := :new.al;
            d_new_attributi_componente.incarico                := :new.incarico;
            d_new_attributi_componente.telefono                := :new.telefono;
            d_new_attributi_componente.fax                     := :new.fax;
            d_new_attributi_componente.e_mail                  := :new.e_mail;
            d_new_attributi_componente.assegnazione_prevalente := :new.assegnazione_prevalente;
            d_new_attributi_componente.percentuale_impiego     := :new.percentuale_impiego;
            d_new_attributi_componente.ottica                  := :new.ottica;
            d_new_attributi_componente.revisione_assegnazione  := :new.revisione_assegnazione;
            d_new_attributi_componente.revisione_cessazione    := :new.revisione_cessazione;
            d_new_attributi_componente.utente_aggiornamento    := :new.utente_aggiornamento;
            d_new_attributi_componente.data_aggiornamento      := :new.data_aggiornamento;
            d_new_attributi_componente.gradazione              := :new.gradazione;
            d_new_attributi_componente.tipo_assegnazione       := :new.tipo_assegnazione;
            d_new_attributi_componente.voto                    := :new.voto;
            d_new_attributi_componente.dal_pubb                := :new.dal_pubb;
            d_new_attributi_componente.al_pubb                 := :new.al_pubb;
            d_new_attributi_componente.al_prec                 := :new.al_prec;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_attributi_componente.id_attr_componente      := :old.id_attr_componente;
            d_old_attributi_componente.id_componente           := :old.id_componente;
            d_old_attributi_componente.dal                     := :old.dal;
            d_old_attributi_componente.al                      := :old.al;
            d_old_attributi_componente.incarico                := :old.incarico;
            d_old_attributi_componente.telefono                := :old.telefono;
            d_old_attributi_componente.fax                     := :old.fax;
            d_old_attributi_componente.e_mail                  := :old.e_mail;
            d_old_attributi_componente.assegnazione_prevalente := :old.assegnazione_prevalente;
            d_old_attributi_componente.percentuale_impiego     := :old.percentuale_impiego;
            d_old_attributi_componente.ottica                  := :old.ottica;
            d_old_attributi_componente.revisione_assegnazione  := :old.revisione_assegnazione;
            d_old_attributi_componente.revisione_cessazione    := :old.revisione_cessazione;
            d_old_attributi_componente.utente_aggiornamento    := :old.utente_aggiornamento;
            d_old_attributi_componente.data_aggiornamento      := :old.data_aggiornamento;
            d_old_attributi_componente.gradazione              := :old.gradazione;
            d_old_attributi_componente.tipo_assegnazione       := :old.tipo_assegnazione;
            d_old_attributi_componente.voto                    := :old.voto;
            d_old_attributi_componente.dal_pubb                := :old.dal_pubb;
            d_old_attributi_componente.al_pubb                 := :old.al_pubb;
            d_old_attributi_componente.al_prec                 := :old.al_prec;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         if inserting or deleting or
            (updating and
            (d_old_attributi_componente.id_attr_componente <> :new.id_attr_componente or
            d_old_attributi_componente.id_componente <> :new.id_componente or
            d_old_attributi_componente.dal <> :new.dal or
            d_old_attributi_componente.al <> :new.al or
            d_old_attributi_componente.incarico <> :new.incarico or
            d_old_attributi_componente.telefono <> :new.telefono or
            d_old_attributi_componente.fax <> :new.fax or
            d_old_attributi_componente.e_mail <> :new.e_mail or
            d_old_attributi_componente.assegnazione_prevalente <>
            :new.assegnazione_prevalente or
            d_old_attributi_componente.percentuale_impiego <> :new.percentuale_impiego or
            d_old_attributi_componente.ottica <> :new.ottica or
            d_old_attributi_componente.revisione_assegnazione <>
            :new.revisione_assegnazione or d_old_attributi_componente.revisione_cessazione <>
            :new.revisione_cessazione or d_old_attributi_componente.utente_aggiornamento <>
            :new.utente_aggiornamento or
            d_old_attributi_componente.data_aggiornamento <> :new.data_aggiornamento or
            d_old_attributi_componente.gradazione <> :new.gradazione or
            d_old_attributi_componente.tipo_assegnazione <> :new.tipo_assegnazione or
            d_old_attributi_componente.voto <> :new.voto or
            d_old_attributi_componente.dal_pubb <> :new.dal_pubb or
            d_old_attributi_componente.al_pubb <> :new.al_pubb or
            d_old_attributi_componente.al_prec <> :new.al_prec)) then
            
            so4_pubblicazione_modifiche.registra_attributo_componente(d_new_attributi_componente
                                                                     ,d_old_attributi_componente
                                                                     ,d_operazione);
         end if;
      
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



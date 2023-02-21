CREATE OR REPLACE TRIGGER anagrafe_unita_organizzati_tpe
/******************************************************************************
    NOME:        ANAGRAFE_UNITA_ORGANIZZATIVE_TPE
    DESCRIZIONE: Trigger for Set REFERENTIAL Integrity
                          at INSERT or UPDATE or DELETE on Table ANAGRAFE_UNITA_ORGANIZZATIVE
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Generato in automatico.
   ******************************************************************************/
   after insert or update or delete on anagrafe_unita_organizzative
   for each row
declare
   d_new_anagrafe_unita_org anagrafe_unita_organizzative_b%rowtype;
   d_old_anagrafe_unita_org anagrafe_unita_organizzative_b%rowtype;
   d_operazione                  varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_anagrafe_unita_org.progr_unita_organizzativa := :new.progr_unita_organizzativa;
            d_new_anagrafe_unita_org.dal                       := :new.dal;
            d_new_anagrafe_unita_org.codice_uo                 := :new.codice_uo;
            d_new_anagrafe_unita_org.descrizione               := :new.descrizione;
            d_new_anagrafe_unita_org.descrizione_al1           := :new.descrizione_al1;
            d_new_anagrafe_unita_org.descrizione_al2           := :new.descrizione_al2;
            d_new_anagrafe_unita_org.des_abb                   := :new.des_abb;
            d_new_anagrafe_unita_org.des_abb_al1               := :new.des_abb_al1;
            d_new_anagrafe_unita_org.des_abb_al2               := :new.des_abb_al2;
            d_new_anagrafe_unita_org.id_suddivisione           := :new.id_suddivisione;
            d_new_anagrafe_unita_org.ottica                    := :new.ottica;
            d_new_anagrafe_unita_org.revisione_istituzione     := :new.revisione_istituzione;
            d_new_anagrafe_unita_org.revisione_cessazione      := :new.revisione_cessazione;
            d_new_anagrafe_unita_org.tipologia_unita           := :new.tipologia_unita;
            d_new_anagrafe_unita_org.se_giuridico              := :new.se_giuridico;
            d_new_anagrafe_unita_org.assegnazione_componenti   := :new.assegnazione_componenti;
            d_new_anagrafe_unita_org.amministrazione           := :new.amministrazione;
            d_new_anagrafe_unita_org.progr_aoo                 := :new.progr_aoo;
            d_new_anagrafe_unita_org.indirizzo                 := :new.indirizzo;
            d_new_anagrafe_unita_org.cap                       := :new.cap;
            d_new_anagrafe_unita_org.provincia                 := :new.provincia;
            d_new_anagrafe_unita_org.comune                    := :new.comune;
            d_new_anagrafe_unita_org.telefono                  := :new.telefono;
            d_new_anagrafe_unita_org.fax                       := :new.fax;
            d_new_anagrafe_unita_org.centro                    := :new.centro;
            d_new_anagrafe_unita_org.centro_responsabilita     := :new.centro_responsabilita;
            d_new_anagrafe_unita_org.al                        := :new.al;
            d_new_anagrafe_unita_org.utente_ad4                := :new.utente_ad4;
            d_new_anagrafe_unita_org.utente_aggiornamento      := :new.utente_aggiornamento;
            d_new_anagrafe_unita_org.data_aggiornamento        := :new.data_aggiornamento;
            d_new_anagrafe_unita_org.note                      := :new.note;
            d_new_anagrafe_unita_org.tipo_unita                := :new.tipo_unita;
            d_new_anagrafe_unita_org.dal_pubb                  := :new.dal_pubb;
            d_new_anagrafe_unita_org.al_pubb                   := :new.al_pubb;
            d_new_anagrafe_unita_org.al_prec                   := :new.al_prec;
            d_new_anagrafe_unita_org.incarico_resp             := :new.incarico_resp;
            d_new_anagrafe_unita_org.etichetta                 := :new.etichetta;
            d_new_anagrafe_unita_org.aggregatore               := :new.aggregatore;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_anagrafe_unita_org.progr_unita_organizzativa := :old.progr_unita_organizzativa;
            d_old_anagrafe_unita_org.dal                       := :old.dal;
            d_old_anagrafe_unita_org.codice_uo                 := :old.codice_uo;
            d_old_anagrafe_unita_org.descrizione               := :old.descrizione;
            d_old_anagrafe_unita_org.descrizione_al1           := :old.descrizione_al1;
            d_old_anagrafe_unita_org.descrizione_al2           := :old.descrizione_al2;
            d_old_anagrafe_unita_org.des_abb                   := :old.des_abb;
            d_old_anagrafe_unita_org.des_abb_al1               := :old.des_abb_al1;
            d_old_anagrafe_unita_org.des_abb_al2               := :old.des_abb_al2;
            d_old_anagrafe_unita_org.id_suddivisione           := :old.id_suddivisione;
            d_old_anagrafe_unita_org.ottica                    := :old.ottica;
            d_old_anagrafe_unita_org.revisione_istituzione     := :old.revisione_istituzione;
            d_old_anagrafe_unita_org.revisione_cessazione      := :old.revisione_cessazione;
            d_old_anagrafe_unita_org.tipologia_unita           := :old.tipologia_unita;
            d_old_anagrafe_unita_org.se_giuridico              := :old.se_giuridico;
            d_old_anagrafe_unita_org.assegnazione_componenti   := :old.assegnazione_componenti;
            d_old_anagrafe_unita_org.amministrazione           := :old.amministrazione;
            d_old_anagrafe_unita_org.progr_aoo                 := :old.progr_aoo;
            d_old_anagrafe_unita_org.indirizzo                 := :old.indirizzo;
            d_old_anagrafe_unita_org.cap                       := :old.cap;
            d_old_anagrafe_unita_org.provincia                 := :old.provincia;
            d_old_anagrafe_unita_org.comune                    := :old.comune;
            d_old_anagrafe_unita_org.telefono                  := :old.telefono;
            d_old_anagrafe_unita_org.fax                       := :old.fax;
            d_old_anagrafe_unita_org.centro                    := :old.centro;
            d_old_anagrafe_unita_org.centro_responsabilita     := :old.centro_responsabilita;
            d_old_anagrafe_unita_org.al                        := :old.al;
            d_old_anagrafe_unita_org.utente_ad4                := :old.utente_ad4;
            d_old_anagrafe_unita_org.utente_aggiornamento      := :old.utente_aggiornamento;
            d_old_anagrafe_unita_org.data_aggiornamento        := :old.data_aggiornamento;
            d_old_anagrafe_unita_org.note                      := :old.note;
            d_old_anagrafe_unita_org.tipo_unita                := :old.tipo_unita;
            d_old_anagrafe_unita_org.dal_pubb                  := :old.dal_pubb;
            d_old_anagrafe_unita_org.al_pubb                   := :old.al_pubb;
            d_old_anagrafe_unita_org.al_prec                   := :old.al_prec;
            d_old_anagrafe_unita_org.incarico_resp             := :old.incarico_resp;
            d_old_anagrafe_unita_org.etichetta                 := :old.etichetta;
            d_old_anagrafe_unita_org.aggregatore               := :old.aggregatore;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_anagrafe_unita_org(d_new_anagrafe_unita_org
                                                                ,d_old_anagrafe_unita_org
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



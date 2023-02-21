CREATE OR REPLACE TRIGGER revisioni_struttura_tpe
/******************************************************************************
    NOME:        revisioni_struttura_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table revisioni_struttura
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on revisioni_struttura
   for each row
declare
   d_new_revisioni_struttura revisioni_struttura_b%rowtype;
   d_old_revisioni_struttura revisioni_struttura_b%rowtype;
   d_operazione              varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_revisioni_struttura.ottica               := :new.ottica;
            d_new_revisioni_struttura.revisione            := :new.revisione;
            d_new_revisioni_struttura.tipo_registro        := :new.tipo_registro;
            d_new_revisioni_struttura.anno                 := :new.anno;
            d_new_revisioni_struttura.numero               := :new.numero;
            d_new_revisioni_struttura.data                 := :new.data;
            d_new_revisioni_struttura.descrizione          := :new.descrizione;
            d_new_revisioni_struttura.descrizione_al1      := :new.descrizione_al1;
            d_new_revisioni_struttura.descrizione_al2      := :new.descrizione_al2;
            d_new_revisioni_struttura.dal                  := :new.dal;
            d_new_revisioni_struttura.nota                 := :new.nota;
            d_new_revisioni_struttura.stato                := :new.stato;
            d_new_revisioni_struttura.provenienza          := :new.provenienza;
            d_new_revisioni_struttura.utente_aggiornamento := :new.utente_aggiornamento;
            d_new_revisioni_struttura.data_aggiornamento   := :new.data_aggiornamento;
            d_new_revisioni_struttura.data_pubblicazione   := :new.data_pubblicazione;
            d_new_revisioni_struttura.tipo_revisione       := :new.tipo_revisione;
            d_new_revisioni_struttura.data_termine         := :new.data_termine;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_revisioni_struttura.ottica               := :old.ottica;
            d_old_revisioni_struttura.revisione            := :old.revisione;
            d_old_revisioni_struttura.tipo_registro        := :old.tipo_registro;
            d_old_revisioni_struttura.anno                 := :old.anno;
            d_old_revisioni_struttura.numero               := :old.numero;
            d_old_revisioni_struttura.data                 := :old.data;
            d_old_revisioni_struttura.descrizione          := :old.descrizione;
            d_old_revisioni_struttura.descrizione_al1      := :old.descrizione_al1;
            d_old_revisioni_struttura.descrizione_al2      := :old.descrizione_al2;
            d_old_revisioni_struttura.dal                  := :old.dal;
            d_old_revisioni_struttura.nota                 := :old.nota;
            d_old_revisioni_struttura.stato                := :old.stato;
            d_old_revisioni_struttura.provenienza          := :old.provenienza;
            d_old_revisioni_struttura.utente_aggiornamento := :old.utente_aggiornamento;
            d_old_revisioni_struttura.data_aggiornamento   := :old.data_aggiornamento;
            d_old_revisioni_struttura.data_pubblicazione   := :old.data_pubblicazione;
            d_old_revisioni_struttura.tipo_revisione       := :old.tipo_revisione;
            d_old_revisioni_struttura.data_termine         := :old.data_termine;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_revisione_struttura(d_new_revisioni_struttura
                                                                 ,d_old_revisioni_struttura
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



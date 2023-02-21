CREATE OR REPLACE FORCE VIEW VISTA_ATCO_GRAILS
(ID_COMPONENTE, DAL, AL, ID_ATTR_COMPONENTE, INCARICO, 
 DES_INCARICO, RESPONSABILE, ORDINAMENTO, TELEFONO, E_MAIL, 
 FAX, ASSEGNAZIONE_PREVALENTE, PERCENTUALE_IMPIEGO, REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, GRADAZIONE, TIPO_ASSEGNAZIONE, ASSEGNAZIONE_PREVALENTE_CHAR)
BEQUEATH DEFINER
AS 
select a.id_componente
      ,a.dal
      ,decode(nvl(a.revisione_cessazione, -2)
             ,r.revisione_modifica
             ,a.al_prec  --#547
             ,a.al) al
      ,a.id_attr_componente
      ,a.incarico
      ,tipo_incarico.get_descrizione(a.incarico) des_incarico
      ,tipo_incarico.get_responsabile(a.incarico) responsabile
      ,tipo_incarico.get_ordinamento(a.incarico) ordinamento
      ,a.telefono
      ,a.e_mail
      ,a.fax
      ,nvl(a.assegnazione_prevalente, 1) assegnazione_prevalente
      ,a.percentuale_impiego
      ,a.revisione_assegnazione
      ,a.revisione_cessazione
      ,a.utente_aggiornamento
      ,a.data_aggiornamento
      ,a.gradazione
      ,nvl(a.tipo_assegnazione,'I')
      ,to_char(nvl(a.assegnazione_prevalente, 1)) assegnazione_prevalente_char
  from revisioni_modifica   r --#558
      ,attributi_componente a
 where nvl(a.revisione_assegnazione, -2) != r.revisione_modifica
   and a.dal <= nvl(a.al, to_date(3333333, 'j'))
   and r.ottica = a.ottica;



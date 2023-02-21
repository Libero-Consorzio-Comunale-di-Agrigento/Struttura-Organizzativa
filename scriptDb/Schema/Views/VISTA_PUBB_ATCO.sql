CREATE OR REPLACE FORCE VIEW VISTA_PUBB_ATCO
(ID_ATTR_COMPONENTE, ID_COMPONENTE, DAL, AL, INCARICO, 
 TELEFONO, FAX, E_MAIL, ASSEGNAZIONE_PREVALENTE, PERCENTUALE_IMPIEGO, 
 OTTICA, REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, 
 GRADAZIONE, TIPO_ASSEGNAZIONE, VOTO)
BEQUEATH DEFINER
AS 
select id_attr_componente
     , id_componente
     , dal_pubb dal
     , al_pubb al
     , incarico
     , telefono
     , fax
     , e_mail
     , assegnazione_prevalente
     , percentuale_impiego
     , a.ottica
     , revisione_assegnazione
     , revisione_cessazione
     , utente_aggiornamento
     , data_aggiornamento
     , gradazione
     , tipo_assegnazione
     , voto
  from revisioni_modifica  r
      ,attributi_componente a
 where nvl(a.revisione_assegnazione, -2) <> r.revisione_modifica
   and r.ottica = a.ottica
   and dal_pubb <= nvl(al_pubb,to_date(3333333,'j'));



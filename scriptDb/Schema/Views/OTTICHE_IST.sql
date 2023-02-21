CREATE OR REPLACE FORCE VIEW OTTICHE_IST
(OTTICA, DESCR_OTTICA, AMMINISTRAZIONE, DESCR_AMMINISTRAZIONE)
BEQUEATH DEFINER
AS 
select o.ottica
     , o.descrizione descr_ottica
     , o.amministrazione
     , soggetti_get_descr (a.ni, trunc(sysdate), 'DESCRIZIONE') descr_amministrazione
  from ottiche o, amministrazioni a
 where ottica_istituzionale = 'SI'
   and o.amministrazione = a.codice_amministrazione;



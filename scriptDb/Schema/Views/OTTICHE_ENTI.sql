CREATE OR REPLACE FORCE VIEW OTTICHE_ENTI
(OTTICA, DESCRIZIONE, AMMINISTRAZIONE, DENOMINAZIONE, OTTICA_ISTITUZIONALE, 
 GESTIONE_REVISIONI)
BEQUEATH DEFINER
AS 
select o.ottica
     , o.descrizione
	 , o.amministrazione
	 , soggetti_get_descr(a.ni,trunc(sysdate),'DESCRIZIONE') denominazione
	 , ottica_istituzionale
	 , gestione_revisioni
  from ottiche o
     , amministrazioni a
 where o.amministrazione = a.codice_amministrazione
   and a.ente = 'SI';



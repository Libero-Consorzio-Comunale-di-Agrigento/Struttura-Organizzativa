CREATE OR REPLACE package p00_classi_rapporto_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        classi_rapporto_tpk
 DESCRIZIONE: Gestione tabella CLASSI_RAPPORTO.
 ANNOTAZIONI: Versione sostitutiva da installare in assenza di integrazione
              con applicativi GP4 - GPs
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    13/01/2012  VDavalli    Prima emissione.
 </CODE>
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'CLASSI_RAPPORTO';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
   return varchar2;
   pragma restrict_references( versione, WNDS );
-- Getter per attributo componente di riga identificata da chiave
   function get_componente /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_componente, WNDS );
end p00_classi_rapporto_tpk;
/


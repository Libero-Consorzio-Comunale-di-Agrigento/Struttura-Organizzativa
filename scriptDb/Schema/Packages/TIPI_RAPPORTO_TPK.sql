CREATE OR REPLACE package tipi_rapporto_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        tipi_rapporto_tpk
 DESCRIZIONE: Gestione tabella TIPI_RAPPORTO.
 ANNOTAZIONI: .
 REVISIONI:   Table Revision: 06/09/2011 14:04:26
              SiaPKGen Revision: V1.05.014.
              SiaTPKDeclare Revision: V1.17.001.
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    12/10/2012  ADADAMO     Versione fake del pkg per forzarare funzionamento
                               in caso di mancata integrazione con GP4
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'TIPI_RAPPORTO';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
   return varchar2;
   pragma restrict_references( versione, WNDS );
-- Getter per attributo sequenza di riga identificata da chiave
   function get_sequenza /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return number;
   pragma restrict_references( get_sequenza, WNDS );
-- Getter per attributo descrizione di riga identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_descrizione, WNDS );
-- Getter per attributo descrizione_al1 di riga identificata da chiave
   function get_descrizione_al1 /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_descrizione_al1, WNDS );
-- Getter per attributo descrizione_al2 di riga identificata da chiave
   function get_descrizione_al2 /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_descrizione_al2, WNDS );
-- Getter per attributo stampa_certificato di riga identificata da chiave
   function get_stampa_certificato /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_stampa_certificato, WNDS );
-- Getter per attributo note di riga identificata da chiave
   function get_note /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_note, WNDS );
-- Getter per attributo conto_annuale di riga identificata da chiave
   function get_conto_annuale /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return number;
   pragma restrict_references( get_conto_annuale, WNDS );
-- Getter per attributo data_cessazione di riga identificata da chiave
   function get_data_cessazione /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return date;
   pragma restrict_references( get_data_cessazione, WNDS );
end tipi_rapporto_tpk;
/


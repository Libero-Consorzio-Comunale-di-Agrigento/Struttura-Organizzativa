CREATE OR REPLACE package posizioni_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        posizioni_tpk
 DESCRIZIONE: Gestione tabella POSIZIONI.
 ANNOTAZIONI: .
 REVISIONI:   Table Revision: 20/05/2010 17:11:32
              SiaPKGen Revision: V1.03.012.
              SiaTPKDeclare Revision: V1.17.001.
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    16/06/2009  ftassinari  Prima emissione.
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.04';
   s_table_name constant AFC.t_object_name := 'POSIZIONI';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
   return varchar2;
   pragma restrict_references( versione, WNDS );
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
-- Getter per attributo sequenza di riga identificata da chiave
   function get_sequenza /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return number;
   pragma restrict_references( get_sequenza, WNDS );
-- Getter per attributo posizione di riga identificata da chiave
   function get_posizione /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_posizione, WNDS );
-- Getter per attributo ruolo di riga identificata da chiave
   function get_ruolo /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_ruolo, WNDS );
-- Getter per attributo stagionale di riga identificata da chiave
   function get_stagionale /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_stagionale, WNDS );
-- Getter per attributo contratto_formazione di riga identificata da chiave
   function get_contratto_formazione /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_contratto_formazione, WNDS );
-- Getter per attributo tempo_determinato di riga identificata da chiave
   function get_tempo_determinato /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_tempo_determinato, WNDS );
-- Getter per attributo part_time di riga identificata da chiave
   function get_part_time /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_part_time, WNDS );
-- Getter per attributo copertura_part_time di riga identificata da chiave
   function get_copertura_part_time /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_copertura_part_time, WNDS );
-- Getter per attributo tipo_part_time di riga identificata da chiave
   function get_tipo_part_time /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_tipo_part_time, WNDS );
-- Getter per attributo di_ruolo di riga identificata da chiave
   function get_di_ruolo /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_di_ruolo, WNDS );
-- Getter per attributo tipo_formazione di riga identificata da chiave
   function get_tipo_formazione /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_tipo_formazione, WNDS );
-- Getter per attributo tipo_determinato di riga identificata da chiave
   function get_tipo_determinato /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_tipo_determinato, WNDS );
-- Getter per attributo universitario di riga identificata da chiave
   function get_universitario /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_universitario, WNDS );
-- Getter per attributo collaboratore di riga identificata da chiave
   function get_collaboratore /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_collaboratore, WNDS );
-- Getter per attributo lsu di riga identificata da chiave
   function get_lsu /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_lsu, WNDS );
-- Getter per attributo ruolo_do di riga identificata da chiave
   function get_ruolo_do /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_ruolo_do, WNDS );
-- Getter per attributo contratto_opera di riga identificata da chiave
   function get_contratto_opera /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_contratto_opera, WNDS );
-- Getter per attributo sovrannumero di riga identificata da chiave
   function get_sovrannumero /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_sovrannumero, WNDS );
-- Getter per attributo amm_cons di riga identificata da chiave
   function get_amm_cons /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_amm_cons, WNDS );
-- Getter per attributo tipologia_contrattuale di riga identificata da chiave
   function get_tipologia_contrattuale /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_tipologia_contrattuale, WNDS );
-- Getter per attributo vortale di riga identificata da chiave
   function get_vortale /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_vortale, WNDS );
-- Getter per attributo interinale di riga identificata da chiave
   function get_interinale /* SLAVE_COPY */
   (
     p_codice  in varchar2
   ) return varchar2;
   pragma restrict_references( get_interinale, WNDS );
end posizioni_tpk;
/


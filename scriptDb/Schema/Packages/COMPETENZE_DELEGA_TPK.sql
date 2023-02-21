CREATE OR REPLACE package competenze_delega_tpk is /* MASTER_LINK */
/******************************************************************************
 NOME:        competenze_delega_tpk
 DESCRIZIONE: Gestione tabella COMPETENZE_DELEGA.
 ANNOTAZIONI: .
 REVISIONI:   Table Revision: 07/03/2018 12:08:21
              SiaPKGen Revision: V1.05.014.
              SiaTPKDeclare Revision: V1.17.001.
 <CODE>
 Rev.  Data        Autore      Descrizione.
    00    23/11/2017  MMonari  Generazione automatica.
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione    CONSTANT afc.t_revision := 'V1.00';
   s_table_name   CONSTANT afc.t_object_name := 'COMPETENZE_DELEGA';
   SUBTYPE t_rowtype IS competenze_delega%ROWTYPE;
   -- Tipo del record primary key
   SUBTYPE t_id_competenza_delega IS competenze_delega.id_competenza_delega%TYPE;
   TYPE t_pk IS RECORD (id_competenza_delega t_id_competenza_delega);
   -- Versione e revisione
   FUNCTION versione                                          /* SLAVE_COPY */
      RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (versione, WNDS);
   -- Costruttore di record chiave
   FUNCTION pk                                                /* SLAVE_COPY */
               (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN t_pk;
   PRAGMA RESTRICT_REFERENCES (pk, WNDS);
   -- Controllo integrita chiave
   FUNCTION can_handle                                        /* SLAVE_COPY */
                       (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES (can_handle, WNDS);
   -- Controllo integrita chiave
   -- wrapper boolean
   FUNCTION canhandle                                         /* SLAVE_COPY */
                      (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN BOOLEAN;
   PRAGMA RESTRICT_REFERENCES (canhandle, WNDS);
   -- Esistenza riga con chiave indicata
   FUNCTION exists_id                                         /* SLAVE_COPY */
                      (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES (exists_id, WNDS);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   FUNCTION existsid                                          /* SLAVE_COPY */
                     (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN BOOLEAN;
   PRAGMA RESTRICT_REFERENCES (existsid, WNDS);
   -- Inserimento di una riga
   PROCEDURE ins (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_codice                 IN competenze_delega.codice%TYPE,
      p_descrizione            IN competenze_delega.descrizione%TYPE,
      p_id_applicativo         IN competenze_delega.id_applicativo%TYPE,
      p_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL);
   FUNCTION ins /*+ SOA  */
                (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_codice                 IN competenze_delega.codice%TYPE,
      p_descrizione            IN competenze_delega.descrizione%TYPE,
      p_id_applicativo         IN competenze_delega.id_applicativo%TYPE,
      p_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL)
      RETURN NUMBER;
   -- Aggiornamento di una riga
   PROCEDURE upd /*+ SOA  */
                 (
      p_check_old                  IN INTEGER DEFAULT 0,
      p_new_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_old_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE DEFAULT NULL,
      p_new_codice                 IN competenze_delega.codice%TYPE DEFAULT afc.default_null (
                                                                               'competenze_delega.codice'),
      p_old_codice                 IN competenze_delega.codice%TYPE DEFAULT NULL,
      p_new_descrizione            IN competenze_delega.descrizione%TYPE DEFAULT afc.default_null (
                                                                                    'competenze_delega.descrizione'),
      p_old_descrizione            IN competenze_delega.descrizione%TYPE DEFAULT NULL,
      p_new_id_applicativo         IN competenze_delega.id_applicativo%TYPE DEFAULT afc.default_null (
                                                                                       'competenze_delega.id_applicativo'),
      p_old_id_applicativo         IN competenze_delega.id_applicativo%TYPE DEFAULT NULL,
      p_new_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT afc.default_null (
                                                                                      'competenze_delega.fine_validita'),
      p_old_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL);
   -- Aggiornamento del campo di una riga
   PROCEDURE upd_column (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_column                 IN VARCHAR2,
      p_value                  IN VARCHAR2 DEFAULT NULL,
      p_literal_value          IN NUMBER DEFAULT 1);
   PROCEDURE upd_column (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_column                 IN VARCHAR2,
      p_value                  IN DATE);
   -- Cancellazione di una riga
   PROCEDURE del /*+ SOA  */
                 (
      p_check_old              IN INTEGER DEFAULT 0,
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_codice                 IN competenze_delega.codice%TYPE DEFAULT NULL,
      p_descrizione            IN competenze_delega.descrizione%TYPE DEFAULT NULL,
      p_id_applicativo         IN competenze_delega.id_applicativo%TYPE DEFAULT NULL,
      p_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL);
   -- Getter per attributo descrizione di riga identificata da chiave
   FUNCTION get_codice                                        /* SLAVE_COPY */
                       (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.codice%TYPE;
   PRAGMA RESTRICT_REFERENCES (get_codice, WNDS);
   -- Getter per attributo descrizione di riga identificata da chiave
   FUNCTION get_descrizione                                   /* SLAVE_COPY */
                            (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.descrizione%TYPE;
   PRAGMA RESTRICT_REFERENCES (get_descrizione, WNDS);
   -- Getter per attributo descrizione di riga identificata da chiave
   FUNCTION get_id_applicativo                                /* SLAVE_COPY */
                               (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.id_applicativo%TYPE;
   PRAGMA RESTRICT_REFERENCES (get_id_applicativo, WNDS);
   -- Getter per attributo fine_validita di riga identificata da chiave
   FUNCTION get_fine_validita                                 /* SLAVE_COPY */
                              (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.fine_validita%TYPE;
   PRAGMA RESTRICT_REFERENCES (get_fine_validita, WNDS);
   -- Setter per attributo codice di riga identificata da chiave
   PROCEDURE set_id_competenza_delega (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.id_competenza_delega%TYPE DEFAULT NULL);
   -- Setter per attributo descrizione di riga identificata da chiave
   PROCEDURE set_codice (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.codice%TYPE DEFAULT NULL);
   -- Setter per attributo descrizione di riga identificata da chiave
   PROCEDURE set_descrizione (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.descrizione%TYPE DEFAULT NULL);
   -- Setter per attributo descrizione di riga identificata da chiave
   PROCEDURE set_id_applicativo (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.id_applicativo%TYPE DEFAULT NULL);
   -- Setter per attributo fine_validita di riga identificata da chiave
   PROCEDURE set_fine_validita (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.fine_validita%TYPE DEFAULT NULL);
   -- where_condition per statement di ricerca
   FUNCTION where_condition                                   /* SLAVE_COPY */
                            (
      p_qbe                    IN NUMBER DEFAULT 0,
      p_other_condition        IN VARCHAR2 DEFAULT NULL,
      p_id_competenza_delega   IN NUMBER DEFAULT NULL,
      p_codice                 IN VARCHAR2 DEFAULT NULL,
      p_descrizione            IN VARCHAR2 DEFAULT NULL,
      p_id_applicativo         IN NUMBER DEFAULT NULL,
      p_fine_validita          IN VARCHAR2 DEFAULT NULL)
      RETURN afc.t_statement;
   -- righe corrispondenti alla selezione indicata
   FUNCTION get_rows /*+ SOA  */
                    /* SLAVE_COPY */
   (p_qbe                    IN NUMBER DEFAULT 0,
    p_other_condition        IN VARCHAR2 DEFAULT NULL,
    p_order_by               IN VARCHAR2 DEFAULT NULL,
    p_extra_columns          IN VARCHAR2 DEFAULT NULL,
    p_extra_condition        IN VARCHAR2 DEFAULT NULL,
    p_id_competenza_delega   IN NUMBER DEFAULT NULL,
    p_codice                 IN VARCHAR2 DEFAULT NULL,
    p_descrizione            IN VARCHAR2 DEFAULT NULL,
    p_id_applicativo         IN NUMBER DEFAULT NULL,
    p_fine_validita          IN VARCHAR2 DEFAULT NULL)
      RETURN afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   FUNCTION count_rows                                        /* SLAVE_COPY */
                       (p_qbe                    IN NUMBER DEFAULT 0,
                        p_other_condition        IN VARCHAR2 DEFAULT NULL,
                        p_id_competenza_delega   IN NUMBER DEFAULT NULL,
                        p_codice                 IN VARCHAR2 DEFAULT NULL,
                        p_descrizione            IN VARCHAR2 DEFAULT NULL,
                        p_id_applicativo         IN NUMBER DEFAULT NULL,
                        p_fine_validita          IN VARCHAR2 DEFAULT NULL)
      RETURN INTEGER;
END competenze_delega_tpk;
/


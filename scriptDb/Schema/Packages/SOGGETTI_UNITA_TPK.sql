CREATE OR REPLACE PACKAGE soggetti_unita_tpk
IS
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        soggetti_unita_tpk
    DESCRIZIONE: Gestione tabella SOGGETTI_UNITA.
    ANNOTAZIONI: .
    REVISIONI:   Table Revision:
                 SiaPKGen Revision: .
                 SiaTPKDeclare Revision: .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    06/12/2017  SO4  Generazione automatica.
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione     CONSTANT afc.t_revision := 'V1.00';
   s_table_name    CONSTANT afc.t_object_name := 'SOGGETTI_UNITA';

   SUBTYPE t_rowtype IS soggetti_unita%ROWTYPE;

   -- Tipo del record primary key
   SUBTYPE t_progr_unita_organizzativa IS soggetti_unita.progr_unita_organizzativa%TYPE;

   TYPE t_pk
      IS RECORD (progr_unita_organizzativa t_progr_unita_organizzativa);

   -- Versione e revisione
   FUNCTION versione                                          /* SLAVE_COPY */
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (versione, WNDS);

   -- Costruttore di record chiave
   FUNCTION pk                                                /* SLAVE_COPY */
               (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN t_pk;

   PRAGMA RESTRICT_REFERENCES (pk, WNDS);

   -- Controllo integrita chiave
   FUNCTION can_handle                                        /* SLAVE_COPY */
                       (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (can_handle, WNDS);

   -- Controllo integrita chiave
   -- wrapper boolean
   FUNCTION canhandle                                         /* SLAVE_COPY */
                      (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN BOOLEAN;

   PRAGMA RESTRICT_REFERENCES (canhandle, WNDS);

   -- Esistenza riga con chiave indicata
   FUNCTION exists_id                                         /* SLAVE_COPY */
                      (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (exists_id, WNDS);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   FUNCTION existsid                                          /* SLAVE_COPY */
                     (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN BOOLEAN;

   PRAGMA RESTRICT_REFERENCES (existsid, WNDS);

   -- Inserimento di una riga
   PROCEDURE ins (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL,
      p_ni                          IN soggetti_unita.ni%TYPE);

   FUNCTION ins /*+ SOA  */
                (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL,
      p_ni                          IN soggetti_unita.ni%TYPE)
      RETURN NUMBER;

   -- Aggiornamento di una riga
   PROCEDURE upd /*+ SOA  */
                 (
      p_check_old                      IN INTEGER DEFAULT 0,
      p_new_progr_unita_organizzativ   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_old_progr_unita_organizzativ   IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL,
      p_new_ni                         IN soggetti_unita.ni%TYPE DEFAULT afc.default_null (
                                                                            'SOGGETTI_UNITA.ni'),
      p_old_ni                         IN soggetti_unita.ni%TYPE DEFAULT NULL);

   -- Aggiornamento del campo di una riga
   PROCEDURE upd_column (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_column                      IN VARCHAR2,
      p_value                       IN VARCHAR2 DEFAULT NULL,
      p_literal_value               IN NUMBER DEFAULT 1);

   -- Cancellazione di una riga
   PROCEDURE del /*+ SOA  */
                 (
      p_check_old                   IN INTEGER DEFAULT 0,
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_ni                          IN soggetti_unita.ni%TYPE DEFAULT NULL);

   -- Getter per attributo ni di riga identificata da chiave
   FUNCTION get_ni                                            /* SLAVE_COPY */
                   (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN soggetti_unita.ni%TYPE;

   PRAGMA RESTRICT_REFERENCES (get_ni, WNDS);

   -- Setter per attributo progr_unita_organizzativa di riga identificata da chiave
   PROCEDURE set_progr_unita_organizzativa (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_value                       IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL);

   -- Setter per attributo ni di riga identificata da chiave
   PROCEDURE set_ni (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_value                       IN soggetti_unita.ni%TYPE DEFAULT NULL);

   -- where_condition per statement di ricerca
   FUNCTION where_condition                                   /* SLAVE_COPY */
                            (
      p_qbe                         IN NUMBER DEFAULT 0,
      p_other_condition             IN VARCHAR2 DEFAULT NULL,
      p_progr_unita_organizzativa   IN VARCHAR2 DEFAULT NULL,
      p_ni                          IN VARCHAR2 DEFAULT NULL)
      RETURN afc.t_statement;

   -- righe corrispondenti alla selezione indicata
   FUNCTION get_rows /*+ SOA  */
                                                              /* SLAVE_COPY */
                     (p_qbe                         IN NUMBER DEFAULT 0,
                      p_other_condition             IN VARCHAR2 DEFAULT NULL,
                      p_order_by                    IN VARCHAR2 DEFAULT NULL,
                      p_extra_columns               IN VARCHAR2 DEFAULT NULL,
                      p_extra_condition             IN VARCHAR2 DEFAULT NULL,
                      p_progr_unita_organizzativa   IN VARCHAR2 DEFAULT NULL,
                      p_ni                          IN VARCHAR2 DEFAULT NULL)
      RETURN afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   FUNCTION count_rows                                        /* SLAVE_COPY */
                       (
      p_qbe                         IN NUMBER DEFAULT 0,
      p_other_condition             IN VARCHAR2 DEFAULT NULL,
      p_progr_unita_organizzativa   IN VARCHAR2 DEFAULT NULL,
      p_ni                          IN VARCHAR2 DEFAULT NULL)
      RETURN INTEGER;
END soggetti_unita_tpk;
/


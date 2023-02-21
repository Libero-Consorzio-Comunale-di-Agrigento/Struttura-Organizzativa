CREATE OR REPLACE PACKAGE BODY soggetti_unita_tpk
IS
   /******************************************************************************
    NOME:        soggetti_unita_tpk
    DESCRIZIONE: Gestione tabella SOGGETTI_UNITA.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   06/12/2017  SO4  Generazione automatica.
   ******************************************************************************/
   s_revisione_body   CONSTANT afc.t_revision := '000 - 06/12/2017';

   --------------------------------------------------------------------------------
   FUNCTION versione
      RETURN VARCHAR2
   IS                                                         /* SLAVE_COPY */
   /******************************************************************************
    NOME:        versione
    DESCRIZIONE: Versione e revisione di distribuzione del package.
    RITORNA:     varchar2 stringa contenente versione e revisione.
    NOTE:        Primo numero  : versione compatibilita del Package.
                 Secondo numero: revisione del Package specification.
                 Terzo numero  : revisione del Package body.
   ******************************************************************************/
   BEGIN
      RETURN afc.version (s_revisione, s_revisione_body);
   END versione;                                -- soggetti_unita_tpk.versione

   --------------------------------------------------------------------------------
   FUNCTION pk (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN t_pk
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result   t_pk;
   BEGIN
      d_result.progr_unita_organizzativa := p_progr_unita_organizzativa;
      dbc.pre (
            NOT dbc.preon
         OR canhandle (
               p_progr_unita_organizzativa   => d_result.progr_unita_organizzativa),
         'canHandle on soggetti_unita_tpk.PK');
      RETURN d_result;
   END pk;                                            -- soggetti_unita_tpk.PK

   --------------------------------------------------------------------------------
   FUNCTION can_handle (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN NUMBER
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la chiave e manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result   NUMBER;
   BEGIN
      d_result := 1;

      -- nelle chiavi primarie composte da piu attributi, ciascun attributo deve essere not null
      IF d_result = 1 AND (p_progr_unita_organizzativa IS NULL)
      THEN
         d_result := 0;
      END IF;

      dbc.POST (
         d_result = 1 OR d_result = 0,
         'd_result = 1  or  d_result = 0 on soggetti_unita_tpk.can_handle');
      RETURN d_result;
   END can_handle;                            -- soggetti_unita_tpk.can_handle

   --------------------------------------------------------------------------------
   FUNCTION canhandle (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN BOOLEAN
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result   CONSTANT BOOLEAN
         := afc.to_boolean (
               can_handle (
                  p_progr_unita_organizzativa   => p_progr_unita_organizzativa)) ;
   BEGIN
      RETURN d_result;
   END canhandle;                              -- soggetti_unita_tpk.canHandle

   --------------------------------------------------------------------------------
   FUNCTION exists_id (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN NUMBER
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        exists_id
       DESCRIZIONE: Esistenza riga con chiave indicata.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
       NOTE:        cfr. existsId per ritorno valori boolean.
      ******************************************************************************/
      d_result   NUMBER;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR canhandle (
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'canHandle on soggetti_unita_tpk.exists_id');

      BEGIN
         SELECT 1
           INTO d_result
           FROM soggetti_unita
          WHERE progr_unita_organizzativa = p_progr_unita_organizzativa;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            d_result := 0;
      END;

      dbc.POST (
         d_result = 1 OR d_result = 0,
         'd_result = 1  or  d_result = 0 on soggetti_unita_tpk.exists_id');
      RETURN d_result;
   END exists_id;                              -- soggetti_unita_tpk.exists_id

   --------------------------------------------------------------------------------
   FUNCTION existsid (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN BOOLEAN
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result   CONSTANT BOOLEAN
         := afc.to_boolean (
               exists_id (
                  p_progr_unita_organizzativa   => p_progr_unita_organizzativa)) ;
   BEGIN
      RETURN d_result;
   END existsid;                                -- soggetti_unita_tpk.existsId

   --------------------------------------------------------------------------------
   PROCEDURE ins (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL,
      p_ni                          IN soggetti_unita.ni%TYPE)
   IS
   /******************************************************************************
    NOME:        ins
    DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
    PARAMETRI:   Chiavi e attributi della table.
   ******************************************************************************/
   BEGIN
      -- Check Mandatory on Insert

      dbc.pre (NOT dbc.preon OR p_ni IS NOT NULL OR          /*default value*/
                                                   '' IS NOT NULL,
               'p_ni on soggetti_unita_tpk.ins');
      dbc.pre (
            NOT dbc.preon
         OR (    p_progr_unita_organizzativa IS NULL
             AND                                             /*default value*/
                'default null' IS NOT NULL)           -- PK nullable on insert
         OR NOT existsid (
                   p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'not existsId on soggetti_unita_tpk.ins');

      INSERT INTO soggetti_unita (progr_unita_organizzativa, ni)
           VALUES (p_progr_unita_organizzativa, p_ni);
   END ins;                                          -- soggetti_unita_tpk.ins

   --------------------------------------------------------------------------------
   FUNCTION ins (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL,
      p_ni                          IN soggetti_unita.ni%TYPE)
      RETURN NUMBER
   /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
       RITORNA:     In caso di PK formata da colonna numerica, ritorna il valore della PK
                    (se positivo), in tutti gli altri casi ritorna 0; in caso di errore,
                    ritorna il codice di errore
      ******************************************************************************/
   IS
      d_result   NUMBER;
   BEGIN
      -- Check Mandatory on Insert

      dbc.pre (NOT dbc.preon OR p_ni IS NOT NULL OR          /*default value*/
                                                   '' IS NOT NULL,
               'p_ni on soggetti_unita_tpk.ins');
      dbc.pre (
            NOT dbc.preon
         OR (    p_progr_unita_organizzativa IS NULL
             AND                                             /*default value*/
                'default null' IS NOT NULL)           -- PK nullable on insert
         OR NOT existsid (
                   p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'not existsId on soggetti_unita_tpk.ins');

      INSERT INTO soggetti_unita (progr_unita_organizzativa, ni)
           VALUES (p_progr_unita_organizzativa, p_ni)
        RETURNING progr_unita_organizzativa
             INTO d_result;

      RETURN d_result;
   END ins;                                          -- soggetti_unita_tpk.ins

   --------------------------------------------------------------------------------
   PROCEDURE upd (
      p_check_old                      IN INTEGER DEFAULT 0,
      p_new_progr_unita_organizzativ   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_old_progr_unita_organizzativ   IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL,
      p_new_ni                         IN soggetti_unita.ni%TYPE DEFAULT afc.default_null (
                                                                            'SOGGETTI_UNITA.ni'),
      p_old_ni                         IN soggetti_unita.ni%TYPE DEFAULT NULL)
   IS
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0    , ricerca senza controllo su attributi precedenti
                                 1    , ricerca con controllo su tutti gli attributi precedenti.
                                 null , ricerca con controllo sui soli attributi precedenti passati.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old e NULL, gli attributi vengono annullati solo se viene
                    indicato anche il relativo attributo OLD.
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old e NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key         t_pk;
      d_row_found   NUMBER;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR NOT ( (p_old_ni IS NOT NULL) AND (NVL (p_check_old, -1) = 0)),
         ' "OLD values" is not null on soggetti_unita_tpk.upd');
      d_key :=
         pk (
            NVL (p_old_progr_unita_organizzativ,
                 p_new_progr_unita_organizzativ));
      dbc.pre (
            NOT dbc.preon
         OR existsid (
               p_progr_unita_organizzativa   => d_key.progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.upd');

      UPDATE soggetti_unita
         SET progr_unita_organizzativa =
                NVL (
                   p_new_progr_unita_organizzativ,
                   DECODE (
                      afc.is_default_null (
                         'SOGGETTI_UNITA.progr_unita_organizzativa'),
                      1, progr_unita_organizzativa,
                      DECODE (
                         p_check_old,
                         0, NULL,
                         DECODE (p_old_progr_unita_organizzativ,
                                 NULL, progr_unita_organizzativa,
                                 NULL)))),
             ni =
                NVL (
                   p_new_ni,
                   DECODE (
                      afc.is_default_null ('SOGGETTI_UNITA.ni'),
                      1, ni,
                      DECODE (p_check_old,
                              0, NULL,
                              DECODE (p_old_ni, NULL, ni, NULL))))
       WHERE     progr_unita_organizzativa = d_key.progr_unita_organizzativa
             AND (   p_check_old = 0
                  OR (    1 = 1
                      AND (   ni = p_old_ni
                           OR (    p_old_ni IS NULL
                               AND (p_check_old IS NULL OR ni IS NULL)))));

      d_row_found := SQL%ROWCOUNT;
      afc.default_null (NULL);
      dbc.assertion (NOT dbc.assertionon OR d_row_found <= 1,
                     'd_row_found <= 1 on soggetti_unita_tpk.upd');

      IF d_row_found < 1
      THEN
         raise_application_error (afc_error.modified_by_other_user_number,
                                  afc_error.modified_by_other_user_msg);
      END IF;
   END upd;                                          -- soggetti_unita_tpk.upd

   --------------------------------------------------------------------------------
   PROCEDURE upd_column (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_column                      IN VARCHAR2,
      p_value                       IN VARCHAR2 DEFAULT NULL,
      p_literal_value               IN NUMBER DEFAULT 1)
   IS
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       PARAMETRI:   p_column:        identificatore del campo da aggiornare.
                    p_value:         valore da modificare.
                    p_literal_value: indica se il valore e un stringa e non un numero
                                     o una funzione.
      ******************************************************************************/
      d_statement   afc.t_statement;
      d_literal     VARCHAR2 (2);
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.upd_column');
      dbc.pre (NOT dbc.preon OR p_column IS NOT NULL,
               'p_column is not null on soggetti_unita_tpk.upd_column');
      dbc.pre (
         NOT dbc.preon OR afc_ddl.hasattribute (s_table_name, p_column),
         'AFC_DDL.HasAttribute on soggetti_unita_tpk.upd_column');
      dbc.pre (
         p_literal_value IN (0, 1) OR p_literal_value IS NULL,
            'p_literal_value on soggetti_unita_tpk.upd_column; p_literal_value = '
         || p_literal_value);

      IF p_literal_value = 1 OR p_literal_value IS NULL
      THEN
         d_literal := '''';
      END IF;

      d_statement :=
            ' declare '
         || '    d_row_found number; '
         || ' begin '
         || '    update SOGGETTI_UNITA '
         || '       set '
         || p_column
         || ' = '
         || d_literal
         || p_value
         || d_literal
         || '     where 1 = 1 '
         || NVL (afc.get_field_condition (
                    ' and ( progr_unita_organizzativa ',
                    p_progr_unita_organizzativa,
                    ' )',
                    0,
                    NULL),
                 ' and ( progr_unita_organizzativa is null ) ')
         || '    ; '
         || '    d_row_found := SQL%ROWCOUNT; '
         || '    if d_row_found < 1 '
         || '    then '
         || '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); '
         || '    end if; '
         || ' end; ';
      afc.sql_execute (d_statement);
   END upd_column;                            -- soggetti_unita_tpk.upd_column

   --------------------------------------------------------------------------------
   PROCEDURE del (
      p_check_old                   IN INTEGER DEFAULT 0,
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_ni                          IN soggetti_unita.ni%TYPE DEFAULT NULL)
   IS
      /******************************************************************************
       NOME:        del
       DESCRIZIONE: Cancellazione della riga indicata.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0    , ricerca senza controllo su attributi precedenti
                                 1    , ricerca con controllo su tutti gli attributi precedenti.
                                 null , ricerca con controllo sui soli attributi precedenti passati.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old e NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_row_found   NUMBER;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR NOT ( (p_ni IS NOT NULL) AND (NVL (p_check_old, -1) = 0)),
         ' "OLD values" is not null on soggetti_unita_tpk.del');
      dbc.pre (
            NOT dbc.preon
         OR existsid (
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.del');

      DELETE FROM soggetti_unita
            WHERE     progr_unita_organizzativa = p_progr_unita_organizzativa
                  AND (   p_check_old = 0
                       OR (    1 = 1
                           AND (   ni = p_ni
                                OR (    p_ni IS NULL
                                    AND (p_check_old IS NULL OR ni IS NULL)))));

      d_row_found := SQL%ROWCOUNT;
      dbc.assertion (NOT dbc.assertionon OR d_row_found <= 1,
                     'd_row_found <= 1 on soggetti_unita_tpk.del');

      IF d_row_found < 1
      THEN
         raise_application_error (afc_error.modified_by_other_user_number,
                                  afc_error.modified_by_other_user_msg);
      END IF;

      dbc.POST (
            NOT dbc.poston
         OR NOT existsid (
                   p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.del');
   END del;                                          -- soggetti_unita_tpk.del

   --------------------------------------------------------------------------------
   FUNCTION get_ni (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE)
      RETURN soggetti_unita.ni%TYPE
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ni
       DESCRIZIONE: Getter per attributo ni di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_UNITA.ni%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result   soggetti_unita.ni%TYPE;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.get_ni');

      SELECT ni
        INTO d_result
        FROM soggetti_unita
       WHERE progr_unita_organizzativa = p_progr_unita_organizzativa;

      -- Check Mandatory Attribute on Table
      IF (TRUE)                                     -- is Mandatory on Table ?
      THEN
         -- Result must be not null
         dbc.POST (NOT dbc.poston OR d_result IS NOT NULL,
                   'd_result is not null on soggetti_unita_tpk.get_ni');
      ELSE
         -- Column must nullable on table
         dbc.assertion (
            NOT dbc.assertionon OR afc_ddl.isnullable (s_table_name, 'ni'),
            ' AFC_DDL.IsNullable on soggetti_unita_tpk.get_ni');
      END IF;

      RETURN d_result;
   END get_ni;                                    -- soggetti_unita_tpk.get_ni

   --------------------------------------------------------------------------------
   PROCEDURE set_progr_unita_organizzativa (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_value                       IN soggetti_unita.progr_unita_organizzativa%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_progr_unita_organizzativa
    DESCRIZIONE: Setter per attributo progr_unita_organizzativa di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.set_progr_unita_organizzativa');

      UPDATE soggetti_unita
         SET progr_unita_organizzativa = p_value
       WHERE progr_unita_organizzativa = p_progr_unita_organizzativa;
   END set_progr_unita_organizzativa; -- soggetti_unita_tpk.set_progr_unita_organizzativa

   --------------------------------------------------------------------------------
   PROCEDURE set_ni (
      p_progr_unita_organizzativa   IN soggetti_unita.progr_unita_organizzativa%TYPE,
      p_value                       IN soggetti_unita.ni%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_ni
    DESCRIZIONE: Setter per attributo ni di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa),
         'existsId on soggetti_unita_tpk.set_ni');

      UPDATE soggetti_unita
         SET ni = p_value
       WHERE progr_unita_organizzativa = p_progr_unita_organizzativa;
   END set_ni;                                    -- soggetti_unita_tpk.set_ni

   --------------------------------------------------------------------------------
   FUNCTION where_condition                                   /* SLAVE_COPY */
                            (
      p_qbe                         IN NUMBER DEFAULT 0,
      p_other_condition             IN VARCHAR2 DEFAULT NULL,
      p_progr_unita_organizzativa   IN VARCHAR2 DEFAULT NULL,
      p_ni                          IN VARCHAR2 DEFAULT NULL)
      RETURN afc.t_statement
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows.
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    Chiavi e attributi della table
       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement   afc.t_statement;
   BEGIN
      d_statement :=
            ' where ( 1 = 1 '
         || afc.get_field_condition (' and ( progr_unita_organizzativa ',
                                     p_progr_unita_organizzativa,
                                     ' )',
                                     p_qbe,
                                     NULL)
         || afc.get_field_condition (' and ( ni ',
                                     p_ni,
                                     ' )',
                                     p_qbe,
                                     NULL)
         || ' ) '
         || p_other_condition;
      RETURN d_statement;
   END where_condition;                 --- soggetti_unita_tpk.where_condition

   --------------------------------------------------------------------------------
   FUNCTION get_rows (p_qbe                         IN NUMBER DEFAULT 0,
                      p_other_condition             IN VARCHAR2 DEFAULT NULL,
                      p_order_by                    IN VARCHAR2 DEFAULT NULL,
                      p_extra_columns               IN VARCHAR2 DEFAULT NULL,
                      p_extra_condition             IN VARCHAR2 DEFAULT NULL,
                      p_progr_unita_organizzativa   IN VARCHAR2 DEFAULT NULL,
                      p_ni                          IN VARCHAR2 DEFAULT NULL)
      RETURN afc.t_ref_cursor
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo.
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    p_order_by: condizioni di ordinamento
                    p_extra_columns: colonne da aggiungere alla select
                    p_extra_condition: condizioni aggiuntive
                    Chiavi e attributi della table
       RITORNA:     Un ref_cursor che punta al risultato della query.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
                    In p_extra_columns e p_order_by non devono essere passati anche la
                    virgola iniziale (per p_extra_columns) e la stringa 'order by' (per
                    p_order_by)
      ******************************************************************************/
      d_statement    afc.t_statement;
      d_ref_cursor   afc.t_ref_cursor;
   BEGIN
      d_statement :=
            ' select SOGGETTI_UNITA.* '
         || afc.decode_value (p_extra_columns,
                              NULL,
                              NULL,
                              ' , ' || p_extra_columns)
         || ' from SOGGETTI_UNITA '
         || where_condition (
               p_qbe                         => p_qbe,
               p_other_condition             => p_other_condition,
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa,
               p_ni                          => p_ni)
         || ' '
         || p_extra_condition
         || afc.decode_value (p_order_by,
                              NULL,
                              NULL,
                              ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor (d_statement);
      RETURN d_ref_cursor;
   END get_rows;                                -- soggetti_unita_tpk.get_rows

   --------------------------------------------------------------------------------
   FUNCTION count_rows (
      p_qbe                         IN NUMBER DEFAULT 0,
      p_other_condition             IN VARCHAR2 DEFAULT NULL,
      p_progr_unita_organizzativa   IN VARCHAR2 DEFAULT NULL,
      p_ni                          IN VARCHAR2 DEFAULT NULL)
      RETURN INTEGER
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    Chiavi e attributi della table
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result      INTEGER;
      d_statement   afc.t_statement;
   BEGIN
      d_statement :=
            ' select count( * ) from SOGGETTI_UNITA '
         || where_condition (
               p_qbe                         => p_qbe,
               p_other_condition             => p_other_condition,
               p_progr_unita_organizzativa   => p_progr_unita_organizzativa,
               p_ni                          => p_ni);
      d_result := afc.sql_execute (d_statement);
      RETURN d_result;
   END count_rows;                            -- soggetti_unita_tpk.count_rows
--------------------------------------------------------------------------------

END soggetti_unita_tpk;
/


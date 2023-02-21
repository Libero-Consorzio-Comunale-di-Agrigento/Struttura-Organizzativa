CREATE OR REPLACE package body competenze_delega_tpk is
/******************************************************************************
 NOME:        competenze_delega_tpk
 DESCRIZIONE: Gestione tabella COMPETENZE_DELEGA.
 ANNOTAZIONI: .
 REVISIONI:   .
 Rev.  Data        Autore      Descrizione.
    000   23/11/2017  MMonari  Generazione automatica.
   ******************************************************************************/
   s_revisione_body   CONSTANT afc.t_revision := '000 - 23/11/2017';
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
   END versione;                             -- competenze_delega_tpk.versione
   --------------------------------------------------------------------------------
   FUNCTION pk (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN t_pk
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result   t_pk;
   BEGIN
      d_result.id_competenza_delega := p_id_competenza_delega;
      dbc.pre (
            NOT dbc.preon
         OR canhandle (
               p_id_competenza_delega   => d_result.id_competenza_delega),
         'canHandle on competenze_delega_tpk.PK');
      RETURN d_result;
   END pk;                                         -- competenze_delega_tpk.PK
   --------------------------------------------------------------------------------
   FUNCTION can_handle (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
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
      IF d_result = 1 AND (p_id_competenza_delega IS NULL)
      THEN
         d_result := 0;
      END IF;
      dbc.POST (
         d_result = 1 OR d_result = 0,
         'd_result = 1  or  d_result = 0 on competenze_delega_tpk.can_handle');
      RETURN d_result;
   END can_handle;                         -- competenze_delega_tpk.can_handle
   --------------------------------------------------------------------------------
   FUNCTION canhandle (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
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
               can_handle (p_id_competenza_delega => p_id_competenza_delega)) ;
   BEGIN
      RETURN d_result;
   END canhandle;                           -- competenze_delega_tpk.canHandle
   --------------------------------------------------------------------------------
   FUNCTION exists_id (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
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
         OR canhandle (p_id_competenza_delega => p_id_competenza_delega),
         'canHandle on competenze_delega_tpk.exists_id');
      BEGIN
         SELECT 1
           INTO d_result
           FROM competenze_delega
          WHERE codice = p_id_competenza_delega;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            d_result := 0;
      END;
      dbc.POST (
         d_result = 1 OR d_result = 0,
         'd_result = 1  or  d_result = 0 on competenze_delega_tpk.exists_id');
      RETURN d_result;
   END exists_id;                           -- competenze_delega_tpk.exists_id
   --------------------------------------------------------------------------------
   FUNCTION existsid (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
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
               exists_id (p_id_competenza_delega => p_id_competenza_delega)) ;
   BEGIN
      RETURN d_result;
   END existsid;                             -- competenze_delega_tpk.existsId
   --------------------------------------------------------------------------------
   PROCEDURE ins (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_codice                 IN competenze_delega.codice%TYPE,
      p_descrizione            IN competenze_delega.descrizione%TYPE,
      p_id_applicativo         IN competenze_delega.id_applicativo%TYPE,
      p_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        ins
    DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
    PARAMETRI:   Chiavi e attributi della table.
   ******************************************************************************/
   BEGIN
      -- Check Mandatory on Insert
      dbc.pre (NOT dbc.preon OR p_descrizione IS NOT NULL OR /*default value*/
                                                            '' IS NOT NULL,
               'p_descrizione on competenze_delega_tpk.ins');
      dbc.pre (
            NOT dbc.preon
         OR p_fine_validita IS NOT NULL
         OR                                                  /*default value*/
           'default' IS NOT NULL,
         'p_fine_validita on competenze_delega_tpk.ins');
      dbc.pre (
            NOT dbc.preon
         OR (p_id_competenza_delega IS NULL AND              /*default value*/
                                               '' IS NOT NULL) -- PK nullable on insert
         OR NOT existsid (p_id_competenza_delega => p_id_competenza_delega),
         'not existsId on competenze_delega_tpk.ins');
      INSERT INTO competenze_delega (id_competenza_delega,
                                     codice,
                                     descrizione,
                                     id_applicativo,
                                     fine_validita)
           VALUES (p_id_competenza_delega,
                   p_codice,
                   p_descrizione,
                   p_id_applicativo,
                   p_fine_validita);
   END ins;                                       -- competenze_delega_tpk.ins
   --------------------------------------------------------------------------------
   FUNCTION ins (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_codice                 IN competenze_delega.codice%TYPE,
      p_descrizione            IN competenze_delega.descrizione%TYPE,
      p_id_applicativo         IN competenze_delega.id_applicativo%TYPE,
      p_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL)
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
      dbc.pre (NOT dbc.preon OR p_descrizione IS NOT NULL OR /*default value*/
                                                            '' IS NOT NULL,
               'p_descrizione on competenze_delega_tpk.ins');
      dbc.pre (
            NOT dbc.preon
         OR p_fine_validita IS NOT NULL
         OR                                                  /*default value*/
           'default' IS NOT NULL,
         'p_fine_validita on competenze_delega_tpk.ins');
      dbc.pre (
            NOT dbc.preon
         OR (p_id_competenza_delega IS NULL AND              /*default value*/
                                               '' IS NOT NULL) -- PK nullable on insert
         OR NOT existsid (p_id_competenza_delega => p_id_competenza_delega),
         'not existsId on competenze_delega_tpk.ins');
      INSERT INTO competenze_delega (id_competenza_delega,
                                     codice,
                                     descrizione,
                                     id_applicativo,
                                     fine_validita)
           VALUES (p_id_competenza_delega,
                   p_codice,
                   p_descrizione,
                   p_id_applicativo,
                   p_fine_validita);
      d_result := 0;
      RETURN d_result;
   END ins;                                       -- competenze_delega_tpk.ins
   --------------------------------------------------------------------------------
   PROCEDURE upd (
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
      p_old_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL)
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
         OR NOT (    (   p_old_codice IS NOT NULL
                      OR p_old_descrizione IS NOT NULL
                      OR p_old_id_applicativo IS NOT NULL
                      OR p_old_fine_validita IS NOT NULL)
                 AND (NVL (p_check_old, -1) = 0)),
         ' "OLD values" is not null on competenze_delega_tpk.upd');
      d_key :=
         pk (NVL (p_old_id_competenza_delega, p_new_id_competenza_delega));
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => d_key.id_competenza_delega),
         'existsId on competenze_delega_tpk.upd');
      UPDATE competenze_delega
         SET id_competenza_delega =
                NVL (
                   p_new_id_competenza_delega,
                   DECODE (
                      afc.is_default_null (
                         'competenze_delega.id_competenza_delega'),
                      1, id_competenza_delega,
                      DECODE (
                         p_check_old,
                         0, NULL,
                         DECODE (p_old_id_competenza_delega,
                                 NULL, id_competenza_delega,
                                 NULL)))),
             codice =
                NVL (
                   p_new_codice,
                   DECODE (
                      afc.is_default_null ('competenze_delega.codice'),
                      1, codice,
                      DECODE (p_check_old,
                              0, NULL,
                              DECODE (p_old_codice, NULL, codice, NULL)))),
             descrizione =
                NVL (
                   p_new_descrizione,
                   DECODE (
                      afc.is_default_null ('competenze_delega.descrizione'),
                      1, descrizione,
                      DECODE (
                         p_check_old,
                         0, NULL,
                         DECODE (p_old_descrizione, NULL, descrizione, NULL)))),
             id_applicativo =
                NVL (
                   p_new_id_applicativo,
                   DECODE (
                      afc.is_default_null (
                         'competenze_delega.id_applicativo'),
                      1, id_applicativo,
                      DECODE (
                         p_check_old,
                         0, NULL,
                         DECODE (p_old_id_applicativo,
                                 NULL, id_applicativo,
                                 NULL)))),
             fine_validita =
                NVL (
                   p_new_fine_validita,
                   DECODE (
                      afc.is_default_null ('competenze_delega.fine_validita'),
                      1, fine_validita,
                      DECODE (
                         p_check_old,
                         0, NULL,
                         DECODE (p_old_fine_validita,
                                 NULL, fine_validita,
                                 NULL))))
       WHERE     id_competenza_delega = d_key.id_competenza_delega
             AND (   p_check_old = 0
                  OR (    1 = 1
                      AND (   codice = p_old_codice
                           OR (    p_old_codice IS NULL
                               AND (p_check_old IS NULL OR codice IS NULL)))
                      AND (   descrizione = p_old_descrizione
                           OR (    p_old_descrizione IS NULL
                               AND (   p_check_old IS NULL
                                    OR descrizione IS NULL)))
                      AND (   id_applicativo = p_old_id_applicativo
                           OR (    p_old_id_applicativo IS NULL
                               AND (   p_check_old IS NULL
                                    OR id_applicativo IS NULL)))
                      AND (   fine_validita = p_old_fine_validita
                           OR (    p_old_fine_validita IS NULL
                               AND (   p_check_old IS NULL
                                    OR fine_validita IS NULL)))));
      d_row_found := SQL%ROWCOUNT;
      afc.default_null (NULL);
      dbc.assertion (NOT dbc.assertionon OR d_row_found <= 1,
                     'd_row_found <= 1 on competenze_delega_tpk.upd');
      IF d_row_found < 1
      THEN
         raise_application_error (afc_error.modified_by_other_user_number,
                                  afc_error.modified_by_other_user_msg);
      END IF;
   END upd;                                       -- competenze_delega_tpk.upd
   --------------------------------------------------------------------------------
   PROCEDURE upd_column (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_column                 IN VARCHAR2,
      p_value                  IN VARCHAR2 DEFAULT NULL,
      p_literal_value          IN NUMBER DEFAULT 1)
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
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.upd_column');
      dbc.pre (NOT dbc.preon OR p_column IS NOT NULL,
               'p_column is not null on competenze_delega_tpk.upd_column');
      dbc.pre (
         NOT dbc.preon OR afc_ddl.hasattribute (s_table_name, p_column),
         'AFC_DDL.HasAttribute on competenze_delega_tpk.upd_column');
      dbc.pre (
         p_literal_value IN (0, 1) OR p_literal_value IS NULL,
            'p_literal_value on competenze_delega_tpk.upd_column; p_literal_value = '
         || p_literal_value);
      IF p_literal_value = 1 OR p_literal_value IS NULL
      THEN
         d_literal := '''';
      END IF;
      d_statement :=
            ' declare '
         || '    d_row_found number; '
         || ' begin '
         || '    update competenze_delega '
         || '       set '
         || p_column
         || ' = '
         || d_literal
         || p_value
         || d_literal
         || '     where 1 = 1 '
         || NVL (afc.get_field_condition (' and ( id_competenza_delega ',
                                          p_id_competenza_delega,
                                          ' )',
                                          0,
                                          NULL),
                 ' and ( id_competenza_delega is null ) ')
         || '    ; '
         || '    d_row_found := SQL%ROWCOUNT; '
         || '    if d_row_found < 1 '
         || '    then '
         || '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); '
         || '    end if; '
         || ' end; ';
      afc.sql_execute (d_statement);
   END upd_column;                         -- competenze_delega_tpk.upd_column
   --------------------------------------------------------------------------------
   PROCEDURE upd_column (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_column                 IN VARCHAR2,
      p_value                  IN DATE)
   IS
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data   VARCHAR2 (19);
   BEGIN
      d_data := TO_CHAR (p_value, afc.date_format);
      upd_column (
         p_id_competenza_delega   => p_id_competenza_delega,
         p_column                 => p_column,
         p_value                  =>    'to_date( '''
                                     || d_data
                                     || ''', '''
                                     || afc.date_format
                                     || ''' )',
         p_literal_value          => 0);
   END upd_column;                         -- competenze_delega_tpk.upd_column
   --------------------------------------------------------------------------------
   PROCEDURE del (
      p_check_old              IN INTEGER DEFAULT 0,
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_codice                 IN competenze_delega.codice%TYPE DEFAULT NULL,
      p_descrizione            IN competenze_delega.descrizione%TYPE DEFAULT NULL,
      p_id_applicativo         IN competenze_delega.id_applicativo%TYPE DEFAULT NULL,
      p_fine_validita          IN competenze_delega.fine_validita%TYPE DEFAULT NULL)
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
         OR NOT (    (   p_descrizione IS NOT NULL
                      OR p_codice IS NOT NULL
                      OR p_id_applicativo IS NOT NULL
                      OR p_fine_validita IS NOT NULL)
                 AND (NVL (p_check_old, -1) = 0)),
         ' "OLD values" is not null on competenze_delega_tpk.del');
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.del');
      DELETE FROM competenze_delega
            WHERE     id_competenza_delega = p_id_competenza_delega
                  AND (   p_check_old = 0
                       OR (    1 = 1
                           AND (   codice = p_codice
                                OR (    p_codice IS NULL
                                    AND (   p_check_old IS NULL
                                         OR codice IS NULL)))
                           AND (   descrizione = p_descrizione
                                OR (    p_descrizione IS NULL
                                    AND (   p_check_old IS NULL
                                         OR descrizione IS NULL)))
                           AND (   id_applicativo = p_id_applicativo
                                OR (    p_id_applicativo IS NULL
                                    AND (   p_check_old IS NULL
                                         OR id_applicativo IS NULL)))
                           AND (   fine_validita = p_fine_validita
                                OR (    p_fine_validita IS NULL
                                    AND (   p_check_old IS NULL
                                         OR fine_validita IS NULL)))));
      d_row_found := SQL%ROWCOUNT;
      dbc.assertion (NOT dbc.assertionon OR d_row_found <= 1,
                     'd_row_found <= 1 on competenze_delega_tpk.del');
      IF d_row_found < 1
      THEN
         raise_application_error (afc_error.modified_by_other_user_number,
                                  afc_error.modified_by_other_user_msg);
      END IF;
      dbc.POST (
            NOT dbc.poston
         OR NOT existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.del');
   END del;                                       -- competenze_delega_tpk.del
   --------------------------------------------------------------------------------
   FUNCTION get_codice (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.codice%TYPE
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice
       DESCRIZIONE: Getter per attributo codice di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     competenze_delega.codice%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result   competenze_delega.codice%TYPE;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.get_codice');
      SELECT codice
        INTO d_result
        FROM competenze_delega
       WHERE id_competenza_delega = p_id_competenza_delega;
      -- Check Mandatory Attribute on Table
      IF (TRUE)                                     -- is Mandatory on Table ?
      THEN
         -- Result must be not null
         dbc.POST (
            NOT dbc.poston OR d_result IS NOT NULL,
            'd_result is not null on competenze_delega_tpk.get_codice');
      ELSE
         -- Column must nullable on table
         dbc.assertion (
               NOT dbc.assertionon
            OR afc_ddl.isnullable (s_table_name, 'codice'),
            ' AFC_DDL.IsNullable on competenze_delega_tpk.get_codice');
      END IF;
      RETURN d_result;
   END get_codice;                         -- competenze_delega_tpk.get_codice
   --------------------------------------------------------------------------------
   FUNCTION get_descrizione (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.descrizione%TYPE
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Getter per attributo descrizione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     competenze_delega.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result   competenze_delega.descrizione%TYPE;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.get_descrizione');
      SELECT descrizione
        INTO d_result
        FROM competenze_delega
       WHERE id_competenza_delega = p_id_competenza_delega;
      -- Check Mandatory Attribute on Table
      IF (TRUE)                                     -- is Mandatory on Table ?
      THEN
         -- Result must be not null
         dbc.POST (
            NOT dbc.poston OR d_result IS NOT NULL,
            'd_result is not null on competenze_delega_tpk.get_descrizione');
      ELSE
         -- Column must nullable on table
         dbc.assertion (
               NOT dbc.assertionon
            OR afc_ddl.isnullable (s_table_name, 'descrizione'),
            ' AFC_DDL.IsNullable on competenze_delega_tpk.get_descrizione');
      END IF;
      RETURN d_result;
   END get_descrizione;               -- competenze_delega_tpk.get_descrizione
   --------------------------------------------------------------------------------
   FUNCTION get_id_applicativo (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.id_applicativo%TYPE
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_applicativo
       DESCRIZIONE: Getter per attributo id_applicativo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     competenze_delega.id_applicativo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result   competenze_delega.id_applicativo%TYPE;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.get_id_applicativo');
      SELECT id_applicativo
        INTO d_result
        FROM competenze_delega
       WHERE id_competenza_delega = p_id_competenza_delega;
      -- Check Mandatory Attribute on Table
      IF (TRUE)                                     -- is Mandatory on Table ?
      THEN
         -- Result must be not null
         dbc.POST (
            NOT dbc.poston OR d_result IS NOT NULL,
            'd_result is not null on competenze_delega_tpk.get_id_applicativo');
      ELSE
         -- Column must nullable on table
         dbc.assertion (
               NOT dbc.assertionon
            OR afc_ddl.isnullable (s_table_name, 'id_applicativo'),
            ' AFC_DDL.IsNullable on competenze_delega_tpk.get_id_applicativo');
      END IF;
      RETURN d_result;
   END get_id_applicativo;         -- competenze_delega_tpk.get_id_applicativo
   --------------------------------------------------------------------------------
   FUNCTION get_fine_validita (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE)
      RETURN competenze_delega.fine_validita%TYPE
   IS
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_fine_validita
       DESCRIZIONE: Getter per attributo fine_validita di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     competenze_delega.fine_validita%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result   competenze_delega.fine_validita%TYPE;
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.get_fine_validita');
      SELECT fine_validita
        INTO d_result
        FROM competenze_delega
       WHERE codice = p_id_competenza_delega;
      -- Check Mandatory Attribute on Table
      IF (FALSE)                                    -- is Mandatory on Table ?
      THEN
         -- Result must be not null
         dbc.POST (
            NOT dbc.poston OR d_result IS NOT NULL,
            'd_result is not null on competenze_delega_tpk.get_fine_validita');
      ELSE
         -- Column must nullable on table
         dbc.assertion (
               NOT dbc.assertionon
            OR afc_ddl.isnullable (s_table_name, 'fine_validita'),
            ' AFC_DDL.IsNullable on competenze_delega_tpk.get_fine_validita');
      END IF;
      RETURN d_result;
   END get_fine_validita;           -- competenze_delega_tpk.get_fine_validita
   --------------------------------------------------------------------------------
   PROCEDURE set_id_competenza_delega (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.id_competenza_delega%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_id_competenza_delega
    DESCRIZIONE: Setter per attributo codice di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.set_id_competenza_delega');
      UPDATE competenze_delega
         SET id_competenza_delega = p_value
       WHERE id_competenza_delega = p_id_competenza_delega;
   END set_id_competenza_delega; -- competenze_delega_tpk.set_id_competenza_delega
   --------------------------------------------------------------------------------
   PROCEDURE set_codice (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.codice%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_codice
    DESCRIZIONE: Setter per attributo codice di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.set_codice');
      UPDATE competenze_delega
         SET codice = p_value
       WHERE id_competenza_delega = p_id_competenza_delega;
   END set_codice;                         -- competenze_delega_tpk.set_codice
   --------------------------------------------------------------------------------
   PROCEDURE set_descrizione (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.descrizione%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_descrizione
    DESCRIZIONE: Setter per attributo descrizione di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.set_descrizione');
      UPDATE competenze_delega
         SET descrizione = p_value
       WHERE id_competenza_delega = p_id_competenza_delega;
   END set_descrizione;               -- competenze_delega_tpk.set_descrizione
   --------------------------------------------------------------------------------
   PROCEDURE set_id_applicativo (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.id_applicativo%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_descrizione
    DESCRIZIONE: Setter per attributo id_applicativo di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.set_id_applicativo');
      UPDATE competenze_delega
         SET id_applicativo = p_value
       WHERE id_competenza_delega = p_id_competenza_delega;
   END set_id_applicativo;         -- competenze_delega_tpk.set_id_applicativo
   --------------------------------------------------------------------------------
   PROCEDURE set_fine_validita (
      p_id_competenza_delega   IN competenze_delega.id_competenza_delega%TYPE,
      p_value                  IN competenze_delega.fine_validita%TYPE DEFAULT NULL)
   IS
   /******************************************************************************
    NOME:        set_fine_validita
    DESCRIZIONE: Setter per attributo fine_validita di riga identificata dalla chiave.
    PARAMETRI:   Attributi chiave.
    NOTE:        La riga identificata deve essere presente.
   ******************************************************************************/
   BEGIN
      dbc.pre (
            NOT dbc.preon
         OR existsid (p_id_competenza_delega => p_id_competenza_delega),
         'existsId on competenze_delega_tpk.set_fine_validita');
      UPDATE competenze_delega
         SET fine_validita = p_value
       WHERE codice = p_id_competenza_delega;
   END set_fine_validita;           -- competenze_delega_tpk.set_fine_validita
   --------------------------------------------------------------------------------
   FUNCTION where_condition                                   /* SLAVE_COPY */
                            (
      p_qbe                    IN NUMBER DEFAULT 0,
      p_other_condition        IN VARCHAR2 DEFAULT NULL,
      p_id_competenza_delega   IN NUMBER DEFAULT NULL,
      p_codice                 IN VARCHAR2 DEFAULT NULL,
      p_descrizione            IN VARCHAR2 DEFAULT NULL,
      p_id_applicativo         IN NUMBER DEFAULT NULL,
      p_fine_validita          IN VARCHAR2 DEFAULT NULL)
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
         || afc.get_field_condition (' and ( id_competenza_delega ',
                                     p_id_competenza_delega,
                                     ' )',
                                     p_qbe,
                                     NULL)
         || afc.get_field_condition (' and ( codice ',
                                     p_codice,
                                     ' )',
                                     p_qbe,
                                     NULL)
         || afc.get_field_condition (' and ( descrizione ',
                                     p_descrizione,
                                     ' )',
                                     p_qbe,
                                     NULL)
         || afc.get_field_condition (' and ( id_applicativo ',
                                     p_id_applicativo,
                                     ' )',
                                     p_qbe,
                                     NULL)
         || afc.get_field_condition (' and ( fine_validita ',
                                     p_fine_validita,
                                     ' )',
                                     p_qbe,
                                     afc.date_format)
         || ' ) '
         || p_other_condition;
      RETURN d_statement;
   END where_condition;              --- competenze_delega_tpk.where_condition
   --------------------------------------------------------------------------------
   FUNCTION get_rows (p_qbe                    IN NUMBER DEFAULT 0,
                      p_other_condition        IN VARCHAR2 DEFAULT NULL,
                      p_order_by               IN VARCHAR2 DEFAULT NULL,
                      p_extra_columns          IN VARCHAR2 DEFAULT NULL,
                      p_extra_condition        IN VARCHAR2 DEFAULT NULL,
                      p_id_competenza_delega   IN NUMBER DEFAULT NULL,
                      p_codice                 IN VARCHAR2 DEFAULT NULL,
                      p_descrizione            IN VARCHAR2 DEFAULT NULL,
                      p_id_applicativo         IN NUMBER DEFAULT NULL,
                      p_fine_validita          IN VARCHAR2 DEFAULT NULL)
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
            ' select competenze_delega.* '
         || afc.decode_value (p_extra_columns,
                              NULL,
                              NULL,
                              ' , ' || p_extra_columns)
         || ' from competenze_delega '
         || where_condition (
               p_qbe                    => p_qbe,
               p_other_condition        => p_other_condition,
               p_id_competenza_delega   => p_id_competenza_delega,
               p_codice                 => p_codice,
               p_descrizione            => p_descrizione,
               p_id_applicativo         => p_id_applicativo,
               p_fine_validita          => p_fine_validita)
         || ' '
         || p_extra_condition
         || afc.decode_value (p_order_by,
                              NULL,
                              NULL,
                              ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor (d_statement);
      RETURN d_ref_cursor;
   END get_rows;                             -- competenze_delega_tpk.get_rows
   --------------------------------------------------------------------------------
   FUNCTION count_rows (p_qbe                    IN NUMBER DEFAULT 0,
                        p_other_condition        IN VARCHAR2 DEFAULT NULL,
                        p_id_competenza_delega   IN NUMBER DEFAULT NULL,
                        p_codice                 IN VARCHAR2 DEFAULT NULL,
                        p_descrizione            IN VARCHAR2 DEFAULT NULL,
                        p_id_applicativo         IN NUMBER DEFAULT NULL,
                        p_fine_validita          IN VARCHAR2 DEFAULT NULL)
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
            ' select count( * ) from competenze_delega '
         || where_condition (
               p_qbe                    => p_qbe,
               p_other_condition        => p_other_condition,
               p_id_competenza_delega   => p_id_competenza_delega,
               p_codice                 => p_codice,
               p_descrizione            => p_descrizione,
               p_id_applicativo         => p_id_applicativo,
               p_fine_validita          => p_fine_validita);
      d_result := afc.sql_execute (d_statement);
      RETURN d_result;
   END count_rows;                         -- competenze_delega_tpk.count_rows
--------------------------------------------------------------------------------
END competenze_delega_tpk;
/


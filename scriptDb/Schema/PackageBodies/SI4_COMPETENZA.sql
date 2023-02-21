CREATE OR REPLACE PACKAGE BODY "SI4_COMPETENZA" IS
FUNCTION  versione
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 RITORNA:     stringa VARCHAR2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
RETURN varchar2
IS
BEGIN
   RETURN revisione;
END versione;
PROCEDURE set_true
IS
BEGIN
g_diritto := 1;
END;
PROCEDURE set_false
IS
BEGIN
g_diritto := 0;
END;
PROCEDURE resetta
IS
BEGIN
g_diritto := NULL;
END;
FUNCTION assegna
/******************************************************************************
 NOME:        assegna
 DESCRIZIONE: Registra la competenza per il soggetto (utente o gruppo) indicato, relativamente alla abilitazione di un determinato oggetto.
              - chiude periodo precedente alla data DAL - 1
              - sposta periodo successivo alla data AL+ 1
              - elimina periodi contenuti
              Return:
               0 : Inserimento corretto
              -1 : Tipo di abilitazione incompatibile con l'oggetto indicato
              -2 : Non esiste l'oggetto
              -3 : Non esiste il tipo di abilitazione
******************************************************************************/
( p_tipo_oggetto IN varchar2
, p_oggetto IN varchar2
, p_tipo_abilitazione IN varchar2
, p_utente IN varchar2
, p_ruolo IN varchar2 DEFAULT NULL
, p_autore IN varchar2
, p_accesso IN varchar2 DEFAULT 'S'
, p_dal IN varchar2 DEFAULT NULL
, p_al IN varchar2 DEFAULT NULL
, p_funzione IN varchar2 DEFAULT NULL
, p_controllo IN varchar2 DEFAULT 1)
RETURN number
IS
d_id_abilitazione number(10);
d_id_competenza   number(10);
d_errore          number(1);
d_esiste          number(1);
d_id_funzione     number(10);
d_tipo_competenza varchar2(1);
CURSOR c_periodi ( v_tipo_oggetto varchar2
     , v_oggetto varchar2
     , v_tipo_abilitazione varchar2
     , v_utente varchar2
     , v_ruolo varchar2
     , v_dal varchar2
     , v_al varchar2
     , v_id_funzione number
     , v_tipo_competenza varchar2
     )
 IS
SELECT comp.id_competenza
     , abil.id_abilitazione
     , accesso
     , dal
     , al
  FROM si4_competenze comp,
       si4_abilitazioni abil,
       si4_tipi_oggetto tiog,
       si4_tipi_abilitazione tiab
 WHERE abil.id_tipo_oggetto+0 = tiog.id_tipo_oggetto
   AND abil.id_tipo_abilitazione+0 = tiab.id_tipo_abilitazione
   AND comp.id_abilitazione = abil.id_abilitazione
   AND tiog.tipo_oggetto = v_tipo_oggetto
   AND tiab.tipo_abilitazione = v_tipo_abilitazione
   AND NVL(comp.utente,'-1') = NVL(v_utente,'-1')
   AND comp.oggetto = v_oggetto
   AND NVL(comp.ruolo,'-1') = NVL(v_ruolo, '-1')
   AND NVL(comp.dal,TO_DATE('2222222','j')) <= NVL(TO_DATE(v_al,'dd/mm/yyyy'),TO_DATE('3333333','j'))
   AND NVL(comp.al,TO_DATE('3333333','j')) >= NVL(TO_DATE(v_dal,'dd/mm/yyyy'),TO_DATE('2222222','j'))
   AND NVL(comp.id_funzione,-1) = NVL(v_id_funzione,-1)
   AND tipo_competenza = v_tipo_competenza
   ;
BEGIN
    /* Setto il tipo abilitazione */
    IF p_funzione IS NULL THEN
       d_tipo_competenza := 'U';
    ELSE
       d_tipo_competenza := 'F';
    /* Estraggo id_funzione */
    SELECT MIN(id_funzione)
      INTO d_id_funzione
      FROM si4_funzioni
     WHERE nome = p_funzione;
    END IF;
   /* Estraggo id_abilitazione */
   SELECT id_abilitazione
     INTO d_id_abilitazione
     FROM si4_abilitazioni abil,
          si4_tipi_oggetto tiog,
          si4_tipi_abilitazione tiab
    WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
      AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
      AND tiog.tipo_oggetto = p_tipo_oggetto
      AND tiab.tipo_abilitazione = p_tipo_abilitazione;
   /* Tratto i periodi con intersezione non nulla*/
   IF p_controllo = 1 THEN
      FOR v_periodi IN c_periodi(p_tipo_oggetto
                                ,p_oggetto
                                ,p_tipo_abilitazione
                                ,p_utente
                                ,p_ruolo
                                ,p_dal
                                ,p_al
                                ,d_id_funzione
                                ,d_tipo_competenza
                                ) LOOP
         IF NVL(v_periodi.dal,TO_DATE('2222222','j')) >= NVL(TO_DATE(p_dal,'dd/mm/yyyy'),TO_DATE('2222222','j'))
        AND NVL(v_periodi.al,TO_DATE('3333333','j'))  <= NVL(TO_DATE(p_al,'dd/mm/yyyy'),TO_DATE('3333333','j')) THEN
        /*Caso A)Periodo interamente contenuto nel nuovo*/
            DELETE FROM si4_competenze
             WHERE id_competenza = v_periodi.id_competenza;
         ELSIF NVL(v_periodi.dal,TO_DATE('2222222','j')) BETWEEN NVL(TO_DATE(p_dal,'dd/mm/yyyy'),TO_DATE('2222222','j'))
           AND  NVL(TO_DATE(p_al,'dd/mm/yyyy'),TO_DATE('3333333','j')) THEN
        /*Caso B)"Dal" contenuto nel nuovo intervallo*/
               UPDATE si4_competenze
                  SET dal = TO_DATE(p_al,'dd/mm/yyyy') + 1
                WHERE id_competenza = v_periodi.id_competenza;
         ELSIF NVL(v_periodi.al,TO_DATE('3333333','j')) BETWEEN NVL(TO_DATE(p_dal,'dd/mm/yyyy'),TO_DATE('2222222','j'))
           AND  NVL(TO_DATE(p_al,'dd/mm/yyyy'),TO_DATE('3333333','j')) THEN
        /*Caso C)"Al" contenuto nel nuovo intervallo*/
               UPDATE si4_competenze
                  SET al = TO_DATE(p_dal,'dd/mm/yyyy') -1
                WHERE id_competenza = v_periodi.id_competenza;
         ELSE
        /*Caso D)Periodo contiene il nuovo intervallo*/
            SELECT comp_sq.NEXTVAL
              INTO d_id_competenza
              FROM DUAL;
            INSERT INTO si4_competenze
                   (id_competenza, id_abilitazione, utente, oggetto, accesso, ruolo, dal, al, data_aggiornamento, utente_aggiornamento, id_funzione, tipo_competenza)
            VALUES (d_id_competenza,v_periodi.id_abilitazione,p_utente, p_oggetto, v_periodi.accesso, p_ruolo,v_periodi.dal,TO_DATE(p_dal,'dd/mm/yyyy')-1,SYSDATE,p_autore, d_id_funzione, d_tipo_competenza);
            SELECT comp_sq.NEXTVAL
              INTO d_id_competenza
              FROM DUAL;
            INSERT INTO si4_competenze
                   (id_competenza, id_abilitazione, utente, oggetto, accesso, ruolo, dal, al, data_aggiornamento, utente_aggiornamento, id_funzione, tipo_competenza)
            VALUES (d_id_competenza,v_periodi.id_abilitazione,p_utente, p_oggetto, v_periodi.accesso,p_ruolo,TO_DATE(p_al,'dd/mm/yyyy')+1,v_periodi.al,SYSDATE,p_autore, d_id_funzione, d_tipo_competenza);
            DELETE FROM si4_competenze
             WHERE id_competenza = v_periodi.id_competenza;
         END IF;
      END LOOP;
   END IF;
   /*Inserimento nuovo periodo */
   SELECT comp_sq.NEXTVAL
     INTO d_id_competenza
     FROM DUAL;
   INSERT INTO si4_competenze
            (id_competenza, id_abilitazione, utente, oggetto, accesso, ruolo, dal, al, data_aggiornamento, utente_aggiornamento, id_funzione,tipo_competenza)
   VALUES (d_id_competenza, d_id_abilitazione, p_utente, p_oggetto, p_accesso, p_ruolo, TO_DATE(p_dal,'dd/mm/yyyy'), TO_DATE(p_al,'dd/mm/yyyy'), SYSDATE, p_autore, d_id_funzione,d_tipo_competenza);
   RETURN 0;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      d_errore := -1;
      BEGIN
      /*Non esiste il tipo di oggetto */
      SELECT 1
       INTO d_esiste
       FROM si4_tipi_oggetto tiog
      WHERE tiog.tipo_oggetto = p_tipo_oggetto;
      EXCEPTION WHEN NO_DATA_FOUND THEN
      d_errore := -2;
      END;
      BEGIN
      /*Non esiste il tipo di abilitazione */
      SELECT 1
       INTO d_esiste
       FROM si4_tipi_abilitazione tiab
      WHERE tiab.tipo_abilitazione = p_tipo_abilitazione;
      EXCEPTION WHEN NO_DATA_FOUND THEN
      d_errore := -3;
      END;
   RETURN d_errore;
END assegna;
FUNCTION assegna_multipla
/******************************************************************************
 NOME:        assegna_multipla
 DESCRIZIONE: Registra la competenza per il soggetto (utente o gruppo) indicato, relativamente alle abilitazioni
                passate, separate da ";" di un determinato oggetto.
              - chiude periodo precedente alla data DAL - 1
              - sposta periodo successivo alla data AL+ 1
              - elimina periodi contenuti
              Return:
               0 : Inserimento corretto
              -1 : Tipo di abilitazione incompatibile con l'oggetto indicato
              -2 : Non esiste l'oggetto
              -3 : Non esiste il tipo di abilitazione
******************************************************************************/
( p_tipo_oggetto IN varchar2
, p_oggetto IN varchar2
, p_tipo_abilitazione IN varchar2
, p_utente IN varchar2
, p_ruolo IN varchar2 DEFAULT NULL
, p_autore IN varchar2
, p_accesso IN varchar2 DEFAULT 'S'
, p_dal IN varchar2 DEFAULT NULL
, p_al IN varchar2 DEFAULT NULL
, p_funzione IN varchar2 DEFAULT NULL)
RETURN number IS
d_result               number(1);
d_tipo_competenza      varchar2(1);
d_id_funzione          si4_competenze.id_funzione%TYPE;
d_tipo_abilitazione    varchar2(100);
d_abilitazione    varchar2(100);
d_return               number;
BEGIN
    /* Setto il tipo abilitazione */
    IF p_funzione IS NULL THEN
       d_tipo_competenza := 'U';
    ELSE
       d_tipo_competenza := 'F';
    /* Estraggo id_funzione */
    SELECT MIN(id_funzione)
      INTO d_id_funzione
      FROM si4_funzioni
     WHERE nome = p_funzione;
    END IF;
   /* Verifico che non ci siano competenze per quell'oggetto e tipo oggetto */
   SELECT NVL(MAX(1),0)
     INTO d_result
     FROM si4_tipi_oggetto tiog,
          si4_competenze comp,
          si4_abilitazioni abil
    WHERE abil.id_tipo_oggetto+0 = tiog.id_tipo_oggetto
      AND comp.id_abilitazione = abil.id_abilitazione
      AND comp.utente = p_utente
      AND comp.oggetto = p_oggetto
      AND comp.ruolo = p_ruolo
      AND NVL(comp.dal,TO_DATE('2222222','j')) <= NVL(TO_DATE(p_al,'dd/mm/yyyy'),TO_DATE('3333333','j'))
      AND NVL(comp.al,TO_DATE('3333333','j')) >= NVL(TO_DATE(p_dal,'dd/mm/yyyy'),TO_DATE('2222222','j'))
      AND NVL(comp.id_funzione,-1) = NVL(d_id_funzione,-1)
      AND tipo_competenza = d_tipo_competenza
      AND tiog.tipo_oggetto = p_tipo_oggetto ;
   d_abilitazione := p_tipo_abilitazione;
   WHILE (LENGTH(d_abilitazione) > 0) LOOP
      d_tipo_abilitazione := SUBSTR(d_abilitazione,1,INSTR(d_abilitazione,';')-1);
      d_return := assegna( p_tipo_oggetto
                         , p_oggetto
                         , d_tipo_abilitazione
                         , p_utente
                         , p_ruolo
                         , p_autore
                         , p_accesso
                         , p_dal
                         , p_al
                         , p_funzione
                         , d_result);
      IF d_return != 0 THEN
         d_abilitazione := 0;
      END IF;
      d_abilitazione := SUBSTR(d_abilitazione,INSTR(d_abilitazione,';')+1);
   END LOOP;
   RETURN d_return;
END assegna_multipla;
FUNCTION verifica_gruppi
/******************************************************************************
 NOME:        verifica_gruppi
 DESCRIZIONE: Verifica l'abilitazione di accesso ad una certa data restituendo il valore 1 o 0 in funzione del contenuto nel campo ACCESSO.
              Ritorna:
              1 : se esiste il diritto di accesso
              0 : se non esiste diritto di accesso
******************************************************************************/
( p_null_gestito IN number
, p_tipo_oggetto IN varchar2
, p_oggetto IN varchar2
, p_tipo_abilitazione IN varchar2
, p_utente IN varchar2
, p_data IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy'))
RETURN number IS
CURSOR c_competenze ( v_oggetto varchar2
                    , v_id_abilitazione number
                    , v_data varchar2
                    , v_utente varchar2
           )
   IS
   SELECT DECODE(comp.accesso,'S',1,'N',0), utgr.gruppo
     FROM si4_competenze comp,
          ad4_utenti_gruppo utgr
    WHERE comp.id_abilitazione(+) = v_id_abilitazione
      AND comp.utente(+) = utgr.gruppo
      AND TO_DATE(v_data,'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                           AND NVL(al ,TO_DATE('3333333','j'))
      AND comp.oggetto(+) = v_oggetto
      AND utgr.utente(+) =  v_utente
      AND comp.tipo_competenza(+) = 'U'
      ORDER BY DECODE(comp.accesso,'S',1,'N',2);
d_return          number(1);
d_diritto         number(1);
d_gruppo          ad4_utenti_gruppo.gruppo%TYPE;
d_id_abilitazione si4_abilitazioni.id_abilitazione%TYPE;
BEGIN
   -- Estraggo ID_ABILITAZIONE
      SELECT abil.id_abilitazione
        INTO d_id_abilitazione
        FROM si4_abilitazioni abil,
             si4_tipi_oggetto tiog,
             si4_tipi_abilitazione tiab
       WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
         AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
         AND tiog.tipo_oggetto = p_tipo_oggetto
         AND tiab.tipo_abilitazione =p_tipo_abilitazione
        ;
      -- Verifico le competenze per i vari livelli
      OPEN c_competenze(p_oggetto, d_id_abilitazione, p_data, p_utente);
      LOOP
         EXIT WHEN d_diritto = 1;
         FETCH c_competenze INTO d_diritto, d_gruppo;
         EXIT WHEN c_competenze%NOTFOUND;
         IF d_diritto = 1 THEN
            -- d_return := d_diritto;
            EXIT; --close c_competenze;
            -- return d_return;
         ELSIF d_diritto = 0 THEN
            --d_return := d_diritto;
            NULL;
         ELSIF d_diritto IS NULL AND d_gruppo IS NULL THEN
            EXIT; --close c_competenze;
            --return d_return;
         ELSIF d_diritto IS NULL THEN
               d_diritto := verifica_gruppi( p_null_gestito , p_tipo_oggetto, p_oggetto, p_tipo_abilitazione, d_gruppo, p_data);
         END IF;
      END LOOP;
      CLOSE c_competenze;
    --    IF p_Null_gestito = 0 and d_diritto is null THEN
     --      d_return := 0;
    --    else
           d_return := d_diritto;
    --    END IF;
      RETURN d_return;
END;
FUNCTION verifica_funzionale
/******************************************************************************
 NOME:        verifica
 DESCRIZIONE: Verifica l'abilitazione di accesso ad una certa data restituendo il valore 1 o 0 in funzione del contenuto nel campo ACCESSO.
              Controlla prima l'accesso specifico per il Soggetto e poi per appartenenza ai diversi Gruppi.
              Se il ruolo e indicato in ingresso controlla l'esistenza di una competenza con quel ruolo o in assenza di questa, senza ruolo.
              Se il ruolo non e indicato in ingresso, per ogni gruppo acquisisce il Ruolo del Soggetto nel Gruppo
              Ritorna:
              1 : se esiste il diritto di accesso
              0 : se non esiste diritto di accesso
******************************************************************************/
( p_null_gestito IN number
, p_tipo_oggetto IN varchar2
, p_oggetto IN varchar2
, p_tipo_abilitazione IN varchar2
, p_utente IN varchar2
, p_ruolo IN varchar2 DEFAULT NULL
, p_data IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy'))
RETURN number IS
d_diritto   number(1);
d_funzione  number(10);
d_nome      varchar2(30);
d_testo     varchar2(4000);
d_new_testo varchar2(4000);
d_cursor         integer;
d_rows_processed integer;
BEGIN
   BEGIN
  -- DBMS_OUTPUT.PUT_LINE('VER FUNZ '||p_Oggetto||' utente='||p_Utente);
      /* Competenza Funzionale sull'Oggetto*/
      SELECT  funz.id_funzione, funz.nome, funz.testo
        INTO d_funzione, d_nome, d_testo
        FROM si4_competenze comp,
             si4_abilitazioni abil,
             si4_tipi_oggetto tiog,
             si4_tipi_abilitazione tiab,
             si4_funzioni funz
       WHERE abil.id_tipo_oggetto +0 = tiog.id_tipo_oggetto
         AND abil.id_tipo_abilitazione+0 = tiab.id_tipo_abilitazione
         AND comp.id_abilitazione = abil.id_abilitazione
         AND comp.id_funzione = funz.id_funzione
         AND comp.utente IS NULL
         AND TO_DATE(p_data,'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                              AND NVL(al ,TO_DATE('3333333','j'))
         AND tiog.tipo_oggetto = p_tipo_oggetto
         AND tiab.tipo_abilitazione = p_tipo_abilitazione
         AND comp.oggetto = p_oggetto
         AND NVL(comp.ruolo,'x') = NVL(p_ruolo,'x')
         AND tipo_competenza = 'F';
      --   DBMS_OUTPUT.PUT_LINE(d_funzione||', '||d_nome);
      EXCEPTION WHEN NO_DATA_FOUND THEN
         /* Competenza Funzionale sul Tipo Oggetto*/
         SELECT funz.id_funzione, funz.nome, funz.testo
           INTO d_funzione, d_nome, d_testo
           FROM si4_competenze comp,
                si4_abilitazioni abil,
                si4_tipi_oggetto tiog,
                si4_tipi_abilitazione tiab,
                si4_funzioni funz
          WHERE abil.id_tipo_oggetto+0 = tiog.id_tipo_oggetto
            AND abil.id_tipo_abilitazione+0 = tiab.id_tipo_abilitazione
            AND comp.id_abilitazione = abil.id_abilitazione
            AND comp.id_funzione = funz.id_funzione
            AND comp.utente IS NULL
            AND TO_DATE(p_data,'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                                 AND NVL(al ,TO_DATE('3333333','j'))
            AND tiog.tipo_oggetto = p_tipo_oggetto
            AND tiab.tipo_abilitazione = p_tipo_abilitazione
            AND comp.oggetto IS NULL
            AND NVL(comp.ruolo,'x') = NVL(p_ruolo,'x')
            AND tipo_competenza ='F';
      END;
      /* Eseguo il Binding del testo trovato*/
      d_testo := si4comp_binding(d_testo, p_oggetto,p_tipo_oggetto);
      /***************************AGGIUNTO DA SC **************************/
--      d_testo := REPLACE(REPLACE(d_testo,':OGGETTO',p_Oggetto),CHR(13),' ');
      /***************************FINE AGGIUNTO DA SC **************************/
      /* Eseguo il testo della funzione sostituendo :UTENTE con l'utente e gli eventuali gruppi a cui appartiene*/
      FOR c_utente IN (SELECT p_utente utente
                         FROM DUAL
                        UNION ALL
                       SELECT gruppo
                         FROM ad4_utenti_gruppo utgr
             CONNECT BY PRIOR gruppo = utente
                   START WITH utente = p_utente) LOOP
         d_new_testo := REPLACE(REPLACE(d_testo,':UTENTE',c_utente.utente),CHR(13),' ');
        /* Controllo se si tratta di un blocco Begin End, di una funzione o di una Procedura */
        -- controllo ed eventuale  modifica statement
        IF UPPER (SUBSTR (LTRIM (d_new_testo), 1, 2)) =':=' THEN
           /* AGGIUNGO LA GESTIONE DEL RITORNO */
           d_new_testo :=
                 'DECLARE d_ritorno number(1);'
              || 'BEGIN d_ritorno'
              || RTRIM (d_new_testo, ' ;')
              || '; if d_ritorno = 1 then si4_competenza.set_true; '
              || ' elsif d_ritorno = 0 then si4_competenza.set_false; '
              || 'end if; END;';
        ELSIF UPPER (SUBSTR (LTRIM (d_new_testo), 1,5)) != 'BEGIN' THEN
           /* in caso di declare mette un altro begin end esterno */
           d_new_testo :=
               'DECLARE d_ritorno number(1);'
              || 'BEGIN '
              || RTRIM (d_new_testo, ' ;')
              || '; if d_ritorno = 1 then si4_competenza.set_true; '
              || ' elsif d_ritorno = 0 then si4_competenza.set_false; '
              || 'end if; END;';
        END IF;
        BEGIN
      --  DBMS_OUTPUT.PUT_LINE(SUBSTR(d_new_testo,1,255));
           resetta;
--           d_cursor := DBMS_SQL.OPEN_CURSOR;
--           DBMS_SQL.PARSE( d_cursor, d_new_testo, dbms_sql.native );
--           d_rows_processed := DBMS_SQL.EXECUTE( d_cursor );
--           DBMS_SQL.CLOSE_CURSOR( d_cursor );
           EXECUTE IMMEDIATE d_new_testo;
        EXCEPTION
           WHEN OTHERS THEN
              --DBMS_SQL.CLOSE_CURSOR( d_cursor );
              RAISE;
        END;
     --   DBMS_OUTPUT.PUT_LINE('g_diritto '||g_diritto);
        d_diritto := g_diritto;
        IF d_diritto IS NOT NULL THEN
           EXIT;
        END IF;
     END LOOP;
--     IF d_diritto IS NULL THEN
--        RAISE_APPLICATION_ERROR(-20999,'La funzione restituisce il valore null');
--     END IF;
  --   DBMS_OUTPUT.PUT_LINE('d_diritto '||d_diritto);
     RETURN d_diritto;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
        IF p_null_gestito = 0 THEN
           d_diritto := 0;
        END IF;
        RETURN d_diritto;
END;
FUNCTION verifica
/******************************************************************************
 NOME:        verifica
 DESCRIZIONE: Verifica l'abilitazione di accesso ad una certa data restituendo il valore 1 o 0 in funzione del contenuto nel campo ACCESSO.
              Controlla prima l'accesso specifico per il Soggetto e poi per appartenenza ai diversi Gruppi.
              Se il ruolo e indicato in ingresso controlla l'esistenza di una competenza con quel ruolo o in assenza di questa, senza ruolo.
              Se il ruolo non e indicato in ingresso, per ogni gruppo acquisisce il Ruolo del Soggetto nel Gruppo
              Ritorna:
              1 : se esiste il diritto di accesso
              0 : se non esiste diritto di accesso
******************************************************************************/
( p_null_gestito IN number
, p_tipo_oggetto IN varchar2
, p_oggetto IN varchar2
, p_tipo_abilitazione IN varchar2
, p_utente IN varchar2
, p_ruolo IN varchar2 DEFAULT NULL
, p_data IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy'))
RETURN number
IS
d_diritto   number(1);
d_ruolo     varchar2(250);
--d_funzione  NUMBER(10);
--d_nome      VARCHAR2(30);
--d_testo     VARCHAR2(4000);
--d_new_testo VARCHAR2(4000);
--d_cursor         INTEGER;
--d_rows_processed INTEGER;
d_exists         number(1);
/* Estraggo tutte le competenze sull'oggetto assegnate ad utenti di tipo Gruppi e Organizzazioni */
   CURSOR c_competenze ( v_tipo_oggetto varchar2
           , v_oggetto varchar2
           , v_tipo_abilitazione varchar2
        , v_data varchar2
           )
   IS
   SELECT comp.utente, comp.ruolo, uten.tipo_utente
     FROM si4_competenze comp,
          si4_abilitazioni abil,
          si4_tipi_oggetto tiog,
          si4_tipi_abilitazione tiab,
       ad4_utenti uten
    WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
      AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
      AND comp.id_abilitazione = abil.id_abilitazione
      AND comp.utente = uten.utente
      AND TO_DATE(v_data,'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                           AND NVL(al ,TO_DATE('3333333','j'))
      AND tiog.tipo_oggetto = v_tipo_oggetto
      AND tiab.tipo_abilitazione = v_tipo_abilitazione
      AND comp.oggetto = v_oggetto
      AND uten.tipo_utente IN ('G','O')
      AND accesso = 'S'
      AND comp.tipo_competenza = 'U';
BEGIN
      /*Verifica l'esistenza di una competenza per utente e ruolo */
      SELECT DECODE(accesso,'S',1,'N',0)
        INTO d_diritto
        FROM si4_competenze comp,
             si4_abilitazioni abil,
             si4_tipi_oggetto tiog,
             si4_tipi_abilitazione tiab
       WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
         AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
         AND comp.id_abilitazione = abil.id_abilitazione
         AND comp.utente = p_utente
         AND TO_DATE(p_data,'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                              AND NVL(al ,TO_DATE('3333333','j'))
         AND tiog.tipo_oggetto = p_tipo_oggetto
         AND tiab.tipo_abilitazione = p_tipo_abilitazione
         AND comp.oggetto = p_oggetto
         AND NVL(comp.ruolo,'x') = NVL(p_ruolo,'x')
         AND comp.tipo_competenza = 'U';
      RETURN d_diritto;
EXCEPTION
      WHEN NO_DATA_FOUND THEN
      BEGIN
      /*Verifica l'esistenza di una competenza per utente e ruolo nullo */
      SELECT DECODE(accesso,'S',1,'N',0)
        INTO d_diritto
        FROM si4_competenze comp,
             si4_abilitazioni abil,
             si4_tipi_oggetto tiog,
             si4_tipi_abilitazione tiab
       WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
         AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
         AND comp.id_abilitazione = abil.id_abilitazione
         AND comp.utente = p_utente
         AND TO_DATE(p_data,'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                              AND NVL(al ,TO_DATE('3333333','j'))
         AND tiog.tipo_oggetto = p_tipo_oggetto
         AND tiab.tipo_abilitazione = p_tipo_abilitazione
         AND comp.oggetto = p_oggetto
         AND comp.ruolo IS NULL
         AND comp.tipo_competenza = 'U';
      RETURN d_diritto;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
         /*Verifica l'esistenza di una competenza per gruppi*/
         d_diritto := verifica_gruppi(p_null_gestito,p_tipo_oggetto,p_oggetto,p_tipo_abilitazione, p_utente, p_data);
--         FOR v_competenze IN c_competenze ( p_Tipo_Oggetto, p_Oggetto, p_Tipo_Abilitazione, p_Data)
--             LOOP
--                SELECT DECODE(MAX(utente), NULL, NULL, 1)
--                  INTO d_diritto
--                  FROM ad4_utenti_gruppo utgr
--                 WHERE utgr.gruppo = v_competenze.utente
--                   AND NVL(v_competenze.ruolo,NVL(p_ruolo,'x')) = NVL(p_ruolo,'x')
--               CONNECT BY PRIOR gruppo = utente
--                 START WITH utente = p_utente;
--            IF v_competenze.tipo_utente = 'O' and d_diritto is null THEN
--               d_exists := SO4_UTIL.exists_reference(p_utente, v_competenze.utente,NULL /*v_competenze.ruolo*/);
--               IF d_exists = 1 THEN
--                  d_diritto := 1;
--               END IF;
--            END IF;
--           IF d_diritto = 1 THEN
--               EXIT;
--            END IF;
--         END LOOP;
       /* Se non ho trovato competenze (d_diritto null) verifico eventuali competenze funzionali*/
        IF d_diritto IS NULL THEN
        d_diritto := verifica_funzionale( p_null_gestito, p_tipo_oggetto, p_oggetto, p_tipo_abilitazione, p_utente, p_ruolo, p_data);
        END IF;
        IF d_diritto IS NULL THEN
            IF p_null_gestito = 0 THEN
               d_diritto := 0;
            END IF;
        END IF;
      END;
      RETURN d_diritto;
END verifica;
FUNCTION verifica
/******************************************************************************
 NOME:        verifica
 DESCRIZIONE: Verifica l'abilitazione di accesso ad una certa data restituendo il valore 1 o 0 in funzione del contenuto nel campo ACCESSO.
              Controlla prima l'accesso specifico per il Soggetto e poi per appartenenza ai diversi Gruppi.
              Se il ruolo e indicato in ingresso controlla l'esistenza di una competenza con quel ruolo o in assenza di questa, senza ruolo.
              Se il ruolo non e indicato in ingresso, per ogni gruppo acquisisce il Ruolo del Soggetto nel Gruppo
              Ritorna:
              1 : se esiste il diritto di accesso
              0 : se non esiste diritto di accesso
******************************************************************************/
( p_tipo_oggetto IN varchar2
, p_oggetto IN varchar2
, p_tipo_abilitazione IN varchar2
, p_utente IN varchar2
, p_ruolo IN varchar2 DEFAULT NULL
, p_data IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy'))
RETURN number
IS
d_diritto number(1) := 0;
BEGIN
   d_diritto := verifica( 0
                        , p_tipo_oggetto
                        , p_oggetto
                        , p_tipo_abilitazione
                        , p_utente
                        , p_ruolo
                        , p_data);
RETURN d_diritto;
END verifica;
FUNCTION get_tipo_abilitazione
/******************************************************************************
 NOME:        get_tipo_abilitazione
 DESCRIZIONE: Ritorna la descrizione della abilitazione richiesta.
              NULL : se l'abilitazione non esiste
******************************************************************************/
( p_tipo_abilitazione IN varchar2)
RETURN varchar2
IS
v_descrizione varchar2(2000);
BEGIN
   SELECT descrizione
     INTO v_descrizione
     FROM si4_tipi_abilitazione
   WHERE tipo_abilitazione = p_tipo_abilitazione
   ;
   RETURN v_descrizione;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
   RETURN NULL;
END get_tipo_abilitazione;
FUNCTION oggetti
/******************************************************************************
 NOME:        oggetti
 DESCRIZIONE: Ritorna una stringa con gli oggetti a cui l'utente e abilitato.
******************************************************************************/
( p_utente IN varchar2
, p_tipo_abilitazione IN varchar2 DEFAULT '%'
, p_ruolo IN varchar2 DEFAULT NULL
, p_tipo_oggetto IN varchar2 DEFAULT '%'
, p_oggetto IN varchar2 DEFAULT'%'
, p_data IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy')
, p_separatore IN varchar2 DEFAULT ';'
)
RETURN varchar2
IS
sstringat varchar2(32767);
BEGIN
FOR c IN (SELECT p_utente utente
            FROM DUAL
    UNION
    SELECT gruppo
            FROM ad4_utenti_gruppo
       START WITH utente = p_utente
 CONNECT BY PRIOR gruppo = utente) LOOP
   FOR c_comp IN (   SELECT comp.oggetto sstringa
                       FROM si4_competenze comp,
                            si4_abilitazioni abil,
                            si4_tipi_oggetto tiog,
                            si4_tipi_abilitazione tiab
                      WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
                        AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
                        AND comp.id_abilitazione = abil.id_abilitazione
                        AND TO_DATE(NVL(p_data,TO_CHAR(SYSDATE,'dd/mm/yyyy')),'dd/mm/yyyy') BETWEEN NVL(dal,TO_DATE('2222222','j'))
                                           AND NVL(al ,TO_DATE('3333333','j'))
                        AND tiog.tipo_oggetto LIKE NVL(p_tipo_oggetto,'%')
                        AND tiab.tipo_abilitazione LIKE NVL(p_tipo_abilitazione,'%')
                        AND comp.oggetto LIKE NVL(p_oggetto,'%')
                        AND accesso = 'S'
                        AND NVL(comp.ruolo,'x') = NVL(p_ruolo,'x')
                        AND comp.utente  = c.utente) LOOP
      sstringat := sstringat||p_separatore||c_comp.sstringa;
   END LOOP;
END LOOP;
RETURN LTRIM(sstringat,p_separatore);
END oggetti;
FUNCTION open_comp_cv
/******************************************************************************
 NOME:        open_comp_cv
 DESCRIZIONE: Dato un utente e un oggetto, ritorna le informazioni su chi ha dato
              l'abilitazione, quando ed il tipo di abilitazione.
 RITORNA:  REF CURSOR con l'utente che ha assegnato la competenza,
           la data di assegnazione e il tipo di competenza:
******************************************************************************/
( p_utente IN varchar2
, p_oggetto IN varchar2)
 RETURN compcurtyp
IS
comp_cv compcurtyp;
BEGIN
OPEN comp_cv FOR SELECT comp.utente_aggiornamento
                      , comp.data_aggiornamento
                      , tiab.tipo_abilitazione
                  FROM si4_competenze comp
                     , si4_abilitazioni abil
                     , si4_tipi_abilitazione tiab
                 WHERE comp.id_abilitazione = abil.id_abilitazione
                   AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
                   AND comp.utente = p_utente
                   AND comp.oggetto = p_oggetto
                 ORDER BY 2;
RETURN comp_cv;
END;
FUNCTION get_competenze
/******************************************************************************
 NOME:        get_competenze
 DESCRIZIONE: Dato un utente ed un oggetto ritorna una stringa con le competenze
              separati da un separatore parametrizzabile:
 RITORNA:  Stringa
******************************************************************************/
( p_utente IN varchar2
, p_oggetto IN varchar2
, p_separatore IN varchar2 DEFAULT ';')
 RETURN varchar2
 IS
 sstringat varchar2(32767);
 BEGIN
    FOR c_comp IN (SELECT tiab.tipo_abilitazione sstringa
                  FROM si4_competenze comp
                     , si4_abilitazioni abil
                     , si4_tipi_abilitazione tiab
                 WHERE comp.id_abilitazione = abil.id_abilitazione
                   AND abil.id_tipo_abilitazione = tiab.id_tipo_abilitazione
                   AND comp.utente = p_utente
                   AND comp.oggetto = p_oggetto) LOOP
    sstringat := sstringat||p_separatore||c_comp.sstringa;
    END LOOP;
 RETURN LTRIM(sstringat,p_separatore);
 END;
PROCEDURE chiudi
/******************************************************************************
 DESCRIZIONE: Chiude le registrazioni di competenza previste per p_utente alla
              data prevista in parametro.
              Se il p_tipo_oggetto non è indicato opera su tutti gli oggetti.
              Se la p_data non è indicata le chiude alla data di oggi.
 NOTE:        .
******************************************************************************/
( p_utente       IN varchar2
, p_tipo_oggetto IN varchar2 DEFAULT NULL
, p_data         IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy')
, p_oggetto      IN varchar2 DEFAULT NULL) IS
BEGIN
   /* Se p_tipo oggetto è nullo chiudo le competenze per tutti gli oggetti*/
   IF p_tipo_oggetto IS NULL THEN
      UPDATE si4_competenze
         SET al =  TO_DATE(p_data,'dd/mm/yyyy')
       WHERE utente = p_utente
         AND oggetto = NVL(p_oggetto, oggetto);
   ELSE
     FOR c_abil IN (SELECT id_abilitazione
                      FROM si4_abilitazioni abil
                         , si4_tipi_oggetto tiog
                     WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
                       AND tiog.tipo_oggetto = p_tipo_oggetto
                       ) LOOP
        UPDATE si4_competenze
           SET al =  TO_DATE(p_data,'dd/mm/yyyy')
         WHERE utente = p_utente
           AND oggetto = NVL(p_oggetto, oggetto)
           AND id_abilitazione = c_abil.id_abilitazione;
     END LOOP;
  END IF;
END;
PROCEDURE apri
/******************************************************************************
 DESCRIZIONE: Apre una nuova registrazione con le caratteristiche previste per le
              competenze relative a p_da_utente.
              Se il p_tipo_oggetto non è indicato opera su tutti gli oggetti.
              Se la p_data non è indicata assume la data di oggi.
 NOTE:        .
******************************************************************************/
( p_da_utente       IN varchar2
, p_a_utente        IN varchar2
, p_tipo_oggetto    IN varchar2 DEFAULT NULL
, p_data            IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy')) IS
BEGIN
   FOR c_comp IN (SELECT comp.*
                    FROM si4_competenze comp
                       , si4_abilitazioni abil
                       , si4_tipi_oggetto tiog
                   WHERE comp.id_abilitazione = abil.id_abilitazione
                     AND abil.id_tipo_oggetto = tiog.id_tipo_oggetto
                     AND tiog.tipo_oggetto = NVL(p_tipo_oggetto, tiog.tipo_oggetto)
                     AND comp.utente = p_da_utente) LOOP
      INSERT INTO si4_competenze ( id_abilitazione
                                 , utente
                                 , oggetto
                                 , accesso
                                 , ruolo
                                 , dal
                                 , al
                                 , data_aggiornamento
                                 , utente_aggiornamento
                                 , id_funzione
                                 , tipo_competenza)
                          VALUES ( c_comp.id_abilitazione
                                 , p_a_utente
                                 , c_comp.oggetto
                                 , c_comp.accesso
                                 , c_comp.ruolo
                                 , TO_DATE(p_data, 'dd/mm/yyyy')
                                 , c_comp.al
                                 , SYSDATE
                                 , USER
                                 , c_comp.id_funzione
                                 , c_comp.tipo_competenza);
   END LOOP;
END;
PROCEDURE sposta
/******************************************************************************
 DESCRIZIONE: Sposta le competenze da un utente ad un altro utente per il tipo_oggetto
              indicato, chiudendo la competenza di provenienza alla data p_data-1 e
              aprendo la nuova competenza alla data p_data.
              Se il p_tipo_oggetto non è indicato opera su tutti gli oggetti.
              Se la p_data non è indicata assume la data di oggi.
              Se come p_data viene passato NULL agisce in modalità UPDATE, modificando
              direttamente le competenze presenti da p_da_utente a p_a_utente.
 NOTE:        .
******************************************************************************/
( p_da_utente       IN varchar2
, p_a_utente        IN varchar2
, p_tipo_oggetto    IN varchar2 DEFAULT NULL
, p_data            IN varchar2 DEFAULT TO_CHAR(SYSDATE,'dd/mm/yyyy')) IS
d_data              date;
BEGIN
   IF p_data IS NULL AND p_tipo_oggetto IS NULL THEN
      UPDATE si4_competenze
         SET utente = p_a_utente
       WHERE utente = p_da_utente;
   ELSIF p_data IS NULL AND p_tipo_oggetto IS NOT NULL THEN
      FOR c_abil IN (SELECT id_abilitazione
                      FROM si4_abilitazioni abil
                         , si4_tipi_oggetto tiog
                     WHERE abil.id_tipo_oggetto = tiog.id_tipo_oggetto
                       AND tiog.tipo_oggetto = p_tipo_oggetto) LOOP
      UPDATE si4_competenze
         SET utente =  p_a_utente
       WHERE utente = p_da_utente
         AND id_abilitazione = c_abil.id_abilitazione;
     END LOOP;
   ELSE
      d_data := TO_DATE(p_data,'dd/mm/yyyy')-1;
      apri  (p_da_utente, p_a_utente, p_tipo_oggetto, p_data);
      chiudi(p_da_utente, p_tipo_oggetto, TO_CHAR(d_data,'dd/mm/yyyy'));
   END IF;
END;
END si4_competenza;
/


CREATE TABLE TASK_FUNZIONI
(
  ID_TASK              NUMBER(8)                NOT NULL,
  ID_FUNZIONE          NUMBER(8)                NOT NULL,
  VALORE_PARAMETRO_1   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_2   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_3   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_4   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_5   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_6   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_7   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_8   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_9   VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_10  VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_11  VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_12  VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_13  VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_14  VARCHAR2(99 BYTE),
  VALORE_PARAMETRO_15  VARCHAR2(99 BYTE),
  UTENTE               VARCHAR2(8 BYTE),
  DATA_ELABORAZIONE    TIMESTAMP(6),
  DATA_TERMINE         TIMESTAMP(6)
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON COLUMN TASK_FUNZIONI.ID_TASK IS 'Pk task';

COMMENT ON COLUMN TASK_FUNZIONI.ID_FUNZIONE IS 'Funzione eseguita nell''ambito del task';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_1 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_2 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_3 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_4 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_5 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_6 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_7 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_8 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_9 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_10 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_11 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_12 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_13 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_14 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.VALORE_PARAMETRO_15 IS 'Valore del parametro';

COMMENT ON COLUMN TASK_FUNZIONI.UTENTE IS 'Utente che ha richiesto l''esecuzione del task';

COMMENT ON COLUMN TASK_FUNZIONI.DATA_ELABORAZIONE IS 'Data di inizio dell''elaborazione';

COMMENT ON COLUMN TASK_FUNZIONI.DATA_TERMINE IS 'Data di termine dell''elaborazione';




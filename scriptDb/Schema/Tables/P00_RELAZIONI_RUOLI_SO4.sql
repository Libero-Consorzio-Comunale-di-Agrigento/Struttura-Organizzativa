CREATE TABLE P00_RELAZIONI_RUOLI_SO4
(
  RRSO4_ID               NUMBER(10)             NOT NULL,
  FIGURA                 VARCHAR2(8 BYTE)       DEFAULT '%'                   NOT NULL,
  PROFILO_PROFESSIONALE  VARCHAR2(4 BYTE)       DEFAULT '%'                   NOT NULL,
  POSIZIONE_FUNZIONALE   VARCHAR2(4 BYTE)       DEFAULT '%'                   NOT NULL,
  ATTIVITA               VARCHAR2(4 BYTE)       DEFAULT '%'                   NOT NULL,
  TIPO_RAPPORTO          VARCHAR2(4 BYTE)       DEFAULT '%'                   NOT NULL,
  CONTRATTO              VARCHAR2(4 BYTE)       DEFAULT '%'                   NOT NULL,
  QUALIFICA              VARCHAR2(8 BYTE)       DEFAULT '%'                   NOT NULL,
  DI_RUOLO               VARCHAR2(2 BYTE)       DEFAULT '%'                   NOT NULL,
  TEMPO_DETERMINATO      VARCHAR2(2 BYTE)       DEFAULT '%'                   NOT NULL,
  PART_TIME              VARCHAR2(2 BYTE)       DEFAULT '%'                   NOT NULL,
  FORMAZIONE_LAVORO      VARCHAR2(2 BYTE)       DEFAULT '%'                   NOT NULL,
  COLLABORATORE          VARCHAR2(2 BYTE)       DEFAULT '%'                   NOT NULL,
  CHIAVE                 VARCHAR2(46 BYTE)      DEFAULT '%%%%%%%%%%%%'        NOT NULL,
  RUOLO_SO4              VARCHAR2(8 BYTE)       NOT NULL
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



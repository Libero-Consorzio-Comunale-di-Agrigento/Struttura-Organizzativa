CREATE TABLE AMV_DOCUMENTI_REVISIONI
(
  ID_DOCUMENTO         NUMBER(10)               NOT NULL,
  REVISIONE            NUMBER(10)               NOT NULL,
  DATA_REDAZIONE       DATE,
  UTENTE_REDAZIONE     VARCHAR2(8 BYTE),
  DATA_VERIFICA        DATE,
  UTENTE_VERIFICA      VARCHAR2(8 BYTE),
  DATA_APPROVAZIONE    DATE,
  UTENTE_APPROVAZIONE  VARCHAR2(8 BYTE),
  CRONOLOGIA           VARCHAR2(4000 BYTE),
  NOTE                 VARCHAR2(4000 BYTE)
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



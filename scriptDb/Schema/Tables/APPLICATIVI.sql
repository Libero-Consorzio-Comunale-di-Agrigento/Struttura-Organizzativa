CREATE TABLE APPLICATIVI
(
  ID_APPLICATIVO        NUMBER                  NOT NULL,
  DESCRIZIONE           VARCHAR2(4000 BYTE)     NOT NULL,
  ISTANZA               VARCHAR2(10 BYTE),
  MODULO                VARCHAR2(10 BYTE),
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE
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



CREATE TABLE SLAVES
(
  DB_LINK      VARCHAR2(200 BYTE)               NOT NULL,
  LINK_ORACLE  VARCHAR2(2000 BYTE)              NOT NULL,
  STATO        VARCHAR2(1 BYTE)                 DEFAULT 'A'                   NOT NULL
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

COMMENT ON TABLE SLAVES IS 'Tabella contenente l''elenco dei dblink degli eventuali user so4 slaves.';




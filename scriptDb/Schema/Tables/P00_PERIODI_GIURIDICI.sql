CREATE TABLE P00_PERIODI_GIURIDICI
(
  CI             NUMBER(8)                      NOT NULL,
  RILEVANZA      VARCHAR2(1 BYTE)               NOT NULL,
  DAL            DATE                           NOT NULL,
  AL             DATE,
  EVENTO         VARCHAR2(6 BYTE)               NOT NULL,
  POSIZIONE      VARCHAR2(4 BYTE),
  TIPO_RAPPORTO  VARCHAR2(4 BYTE),
  QUALIFICA      NUMBER(6),
  FIGURA         NUMBER(6),
  ATTIVITA       VARCHAR2(4 BYTE),
  GESTIONE       VARCHAR2(8 BYTE),
  SETTORE        NUMBER(8),
  SEDE           NUMBER(6)
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



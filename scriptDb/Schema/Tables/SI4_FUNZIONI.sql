CREATE TABLE SI4_FUNZIONI
(
  ID_FUNZIONE  NUMBER(10)                       NOT NULL,
  NOME         VARCHAR2(30 BYTE)                NOT NULL,
  TESTO        VARCHAR2(4000 BYTE)              NOT NULL
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

COMMENT ON TABLE SI4_FUNZIONI IS 'FUNZ - Funzioni per Gestione Competenze Funzionali';




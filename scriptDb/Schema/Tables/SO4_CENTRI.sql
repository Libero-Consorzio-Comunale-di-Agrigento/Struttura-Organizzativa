CREATE TABLE SO4_CENTRI
(
  CENTRO           VARCHAR2(16 BYTE)            NOT NULL,
  DESCRIZIONE      VARCHAR2(60 BYTE),
  DESCRIZIONE_ABB  VARCHAR2(30 BYTE),
  TIPO_CENTRO      VARCHAR2(8 BYTE),
  DATA_VALIDITA    DATE
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

COMMENT ON TABLE SO4_CENTRI IS 'Tabella per la gestione dell''integrazione con CG4.
In presenza di integrazione, la vista CENTRI punta al sinonimo CG4_CENTRI_SYN; in assenza di integrazione, la vista CENTRI punta alla tabella SO4_CENTRI.';

COMMENT ON COLUMN SO4_CENTRI.DESCRIZIONE IS 'Descrizione centro di costo';




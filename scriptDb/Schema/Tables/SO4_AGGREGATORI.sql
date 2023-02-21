CREATE TABLE SO4_AGGREGATORI
(
  AGGREGATORE           VARCHAR2(16 BYTE)       NOT NULL,
  DESCRIZIONE           VARCHAR2(200 BYTE),
  DATA_INIZIO_VALIDITA  DATE                    NOT NULL,
  DATA_FINE_VALIDITA    DATE
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

COMMENT ON TABLE SO4_AGGREGATORI IS 'Tabella per la gestione dell''integrazione con CGS.
In presenza di integrazione, la vista AGGREGATORI  punta al sinonimo CGS_AGGREGATORI_SYN; in assenza di integrazione, la vista AGGREGATORI  punta alla tabella SO4_AGGREGATORI .';

COMMENT ON COLUMN SO4_AGGREGATORI.DESCRIZIONE IS 'Descrizione aggregatore';




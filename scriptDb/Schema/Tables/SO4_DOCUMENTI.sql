CREATE TABLE SO4_DOCUMENTI
(
  TIPO_REGISTRO     VARCHAR2(4 BYTE)            NOT NULL,
  ANNO              NUMBER(4)                   NOT NULL,
  NUMERO            NUMBER(8)                   NOT NULL,
  TIPO_DOCUMENTO    VARCHAR2(4 BYTE),
  DATA_PROTOCOLLO   DATE,
  MOVIMENTO         VARCHAR2(3 BYTE),
  DATA_ARRIVO       DATE,
  MOD_RICEVIMENTO   VARCHAR2(4 BYTE),
  NUMERO_DOCUMENTO  VARCHAR2(20 BYTE),
  DATA_DOCUMENTO    DATE,
  DATA_SCADENZA     DATE,
  DATA_EVASIONE     DATE,
  TIPO_STATO        VARCHAR2(4 BYTE)
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

COMMENT ON TABLE SO4_DOCUMENTI IS 'Tabella per la gestione dell''integrazione con GS4.
In presenza di integrazione, la vista DOCUMENTI punta al sinonimo GS4_DOCUMENTI_SYN; in assenza di integrazione, la vista DOCUMENTI punta alla tabella SO4_DOCUMENTI.';




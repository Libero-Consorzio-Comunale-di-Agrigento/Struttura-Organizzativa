CREATE TABLE TIPI_INCARICO
(
  INCARICO         VARCHAR2(8 BYTE)             NOT NULL,
  DESCRIZIONE      VARCHAR2(120 BYTE)           NOT NULL,
  DESCRIZIONE_AL1  VARCHAR2(120 BYTE),
  DESCRIZIONE_AL2  VARCHAR2(120 BYTE),
  RESPONSABILE     VARCHAR2(2 BYTE)             DEFAULT 'NO',
  SE_ASPETTATIVA   VARCHAR2(2 BYTE)             DEFAULT 'NO',
  ORDINAMENTO      NUMBER(3),
  TIPO_INCARICO    VARCHAR2(1 BYTE)
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON TABLE TIPI_INCARICO IS 'Dizionario dei tipi incarico';

COMMENT ON COLUMN TIPI_INCARICO.INCARICO IS 'Codice incarico';

COMMENT ON COLUMN TIPI_INCARICO.DESCRIZIONE IS 'Descrizione incarico';

COMMENT ON COLUMN TIPI_INCARICO.DESCRIZIONE_AL1 IS 'Descrizione incarico in lingua alternativa 1';

COMMENT ON COLUMN TIPI_INCARICO.DESCRIZIONE_AL2 IS 'Descrizione incarico in lingua alternativa 2';

COMMENT ON COLUMN TIPI_INCARICO.RESPONSABILE IS 'Valori possibili :  SI / NO, Default NO';

COMMENT ON COLUMN TIPI_INCARICO.SE_ASPETTATIVA IS 'Valori possibili :  SI / NO, Default NO';

COMMENT ON COLUMN TIPI_INCARICO.ORDINAMENTO IS 'Per ordinare l''esposizione dei componenti';

COMMENT ON COLUMN TIPI_INCARICO.TIPO_INCARICO IS 'Indica il tipo di incarico. Valori previsti:
A - Amministrativo
P - Politico
S - Sanitario
E - Esterno';




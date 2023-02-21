CREATE TABLE SOGGETTI_RUBRICA
(
  NI                    NUMBER(8)               NOT NULL,
  TIPO_CONTATTO         NUMBER(2)               NOT NULL,
  PROGRESSIVO           NUMBER(2)               NOT NULL,
  CONTATTO              VARCHAR2(100 BYTE)      NOT NULL,
  RIFERIMENTO_TIPO      NUMBER(2),
  RIFERIMENTO           NUMBER(2),
  PUBBLICABILE          VARCHAR2(1 BYTE),
  UTENTE_AGG            VARCHAR2(8 BYTE),
  DATA_AGG              DATE,
  DESCRIZIONE_CONTATTO  VARCHAR2(240 BYTE)
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

COMMENT ON TABLE SOGGETTI_RUBRICA IS 'Contiene i contatti aziendali dei componenti della struttura organizzativa.';

COMMENT ON COLUMN SOGGETTI_RUBRICA.NI IS 'Identificativo del soggetto';

COMMENT ON COLUMN SOGGETTI_RUBRICA.TIPO_CONTATTO IS 'Tipologia di contatto';

COMMENT ON COLUMN SOGGETTI_RUBRICA.PROGRESSIVO IS 'Progressivo contatto (nell''ambito della tipologia)';

COMMENT ON COLUMN SOGGETTI_RUBRICA.CONTATTO IS 'Contatto';

COMMENT ON COLUMN SOGGETTI_RUBRICA.RIFERIMENTO_TIPO IS 'Tipo contatto di riferimento';

COMMENT ON COLUMN SOGGETTI_RUBRICA.RIFERIMENTO IS 'Contatto di riferimento';

COMMENT ON COLUMN SOGGETTI_RUBRICA.PUBBLICABILE IS 'Indica se il contatto e'' pubblicabile (S/N)';

COMMENT ON COLUMN SOGGETTI_RUBRICA.UTENTE_AGG IS 'Utente dell''ultimo aggiornamento';

COMMENT ON COLUMN SOGGETTI_RUBRICA.DATA_AGG IS 'Data dell''ultimo aggiornamento';

COMMENT ON COLUMN SOGGETTI_RUBRICA.DESCRIZIONE_CONTATTO IS 'Descrizione del contatto';




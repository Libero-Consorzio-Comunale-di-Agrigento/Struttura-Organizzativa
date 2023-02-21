CREATE TABLE SOGGETTI_RUBRICA_B
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
  DESCRIZIONE_CONTATTO  VARCHAR2(240 BYTE),
  OPERAZIONE            VARCHAR2(2 BYTE),
  NOTE_SESSIONE         VARCHAR2(200 BYTE),
  DATA_OPERAZIONE       TIMESTAMP(6),
  ID_BACKUP             NUMBER(10)              NOT NULL,
  CONTESTO              VARCHAR2(1 BYTE)
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

COMMENT ON TABLE SOGGETTI_RUBRICA_B IS 'Rubrica soggetti: Backup per pubblicazione eventi';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.NI IS 'Identificativo del soggetto';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.TIPO_CONTATTO IS 'Tipologia di contatto';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.PROGRESSIVO IS 'Progressivo contatto (nell''ambito della tipologia)';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.CONTATTO IS 'Contatto';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.RIFERIMENTO_TIPO IS 'Tipo contatto di riferimento';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.RIFERIMENTO IS 'Contatto di riferimento';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.PUBBLICABILE IS 'Indica se il contatto è pubblicabile (S/N)';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.UTENTE_AGG IS 'Utente dell''ultimo aggiornamento';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.DATA_AGG IS 'Data dell''ultimo aggiornamento';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.DESCRIZIONE_CONTATTO IS 'Descrizione del contatto';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN SOGGETTI_RUBRICA_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




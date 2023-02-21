CREATE TABLE DUP_IMBI
(
  ID_IMPUTAZIONE  NUMBER(8)                     NOT NULL,
  ID_COMPONENTE   NUMBER(8)                     NOT NULL,
  NUMERO          NUMBER(6),
  DAL             DATE,
  AL              DATE,
  UTENTE_AGG      VARCHAR2(8 BYTE),
  DATA_AGG        DATE
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

COMMENT ON TABLE DUP_IMBI IS 'Tabella di appoggio per modifiche componenti con stessa data decorrenza';

COMMENT ON COLUMN DUP_IMBI.ID_IMPUTAZIONE IS 'Identificativo del record IMPUTAZIONI';

COMMENT ON COLUMN DUP_IMBI.ID_COMPONENTE IS 'Identificativo del record di COMPONENTI';

COMMENT ON COLUMN DUP_IMBI.NUMERO IS 'Numero della sede contabile';

COMMENT ON COLUMN DUP_IMBI.DAL IS 'Data inizio validita'' della registrazione';

COMMENT ON COLUMN DUP_IMBI.AL IS 'Data fine validita'' della registrazione';

COMMENT ON COLUMN DUP_IMBI.UTENTE_AGG IS 'Utente aggiornamento';

COMMENT ON COLUMN DUP_IMBI.DATA_AGG IS 'Data aggiornamento';




CREATE TABLE IMPUTAZIONI_BILANCIO
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

COMMENT ON TABLE IMPUTAZIONI_BILANCIO IS 'Contiene le imputazioni di bilancio relative all''associazione del componente all''unita'' organizzativa';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.ID_IMPUTAZIONE IS 'Identificativo del record IMPUTAZIONI';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.ID_COMPONENTE IS 'Identificativo del record di COMPONENTI';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.NUMERO IS 'Numero della sede contabile';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.DAL IS 'Data inizio validita'' della registrazione';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.AL IS 'Data fine validita'' della registrazione';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.UTENTE_AGG IS 'Utente aggiornamento';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO.DATA_AGG IS 'Data aggiornamento';




CREATE TABLE IMPUTAZIONI_BILANCIO_B
(
  ID_IMPUTAZIONE   NUMBER(8)                    NOT NULL,
  ID_COMPONENTE    NUMBER(8)                    NOT NULL,
  NUMERO           NUMBER(6),
  DAL              DATE,
  AL               DATE,
  UTENTE_AGG       VARCHAR2(8 BYTE),
  DATA_AGG         DATE,
  OPERAZIONE       VARCHAR2(2 BYTE),
  NOTE_SESSIONE    VARCHAR2(200 BYTE),
  DATA_OPERAZIONE  TIMESTAMP(6),
  ID_BACKUP        NUMBER(10)                   NOT NULL,
  CONTESTO         VARCHAR2(1 BYTE)
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

COMMENT ON TABLE IMPUTAZIONI_BILANCIO_B IS 'Contiene le imputazioni di bilancio relative all''associazione del componente all''unita'' organizzativa: Backup per pubblicazione eventi';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.ID_IMPUTAZIONE IS 'Identificativo del record IMPUTAZIONI';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.ID_COMPONENTE IS 'Identificativo del record di COMPONENTI';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.NUMERO IS 'Numero della sede contabile';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.DAL IS 'Data inizio validita'' della registrazione';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.AL IS 'Data fine validita'' della registrazione';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.UTENTE_AGG IS 'Utente aggiornamento';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.DATA_AGG IS 'Data aggiornamento';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN IMPUTAZIONI_BILANCIO_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




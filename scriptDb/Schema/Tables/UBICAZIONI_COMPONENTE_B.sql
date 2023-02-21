CREATE TABLE UBICAZIONI_COMPONENTE_B
(
  ID_UBICAZIONE_COMPONENTE  NUMBER(8)           NOT NULL,
  ID_COMPONENTE             NUMBER(8)           NOT NULL,
  ID_UBICAZIONE_UNITA       NUMBER(8)           NOT NULL,
  DAL                       DATE,
  AL                        DATE,
  ID_ORIGINE                NUMBER(8),
  UTENTE_AGGIORNAMENTO      VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO        DATE,
  OPERAZIONE                VARCHAR2(2 BYTE),
  NOTE_SESSIONE             VARCHAR2(200 BYTE),
  DATA_OPERAZIONE           TIMESTAMP(6),
  ID_BACKUP                 NUMBER(10)          NOT NULL,
  CONTESTO                  VARCHAR2(1 BYTE)
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

COMMENT ON TABLE UBICAZIONI_COMPONENTE_B IS 'Associazione componente/sede fisica: Backup per pubblicazione eventi';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.ID_UBICAZIONE_COMPONENTE IS 'Identificativo del record';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.ID_COMPONENTE IS 'Identificativo del record di COMPONENTI';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.ID_UBICAZIONE_UNITA IS 'Identificativo del record di UBICAZIONI_UNITA';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.DAL IS 'Data di inizio assegnazione del componente all''unita fisica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.AL IS 'Data di fine assegnazione del componente all''unita fisica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.ID_ORIGINE IS 'In caso di registrazione ereditata, identificativo del record che ha generato la registrazione';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.UTENTE_AGGIORNAMENTO IS 'Utente dell''ultimo aggiornamento';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.DATA_AGGIORNAMENTO IS 'Data dell''ultimo aggiornamento';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




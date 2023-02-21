CREATE TABLE AMMINISTRAZIONI_B
(
  CODICE_AMMINISTRAZIONE  VARCHAR2(50 BYTE)     NOT NULL,
  NI                      NUMBER(8)             NOT NULL,
  DATA_ISTITUZIONE        DATE,
  DATA_SOPPRESSIONE       DATE,
  ENTE                    VARCHAR2(2 BYTE)      NOT NULL,
  UTENTE_AGGIORNAMENTO    VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO      DATE,
  OPERAZIONE              VARCHAR2(2 BYTE),
  NOTE_SESSIONE           VARCHAR2(200 BYTE),
  DATA_OPERAZIONE         TIMESTAMP(6),
  ID_BACKUP               NUMBER(10)            NOT NULL,
  CONTESTO                VARCHAR2(1 BYTE)
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

COMMENT ON TABLE AMMINISTRAZIONI_B IS 'Amministrazioni: Backup per pubblicazione eventi
ATTENZIONE: NON GENERARE I TRIGGER DI DEFAULT.';

COMMENT ON COLUMN AMMINISTRAZIONI_B.CODICE_AMMINISTRAZIONE IS 'Codice amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI_B.NI IS 'Identificativo dell''anagrafe soggetti relativo all''amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI_B.DATA_ISTITUZIONE IS 'Data istituzione amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI_B.DATA_SOPPRESSIONE IS 'Data soppressione amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI_B.ENTE IS 'Indica se l''amministrazione e'' di proprieta'' (gestito in SO4)';

COMMENT ON COLUMN AMMINISTRAZIONI_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN AMMINISTRAZIONI_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN AMMINISTRAZIONI_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN AMMINISTRAZIONI_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN AMMINISTRAZIONI_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN AMMINISTRAZIONI_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN AMMINISTRAZIONI_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




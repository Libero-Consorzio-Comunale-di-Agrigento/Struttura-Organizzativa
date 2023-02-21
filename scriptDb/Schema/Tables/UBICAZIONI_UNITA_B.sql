CREATE TABLE UBICAZIONI_UNITA_B
(
  ID_UBICAZIONE              NUMBER(8)          NOT NULL,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  SEQUENZA                   NUMBER(6)          NOT NULL,
  DAL                        DATE               NOT NULL,
  AL                         DATE,
  PROGR_UNITA_FISICA         NUMBER(8)          NOT NULL,
  ID_ORIGINE                 NUMBER(8),
  UTENTE_AGGIORNAMENTO       VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO         DATE,
  OPERAZIONE                 VARCHAR2(2 BYTE),
  NOTE_SESSIONE              VARCHAR2(200 BYTE),
  DATA_OPERAZIONE            TIMESTAMP(6),
  ID_BACKUP                  NUMBER(10)         NOT NULL,
  CONTESTO                   VARCHAR2(1 BYTE)
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

COMMENT ON TABLE UBICAZIONI_UNITA_B IS 'Ubicazioni unita'' organizzative: Backup per pubblicazione eventi';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.ID_UBICAZIONE IS 'Identificativo delle registrazione dell''ubicazione (sequence)';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.PROGR_UNITA_ORGANIZZATIVA IS 'Identificativo dell''unita'' organizzativa da mettere in relazione con l''unita'' fisica';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.SEQUENZA IS 'Sequenza dell''unita'' organizzativa nell''ambito dell''ubicazione';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.DAL IS 'Data inizio validita'' dell''ubicazione';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.AL IS 'Data fine validita'' dell''ubicazione';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.PROGR_UNITA_FISICA IS 'Identificativo dell''unita'' fisica da mettere in relazione con l''unita'' organizzativa';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.ID_ORIGINE IS 'In caso di registrazione ereditata, identificativo del record che ha generato la registrazione';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN UBICAZIONI_UNITA_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




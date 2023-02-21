CREATE TABLE RUOLI_COMPONENTE_B
(
  ID_RUOLO_COMPONENTE   NUMBER(8)               NOT NULL,
  ID_COMPONENTE         NUMBER(8)               NOT NULL,
  RUOLO                 VARCHAR2(8 BYTE)        NOT NULL,
  DAL                   DATE                    NOT NULL,
  AL                    DATE,
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE,
  DAL_PUBB              DATE,
  AL_PUBB               DATE,
  AL_PREC               DATE,
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

COMMENT ON TABLE RUOLI_COMPONENTE_B IS 'Ruoli componente: Backup per pubblicazione eventi';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.ID_RUOLO_COMPONENTE IS 'Identificativo del record che associa il ruolo al componente (sequence)';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.RUOLO IS 'Codice ruolo';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.DAL IS 'Data inizio validita'' ruolo';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.AL IS 'Data fine validita'' ruolo';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.AL_PREC IS 'Data fine validita'' memorizzata';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN RUOLI_COMPONENTE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




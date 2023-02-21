CREATE TABLE ASSEGNAZIONI_FISICHE_B
(
  ID_ASFI                    NUMBER(8)          NOT NULL,
  ID_UBICAZIONE_COMPONENTE   NUMBER(8),
  NI                         NUMBER(8)          NOT NULL,
  PROGR_UNITA_FISICA         NUMBER(8)          NOT NULL,
  DAL                        DATE,
  AL                         DATE,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8),
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

COMMENT ON TABLE ASSEGNAZIONI_FISICHE_B IS 'Assegnazioni dei soggetti alla struttura fisica: Backup per pubblicazione eventi';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.ID_UBICAZIONE_COMPONENTE IS 'Id ubicazione componente relativo all''assegnazione fisica. Nullo se l''assegnazione è diretta';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.NI IS 'NI del soggetto';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.PROGR_UNITA_FISICA IS 'progressivo della UF di assegnazione';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.DAL IS 'Data di inizio assegnazione';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.AL IS 'Data di fine';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.PROGR_UNITA_ORGANIZZATIVA IS 'Progressivo della UO di riferimento per soggetti esterni non assegnati alla struttura logica';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN ASSEGNAZIONI_FISICHE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




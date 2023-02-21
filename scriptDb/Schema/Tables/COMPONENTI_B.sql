CREATE TABLE COMPONENTI_B
(
  ID_COMPONENTE              NUMBER(8)          NOT NULL,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  DAL                        DATE,
  AL                         DATE,
  NI                         NUMBER(8),
  CI                         NUMBER(8),
  DENOMINAZIONE              VARCHAR2(240 BYTE),
  DENOMINAZIONE_AL1          VARCHAR2(240 BYTE),
  DENOMINAZIONE_AL2          VARCHAR2(240 BYTE),
  STATO                      VARCHAR2(1 BYTE),
  OTTICA                     VARCHAR2(18 BYTE)  NOT NULL,
  REVISIONE_ASSEGNAZIONE     NUMBER(8),
  REVISIONE_CESSAZIONE       NUMBER(8),
  UTENTE_AGGIORNAMENTO       VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO         DATE,
  CODICE_FISCALE             VARCHAR2(16 BYTE),
  DAL_PUBB                   DATE,
  AL_PUBB                    DATE,
  AL_PREC                    DATE,
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

COMMENT ON TABLE COMPONENTI_B IS 'Componenti assegnati all''unita'' organizzativa: Backup per pubblicazione eventi';

COMMENT ON COLUMN COMPONENTI_B.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN COMPONENTI_B.PROGR_UNITA_ORGANIZZATIVA IS 'Codice numerico dell''unita'' organizzativa a cui sono associati i componenti_b';

COMMENT ON COLUMN COMPONENTI_B.DAL IS 'Data inizio validita'' componente';

COMMENT ON COLUMN COMPONENTI_B.AL IS 'Data fine validita'' componente';

COMMENT ON COLUMN COMPONENTI_B.NI IS 'Identificativo dell''anagrafe soggetti del componente (solo per componenti_b gia'' codificati)';

COMMENT ON COLUMN COMPONENTI_B.CI IS 'CI per l''integrazione con la procedura GP4';

COMMENT ON COLUMN COMPONENTI_B.DENOMINAZIONE IS 'Denominazione del componente (solo per i componenti_b non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN COMPONENTI_B.DENOMINAZIONE_AL1 IS 'Denominazione del componente in lingua alternativa 1 (solo per i componenti_b non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN COMPONENTI_B.DENOMINAZIONE_AL2 IS 'Denominazione del componente in lingua alternativa 2 (solo per i componenti_b non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN COMPONENTI_B.STATO IS 'Indica se l''assegnazione e'' provvisoria o definitiva';

COMMENT ON COLUMN COMPONENTI_B.OTTICA IS 'Ottica di istituzione del legame';

COMMENT ON COLUMN COMPONENTI_B.REVISIONE_ASSEGNAZIONE IS 'Revisione di istituzione del legame';

COMMENT ON COLUMN COMPONENTI_B.REVISIONE_CESSAZIONE IS 'Revisione di cessazione del legame';

COMMENT ON COLUMN COMPONENTI_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN COMPONENTI_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN COMPONENTI_B.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN COMPONENTI_B.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN COMPONENTI_B.AL_PREC IS 'Data fine validita'' memorizzata';

COMMENT ON COLUMN COMPONENTI_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN COMPONENTI_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN COMPONENTI_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN COMPONENTI_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN COMPONENTI_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




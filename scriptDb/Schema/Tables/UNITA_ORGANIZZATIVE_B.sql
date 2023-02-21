CREATE TABLE UNITA_ORGANIZZATIVE_B
(
  ID_ELEMENTO                NUMBER(8)          NOT NULL,
  OTTICA                     VARCHAR2(18 BYTE)  NOT NULL,
  REVISIONE                  NUMBER(8),
  SEQUENZA                   NUMBER(6),
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  ID_UNITA_PADRE             NUMBER(8),
  REVISIONE_CESSAZIONE       NUMBER(8),
  DAL                        DATE,
  AL                         DATE,
  UTENTE_AGGIORNAMENTO       VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO         DATE,
  DAL_PUBB                   DATE,
  AL_PUBB                    DATE,
  AL_PREC                    DATE,
  REVISIONE_CESS_PREC        NUMBER(8),
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

COMMENT ON TABLE UNITA_ORGANIZZATIVE_B IS 'Relazioni unita'' organizzative: Backup per pubblicazione eventi';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.ID_ELEMENTO IS 'Identificativo del record della struttura organizzativa (sequence)';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.REVISIONE IS 'Codice revisione di istituzione del legame padre/figlio';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.SEQUENZA IS 'Sequenza legame nell''ambito della struttura / suddivisione';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.PROGR_UNITA_ORGANIZZATIVA IS 'Codice numerico dell''anagrafica dell''unita'' organizzativa';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.ID_UNITA_PADRE IS 'Identificativo del record della struttura relativo al padre';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.REVISIONE_CESSAZIONE IS 'Codice revisione di cessazione del legame padre/figlio';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.DAL IS 'Data inizio validita'' legame';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.AL IS 'Data fine validita'' legame';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.DAL_PUBB IS 'Data inizio visibilita'' del legame';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.AL_PUBB IS 'Data fine visibilita'' del legame';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.AL_PREC IS 'Valore precedente del campo AL per revisioni retroattive';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.REVISIONE_CESS_PREC IS 'Revisione di cessazione memorizzata';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




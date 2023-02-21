CREATE TABLE UNITA_FISICHE_B
(
  ID_ELEMENTO_FISICO     NUMBER(8)              NOT NULL,
  AMMINISTRAZIONE        VARCHAR2(50 BYTE)      NOT NULL,
  PROGR_UNITA_FISICA     NUMBER(8)              NOT NULL,
  ID_UNITA_FISICA_PADRE  NUMBER(8),
  SEQUENZA               NUMBER(6),
  DAL                    DATE                   NOT NULL,
  AL                     DATE,
  UTENTE_AGGIORNAMENTO   VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO     DATE,
  OPERAZIONE             VARCHAR2(2 BYTE),
  NOTE_SESSIONE          VARCHAR2(200 BYTE),
  DATA_OPERAZIONE        TIMESTAMP(6),
  ID_BACKUP              NUMBER(10)             NOT NULL,
  CONTESTO               VARCHAR2(1 BYTE)
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

COMMENT ON TABLE UNITA_FISICHE_B IS 'Relazioni unità fisiche: Backup per pubblicazione eventi';

COMMENT ON COLUMN UNITA_FISICHE_B.ID_ELEMENTO_FISICO IS 'Identificativo del record della struttura fisica (sequence)';

COMMENT ON COLUMN UNITA_FISICHE_B.AMMINISTRAZIONE IS 'Amministrazione di riferimento';

COMMENT ON COLUMN UNITA_FISICHE_B.PROGR_UNITA_FISICA IS 'Codice numerico dell''unita'' fisica (figlia)';

COMMENT ON COLUMN UNITA_FISICHE_B.ID_UNITA_FISICA_PADRE IS 'Identificativo del record della struttura relativo al padre';

COMMENT ON COLUMN UNITA_FISICHE_B.SEQUENZA IS 'Sequenza del legame nell''ambito della suddivisione';

COMMENT ON COLUMN UNITA_FISICHE_B.DAL IS 'Data inizio validita'' legame';

COMMENT ON COLUMN UNITA_FISICHE_B.AL IS 'Data fine validita'' legame';

COMMENT ON COLUMN UNITA_FISICHE_B.UTENTE_AGGIORNAMENTO IS 'Utente dell''ultimo aggiornamento';

COMMENT ON COLUMN UNITA_FISICHE_B.DATA_AGGIORNAMENTO IS 'Data dell''ultimo aggiornamento';

COMMENT ON COLUMN UNITA_FISICHE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN UNITA_FISICHE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN UNITA_FISICHE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN UNITA_FISICHE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN UNITA_FISICHE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




CREATE TABLE REVISIONI_STRUTTURA_B
(
  OTTICA                VARCHAR2(18 BYTE)       NOT NULL,
  REVISIONE             NUMBER(8)               NOT NULL,
  TIPO_REGISTRO         VARCHAR2(4 BYTE),
  ANNO                  NUMBER(4),
  NUMERO                NUMBER(8),
  DATA                  DATE,
  DESCRIZIONE           VARCHAR2(120 BYTE)      NOT NULL,
  DESCRIZIONE_AL1       VARCHAR2(120 BYTE),
  DESCRIZIONE_AL2       VARCHAR2(120 BYTE),
  DAL                   DATE,
  NOTA                  VARCHAR2(2000 BYTE),
  STATO                 VARCHAR2(1 BYTE),
  PROVENIENZA           VARCHAR2(3 BYTE),
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE,
  DATA_PUBBLICAZIONE    DATE,
  TIPO_REVISIONE        VARCHAR2(1 BYTE),
  DATA_TERMINE          DATE,
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

COMMENT ON TABLE REVISIONI_STRUTTURA_B IS 'Revisioni Struttura: Backup per pubblicazione eventi';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.REVISIONE IS 'Progressivo revisione: le revisioni vengono numerate progressivamente nell''ambito dell''ottica';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.TIPO_REGISTRO IS 'Tipo registro del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.ANNO IS 'Anno del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.NUMERO IS 'Numero del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DATA IS 'Data del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DESCRIZIONE IS 'Descrizione revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DESCRIZIONE_AL1 IS 'Descrizione revisione in lingua alternativa 1';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DESCRIZIONE_AL2 IS 'Descrizione revisione in lingua alternativa 2';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DAL IS 'Data inizio validita'' della revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.NOTA IS 'Nota revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.STATO IS 'Indica lo stato della revisione: A = Attiva, M = in Modifica, S = Sospeso (in attesa di essere inserito nella gestione del personale)';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.PROVENIENZA IS 'Procedura che ha creato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DATA_PUBBLICAZIONE IS 'Data di pubblicazione delle revisione per altri applicativi';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.TIPO_REVISIONE IS 'N: Normale, agisce sulla situazione corrente (null=N); C : Retroattiva, con validità storica fino alla situazione corrente; P : Retroattiva, con validità storica fino alla prima revisione cronologicamente successiva';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DATA_TERMINE IS 'Indica la data di fine validita'' della revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN REVISIONI_STRUTTURA_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




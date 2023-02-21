CREATE TABLE OTTICHE_B
(
  OTTICA                    VARCHAR2(18 BYTE)   NOT NULL,
  DESCRIZIONE               VARCHAR2(120 BYTE)  NOT NULL,
  DESCRIZIONE_AL1           VARCHAR2(120 BYTE),
  DESCRIZIONE_AL2           VARCHAR2(120 BYTE),
  NOTA                      VARCHAR2(2000 BYTE),
  AMMINISTRAZIONE           VARCHAR2(50 BYTE)   NOT NULL,
  OTTICA_ISTITUZIONALE      VARCHAR2(2 BYTE)    NOT NULL,
  GESTIONE_REVISIONI        VARCHAR2(2 BYTE)    NOT NULL,
  UTENTE_AGGIORNAMENTO      VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO        DATE,
  OTTICA_ORIGINE            VARCHAR2(18 BYTE),
  AGGIORNAMENTO_COMPONENTI  VARCHAR2(1 BYTE),
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

COMMENT ON TABLE OTTICHE_B IS 'Dizionario ottiche: Backup per pubblicazione eventi';

COMMENT ON COLUMN OTTICHE_B.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN OTTICHE_B.DESCRIZIONE IS 'Descrizione ottica';

COMMENT ON COLUMN OTTICHE_B.DESCRIZIONE_AL1 IS 'Descrizione ottica in lingua alternativa 1';

COMMENT ON COLUMN OTTICHE_B.DESCRIZIONE_AL2 IS 'Descrizione revisione in lingua alternativa 2';

COMMENT ON COLUMN OTTICHE_B.NOTA IS 'Nota ottica';

COMMENT ON COLUMN OTTICHE_B.AMMINISTRAZIONE IS 'Codice dell''amministrazione a cui si riferisce l''ottica.';

COMMENT ON COLUMN OTTICHE_B.OTTICA_ISTITUZIONALE IS 'Indica se l''ottica è istituzionale per l''amministrazione (SI/NO)';

COMMENT ON COLUMN OTTICHE_B.GESTIONE_REVISIONI IS 'Indica se le modifiche alla struttura relative all''ottica vanno gestite con revisioni (SI/NO)';

COMMENT ON COLUMN OTTICHE_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN OTTICHE_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN OTTICHE_B.OTTICA_ORIGINE IS 'Ottica da cui e'' stata derivata la struttura (per ottiche_backup non istituzionali)';

COMMENT ON COLUMN OTTICHE_B.AGGIORNAMENTO_COMPONENTI IS 'Aggiornamento componenti da ottica di origine; A: Automatico (immediato), M: Manuale (differito), N: Nessun allineamento';

COMMENT ON COLUMN OTTICHE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN OTTICHE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN OTTICHE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN OTTICHE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN OTTICHE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




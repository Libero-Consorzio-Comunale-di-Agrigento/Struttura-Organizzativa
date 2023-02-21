CREATE TABLE IMPOSTAZIONI_TABLE
(
  ID_PARAMETRI              NUMBER(2)           NOT NULL,
  INTEGR_CG4                VARCHAR2(2 BYTE)    NOT NULL,
  INTEGR_GP4                VARCHAR2(2 BYTE)    NOT NULL,
  INTEGR_GS4                VARCHAR2(2 BYTE)    NOT NULL,
  ASSEGNAZIONE_DEFINITIVA   VARCHAR2(2 BYTE)    NOT NULL,
  PROCEDURA_NOMINATIVO      VARCHAR2(100 BYTE),
  VISUALIZZA_SUDDIVISIONE   VARCHAR2(2 BYTE),
  VISUALIZZA_CODICE         VARCHAR2(2 BYTE),
  AGG_ANAGRAFE_DIPENDENTI   VARCHAR2(2 BYTE),
  DATA_INIZIO_INTEGRAZIONE  DATE,
  OBBLIGO_IMBI              VARCHAR2(2 BYTE),
  OBBLIGO_SEFI              VARCHAR2(2 BYTE)
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON TABLE IMPOSTAZIONI_TABLE IS 'Tabella impostazioni procedura struttura organizzativa';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.ID_PARAMETRI IS 'Chiave univoca parametri (= 1 perche'' la tabella ha un solo record)';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.INTEGR_CG4 IS 'Indica se e'' prevista l''integrazione con la procedura CG4 (NO/SI)';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.INTEGR_GP4 IS 'Indica se e'' prevista l''integrazione con la procedura GP4 (NO/SI)';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.INTEGR_GS4 IS 'Indica se e'' prevista l''integrazione con la procedura GS4 (NO/SI)';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.ASSEGNAZIONE_DEFINITIVA IS 'Indica se l''assegnazione componenti viene fatta in maniera definitiva (= SI) oppure provvisoria (= NO)';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.PROCEDURA_NOMINATIVO IS 'Nome della procedure da lanciare per la determinazione del nominativo da inserire in AD4_UTENTI';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.VISUALIZZA_SUDDIVISIONE IS 'Indica se visualizzare o meno la descrizione abbreviata della suddivisione nella struttura ad albero';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.VISUALIZZA_CODICE IS 'Indica se visualizzare o meno il codice dell''unita'' organizzativa nella struttura ad albero';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.AGG_ANAGRAFE_DIPENDENTI IS 'Indica se e'' possibile aggiornare l''anagrafica dei dipendenti (solo per clienti non integrati con GP4)';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.DATA_INIZIO_INTEGRAZIONE IS 'Data di inizio integrazione SO4 / GP4';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.OBBLIGO_IMBI IS 'Indica se e'' prevista l''indicazione dell''imputazione di bilancio';

COMMENT ON COLUMN IMPOSTAZIONI_TABLE.OBBLIGO_SEFI IS 'Indica se e'' prevista l''indicazione della sede fisica';




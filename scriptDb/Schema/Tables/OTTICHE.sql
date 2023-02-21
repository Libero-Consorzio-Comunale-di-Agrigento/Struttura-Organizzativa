CREATE TABLE OTTICHE
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
  AGGIORNAMENTO_COMPONENTI  VARCHAR2(1 BYTE)
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

COMMENT ON TABLE OTTICHE IS 'Dizionario Ottiche: definisce le possibili "ottiche" (modi di vedere) della struttura organizzativa';

COMMENT ON COLUMN OTTICHE.OTTICA IS 'Codice ottica
';

COMMENT ON COLUMN OTTICHE.DESCRIZIONE IS 'Descrizione ottica';

COMMENT ON COLUMN OTTICHE.DESCRIZIONE_AL1 IS 'Descrizione ottica in lingua alternativa 1';

COMMENT ON COLUMN OTTICHE.DESCRIZIONE_AL2 IS 'Descrizione revisione in lingua alternativa 2';

COMMENT ON COLUMN OTTICHE.NOTA IS 'Nota ottica';

COMMENT ON COLUMN OTTICHE.AMMINISTRAZIONE IS 'Codice dell''amministrazione a cui si riferisce l''ottica.
';

COMMENT ON COLUMN OTTICHE.OTTICA_ISTITUZIONALE IS 'Indica se l''ottica e istituzionale per l''amministrazione (SI/NO)';

COMMENT ON COLUMN OTTICHE.GESTIONE_REVISIONI IS 'Indica se le modifiche alla struttura relative all''ottica vanno gestite con revisioni (SI/NO)';

COMMENT ON COLUMN OTTICHE.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN OTTICHE.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN OTTICHE.OTTICA_ORIGINE IS 'Ottica da cui e'' stata derivata la struttura (per ottiche non istituzionali)';

COMMENT ON COLUMN OTTICHE.AGGIORNAMENTO_COMPONENTI IS 'Aggiornamento componenti da ottica di origine; A: Automatico (immediato), M: Manuale (differito), N: nessun allineamento';




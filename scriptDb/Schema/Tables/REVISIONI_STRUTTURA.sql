CREATE TABLE REVISIONI_STRUTTURA
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
  TIPO_REVISIONE        VARCHAR2(1 BYTE)        DEFAULT 'N',
  DATA_TERMINE          DATE
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

COMMENT ON TABLE REVISIONI_STRUTTURA IS 'Per ogni ottica puo esistere una ed una sola revisione con stato ''M'' (in corso di modifica).';

COMMENT ON COLUMN REVISIONI_STRUTTURA.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN REVISIONI_STRUTTURA.REVISIONE IS 'Progressivo revisione: le revisioni vengono numerate progressivamente nell''ambito dell''ottica';

COMMENT ON COLUMN REVISIONI_STRUTTURA.TIPO_REGISTRO IS 'Tipo registro del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.ANNO IS 'Anno del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.NUMERO IS 'Numero del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DATA IS 'Data del documento che ha generato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DESCRIZIONE IS 'Descrizione revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DESCRIZIONE_AL1 IS 'Descrizione revisione in lingua alternativa 1';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DESCRIZIONE_AL2 IS 'Descrizione revisione in lingua alternativa 2';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DAL IS 'Data inizio validita'' della revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.NOTA IS 'Nota revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.STATO IS 'Indica lo stato della revisione: A = Attiva, M = in Modifica, S = Sospeso (in attesa di essere inserito nella gestione del personale)';

COMMENT ON COLUMN REVISIONI_STRUTTURA.PROVENIENZA IS 'Procedura che ha creato la revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DATA_PUBBLICAZIONE IS 'Data pubblicazione revisione';

COMMENT ON COLUMN REVISIONI_STRUTTURA.TIPO_REVISIONE IS 'Tipo revisione: N = Normale, R = Retroattiva / Rettificativa';

COMMENT ON COLUMN REVISIONI_STRUTTURA.DATA_TERMINE IS 'Indica la data di fine validita'' della revisione';




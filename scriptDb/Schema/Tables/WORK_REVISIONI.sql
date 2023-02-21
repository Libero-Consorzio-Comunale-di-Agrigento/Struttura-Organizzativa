CREATE TABLE WORK_REVISIONI
(
  ID_WORK_REVISIONE          NUMBER(8)          NOT NULL,
  OTTICA                     VARCHAR2(18 BYTE)  NOT NULL,
  REVISIONE                  NUMBER(8)          NOT NULL,
  DATA                       DATE,
  MESSAGGIO                  VARCHAR2(2000 BYTE),
  ERRORE_BLOCCANTE           VARCHAR2(2 BYTE),
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8),
  CODICE_UO                  VARCHAR2(50 BYTE),
  DESCR_UO                   VARCHAR2(240 BYTE),
  NI                         NUMBER(8),
  NOMINATIVO                 VARCHAR2(120 BYTE)
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

COMMENT ON TABLE WORK_REVISIONI IS 'Contiene i messaggi di errore relativi alla verifica dei dati prima di attivare una revisione';

COMMENT ON COLUMN WORK_REVISIONI.ID_WORK_REVISIONE IS 'Identificativo di riga (sequence)';

COMMENT ON COLUMN WORK_REVISIONI.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN WORK_REVISIONI.REVISIONE IS 'Progressivo revisione: le revisioni vengono numerate progressivamente nell''ambito dell''ottica';

COMMENT ON COLUMN WORK_REVISIONI.DATA IS 'Data di inizio validita'' della revisione';

COMMENT ON COLUMN WORK_REVISIONI.MESSAGGIO IS 'Messaggio di errore';

COMMENT ON COLUMN WORK_REVISIONI.ERRORE_BLOCCANTE IS 'Indica se l''errore e'' bloccante - Vale SI o NO';

COMMENT ON COLUMN WORK_REVISIONI.PROGR_UNITA_ORGANIZZATIVA IS 'Progressivo dell''unita'' organizzativa a cui si riferisce l''errore';

COMMENT ON COLUMN WORK_REVISIONI.CODICE_UO IS 'Codice dell''unita'' organizzativa a cui si riferisce l''errore';

COMMENT ON COLUMN WORK_REVISIONI.DESCR_UO IS 'Descrizione dell''unita'' organizzativa a cui si riferisce l''errore';

COMMENT ON COLUMN WORK_REVISIONI.NI IS 'Identificativo del componente a cui si riferisce l''errore';

COMMENT ON COLUMN WORK_REVISIONI.NOMINATIVO IS 'Nominativo del componente a cui si riferisce l''errore';




CREATE TABLE INDIRIZZI_TELEMATICI
(
  TIPO_ENTITA             VARCHAR2(2 BYTE)      NOT NULL,
  ID_INDIRIZZO            NUMBER(8)             NOT NULL,
  TIPO_INDIRIZZO          VARCHAR2(1 BYTE)      NOT NULL,
  ID_AMMINISTRAZIONE      NUMBER(8),
  ID_AOO                  NUMBER(8),
  ID_UNITA_ORGANIZZATIVA  NUMBER(8),
  INDIRIZZO               VARCHAR2(200 BYTE)    NOT NULL,
  NOTE                    VARCHAR2(2000 BYTE),
  PROTOCOL                VARCHAR2(100 BYTE),
  SERVER                  VARCHAR2(2000 BYTE),
  PORT                    NUMBER,
  UTENTE                  VARCHAR2(2000 BYTE),
  PASSWORD                VARCHAR2(2000 BYTE),
  SSL                     NUMBER,
  AUTHENTICATION          NUMBER,
  UTENTE_AGGIORNAMENTO    VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO      DATE,
  TAG_MAIL                VARCHAR2(2000 BYTE)
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

COMMENT ON TABLE INDIRIZZI_TELEMATICI IS 'Contiene gli indirizzi telematici delle varie entita'' (Amministrazioni, Aree organizzative omogenee, Unita'' organizzative) suddivisi per tipo';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.TIPO_ENTITA IS 'Definisce il tipo di entita a cui si riferisce l''indirizzo:
AM - Amministrazione
AO - Area organizzativa omogenea
UO - Unita organizzativa';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.ID_INDIRIZZO IS 'Identificativo dell''entita a cui si riferisce l''indirizzo';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.TIPO_INDIRIZZO IS 'Definisce il tipo di indirizzo telematico presente sul record:
I - Istituzionale
R - Risposta automatica
M - Protocollo manuale
G - Generico';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.ID_AMMINISTRAZIONE IS 'Identificativo dell''amministrazione a cui si riferisce l''indirizzo';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.ID_AOO IS 'Identificativo della AOO a cui si riferisce l''indirizzo';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.ID_UNITA_ORGANIZZATIVA IS 'Identificativo dell''unita'' a cui si riferisce l''indirizzo';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.INDIRIZZO IS 'Indirizzo telematico';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.NOTE IS 'Note';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.UTENTE_AGGIORNAMENTO IS 'Utente di aggiornamento del record';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.DATA_AGGIORNAMENTO IS 'Data di aggiornamento del record';

COMMENT ON COLUMN INDIRIZZI_TELEMATICI.TAG_MAIL IS 'Tag di invio tramite si4cs';




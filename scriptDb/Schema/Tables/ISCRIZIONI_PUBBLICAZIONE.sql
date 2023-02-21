CREATE TABLE ISCRIZIONI_PUBBLICAZIONE
(
  ID_ISCRIZIONE             NUMBER(10)          NOT NULL,
  MODULO                    VARCHAR2(10 BYTE)   NOT NULL,
  CATEGORIA                 VARCHAR2(30 BYTE)   NOT NULL,
  MODIFICA                  NUMBER(2)           NOT NULL,
  INIZIO                    DATE                NOT NULL,
  FINE                      DATE,
  DATA_INIZIO_ACQUISIZIONE  DATE,
  UTENTE_AGGIORNAMENTO      VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO        DATE,
  AMMINISTRAZIONE           VARCHAR2(50 BYTE),
  OTTICA                    VARCHAR2(18 BYTE),
  RITARDO                   NUMBER(4),
  NOTIFICA                  NUMBER(1),
  URL_NOTIFICA              VARCHAR2(2000 BYTE)
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

COMMENT ON TABLE ISCRIZIONI_PUBBLICAZIONE IS 'Moduli che richiedono la pubblicazione di eventi e relative tipologie';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.ID_ISCRIZIONE IS 'Identificativo della riga (PK)';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.MODULO IS 'Codice del modulo iscritto';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.CATEGORIA IS 'Codice della categoria di modifiche (% tutte le categorie)';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.MODIFICA IS 'Codice della modifica (def. 0, null tutte le modifiche della categoria)';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.INIZIO IS 'Data di inizio iscrizione';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.FINE IS 'Data di fine iscrizione';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.DATA_INIZIO_ACQUISIZIONE IS 'Data di inizio ultimo aggiornamento eseguito dal modulo andato a buon fine';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.UTENTE_AGGIORNAMENTO IS 'Codice utente di modifica/inserimento';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.DATA_AGGIORNAMENTO IS 'Data di aggiornamento/inserimento del record';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.AMMINISTRAZIONE IS 'Codice Amministrazione';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.OTTICA IS 'Codice Ottica';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.RITARDO IS 'Numero di minuti di ritardo per il lancio del job di pubblicazione';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.NOTIFICA IS 'Indicatore di avvenuta notifica. 0 non notificato, 1 gia'' notificato';

COMMENT ON COLUMN ISCRIZIONI_PUBBLICAZIONE.URL_NOTIFICA IS 'Indirizzo webservice a cui notificare la presenza di modifiche significative';




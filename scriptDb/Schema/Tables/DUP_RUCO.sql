CREATE TABLE DUP_RUCO
(
  ID_RUOLO_COMPONENTE   NUMBER(8)               NOT NULL,
  ID_COMPONENTE         NUMBER(8)               NOT NULL,
  RUOLO                 VARCHAR2(8 BYTE)        NOT NULL,
  DAL                   DATE                    NOT NULL,
  AL                    DATE,
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE
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

COMMENT ON TABLE DUP_RUCO IS 'Tabella di appoggio per modifiche componenti eseguite con la stessa decorrenza';

COMMENT ON COLUMN DUP_RUCO.ID_RUOLO_COMPONENTE IS 'Identificativo del record che associa il ruolo al componente (sequence)';

COMMENT ON COLUMN DUP_RUCO.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN DUP_RUCO.RUOLO IS 'Codice ruolo';

COMMENT ON COLUMN DUP_RUCO.DAL IS 'Data inizio validita'' componente';

COMMENT ON COLUMN DUP_RUCO.AL IS 'Data fine validita'' componente';

COMMENT ON COLUMN DUP_RUCO.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN DUP_RUCO.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';




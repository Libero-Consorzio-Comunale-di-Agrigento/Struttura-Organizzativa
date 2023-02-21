CREATE TABLE RUOLI_COMPONENTE
(
  ID_RUOLO_COMPONENTE   NUMBER(8)               NOT NULL,
  ID_COMPONENTE         NUMBER(8)               NOT NULL,
  RUOLO                 VARCHAR2(8 BYTE)        NOT NULL,
  DAL                   DATE                    NOT NULL,
  AL                    DATE,
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE,
  DAL_PUBB              DATE,
  AL_PUBB               DATE,
  AL_PREC               DATE
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

COMMENT ON TABLE RUOLI_COMPONENTE IS 'Definisce i ruoli (diversi da quelli previsti nella gestione del personale) previste per il componente';

COMMENT ON COLUMN RUOLI_COMPONENTE.ID_RUOLO_COMPONENTE IS 'Identificativo del record che associa il ruolo al componente (sequence)';

COMMENT ON COLUMN RUOLI_COMPONENTE.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN RUOLI_COMPONENTE.RUOLO IS 'Codice ruolo';

COMMENT ON COLUMN RUOLI_COMPONENTE.DAL IS 'Data inizio validita'' componente';

COMMENT ON COLUMN RUOLI_COMPONENTE.AL IS 'Data fine validita'' componente';

COMMENT ON COLUMN RUOLI_COMPONENTE.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN RUOLI_COMPONENTE.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN RUOLI_COMPONENTE.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN RUOLI_COMPONENTE.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN RUOLI_COMPONENTE.AL_PREC IS 'Data fine validita'' memorizzata';




CREATE TABLE RUOLI_PROFILO
(
  ID_RUOLO_PROFILO      NUMBER(10)              NOT NULL,
  RUOLO_PROFILO         VARCHAR2(8 BYTE),
  RUOLO                 VARCHAR2(8 BYTE),
  DAL                   DATE,
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

COMMENT ON COLUMN RUOLI_PROFILO.ID_RUOLO_PROFILO IS 'PK progressiva';

COMMENT ON COLUMN RUOLI_PROFILO.RUOLO_PROFILO IS 'Ruolo identificativo del profilo';

COMMENT ON COLUMN RUOLI_PROFILO.RUOLO IS 'Identificativo del ruolo correlato al profilo';

COMMENT ON COLUMN RUOLI_PROFILO.DAL IS 'Decorrenza della correlazione profilo-ruolo';

COMMENT ON COLUMN RUOLI_PROFILO.AL IS 'Termine della correlazione profilo-ruolo';

COMMENT ON COLUMN RUOLI_PROFILO.UTENTE_AGGIORNAMENTO IS 'Identificativo dell''utente di aggiornamento';

COMMENT ON COLUMN RUOLI_PROFILO.DATA_AGGIORNAMENTO IS 'Data di aggiornamento';




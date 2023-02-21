CREATE TABLE SO4_EVENTI
(
  OGGETTO          VARCHAR2(30 BYTE)            NOT NULL,
  ID_MODIFICA      NUMBER(10),
  CATEGORIA        VARCHAR2(30 BYTE),
  TIPO             NUMBER(2),
  ID_EVENTO        NUMBER(10)                   NOT NULL,
  AMMINISTRAZIONE  VARCHAR2(50 BYTE),
  OTTICA           VARCHAR2(18 BYTE),
  TIME             TIMESTAMP(6)
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

COMMENT ON TABLE SO4_EVENTI IS 'Registro modifiche effettuate in SO4';

COMMENT ON COLUMN SO4_EVENTI.OGGETTO IS 'Tabella oggetto della modifica';

COMMENT ON COLUMN SO4_EVENTI.ID_MODIFICA IS 'Identificativo della modifica; se null, evento generato dall''attivazione di una revisione';

COMMENT ON COLUMN SO4_EVENTI.CATEGORIA IS 'Categoria della modifica';

COMMENT ON COLUMN SO4_EVENTI.TIPO IS 'Tipologia della modifica nel contesto della categoria';

COMMENT ON COLUMN SO4_EVENTI.ID_EVENTO IS 'Identificativo dell''evento (PK)';

COMMENT ON COLUMN SO4_EVENTI.AMMINISTRAZIONE IS 'Amministrazione';

COMMENT ON COLUMN SO4_EVENTI.OTTICA IS 'Ottica';

COMMENT ON COLUMN SO4_EVENTI.TIME IS 'Creazione dell''evento';




CREATE UNIQUE INDEX COIP_PK ON CODICI_IPA
(TIPO_ENTITA, PROGRESSIVO)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



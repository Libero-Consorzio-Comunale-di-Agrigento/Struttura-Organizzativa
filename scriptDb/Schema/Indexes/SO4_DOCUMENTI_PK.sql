CREATE UNIQUE INDEX SO4_DOCUMENTI_PK ON SO4_DOCUMENTI
(TIPO_REGISTRO, ANNO, NUMERO)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



CREATE INDEX UNITA_FISICHE_FK ON UNITA_FISICHE
(ID_UNITA_FISICA_PADRE)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



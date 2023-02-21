CREATE UNIQUE INDEX SUDDIVISIONI_FISICHE_UK2 ON SUDDIVISIONI_FISICHE
(AMMINISTRAZIONE, SUDDIVISIONE)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



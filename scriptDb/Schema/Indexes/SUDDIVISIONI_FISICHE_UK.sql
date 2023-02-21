CREATE UNIQUE INDEX SUDDIVISIONI_FISICHE_UK ON SUDDIVISIONI_FISICHE
(AMMINISTRAZIONE, DENOMINAZIONE)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );


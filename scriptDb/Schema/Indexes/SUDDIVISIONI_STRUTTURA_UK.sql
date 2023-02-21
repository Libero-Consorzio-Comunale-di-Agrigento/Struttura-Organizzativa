CREATE UNIQUE INDEX SUDDIVISIONI_STRUTTURA_UK ON SUDDIVISIONI_STRUTTURA
(OTTICA, SUDDIVISIONE)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



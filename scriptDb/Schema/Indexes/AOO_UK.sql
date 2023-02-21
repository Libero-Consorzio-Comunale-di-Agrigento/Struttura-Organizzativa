CREATE UNIQUE INDEX AOO_UK ON AOO
(CODICE_AMMINISTRAZIONE, CODICE_AOO, DAL)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



CREATE UNIQUE INDEX TIPO_OGGETTO_UK ON SI4_TIPI_OGGETTO
(TIPO_OGGETTO)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



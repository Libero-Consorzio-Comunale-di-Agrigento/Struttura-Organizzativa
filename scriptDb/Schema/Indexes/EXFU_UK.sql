CREATE UNIQUE INDEX EXFU_UK ON EXTERNAL_FUNCTIONS
(TABLE_NAME, FUNCTION_OWNER, FIRING_EVENT)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );



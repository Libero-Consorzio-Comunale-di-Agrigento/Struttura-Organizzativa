CREATE TABLE RELAZIONI_INDIRIZZO_CONTATTO
(
  TIPO_INDIRIZZO  VARCHAR2(1 BYTE)              NOT NULL,
  TIPO_CONTATTO   NUMBER                        NOT NULL
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
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



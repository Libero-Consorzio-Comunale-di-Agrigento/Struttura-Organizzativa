CREATE INDEX AMV_DOCU_CATE_FK ON AMV_DOCUMENTI
(ID_CATEGORIA)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );


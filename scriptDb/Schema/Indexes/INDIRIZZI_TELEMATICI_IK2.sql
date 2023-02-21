CREATE INDEX INDIRIZZI_TELEMATICI_IK2 ON INDIRIZZI_TELEMATICI
(TIPO_ENTITA, TIPO_INDIRIZZO, ID_AOO)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );


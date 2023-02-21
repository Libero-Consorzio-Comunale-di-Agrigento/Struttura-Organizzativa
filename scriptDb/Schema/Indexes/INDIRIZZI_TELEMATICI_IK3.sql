CREATE INDEX INDIRIZZI_TELEMATICI_IK3 ON INDIRIZZI_TELEMATICI
(TIPO_ENTITA, TIPO_INDIRIZZO, ID_UNITA_ORGANIZZATIVA)
TABLESPACE SO4
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );


CREATE TABLE SOGGETTI_UNITA
(
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  NI                         NUMBER(8)          NOT NULL
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON TABLE SOGGETTI_UNITA IS 'Relazione tra soggetto anagrafico e unita organizzativa se questa risulta dotata di codice fiscale proprio ';

COMMENT ON COLUMN SOGGETTI_UNITA.PROGR_UNITA_ORGANIZZATIVA IS 'Codice numerico dell''unita'' organizzativa';

COMMENT ON COLUMN SOGGETTI_UNITA.NI IS 'Identificativo dell''anagrafe soggetti relativo all''UO';




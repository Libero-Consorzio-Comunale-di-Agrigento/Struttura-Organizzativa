CREATE TABLE ATTRIBUTI_STILE
(
  STILE      VARCHAR2(18 BYTE)                  NOT NULL,
  ATTRIBUTO  VARCHAR2(18 BYTE)                  NOT NULL,
  VALORE     VARCHAR2(60 BYTE)
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

COMMENT ON TABLE ATTRIBUTI_STILE IS 'Attributi degli stili visuali (regione Marche)';

COMMENT ON COLUMN ATTRIBUTI_STILE.STILE IS 'Codice dello stile visuale';

COMMENT ON COLUMN ATTRIBUTI_STILE.ATTRIBUTO IS 'Attributo dello stile visuale';

COMMENT ON COLUMN ATTRIBUTI_STILE.VALORE IS 'Valore dell''attributo dello stile visuale';




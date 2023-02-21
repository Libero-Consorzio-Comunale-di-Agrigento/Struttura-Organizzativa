CREATE TABLE CODICI_IPA
(
  TIPO_ENTITA       VARCHAR2(2 BYTE)            NOT NULL,
  PROGRESSIVO       NUMBER(8)                   NOT NULL,
  CODICE_ORIGINALE  VARCHAR2(100 BYTE)          NOT NULL
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

COMMENT ON TABLE CODICI_IPA IS 'Codici originali mixed case di Amministrazioni, AOO e Unita'' Organizzative scaricate da IPA';

COMMENT ON COLUMN CODICI_IPA.TIPO_ENTITA IS 'AM: Amministrazione, AO: Area Organizzativa Omogenea, UO: Unita'' Organizzativa';

COMMENT ON COLUMN CODICI_IPA.PROGRESSIVO IS 'In funziona del tipo entita''. Per AM, NI. Per AO, PROGR_AOO. Per UO, PROGR_UNITA_ORGANIZZATIVA';

COMMENT ON COLUMN CODICI_IPA.CODICE_ORIGINALE IS 'Codice originale mixed case';




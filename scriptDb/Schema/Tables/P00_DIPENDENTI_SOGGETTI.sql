CREATE TABLE P00_DIPENDENTI_SOGGETTI
(
  NI_GP4  NUMBER(8),
  NI_AS4  NUMBER(8)
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

COMMENT ON TABLE P00_DIPENDENTI_SOGGETTI IS 'Tabella di abbinamento tra NI di P00.anagrafici e ni di AS4.anagrafe_soggetti';

COMMENT ON COLUMN P00_DIPENDENTI_SOGGETTI.NI_GP4 IS 'Identificativo del soggetto di P00.anagrafici';

COMMENT ON COLUMN P00_DIPENDENTI_SOGGETTI.NI_AS4 IS 'Identificativo del soggetto di AS4.anagrafe_soggetti';




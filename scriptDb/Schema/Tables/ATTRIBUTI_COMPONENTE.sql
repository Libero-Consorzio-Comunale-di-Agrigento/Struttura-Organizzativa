CREATE TABLE ATTRIBUTI_COMPONENTE
(
  ID_ATTR_COMPONENTE       NUMBER(8)            NOT NULL,
  ID_COMPONENTE            NUMBER(8)            NOT NULL,
  DAL                      DATE,
  AL                       DATE,
  INCARICO                 VARCHAR2(8 BYTE),
  TELEFONO                 VARCHAR2(20 BYTE),
  FAX                      VARCHAR2(20 BYTE),
  E_MAIL                   VARCHAR2(40 BYTE),
  ASSEGNAZIONE_PREVALENTE  NUMBER(2),
  PERCENTUALE_IMPIEGO      NUMBER(5,2),
  OTTICA                   VARCHAR2(18 BYTE)    NOT NULL,
  REVISIONE_ASSEGNAZIONE   NUMBER(8),
  REVISIONE_CESSAZIONE     NUMBER(8),
  GRADAZIONE               VARCHAR2(2 BYTE),
  UTENTE_AGGIORNAMENTO     VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO       DATE,
  TIPO_ASSEGNAZIONE        VARCHAR2(1 BYTE),
  VOTO                     NUMBER(4,2),
  DAL_PUBB                 DATE,
  AL_PUBB                  DATE,
  AL_PREC                  DATE
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

COMMENT ON TABLE ATTRIBUTI_COMPONENTE IS 'Attributi delle assegnazioni dei componenti';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.ID_ATTR_COMPONENTE IS 'Identificativo della registrazione (sequence)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.DAL IS 'Data inizio validita'' attributi';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.AL IS 'Data fine validita'' attributi';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.INCARICO IS 'Tipo incarico del componente nell''unita'' organizzativa';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.TELEFONO IS 'Telefono del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.FAX IS 'Fax del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.E_MAIL IS 'Indirizzo e-mail del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.ASSEGNAZIONE_PREVALENTE IS 'Indica la prevalenza dell''assegnazione del componente all''unita'' operativa (priorita'' numerica)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.PERCENTUALE_IMPIEGO IS 'Indica la percentuale di impiego del componente nell''unita'' operativa';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.REVISIONE_ASSEGNAZIONE IS 'Revisione di assegnazione dell''incarico';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.REVISIONE_CESSAZIONE IS 'Revisione di cessazione dell''incarico';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.GRADAZIONE IS 'Gradazione incarico di responsabilita';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.TIPO_ASSEGNAZIONE IS 'Tipo assegnazione';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.VOTO IS 'Indica il peso del voto (per incarichi di tipo politico)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE.AL_PREC IS 'Data fine validita'' memorizzata';




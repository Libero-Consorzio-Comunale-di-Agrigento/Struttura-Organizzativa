CREATE TABLE DUP_ATCO
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
  VOTO                     NUMBER(4,2)
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

COMMENT ON TABLE DUP_ATCO IS 'Tabella di appoggio per modifiche eseguite sui componenti con stessa decorrenza';

COMMENT ON COLUMN DUP_ATCO.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN DUP_ATCO.DAL IS 'Data inizio validita'' attributi';

COMMENT ON COLUMN DUP_ATCO.AL IS 'Data fine validita'' attributi';

COMMENT ON COLUMN DUP_ATCO.INCARICO IS 'Tipo incarico del componente nell''unita'' organizzativa';

COMMENT ON COLUMN DUP_ATCO.TELEFONO IS 'Telefono del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_ATCO.FAX IS 'Fax del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_ATCO.E_MAIL IS 'Indirizzo e-mail del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_ATCO.ASSEGNAZIONE_PREVALENTE IS 'Indica la prevalenza dell''assegnazione del componente all''unita'' operativa (priorita'' numerica)';

COMMENT ON COLUMN DUP_ATCO.PERCENTUALE_IMPIEGO IS 'Indica la percentuale di impiego del componente nell''unita'' operativa';

COMMENT ON COLUMN DUP_ATCO.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN DUP_ATCO.REVISIONE_ASSEGNAZIONE IS 'Revisione di assegnazione dell''incarico
';

COMMENT ON COLUMN DUP_ATCO.REVISIONE_CESSAZIONE IS 'Revisione di cessazione dell''incarico
';

COMMENT ON COLUMN DUP_ATCO.GRADAZIONE IS 'Gradazione incarico di responsabilita';

COMMENT ON COLUMN DUP_ATCO.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN DUP_ATCO.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN DUP_ATCO.TIPO_ASSEGNAZIONE IS 'Tipo assegnazione';

COMMENT ON COLUMN DUP_ATCO.VOTO IS 'Indica il peso del voto (per incarichi di tipo politico)';




CREATE TABLE ATTRIBUTI_COMPONENTE_B
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
  UTENTE_AGGIORNAMENTO     VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO       DATE,
  GRADAZIONE               VARCHAR2(2 BYTE),
  TIPO_ASSEGNAZIONE        VARCHAR2(1 BYTE),
  VOTO                     NUMBER(4,2),
  DAL_PUBB                 DATE,
  AL_PUBB                  DATE,
  AL_PREC                  DATE,
  OPERAZIONE               VARCHAR2(2 BYTE),
  NOTE_SESSIONE            VARCHAR2(200 BYTE),
  DATA_OPERAZIONE          TIMESTAMP(6),
  ID_BACKUP                NUMBER(10)           NOT NULL,
  CONTESTO                 VARCHAR2(1 BYTE)
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

COMMENT ON TABLE ATTRIBUTI_COMPONENTE_B IS 'Attributi delle assegnazioni dei componenti: Backup per pubblicazione eventi';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.ID_ATTR_COMPONENTE IS 'Identificativo della registrazione (sequence)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.DAL IS 'Data inizio validita'' attributi';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.AL IS 'Data fine validita'' attributi';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.INCARICO IS 'Tipo incarico del componente nell''unita'' organizzativa';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.TELEFONO IS 'Telefono del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.FAX IS 'Fax del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.E_MAIL IS 'Indirizzo e-mail del componente  (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.ASSEGNAZIONE_PREVALENTE IS 'Indica la prevalenza dell''assegnazione del componente all''unita'' operativa (priorita'' numerica)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.PERCENTUALE_IMPIEGO IS 'Indica la percentuale di impiego del componente nell''unita'' operativa';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.REVISIONE_ASSEGNAZIONE IS 'Revisione di assegnazione dell''incarico';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.REVISIONE_CESSAZIONE IS 'Revisione di cessazione dell''incarico';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.TIPO_ASSEGNAZIONE IS 'I = Istituzionale, F = Funzionale';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.VOTO IS 'Indica il peso del voto (per incarichi di tipo politico)';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.AL_PREC IS 'Data fine validita'' memorizzata';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN ATTRIBUTI_COMPONENTE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';




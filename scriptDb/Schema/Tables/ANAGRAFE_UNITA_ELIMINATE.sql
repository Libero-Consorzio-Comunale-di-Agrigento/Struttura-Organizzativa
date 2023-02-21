CREATE TABLE ANAGRAFE_UNITA_ELIMINATE
(
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  DAL                        DATE               NOT NULL,
  CODICE_UO                  VARCHAR2(50 BYTE)  NOT NULL,
  DESCRIZIONE                VARCHAR2(240 BYTE) NOT NULL,
  DESCRIZIONE_AL1            VARCHAR2(240 BYTE),
  DESCRIZIONE_AL2            VARCHAR2(240 BYTE),
  DES_ABB                    VARCHAR2(20 BYTE),
  DES_ABB_AL1                VARCHAR2(20 BYTE),
  DES_ABB_AL2                VARCHAR2(20 BYTE),
  ID_SUDDIVISIONE            NUMBER(8),
  OTTICA                     VARCHAR2(18 BYTE)  NOT NULL,
  REVISIONE_ISTITUZIONE      NUMBER(8),
  REVISIONE_CESSAZIONE       NUMBER(8),
  TIPOLOGIA_UNITA            VARCHAR2(2 BYTE),
  SE_GIURIDICO               VARCHAR2(2 BYTE),
  ASSEGNAZIONE_COMPONENTI    VARCHAR2(2 BYTE),
  AMMINISTRAZIONE            VARCHAR2(50 BYTE)  NOT NULL,
  PROGR_AOO                  NUMBER(8),
  INDIRIZZO                  VARCHAR2(120 BYTE),
  CAP                        VARCHAR2(5 BYTE),
  PROVINCIA                  NUMBER(3),
  COMUNE                     NUMBER(3),
  TELEFONO                   VARCHAR2(14 BYTE),
  FAX                        VARCHAR2(14 BYTE),
  CENTRO                     VARCHAR2(16 BYTE),
  CENTRO_RESPONSABILITA      VARCHAR2(2 BYTE),
  AL                         DATE,
  UTENTE_AD4                 VARCHAR2(8 BYTE),
  UTENTE_AGGIORNAMENTO       VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO         DATE,
  NOTE                       VARCHAR2(4000 BYTE),
  TIPO_UNITA                 VARCHAR2(1 BYTE),
  DAL_PUBB                   DATE,
  AL_PUBB                    DATE,
  AL_PREC                    DATE,
  INCARICO_RESP              VARCHAR2(8 BYTE),
  ETICHETTA                  VARCHAR2(30 BYTE),
  AGGREGATORE                VARCHAR2(16 BYTE),
  SE_FATTURA_ELETTRONICA     VARCHAR2(2 BYTE)
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

COMMENT ON TABLE ANAGRAFE_UNITA_ELIMINATE IS 'Anagrafica unita'' organizzative';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.PROGR_UNITA_ORGANIZZATIVA IS 'Codice numerico dell''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DAL IS 'Data inizio validita'' dell''anagrafica unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.CODICE_UO IS 'Codice unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DESCRIZIONE IS 'Descrizione dell''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DESCRIZIONE_AL1 IS 'Descrizione dell''unita'' organizzativa in lingua alternativa 1';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DESCRIZIONE_AL2 IS 'Descrizione dell''unita'' organizzativa in lingua alternativa 2';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DES_ABB IS 'Descrizione abbreviata dell''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DES_ABB_AL1 IS 'Descrizione abbreviata dell''unita'' organizzativa in lingua alternativa 1';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DES_ABB_AL2 IS 'Descrizione abbreviata dell''unita'' organizzativa in lingua alternativa 2';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.ID_SUDDIVISIONE IS 'Identificativo della suddivisione di appartenenza
';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.OTTICA IS 'Ottica di istituzione dell''unita'' organizzativa
';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.REVISIONE_ISTITUZIONE IS 'Revisione di istituzione dell''unita'' organizzativa
';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.REVISIONE_CESSAZIONE IS 'Revisione di cessazione dell''unita'' organizzativa
';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.TIPOLOGIA_UNITA IS 'Indica se si tratta di struttura semplica (SS), struttura complessa (SC) o altro (null)';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.SE_GIURIDICO IS 'Identifica la sottoradice di un ramo omogeneo';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.ASSEGNAZIONE_COMPONENTI IS 'Indica se i componenti dell''U.O possono essere assegnati temporaneamente ad altre unita'' organizzative oppure no';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.AMMINISTRAZIONE IS 'Codice dell''amministrazione di cui fa parte l''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.PROGR_AOO IS 'Codice numerico dell''Area Organizzativa Omogenea di cui fa parte l''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.INDIRIZZO IS 'Indirizzo';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.CAP IS 'Cap';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.PROVINCIA IS 'Codice provincia';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.COMUNE IS 'Codice comune';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.TELEFONO IS 'Numero di telefono';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.FAX IS 'Numero di fax';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.CENTRO IS 'Centro di costo associato all''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.CENTRO_RESPONSABILITA IS 'Indica se l''unita'' organizzativa e'' anche un centro di responsabilita'' (SI/NO)';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.AL IS 'Data fine validita'' dell''unita'' organizzativa';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.UTENTE_AD4 IS 'Codice utente/gruppo inserito in AD4';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.NOTE IS 'Note aggiuntive';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.TIPO_UNITA IS 'Indica il tipo di unita (P = Politica, S = Sanitaria, A = Amministrativa)';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.AL_PREC IS 'Data fine validita'' memorizzata';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.INCARICO_RESP IS 'Codice incarico del responsabile della U.O.';

COMMENT ON COLUMN ANAGRAFE_UNITA_ELIMINATE.ETICHETTA IS 'Descrizione abbreviata per il timbro di protocollo';




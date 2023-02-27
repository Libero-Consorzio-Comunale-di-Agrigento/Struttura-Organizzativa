//AMV_DOCUMENTIRow: import @5-21A9B33B
package amvadm.AdmDocumento;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DOCUMENTIRow: import

//AMV_DOCUMENTIRow: class head @5-78A8B75A
public class AMV_DOCUMENTIRow {
//End AMV_DOCUMENTIRow: class head

//AMV_DOCUMENTIRow: declare fiels @5-45EF7E46
    private TextField RECORD_TITLE = new TextField("RECORD_TITLE", "");
    private LongField ID_DOCUMENTO = new LongField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private LongField REVISIONE = new LongField("REVISIONE", "REVISIONE");
    private TextField STATO = new TextField("STATO", "STATO");
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField REVISIONE_LABEL = new TextField("REVISIONE_LABEL", "REVISIONE");
    private TextField STATO_DOCUMENTO = new TextField("STATO_DOCUMENTO", "STATO_DOCUMENTO");
    private TextField FLUSSO = new TextField("FLUSSO", "FLUSSO");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private TextField AUTORE = new TextField("AUTORE", "NOME_AUTORE");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
    private TextField UTENTE_AGGIORNAMENTO = new TextField("UTENTE_AGGIORNAMENTO", "NOME_UTENTE");
    private TextField CRONOLOGIA = new TextField("CRONOLOGIA", "CRONOLOGIA");
    private TextField NOTE = new TextField("NOTE", "NOTE");
    private LongField ID_AREA = new LongField("ID_AREA", "ID_AREA");
    private TextField ID_AREA_SEL = new TextField("ID_AREA_SEL", "ID_AREA_SEL");
    private LongField ID_TIPOLOGIA = new LongField("ID_TIPOLOGIA", "ID_TIPOLOGIA");
    private LongField ID_CATEGORIA = new LongField("ID_CATEGORIA", "ID_CATEGORIA");
    private LongField ID_ARGOMENTO = new LongField("ID_ARGOMENTO", "ID_ARGOMENTO");
    private LongField ID_SEZIONE = new LongField("ID_SEZIONE", "ID_SEZIONE");
    private LongField ID_RILEVANZA = new LongField("ID_RILEVANZA", "ID_RILEVANZA");
    private LongField SEQUENZA = new LongField("SEQUENZA", "SEQUENZA");
    private DateField DATA_RIFERIMENTO = new DateField("DATA_RIFERIMENTO", "DATA_RIFERIMENTO");
    private DateField INIZIO_PUBBLICAZIONE = new DateField("INIZIO_PUBBLICAZIONE", "INIZIO_PUBBLICAZIONE");
    private DateField FINE_PUBBLICAZIONE = new DateField("FINE_PUBBLICAZIONE", "FINE_PUBBLICAZIONE");
    private TextField TIPO_TESTO = new TextField("TIPO_TESTO", "TIPO_TESTO");
    private LongTextField TESTO = new LongTextField("TESTO", "TESTO");
    private LongTextField TESTOXQUERY = new LongTextField("TESTOXQUERY", "TESTO");
    private TextField LINKURL = new TextField("LINKURL", "LINKURL");
    private TextField CR = new TextField("CR", "CR");
    private TextField LINK = new TextField("LINK", "");
    private LongTextField XML = new LongTextField("XML", "XML");
    private LongTextField ABSTRACT = new LongTextField("ABSTRACT", "ABSTRACT");
    private TextField LINKMR = new TextField("LINKMR", "LINKMR");
    private TextField LINKMA = new TextField("LINKMA", "LINKMA");
    private TextField LINK_ITER = new TextField("LINK_ITER", "LINK_ITER");
    private TextField LINK_INOLTRO = new TextField("LINK_INOLTRO", "LINK_INOLTRO");
    private TextField LINKDATASOURCE = new TextField("LINKDATASOURCE", "LINKDATASOURCE");
    private TextField IMMAGINE = new TextField("IMMAGINE", "IMMAGINE");
    private TextField ICONA = new TextField("ICONA", "ICONA");
    private TextField ALLEGATI = new TextField("ALLEGATI", "ALLEGATI");
    private TextField FILE_UPLOAD = new TextField("FILE_UPLOAD", "");
    private TextField ALLEGATO = new TextField("ALLEGATO", "");
//End AMV_DOCUMENTIRow: declare fiels

//AMV_DOCUMENTIRow: constructor @5-E66C0356
    public AMV_DOCUMENTIRow() {
    }
//End AMV_DOCUMENTIRow: constructor

//AMV_DOCUMENTIRow: method(s) of RECORD_TITLE @142-81D81763
    public TextField getRECORD_TITLEField() {
        return RECORD_TITLE;
    }

    public String getRECORD_TITLE() {
        return RECORD_TITLE.getValue();
    }

    public void setRECORD_TITLE(String value) {
        this.RECORD_TITLE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of RECORD_TITLE

//AMV_DOCUMENTIRow: method(s) of ID_DOCUMENTO @60-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_DOCUMENTO

//AMV_DOCUMENTIRow: method(s) of REVISIONE @131-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of REVISIONE

//AMV_DOCUMENTIRow: method(s) of STATO @157-B34568E8
    public TextField getSTATOField() {
        return STATO;
    }

    public String getSTATO() {
        return STATO.getValue();
    }

    public void setSTATO(String value) {
        this.STATO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of STATO

//AMV_DOCUMENTIRow: method(s) of TITOLO @17-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of TITOLO

//AMV_DOCUMENTIRow: method(s) of REVISIONE_LABEL @138-FFD8AA27
    public TextField getREVISIONE_LABELField() {
        return REVISIONE_LABEL;
    }

    public String getREVISIONE_LABEL() {
        return REVISIONE_LABEL.getValue();
    }

    public void setREVISIONE_LABEL(String value) {
        this.REVISIONE_LABEL.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of REVISIONE_LABEL

//AMV_DOCUMENTIRow: method(s) of STATO_DOCUMENTO @130-F8075FDA
    public TextField getSTATO_DOCUMENTOField() {
        return STATO_DOCUMENTO;
    }

    public String getSTATO_DOCUMENTO() {
        return STATO_DOCUMENTO.getValue();
    }

    public void setSTATO_DOCUMENTO(String value) {
        this.STATO_DOCUMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of STATO_DOCUMENTO

//AMV_DOCUMENTIRow: method(s) of FLUSSO @155-0D1AFCA0
    public TextField getFLUSSOField() {
        return FLUSSO;
    }

    public String getFLUSSO() {
        return FLUSSO.getValue();
    }

    public void setFLUSSO(String value) {
        this.FLUSSO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of FLUSSO

//AMV_DOCUMENTIRow: method(s) of DATA_INSERIMENTO @88-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of DATA_INSERIMENTO

//AMV_DOCUMENTIRow: method(s) of AUTORE @92-583F757A
    public TextField getAUTOREField() {
        return AUTORE;
    }

    public String getAUTORE() {
        return AUTORE.getValue();
    }

    public void setAUTORE(String value) {
        this.AUTORE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of AUTORE

//AMV_DOCUMENTIRow: method(s) of DATA_AGGIORNAMENTO @27-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of DATA_AGGIORNAMENTO

//AMV_DOCUMENTIRow: method(s) of UTENTE_AGGIORNAMENTO @87-87CA4B9A
    public TextField getUTENTE_AGGIORNAMENTOField() {
        return UTENTE_AGGIORNAMENTO;
    }

    public String getUTENTE_AGGIORNAMENTO() {
        return UTENTE_AGGIORNAMENTO.getValue();
    }

    public void setUTENTE_AGGIORNAMENTO(String value) {
        this.UTENTE_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of UTENTE_AGGIORNAMENTO

//AMV_DOCUMENTIRow: method(s) of CRONOLOGIA @139-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of CRONOLOGIA

//AMV_DOCUMENTIRow: method(s) of NOTE @140-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of NOTE

//AMV_DOCUMENTIRow: method(s) of ID_AREA @105-0DE84566
    public LongField getID_AREAField() {
        return ID_AREA;
    }

    public Long getID_AREA() {
        return ID_AREA.getValue();
    }

    public void setID_AREA(Long value) {
        this.ID_AREA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_AREA

//AMV_DOCUMENTIRow: method(s) of ID_AREA_SEL @166-AF4479C2
    public TextField getID_AREA_SELField() {
        return ID_AREA_SEL;
    }

    public String getID_AREA_SEL() {
        return ID_AREA_SEL.getValue();
    }

    public void setID_AREA_SEL(String value) {
        this.ID_AREA_SEL.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_AREA_SEL

//AMV_DOCUMENTIRow: method(s) of ID_TIPOLOGIA @103-1DBA51EF
    public LongField getID_TIPOLOGIAField() {
        return ID_TIPOLOGIA;
    }

    public Long getID_TIPOLOGIA() {
        return ID_TIPOLOGIA.getValue();
    }

    public void setID_TIPOLOGIA(Long value) {
        this.ID_TIPOLOGIA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_TIPOLOGIA

//AMV_DOCUMENTIRow: method(s) of ID_CATEGORIA @102-B7640A0C
    public LongField getID_CATEGORIAField() {
        return ID_CATEGORIA;
    }

    public Long getID_CATEGORIA() {
        return ID_CATEGORIA.getValue();
    }

    public void setID_CATEGORIA(Long value) {
        this.ID_CATEGORIA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_CATEGORIA

//AMV_DOCUMENTIRow: method(s) of ID_ARGOMENTO @101-6544611D
    public LongField getID_ARGOMENTOField() {
        return ID_ARGOMENTO;
    }

    public Long getID_ARGOMENTO() {
        return ID_ARGOMENTO.getValue();
    }

    public void setID_ARGOMENTO(Long value) {
        this.ID_ARGOMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_ARGOMENTO

//AMV_DOCUMENTIRow: method(s) of ID_SEZIONE @134-87BE2FDD
    public LongField getID_SEZIONEField() {
        return ID_SEZIONE;
    }

    public Long getID_SEZIONE() {
        return ID_SEZIONE.getValue();
    }

    public void setID_SEZIONE(Long value) {
        this.ID_SEZIONE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_SEZIONE

//AMV_DOCUMENTIRow: method(s) of ID_RILEVANZA @100-5CCE130A
    public LongField getID_RILEVANZAField() {
        return ID_RILEVANZA;
    }

    public Long getID_RILEVANZA() {
        return ID_RILEVANZA.getValue();
    }

    public void setID_RILEVANZA(Long value) {
        this.ID_RILEVANZA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ID_RILEVANZA

//AMV_DOCUMENTIRow: method(s) of SEQUENZA @173-E6112114
    public LongField getSEQUENZAField() {
        return SEQUENZA;
    }

    public Long getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(Long value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of SEQUENZA

//AMV_DOCUMENTIRow: method(s) of DATA_RIFERIMENTO @21-279E1C09
    public DateField getDATA_RIFERIMENTOField() {
        return DATA_RIFERIMENTO;
    }

    public Date getDATA_RIFERIMENTO() {
        return DATA_RIFERIMENTO.getValue();
    }

    public void setDATA_RIFERIMENTO(Date value) {
        this.DATA_RIFERIMENTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of DATA_RIFERIMENTO

//AMV_DOCUMENTIRow: method(s) of INIZIO_PUBBLICAZIONE @22-EA180E25
    public DateField getINIZIO_PUBBLICAZIONEField() {
        return INIZIO_PUBBLICAZIONE;
    }

    public Date getINIZIO_PUBBLICAZIONE() {
        return INIZIO_PUBBLICAZIONE.getValue();
    }

    public void setINIZIO_PUBBLICAZIONE(Date value) {
        this.INIZIO_PUBBLICAZIONE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of INIZIO_PUBBLICAZIONE

//AMV_DOCUMENTIRow: method(s) of FINE_PUBBLICAZIONE @23-3D89441A
    public DateField getFINE_PUBBLICAZIONEField() {
        return FINE_PUBBLICAZIONE;
    }

    public Date getFINE_PUBBLICAZIONE() {
        return FINE_PUBBLICAZIONE.getValue();
    }

    public void setFINE_PUBBLICAZIONE(Date value) {
        this.FINE_PUBBLICAZIONE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of FINE_PUBBLICAZIONE

//AMV_DOCUMENTIRow: method(s) of TIPO_TESTO @118-A8742077
    public TextField getTIPO_TESTOField() {
        return TIPO_TESTO;
    }

    public String getTIPO_TESTO() {
        return TIPO_TESTO.getValue();
    }

    public void setTIPO_TESTO(String value) {
        this.TIPO_TESTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of TIPO_TESTO

//AMV_DOCUMENTIRow: method(s) of TESTO @170-4004D144
    public LongTextField getTESTOField() {
        return TESTO;
    }

    public String getTESTO() {
        return TESTO.getValue();
    }

    public void setTESTO(String value) {
        this.TESTO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of TESTO

//AMV_DOCUMENTIRow: method(s) of TESTOXQUERY @167-03F10BFB
    public LongTextField getTESTOXQUERYField() {
        return TESTOXQUERY;
    }

    public String getTESTOXQUERY() {
        return TESTOXQUERY.getValue();
    }

    public void setTESTOXQUERY(String value) {
        this.TESTOXQUERY.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of TESTOXQUERY

//AMV_DOCUMENTIRow: method(s) of LINKURL @20-41565A1E
    public TextField getLINKURLField() {
        return LINKURL;
    }

    public String getLINKURL() {
        return LINKURL.getValue();
    }

    public void setLINKURL(String value) {
        this.LINKURL.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINKURL

//AMV_DOCUMENTIRow: method(s) of CR @137-4DEAA5BC
    public TextField getCRField() {
        return CR;
    }

    public String getCR() {
        return CR.getValue();
    }

    public void setCR(String value) {
        this.CR.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of CR

//AMV_DOCUMENTIRow: method(s) of LINK @159-E8490594
    public TextField getLINKField() {
        return LINK;
    }

    public String getLINK() {
        return LINK.getValue();
    }

    public void setLINK(String value) {
        this.LINK.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINK

//AMV_DOCUMENTIRow: method(s) of XML @169-E8E71A3D
    public LongTextField getXMLField() {
        return XML;
    }

    public String getXML() {
        return XML.getValue();
    }

    public void setXML(String value) {
        this.XML.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of XML

//AMV_DOCUMENTIRow: method(s) of ABSTRACT @145-8BC81A7C
    public LongTextField getABSTRACTField() {
        return ABSTRACT;
    }

    public String getABSTRACT() {
        return ABSTRACT.getValue();
    }

    public void setABSTRACT(String value) {
        this.ABSTRACT.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ABSTRACT

//AMV_DOCUMENTIRow: method(s) of LINKMR @153-DB78028C
    public TextField getLINKMRField() {
        return LINKMR;
    }

    public String getLINKMR() {
        return LINKMR.getValue();
    }

    public void setLINKMR(String value) {
        this.LINKMR.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINKMR

//AMV_DOCUMENTIRow: method(s) of LINKMA @158-499C232E
    public TextField getLINKMAField() {
        return LINKMA;
    }

    public String getLINKMA() {
        return LINKMA.getValue();
    }

    public void setLINKMA(String value) {
        this.LINKMA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINKMA

//AMV_DOCUMENTIRow: method(s) of LINK_ITER @161-65DBF92D
    public TextField getLINK_ITERField() {
        return LINK_ITER;
    }

    public String getLINK_ITER() {
        return LINK_ITER.getValue();
    }

    public void setLINK_ITER(String value) {
        this.LINK_ITER.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINK_ITER

//AMV_DOCUMENTIRow: method(s) of LINK_INOLTRO @164-545D54CB
    public TextField getLINK_INOLTROField() {
        return LINK_INOLTRO;
    }

    public String getLINK_INOLTRO() {
        return LINK_INOLTRO.getValue();
    }

    public void setLINK_INOLTRO(String value) {
        this.LINK_INOLTRO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINK_INOLTRO

//AMV_DOCUMENTIRow: method(s) of LINKDATASOURCE @168-23654A6B
    public TextField getLINKDATASOURCEField() {
        return LINKDATASOURCE;
    }

    public String getLINKDATASOURCE() {
        return LINKDATASOURCE.getValue();
    }

    public void setLINKDATASOURCE(String value) {
        this.LINKDATASOURCE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of LINKDATASOURCE

//AMV_DOCUMENTIRow: method(s) of IMMAGINE @147-D0029DDF
    public TextField getIMMAGINEField() {
        return IMMAGINE;
    }

    public String getIMMAGINE() {
        return IMMAGINE.getValue();
    }

    public void setIMMAGINE(String value) {
        this.IMMAGINE.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of IMMAGINE

//AMV_DOCUMENTIRow: method(s) of ICONA @171-51B27CAD
    public TextField getICONAField() {
        return ICONA;
    }

    public String getICONA() {
        return ICONA.getValue();
    }

    public void setICONA(String value) {
        this.ICONA.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ICONA

//AMV_DOCUMENTIRow: method(s) of ALLEGATI @148-E07BBA0E
    public TextField getALLEGATIField() {
        return ALLEGATI;
    }

    public String getALLEGATI() {
        return ALLEGATI.getValue();
    }

    public void setALLEGATI(String value) {
        this.ALLEGATI.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ALLEGATI

//AMV_DOCUMENTIRow: method(s) of FILE_UPLOAD @149-626E1C0E
    public TextField getFILE_UPLOADField() {
        return FILE_UPLOAD;
    }

    public String getFILE_UPLOAD() {
        return FILE_UPLOAD.getValue();
    }

    public void setFILE_UPLOAD(String value) {
        this.FILE_UPLOAD.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of FILE_UPLOAD

//AMV_DOCUMENTIRow: method(s) of ALLEGATO @150-16C7D367
    public TextField getALLEGATOField() {
        return ALLEGATO;
    }

    public String getALLEGATO() {
        return ALLEGATO.getValue();
    }

    public void setALLEGATO(String value) {
        this.ALLEGATO.setValue(value);
    }
//End AMV_DOCUMENTIRow: method(s) of ALLEGATO

//AMV_DOCUMENTIRow: class tail @5-FCB6E20C
}
//End AMV_DOCUMENTIRow: class tail


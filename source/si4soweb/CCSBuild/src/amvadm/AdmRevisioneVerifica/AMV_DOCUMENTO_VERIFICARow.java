//AMV_DOCUMENTO_VERIFICARow: import @6-4F1A31F2
package amvadm.AdmRevisioneVerifica;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DOCUMENTO_VERIFICARow: import

//AMV_DOCUMENTO_VERIFICARow: class head @6-9E7AA4D1
public class AMV_DOCUMENTO_VERIFICARow {
//End AMV_DOCUMENTO_VERIFICARow: class head

//AMV_DOCUMENTO_VERIFICARow: declare fiels @6-DC55CFD0
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField MVPAGES = new TextField("MVPAGES", "MVPAGES");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private TextField NOMINATIVO_AUTORE = new TextField("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
    private TextField NOMINATIVO_AGGIORNAMENTO = new TextField("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO");
    private TextField UTENTE_APPROVAZIONE = new TextField("UTENTE_APPROVAZIONE", "UTENTE_APPROVAZIONE");
    private TextField NOTE = new TextField("NOTE", "");
    private TextField CRONOLOGIA = new TextField("CRONOLOGIA", "CRONOLOGIA");
    private TextField NOTE_LABEL = new TextField("NOTE_LABEL", "NOTE");
    private LongField REVISIONE = new LongField("REVISIONE", "REVISIONE");
    private LongField ID_DOCUMENTO = new LongField("ID_DOCUMENTO", "ID_DOCUMENTO");
//End AMV_DOCUMENTO_VERIFICARow: declare fiels

//AMV_DOCUMENTO_VERIFICARow: constructor @6-259EB7C7
    public AMV_DOCUMENTO_VERIFICARow() {
    }
//End AMV_DOCUMENTO_VERIFICARow: constructor

//AMV_DOCUMENTO_VERIFICARow: method(s) of TITOLO @7-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of TITOLO

//AMV_DOCUMENTO_VERIFICARow: method(s) of MVPAGES @36-59C95F0B
    public TextField getMVPAGESField() {
        return MVPAGES;
    }

    public String getMVPAGES() {
        return MVPAGES.getValue();
    }

    public void setMVPAGES(String value) {
        this.MVPAGES.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of MVPAGES

//AMV_DOCUMENTO_VERIFICARow: method(s) of DATA_INSERIMENTO @34-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of DATA_INSERIMENTO

//AMV_DOCUMENTO_VERIFICARow: method(s) of NOMINATIVO_AUTORE @35-5402A051
    public TextField getNOMINATIVO_AUTOREField() {
        return NOMINATIVO_AUTORE;
    }

    public String getNOMINATIVO_AUTORE() {
        return NOMINATIVO_AUTORE.getValue();
    }

    public void setNOMINATIVO_AUTORE(String value) {
        this.NOMINATIVO_AUTORE.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of NOMINATIVO_AUTORE

//AMV_DOCUMENTO_VERIFICARow: method(s) of DATA_AGGIORNAMENTO @21-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of DATA_AGGIORNAMENTO

//AMV_DOCUMENTO_VERIFICARow: method(s) of NOMINATIVO_AGGIORNAMENTO @22-CC248FDB
    public TextField getNOMINATIVO_AGGIORNAMENTOField() {
        return NOMINATIVO_AGGIORNAMENTO;
    }

    public String getNOMINATIVO_AGGIORNAMENTO() {
        return NOMINATIVO_AGGIORNAMENTO.getValue();
    }

    public void setNOMINATIVO_AGGIORNAMENTO(String value) {
        this.NOMINATIVO_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of NOMINATIVO_AGGIORNAMENTO

//AMV_DOCUMENTO_VERIFICARow: method(s) of UTENTE_APPROVAZIONE @16-3832AC88
    public TextField getUTENTE_APPROVAZIONEField() {
        return UTENTE_APPROVAZIONE;
    }

    public String getUTENTE_APPROVAZIONE() {
        return UTENTE_APPROVAZIONE.getValue();
    }

    public void setUTENTE_APPROVAZIONE(String value) {
        this.UTENTE_APPROVAZIONE.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of UTENTE_APPROVAZIONE

//AMV_DOCUMENTO_VERIFICARow: method(s) of NOTE @31-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of NOTE

//AMV_DOCUMENTO_VERIFICARow: method(s) of CRONOLOGIA @30-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of CRONOLOGIA

//AMV_DOCUMENTO_VERIFICARow: method(s) of NOTE_LABEL @32-2E4B73D0
    public TextField getNOTE_LABELField() {
        return NOTE_LABEL;
    }

    public String getNOTE_LABEL() {
        return NOTE_LABEL.getValue();
    }

    public void setNOTE_LABEL(String value) {
        this.NOTE_LABEL.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of NOTE_LABEL

//AMV_DOCUMENTO_VERIFICARow: method(s) of REVISIONE @23-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of REVISIONE

//AMV_DOCUMENTO_VERIFICARow: method(s) of ID_DOCUMENTO @14-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_VERIFICARow: method(s) of ID_DOCUMENTO

//AMV_DOCUMENTO_VERIFICARow: class tail @6-FCB6E20C
}
//End AMV_DOCUMENTO_VERIFICARow: class tail


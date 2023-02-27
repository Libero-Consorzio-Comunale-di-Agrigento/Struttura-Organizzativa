//AMV_DOCUMENTO_APPROVARow: import @6-88C3E901
package amvadm.AdmRevisioneApprova;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DOCUMENTO_APPROVARow: import

//AMV_DOCUMENTO_APPROVARow: class head @6-A05C6078
public class AMV_DOCUMENTO_APPROVARow {
//End AMV_DOCUMENTO_APPROVARow: class head

//AMV_DOCUMENTO_APPROVARow: declare fiels @6-843D3499
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField MVPAGES = new TextField("MVPAGES", "MVPAGES");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private TextField AUTORE = new TextField("AUTORE", "AUTORE");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
    private TextField UTENTE_AGGIORNAMENTO = new TextField("UTENTE_AGGIORNAMENTO", "UTENTE_AGGIORNAMENTO");
    private TextField NOTE = new TextField("NOTE", "");
    private TextField CRONOLOGIA = new TextField("CRONOLOGIA", "CRONOLOGIA");
    private TextField NOTE_LABEL = new TextField("NOTE_LABEL", "NOTE");
    private LongField REVISIONE = new LongField("REVISIONE", "REVISIONE");
    private LongField ID_DOCUMENTO = new LongField("ID_DOCUMENTO", "ID_DOCUMENTO");
//End AMV_DOCUMENTO_APPROVARow: declare fiels

//AMV_DOCUMENTO_APPROVARow: constructor @6-B5FD49C8
    public AMV_DOCUMENTO_APPROVARow() {
    }
//End AMV_DOCUMENTO_APPROVARow: constructor

//AMV_DOCUMENTO_APPROVARow: method(s) of TITOLO @7-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of TITOLO

//AMV_DOCUMENTO_APPROVARow: method(s) of MVPAGES @34-59C95F0B
    public TextField getMVPAGESField() {
        return MVPAGES;
    }

    public String getMVPAGES() {
        return MVPAGES.getValue();
    }

    public void setMVPAGES(String value) {
        this.MVPAGES.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of MVPAGES

//AMV_DOCUMENTO_APPROVARow: method(s) of DATA_INSERIMENTO @32-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of DATA_INSERIMENTO

//AMV_DOCUMENTO_APPROVARow: method(s) of AUTORE @33-583F757A
    public TextField getAUTOREField() {
        return AUTORE;
    }

    public String getAUTORE() {
        return AUTORE.getValue();
    }

    public void setAUTORE(String value) {
        this.AUTORE.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of AUTORE

//AMV_DOCUMENTO_APPROVARow: method(s) of DATA_AGGIORNAMENTO @21-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of DATA_AGGIORNAMENTO

//AMV_DOCUMENTO_APPROVARow: method(s) of UTENTE_AGGIORNAMENTO @22-87CA4B9A
    public TextField getUTENTE_AGGIORNAMENTOField() {
        return UTENTE_AGGIORNAMENTO;
    }

    public String getUTENTE_AGGIORNAMENTO() {
        return UTENTE_AGGIORNAMENTO.getValue();
    }

    public void setUTENTE_AGGIORNAMENTO(String value) {
        this.UTENTE_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of UTENTE_AGGIORNAMENTO

//AMV_DOCUMENTO_APPROVARow: method(s) of NOTE @30-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of NOTE

//AMV_DOCUMENTO_APPROVARow: method(s) of CRONOLOGIA @26-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of CRONOLOGIA

//AMV_DOCUMENTO_APPROVARow: method(s) of NOTE_LABEL @31-2E4B73D0
    public TextField getNOTE_LABELField() {
        return NOTE_LABEL;
    }

    public String getNOTE_LABEL() {
        return NOTE_LABEL.getValue();
    }

    public void setNOTE_LABEL(String value) {
        this.NOTE_LABEL.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of NOTE_LABEL

//AMV_DOCUMENTO_APPROVARow: method(s) of REVISIONE @23-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of REVISIONE

//AMV_DOCUMENTO_APPROVARow: method(s) of ID_DOCUMENTO @14-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_APPROVARow: method(s) of ID_DOCUMENTO

//AMV_DOCUMENTO_APPROVARow: class tail @6-FCB6E20C
}
//End AMV_DOCUMENTO_APPROVARow: class tail


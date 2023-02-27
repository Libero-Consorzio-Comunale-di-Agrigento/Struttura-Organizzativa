//ELENCO_REVISIONIRow: import @2-CF60D6C3
package amvadm.AdmContenutiElenco;

import java.util.*;
import com.codecharge.db.*;
//End ELENCO_REVISIONIRow: import

//ELENCO_REVISIONIRow: class head @2-B6A62E52
public class ELENCO_REVISIONIRow {
//End ELENCO_REVISIONIRow: class head

//ELENCO_REVISIONIRow: declare fiels @2-E2AEC770
    private TextField TITOLO_DOC = new TextField("TITOLO_DOC", "TITOLO");
    private DateField DATA_RIFERIMENTO = new DateField("DATA_RIFERIMENTO", "DATA_RIFERIMENTO");
    private TextField ID_DOCUMENTO = new TextField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private TextField REVISIONE = new TextField("REVISIONE", "REVISIONE");
    private TextField STATO_DOCUMENTO = new TextField("STATO_DOCUMENTO", "STATO_DOCUMENTO");
    private TextField STORICO = new TextField("STORICO", "STORICO_SRC");
    private TextField REVISIONA = new TextField("REVISIONA", "REV_SRC");
    private TextField MODIFICA = new TextField("MODIFICA", "MOD_SRC");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_DOCUMENTO");
    private TextField REV = new TextField("REV", "REVISIONE");
    private TextField HREF_SRC = new TextField("HREF_SRC", "HREF_SRC");
    private TextField REV_HREF = new TextField("REV_HREF", "REV_HREF");
    private TextField MOD_HREF = new TextField("MOD_HREF", "MOD_HREF");
//End ELENCO_REVISIONIRow: declare fiels

//ELENCO_REVISIONIRow: constructor @2-190DF12D
    public ELENCO_REVISIONIRow() {
    }
//End ELENCO_REVISIONIRow: constructor

//ELENCO_REVISIONIRow: method(s) of TITOLO_DOC @3-CEA418CF
    public TextField getTITOLO_DOCField() {
        return TITOLO_DOC;
    }

    public String getTITOLO_DOC() {
        return TITOLO_DOC.getValue();
    }

    public void setTITOLO_DOC(String value) {
        this.TITOLO_DOC.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of TITOLO_DOC

//ELENCO_REVISIONIRow: method(s) of DATA_RIFERIMENTO @21-279E1C09
    public DateField getDATA_RIFERIMENTOField() {
        return DATA_RIFERIMENTO;
    }

    public Date getDATA_RIFERIMENTO() {
        return DATA_RIFERIMENTO.getValue();
    }

    public void setDATA_RIFERIMENTO(Date value) {
        this.DATA_RIFERIMENTO.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of DATA_RIFERIMENTO

//ELENCO_REVISIONIRow: method(s) of ID_DOCUMENTO @30-0839CD9A
    public TextField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public String getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(String value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of ID_DOCUMENTO

//ELENCO_REVISIONIRow: method(s) of REVISIONE @4-DF4C75B7
    public TextField getREVISIONEField() {
        return REVISIONE;
    }

    public String getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(String value) {
        this.REVISIONE.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of REVISIONE

//ELENCO_REVISIONIRow: method(s) of STATO_DOCUMENTO @5-F8075FDA
    public TextField getSTATO_DOCUMENTOField() {
        return STATO_DOCUMENTO;
    }

    public String getSTATO_DOCUMENTO() {
        return STATO_DOCUMENTO.getValue();
    }

    public void setSTATO_DOCUMENTO(String value) {
        this.STATO_DOCUMENTO.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of STATO_DOCUMENTO

//ELENCO_REVISIONIRow: method(s) of STORICO @20-778DF9CA
    public TextField getSTORICOField() {
        return STORICO;
    }

    public String getSTORICO() {
        return STORICO.getValue();
    }

    public void setSTORICO(String value) {
        this.STORICO.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of STORICO

//ELENCO_REVISIONIRow: method(s) of REVISIONA @14-0A7125F6
    public TextField getREVISIONAField() {
        return REVISIONA;
    }

    public String getREVISIONA() {
        return REVISIONA.getValue();
    }

    public void setREVISIONA(String value) {
        this.REVISIONA.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of REVISIONA

//ELENCO_REVISIONIRow: method(s) of MODIFICA @17-EF108664
    public TextField getMODIFICAField() {
        return MODIFICA;
    }

    public String getMODIFICA() {
        return MODIFICA.getValue();
    }

    public void setMODIFICA(String value) {
        this.MODIFICA.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of MODIFICA

//ELENCO_REVISIONIRow: method(s) of AFCNavigator @31-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of AFCNavigator

//ELENCO_REVISIONIRow: method(s) of ID @15-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of ID

//ELENCO_REVISIONIRow: method(s) of REV @16-E7377A02
    public TextField getREVField() {
        return REV;
    }

    public String getREV() {
        return REV.getValue();
    }

    public void setREV(String value) {
        this.REV.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of REV

//ELENCO_REVISIONIRow: method(s) of HREF_SRC @HREF_SRC-D535C64B
    public TextField getHREF_SRCField() {
        return HREF_SRC;
    }

    public String getHREF_SRC() {
        return HREF_SRC.getValue();
    }

    public void setHREF_SRC(String value) {
        this.HREF_SRC.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of HREF_SRC

//ELENCO_REVISIONIRow: method(s) of REV_HREF @REV_HREF-C6BE5031
    public TextField getREV_HREFField() {
        return REV_HREF;
    }

    public String getREV_HREF() {
        return REV_HREF.getValue();
    }

    public void setREV_HREF(String value) {
        this.REV_HREF.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of REV_HREF

//ELENCO_REVISIONIRow: method(s) of MOD_HREF @MOD_HREF-F05648A4
    public TextField getMOD_HREFField() {
        return MOD_HREF;
    }

    public String getMOD_HREF() {
        return MOD_HREF.getValue();
    }

    public void setMOD_HREF(String value) {
        this.MOD_HREF.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of MOD_HREF

//ELENCO_REVISIONIRow: class tail @2-FCB6E20C
}
//End ELENCO_REVISIONIRow: class tail


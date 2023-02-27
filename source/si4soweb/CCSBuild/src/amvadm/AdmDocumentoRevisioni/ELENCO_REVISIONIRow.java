//ELENCO_REVISIONIRow: import @2-F8A201D2
package amvadm.AdmDocumentoRevisioni;

import java.util.*;
import com.codecharge.db.*;
//End ELENCO_REVISIONIRow: import

//ELENCO_REVISIONIRow: class head @2-B6A62E52
public class ELENCO_REVISIONIRow {
//End ELENCO_REVISIONIRow: class head

//ELENCO_REVISIONIRow: declare fiels @2-26391222
    private TextField REVISIONE = new TextField("REVISIONE", "REVISIONE");
    private TextField STATO_DOCUMENTO = new TextField("STATO_DOCUMENTO", "STATO_DOCUMENTO");
    private TextField TITOLO_DOC = new TextField("TITOLO_DOC", "TITOLO");
    private TextField MODIFICA = new TextField("MODIFICA", "MOD_SRC");
    private TextField ID = new TextField("ID", "ID_DOCUMENTO");
    private TextField ID_DOCUMENTO = new TextField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private TextField REV = new TextField("REV", "REVISIONE");
    private TextField HREF_SRC = new TextField("HREF_SRC", "HREF_SRC");
    private TextField MOD_HREF = new TextField("MOD_HREF", "MOD_HREF");
//End ELENCO_REVISIONIRow: declare fiels

//ELENCO_REVISIONIRow: constructor @2-190DF12D
    public ELENCO_REVISIONIRow() {
    }
//End ELENCO_REVISIONIRow: constructor

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

//ELENCO_REVISIONIRow: method(s) of ID @31-2B895796
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

//ELENCO_REVISIONIRow: method(s) of ID_DOCUMENTO @31-0839CD9A
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

//ELENCO_REVISIONIRow: method(s) of REV @32-E7377A02
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


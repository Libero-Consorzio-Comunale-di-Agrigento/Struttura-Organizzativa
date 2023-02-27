//AMV_VISTA_DOCUMENTIRow: import @5-296D8861
package common.AmvDocumentiRicerca;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTIRow: import

//AMV_VISTA_DOCUMENTIRow: class head @5-DC06F424
public class AMV_VISTA_DOCUMENTIRow {
//End AMV_VISTA_DOCUMENTIRow: class head

//AMV_VISTA_DOCUMENTIRow: declare fiels @5-279AE626
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField SEZIONE = new TextField("SEZIONE", "DES_SEZIONE");
    private DateField DATA_ULTIMA_MODIFICA = new DateField("DATA_ULTIMA_MODIFICA", "DATA_ULTIMA_MODIFICA");
    private TextField MODIFICA = new TextField("MODIFICA", "MOD_SRC");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_DOCUMENTO");
    private TextField ID_DOCUMENTO = new TextField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private TextField REV = new TextField("REV", "REVISIONE");
    private TextField REVISIONE = new TextField("REVISIONE", "REVISIONE");
    private TextField MVTD = new TextField("MVTD", "ID_TIPOLOGIA");
    private TextField ID_TIPOLOGIA = new TextField("ID_TIPOLOGIA", "ID_TIPOLOGIA");
    private TextField MVSZ = new TextField("MVSZ", "ID_SEZIONE");
    private TextField ID_SEZIONE = new TextField("ID_SEZIONE", "ID_SEZIONE");
//End AMV_VISTA_DOCUMENTIRow: declare fiels

//AMV_VISTA_DOCUMENTIRow: constructor @5-EB403512
    public AMV_VISTA_DOCUMENTIRow() {
    }
//End AMV_VISTA_DOCUMENTIRow: constructor

//AMV_VISTA_DOCUMENTIRow: method(s) of TITOLO @32-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of TITOLO

//AMV_VISTA_DOCUMENTIRow: method(s) of SEZIONE @78-ED95B6A5
    public TextField getSEZIONEField() {
        return SEZIONE;
    }

    public String getSEZIONE() {
        return SEZIONE.getValue();
    }

    public void setSEZIONE(String value) {
        this.SEZIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of SEZIONE

//AMV_VISTA_DOCUMENTIRow: method(s) of DATA_ULTIMA_MODIFICA @82-C2A731F8
    public DateField getDATA_ULTIMA_MODIFICAField() {
        return DATA_ULTIMA_MODIFICA;
    }

    public Date getDATA_ULTIMA_MODIFICA() {
        return DATA_ULTIMA_MODIFICA.getValue();
    }

    public void setDATA_ULTIMA_MODIFICA(Date value) {
        this.DATA_ULTIMA_MODIFICA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of DATA_ULTIMA_MODIFICA

//AMV_VISTA_DOCUMENTIRow: method(s) of MODIFICA @83-EF108664
    public TextField getMODIFICAField() {
        return MODIFICA;
    }

    public String getMODIFICA() {
        return MODIFICA.getValue();
    }

    public void setMODIFICA(String value) {
        this.MODIFICA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of MODIFICA

//AMV_VISTA_DOCUMENTIRow: method(s) of AFCNavigator @70-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of AFCNavigator

//AMV_VISTA_DOCUMENTIRow: method(s) of ID @47-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ID

//AMV_VISTA_DOCUMENTIRow: method(s) of ID_DOCUMENTO @47-0839CD9A
    public TextField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public String getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(String value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ID_DOCUMENTO

//AMV_VISTA_DOCUMENTIRow: method(s) of REV @86-E7377A02
    public TextField getREVField() {
        return REV;
    }

    public String getREV() {
        return REV.getValue();
    }

    public void setREV(String value) {
        this.REV.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of REV

//AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONE @86-DF4C75B7
    public TextField getREVISIONEField() {
        return REVISIONE;
    }

    public String getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(String value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONE

//AMV_VISTA_DOCUMENTIRow: method(s) of MVTD @87-2F00C306
    public TextField getMVTDField() {
        return MVTD;
    }

    public String getMVTD() {
        return MVTD.getValue();
    }

    public void setMVTD(String value) {
        this.MVTD.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of MVTD

//AMV_VISTA_DOCUMENTIRow: method(s) of ID_TIPOLOGIA @87-3DFA78BA
    public TextField getID_TIPOLOGIAField() {
        return ID_TIPOLOGIA;
    }

    public String getID_TIPOLOGIA() {
        return ID_TIPOLOGIA.getValue();
    }

    public void setID_TIPOLOGIA(String value) {
        this.ID_TIPOLOGIA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ID_TIPOLOGIA

//AMV_VISTA_DOCUMENTIRow: method(s) of MVSZ @88-A1D08CB8
    public TextField getMVSZField() {
        return MVSZ;
    }

    public String getMVSZ() {
        return MVSZ.getValue();
    }

    public void setMVSZ(String value) {
        this.MVSZ.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of MVSZ

//AMV_VISTA_DOCUMENTIRow: method(s) of ID_SEZIONE @88-7E23C377
    public TextField getID_SEZIONEField() {
        return ID_SEZIONE;
    }

    public String getID_SEZIONE() {
        return ID_SEZIONE.getValue();
    }

    public void setID_SEZIONE(String value) {
        this.ID_SEZIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ID_SEZIONE

//AMV_VISTA_DOCUMENTIRow: class tail @5-FCB6E20C
}
//End AMV_VISTA_DOCUMENTIRow: class tail


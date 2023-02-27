//ELENCO_REVISIONIRow: import @6-1A4D2EB4
package amvadm.AdmRevisioniElenco;

import java.util.*;
import com.codecharge.db.*;
//End ELENCO_REVISIONIRow: import

//ELENCO_REVISIONIRow: class head @6-B6A62E52
public class ELENCO_REVISIONIRow {
//End ELENCO_REVISIONIRow: class head

//ELENCO_REVISIONIRow: declare fiels @6-12B82AAF
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField REVISIONE = new TextField("REVISIONE", "REVISIONE");
    private TextField CRONOLOGIA = new TextField("CRONOLOGIA", "CRONOLOGIA");
    private TextField STATO_DOCUMENTO = new TextField("STATO_DOCUMENTO", "STATO_DOCUMENTO");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End ELENCO_REVISIONIRow: declare fiels

//ELENCO_REVISIONIRow: constructor @6-190DF12D
    public ELENCO_REVISIONIRow() {
    }
//End ELENCO_REVISIONIRow: constructor

//ELENCO_REVISIONIRow: method(s) of TITOLO @7-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of TITOLO

//ELENCO_REVISIONIRow: method(s) of REVISIONE @13-DF4C75B7
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

//ELENCO_REVISIONIRow: method(s) of CRONOLOGIA @14-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End ELENCO_REVISIONIRow: method(s) of CRONOLOGIA

//ELENCO_REVISIONIRow: method(s) of STATO_DOCUMENTO @11-F8075FDA
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

//ELENCO_REVISIONIRow: method(s) of AFCNavigator @15-B6FE7CCE
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

//ELENCO_REVISIONIRow: class tail @6-FCB6E20C
}
//End ELENCO_REVISIONIRow: class tail


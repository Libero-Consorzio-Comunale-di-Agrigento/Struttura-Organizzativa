//AccessiDettaglioRow: import @14-9303442F
package restrict.AmvUltimiAccessi;

import java.util.*;
import com.codecharge.db.*;
//End AccessiDettaglioRow: import

//AccessiDettaglioRow: class head @14-77758C2A
public class AccessiDettaglioRow {
//End AccessiDettaglioRow: class head

//AccessiDettaglioRow: declare fiels @14-A4E83195
    private TextField DES_ACCESSO = new TextField("DES_ACCESSO", "DES_ACCESSO");
    private TextField DES_ORA = new TextField("DES_ORA", "DES_ORA");
    private TextField DSP_SESSIONE = new TextField("DSP_SESSIONE", "DSP_SESSIONE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End AccessiDettaglioRow: declare fiels

//AccessiDettaglioRow: constructor @14-C0049501
    public AccessiDettaglioRow() {
    }
//End AccessiDettaglioRow: constructor

//AccessiDettaglioRow: method(s) of DES_ACCESSO @15-BC13A282
    public TextField getDES_ACCESSOField() {
        return DES_ACCESSO;
    }

    public String getDES_ACCESSO() {
        return DES_ACCESSO.getValue();
    }

    public void setDES_ACCESSO(String value) {
        this.DES_ACCESSO.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of DES_ACCESSO

//AccessiDettaglioRow: method(s) of DES_ORA @33-85D66C94
    public TextField getDES_ORAField() {
        return DES_ORA;
    }

    public String getDES_ORA() {
        return DES_ORA.getValue();
    }

    public void setDES_ORA(String value) {
        this.DES_ORA.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of DES_ORA

//AccessiDettaglioRow: method(s) of DSP_SESSIONE @17-671EAA9C
    public TextField getDSP_SESSIONEField() {
        return DSP_SESSIONE;
    }

    public String getDSP_SESSIONE() {
        return DSP_SESSIONE.getValue();
    }

    public void setDSP_SESSIONE(String value) {
        this.DSP_SESSIONE.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of DSP_SESSIONE

//AccessiDettaglioRow: method(s) of AFCNavigator @35-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of AFCNavigator

//AccessiDettaglioRow: class tail @14-FCB6E20C
}
//End AccessiDettaglioRow: class tail


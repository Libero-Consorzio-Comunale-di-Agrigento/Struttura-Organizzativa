//GuidaRow: import @2-4A41CF08
package common.AmvGuidaBar;

import java.util.*;
import com.codecharge.db.*;
//End GuidaRow: import

//GuidaRow: class head @2-6A08D823
public class GuidaRow {
//End GuidaRow: class head

//GuidaRow: declare fiels @2-AEB06D6E
    private TextField SEPARATORE = new TextField("SEPARATORE", "SEPARATORE");
    private TextField GUIDA = new TextField("GUIDA", "TITOLO");
    private TextField ID = new TextField("ID", "SEQUENZA");
    private TextField SEQUENZA = new TextField("SEQUENZA", "SEQUENZA");
    private TextField STRINGA = new TextField("STRINGA", "STRINGA");
//End GuidaRow: declare fiels

//GuidaRow: constructor @2-5B3C2AD5
    public GuidaRow() {
    }
//End GuidaRow: constructor

//GuidaRow: method(s) of SEPARATORE @11-94113487
    public TextField getSEPARATOREField() {
        return SEPARATORE;
    }

    public String getSEPARATORE() {
        return SEPARATORE.getValue();
    }

    public void setSEPARATORE(String value) {
        this.SEPARATORE.setValue(value);
    }
//End GuidaRow: method(s) of SEPARATORE

//GuidaRow: method(s) of GUIDA @3-002FBA82
    public TextField getGUIDAField() {
        return GUIDA;
    }

    public String getGUIDA() {
        return GUIDA.getValue();
    }

    public void setGUIDA(String value) {
        this.GUIDA.setValue(value);
    }
//End GuidaRow: method(s) of GUIDA

//GuidaRow: method(s) of ID @10-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End GuidaRow: method(s) of ID

//GuidaRow: method(s) of SEQUENZA @10-C6A59924
    public TextField getSEQUENZAField() {
        return SEQUENZA;
    }

    public String getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(String value) {
        this.SEQUENZA.setValue(value);
    }
//End GuidaRow: method(s) of SEQUENZA

//GuidaRow: method(s) of STRINGA @STRINGA-A3BF594E
    public TextField getSTRINGAField() {
        return STRINGA;
    }

    public String getSTRINGA() {
        return STRINGA.getValue();
    }

    public void setSTRINGA(String value) {
        this.STRINGA.setValue(value);
    }
//End GuidaRow: method(s) of STRINGA

//GuidaRow: class tail @2-FCB6E20C
}
//End GuidaRow: class tail


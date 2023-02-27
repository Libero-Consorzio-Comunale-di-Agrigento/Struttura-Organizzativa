//GuidaPropriaRow: import @13-4A41CF08
package common.AmvGuidaBar;

import java.util.*;
import com.codecharge.db.*;
//End GuidaPropriaRow: import

//GuidaPropriaRow: class head @13-4C89BCE1
public class GuidaPropriaRow {
//End GuidaPropriaRow: class head

//GuidaPropriaRow: declare fiels @13-AEB06D6E
    private TextField SEPARATORE = new TextField("SEPARATORE", "SEPARATORE");
    private TextField GUIDA = new TextField("GUIDA", "TITOLO");
    private TextField ID = new TextField("ID", "SEQUENZA");
    private TextField SEQUENZA = new TextField("SEQUENZA", "SEQUENZA");
    private TextField STRINGA = new TextField("STRINGA", "STRINGA");
//End GuidaPropriaRow: declare fiels

//GuidaPropriaRow: constructor @13-3EF8B062
    public GuidaPropriaRow() {
    }
//End GuidaPropriaRow: constructor

//GuidaPropriaRow: method(s) of SEPARATORE @14-94113487
    public TextField getSEPARATOREField() {
        return SEPARATORE;
    }

    public String getSEPARATORE() {
        return SEPARATORE.getValue();
    }

    public void setSEPARATORE(String value) {
        this.SEPARATORE.setValue(value);
    }
//End GuidaPropriaRow: method(s) of SEPARATORE

//GuidaPropriaRow: method(s) of GUIDA @15-002FBA82
    public TextField getGUIDAField() {
        return GUIDA;
    }

    public String getGUIDA() {
        return GUIDA.getValue();
    }

    public void setGUIDA(String value) {
        this.GUIDA.setValue(value);
    }
//End GuidaPropriaRow: method(s) of GUIDA

//GuidaPropriaRow: method(s) of ID @16-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End GuidaPropriaRow: method(s) of ID

//GuidaPropriaRow: method(s) of SEQUENZA @16-C6A59924
    public TextField getSEQUENZAField() {
        return SEQUENZA;
    }

    public String getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(String value) {
        this.SEQUENZA.setValue(value);
    }
//End GuidaPropriaRow: method(s) of SEQUENZA

//GuidaPropriaRow: method(s) of STRINGA @STRINGA-A3BF594E
    public TextField getSTRINGAField() {
        return STRINGA;
    }

    public String getSTRINGA() {
        return STRINGA.getValue();
    }

    public void setSTRINGA(String value) {
        this.STRINGA.setValue(value);
    }
//End GuidaPropriaRow: method(s) of STRINGA

//GuidaPropriaRow: class tail @13-FCB6E20C
}
//End GuidaPropriaRow: class tail


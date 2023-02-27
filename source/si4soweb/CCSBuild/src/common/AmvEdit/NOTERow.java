//NOTERow: import @2-4E17E40C
package common.AmvEdit;

import java.util.*;
import com.codecharge.db.*;
//End NOTERow: import

//NOTERow: class head @2-A50BA742
public class NOTERow {
//End NOTERow: class head

//NOTERow: declare fiels @2-C60680EC
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private LongTextField VALORE = new LongTextField("VALORE", "");
    private TextField INPUT_FILE = new TextField("INPUT_FILE", "INPUT_FILE");
    private TextField MOSTRA = new TextField("MOSTRA", "MOSTRA");
//End NOTERow: declare fiels

//NOTERow: constructor @2-816D4902
    public NOTERow() {
    }
//End NOTERow: constructor

//NOTERow: method(s) of TITOLO @10-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End NOTERow: method(s) of TITOLO

//NOTERow: method(s) of VALORE @3-20B95938
    public LongTextField getVALOREField() {
        return VALORE;
    }

    public String getVALORE() {
        return VALORE.getValue();
    }

    public void setVALORE(String value) {
        this.VALORE.setValue(value);
    }
//End NOTERow: method(s) of VALORE

//NOTERow: method(s) of INPUT_FILE @22-3DD795C7
    public TextField getINPUT_FILEField() {
        return INPUT_FILE;
    }

    public String getINPUT_FILE() {
        return INPUT_FILE.getValue();
    }

    public void setINPUT_FILE(String value) {
        this.INPUT_FILE.setValue(value);
    }
//End NOTERow: method(s) of INPUT_FILE

//NOTERow: method(s) of MOSTRA @27-10A00701
    public TextField getMOSTRAField() {
        return MOSTRA;
    }

    public String getMOSTRA() {
        return MOSTRA.getValue();
    }

    public void setMOSTRA(String value) {
        this.MOSTRA.setValue(value);
    }
//End NOTERow: method(s) of MOSTRA

//NOTERow: class tail @2-FCB6E20C
}
//End NOTERow: class tail


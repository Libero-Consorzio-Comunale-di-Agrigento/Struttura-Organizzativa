//FILE_LISTRow: import @2-DD64C9DC
package common.AmvModSelect;

import java.util.*;
import com.codecharge.db.*;
//End FILE_LISTRow: import

//FILE_LISTRow: class head @2-972397CA
public class FILE_LISTRow {
//End FILE_LISTRow: class head

//FILE_LISTRow: declare fiels @2-BA664CF8
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField MODELLO = new TextField("MODELLO", "VALORE");
//End FILE_LISTRow: declare fiels

//FILE_LISTRow: constructor @2-618F1CAC
    public FILE_LISTRow() {
    }
//End FILE_LISTRow: constructor

//FILE_LISTRow: method(s) of TITOLO @10-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End FILE_LISTRow: method(s) of TITOLO

//FILE_LISTRow: method(s) of MODELLO @27-8BFFBBFB
    public TextField getMODELLOField() {
        return MODELLO;
    }

    public String getMODELLO() {
        return MODELLO.getValue();
    }

    public void setMODELLO(String value) {
        this.MODELLO.setValue(value);
    }
//End FILE_LISTRow: method(s) of MODELLO

//FILE_LISTRow: class tail @2-FCB6E20C
}
//End FILE_LISTRow: class tail


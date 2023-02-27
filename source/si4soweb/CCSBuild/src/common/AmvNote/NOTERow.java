//NOTERow: import @2-F0324E0B
package common.AmvNote;

import java.util.*;
import com.codecharge.db.*;
//End NOTERow: import

//NOTERow: class head @2-A50BA742
public class NOTERow {
//End NOTERow: class head

//NOTERow: declare fiels @2-0805DEB9
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private LongTextField VALORE = new LongTextField("VALORE", "VALORE");
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

//NOTERow: class tail @2-FCB6E20C
}
//End NOTERow: class tail


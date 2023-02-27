//TITLEGridRow: import @31-7693BFCE
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import com.codecharge.db.*;
//End TITLEGridRow: import

//TITLEGridRow: class head @31-61783343
public class TITLEGridRow {
//End TITLEGridRow: class head

//TITLEGridRow: declare fiels @31-85A3A13D
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField LIVELLO = new TextField("LIVELLO", "LIVELLO");
//End TITLEGridRow: declare fiels

//TITLEGridRow: constructor @31-B9B9CDC4
    public TITLEGridRow() {
    }
//End TITLEGridRow: constructor

//TITLEGridRow: method(s) of TITOLO @32-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End TITLEGridRow: method(s) of TITOLO

//TITLEGridRow: method(s) of LIVELLO @42-E164E905
    public TextField getLIVELLOField() {
        return LIVELLO;
    }

    public String getLIVELLO() {
        return LIVELLO.getValue();
    }

    public void setLIVELLO(String value) {
        this.LIVELLO.setValue(value);
    }
//End TITLEGridRow: method(s) of LIVELLO

//TITLEGridRow: class tail @31-FCB6E20C
}
//End TITLEGridRow: class tail


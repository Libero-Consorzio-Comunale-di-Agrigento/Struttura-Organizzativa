//TITLEGridRow: import @148-1F03BD27
package amvadm.AdmRichieste;

import java.util.*;
import com.codecharge.db.*;
//End TITLEGridRow: import

//TITLEGridRow: class head @148-61783343
public class TITLEGridRow {
//End TITLEGridRow: class head

//TITLEGridRow: declare fiels @148-4E5D3A73
    private TextField STATO = new TextField("STATO", "STATO");
//End TITLEGridRow: declare fiels

//TITLEGridRow: constructor @148-B9B9CDC4
    public TITLEGridRow() {
    }
//End TITLEGridRow: constructor

//TITLEGridRow: method(s) of STATO @149-B34568E8
    public TextField getSTATOField() {
        return STATO;
    }

    public String getSTATO() {
        return STATO.getValue();
    }

    public void setSTATO(String value) {
        this.STATO.setValue(value);
    }
//End TITLEGridRow: method(s) of STATO

//TITLEGridRow: class tail @148-FCB6E20C
}
//End TITLEGridRow: class tail


//DISPONIBILIRow: import @70-FFBA87D0
package amvadm.AdmGruppoUtenti;

import java.util.*;
import com.codecharge.db.*;
//End DISPONIBILIRow: import

//DISPONIBILIRow: class head @70-F1C1964A
public class DISPONIBILIRow {
//End DISPONIBILIRow: class head

//DISPONIBILIRow: declare fiels @70-2F37D512
    private TextField UTENTE_D = new TextField("UTENTE_D", "");
//End DISPONIBILIRow: declare fiels

//DISPONIBILIRow: constructor @70-F5C273A6
    public DISPONIBILIRow() {
    }
//End DISPONIBILIRow: constructor

//DISPONIBILIRow: method(s) of UTENTE_D @-9E2474A5
    public TextField getUTENTE_DField() {
        return UTENTE_D;
    }

    public String getUTENTE_D() {
        return UTENTE_D.getValue();
    }

    public void setUTENTE_D(String value) {
        this.UTENTE_D.setValue(value);
    }
//End DISPONIBILIRow: method(s) of UTENTE_D

//DISPONIBILIRow: class tail @70-FCB6E20C
}
//End DISPONIBILIRow: class tail


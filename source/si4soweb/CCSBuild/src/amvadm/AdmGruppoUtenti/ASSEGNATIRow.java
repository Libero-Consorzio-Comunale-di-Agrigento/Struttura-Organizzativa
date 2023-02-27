//ASSEGNATIRow: import @76-FFBA87D0
package amvadm.AdmGruppoUtenti;

import java.util.*;
import com.codecharge.db.*;
//End ASSEGNATIRow: import

//ASSEGNATIRow: class head @76-D2D66EFA
public class ASSEGNATIRow {
//End ASSEGNATIRow: class head

//ASSEGNATIRow: declare fiels @76-B0EC959D
    private TextField UTENTE_A = new TextField("UTENTE_A", "");
//End ASSEGNATIRow: declare fiels

//ASSEGNATIRow: constructor @76-4D4DA51E
    public ASSEGNATIRow() {
    }
//End ASSEGNATIRow: constructor

//ASSEGNATIRow: method(s) of UTENTE_A @-FE7EAA58
    public TextField getUTENTE_AField() {
        return UTENTE_A;
    }

    public String getUTENTE_A() {
        return UTENTE_A.getValue();
    }

    public void setUTENTE_A(String value) {
        this.UTENTE_A.setValue(value);
    }
//End ASSEGNATIRow: method(s) of UTENTE_A

//ASSEGNATIRow: class tail @76-FCB6E20C
}
//End ASSEGNATIRow: class tail


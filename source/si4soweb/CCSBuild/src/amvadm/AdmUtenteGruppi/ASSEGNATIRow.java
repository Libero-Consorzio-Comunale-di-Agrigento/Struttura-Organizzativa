//ASSEGNATIRow: import @76-42702442
package amvadm.AdmUtenteGruppi;

import java.util.*;
import com.codecharge.db.*;
//End ASSEGNATIRow: import

//ASSEGNATIRow: class head @76-D2D66EFA
public class ASSEGNATIRow {
//End ASSEGNATIRow: class head

//ASSEGNATIRow: declare fiels @76-C4DC574A
    private TextField GRUPPO_A = new TextField("GRUPPO_A", "");
//End ASSEGNATIRow: declare fiels

//ASSEGNATIRow: constructor @76-4D4DA51E
    public ASSEGNATIRow() {
    }
//End ASSEGNATIRow: constructor

//ASSEGNATIRow: method(s) of GRUPPO_A @77-706D4B4B
    public TextField getGRUPPO_AField() {
        return GRUPPO_A;
    }

    public String getGRUPPO_A() {
        return GRUPPO_A.getValue();
    }

    public void setGRUPPO_A(String value) {
        this.GRUPPO_A.setValue(value);
    }
//End ASSEGNATIRow: method(s) of GRUPPO_A

//ASSEGNATIRow: class tail @76-FCB6E20C
}
//End ASSEGNATIRow: class tail


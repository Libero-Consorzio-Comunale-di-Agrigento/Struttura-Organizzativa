//DISPONIBILIRow: import @70-42702442
package amvadm.AdmUtenteGruppi;

import java.util.*;
import com.codecharge.db.*;
//End DISPONIBILIRow: import

//DISPONIBILIRow: class head @70-F1C1964A
public class DISPONIBILIRow {
//End DISPONIBILIRow: class head

//DISPONIBILIRow: declare fiels @70-5B0717C5
    private TextField GRUPPO_D = new TextField("GRUPPO_D", "");
//End DISPONIBILIRow: declare fiels

//DISPONIBILIRow: constructor @70-F5C273A6
    public DISPONIBILIRow() {
    }
//End DISPONIBILIRow: constructor

//DISPONIBILIRow: method(s) of GRUPPO_D @71-103795B6
    public TextField getGRUPPO_DField() {
        return GRUPPO_D;
    }

    public String getGRUPPO_D() {
        return GRUPPO_D.getValue();
    }

    public void setGRUPPO_D(String value) {
        this.GRUPPO_D.setValue(value);
    }
//End DISPONIBILIRow: method(s) of GRUPPO_D

//DISPONIBILIRow: class tail @70-FCB6E20C
}
//End DISPONIBILIRow: class tail


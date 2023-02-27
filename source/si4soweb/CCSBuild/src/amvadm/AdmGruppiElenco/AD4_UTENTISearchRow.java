//AD4_UTENTISearchRow: import @6-AEE82053
package amvadm.AdmGruppiElenco;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTISearchRow: import

//AD4_UTENTISearchRow: class head @6-919FABCE
public class AD4_UTENTISearchRow {
//End AD4_UTENTISearchRow: class head

//AD4_UTENTISearchRow: declare fiels @6-524C0E79
    private TextField s_TESTO = new TextField("s_TESTO", "");
    private TextField ID = new TextField("ID", "UTENTE");
//End AD4_UTENTISearchRow: declare fiels

//AD4_UTENTISearchRow: constructor @6-F4F55498
    public AD4_UTENTISearchRow() {
    }
//End AD4_UTENTISearchRow: constructor

//AD4_UTENTISearchRow: method(s) of s_TESTO @10-8A65CBD6
    public TextField getS_TESTOField() {
        return s_TESTO;
    }

    public String getS_TESTO() {
        return s_TESTO.getValue();
    }

    public void setS_TESTO(String value) {
        this.s_TESTO.setValue(value);
    }
//End AD4_UTENTISearchRow: method(s) of s_TESTO

//AD4_UTENTISearchRow: method(s) of ID @50-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AD4_UTENTISearchRow: method(s) of ID

//AD4_UTENTISearchRow: class tail @6-FCB6E20C
}
//End AD4_UTENTISearchRow: class tail


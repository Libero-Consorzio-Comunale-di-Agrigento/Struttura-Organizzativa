//AD4_UTENTISearchRow: import @68-FFBA87D0
package amvadm.AdmGruppoUtenti;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTISearchRow: import

//AD4_UTENTISearchRow: class head @68-919FABCE
public class AD4_UTENTISearchRow {
//End AD4_UTENTISearchRow: class head

//AD4_UTENTISearchRow: declare fiels @68-1A968A4A
    private TextField s_TESTO = new TextField("s_TESTO", "");
    private TextField ID = new TextField("ID", "GRUPPO");
    private TextField RICERCA = new TextField("RICERCA", "RICERCA");
//End AD4_UTENTISearchRow: declare fiels

//AD4_UTENTISearchRow: constructor @68-F4F55498
    public AD4_UTENTISearchRow() {
    }
//End AD4_UTENTISearchRow: constructor

//AD4_UTENTISearchRow: method(s) of s_TESTO @69-8A65CBD6
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

//AD4_UTENTISearchRow: method(s) of ID @70-2B895796
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

//AD4_UTENTISearchRow: method(s) of RICERCA @71-548D848A
    public TextField getRICERCAField() {
        return RICERCA;
    }

    public String getRICERCA() {
        return RICERCA.getValue();
    }

    public void setRICERCA(String value) {
        this.RICERCA.setValue(value);
    }
//End AD4_UTENTISearchRow: method(s) of RICERCA

//AD4_UTENTISearchRow: class tail @68-FCB6E20C
}
//End AD4_UTENTISearchRow: class tail


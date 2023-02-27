//AD4_SERVIZIO_SELRow: import @98-1F03BD27
package amvadm.AdmRichieste;

import java.util.*;
import com.codecharge.db.*;
//End AD4_SERVIZIO_SELRow: import

//AD4_SERVIZIO_SELRow: class head @98-4C252EDA
public class AD4_SERVIZIO_SELRow {
//End AD4_SERVIZIO_SELRow: class head

//AD4_SERVIZIO_SELRow: declare fiels @98-FD158202
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
//End AD4_SERVIZIO_SELRow: declare fiels

//AD4_SERVIZIO_SELRow: constructor @98-829A6975
    public AD4_SERVIZIO_SELRow() {
    }
//End AD4_SERVIZIO_SELRow: constructor

//AD4_SERVIZIO_SELRow: method(s) of SERVIZIO @99-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End AD4_SERVIZIO_SELRow: method(s) of SERVIZIO

//AD4_SERVIZIO_SELRow: class tail @98-FCB6E20C
}
//End AD4_SERVIZIO_SELRow: class tail


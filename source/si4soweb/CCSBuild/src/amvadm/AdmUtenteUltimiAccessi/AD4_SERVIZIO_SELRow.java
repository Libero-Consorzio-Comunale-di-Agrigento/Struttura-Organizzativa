//AD4_SERVIZIO_SELRow: import @23-DEFEAF47
package amvadm.AdmUtenteUltimiAccessi;

import java.util.*;
import com.codecharge.db.*;
//End AD4_SERVIZIO_SELRow: import

//AD4_SERVIZIO_SELRow: class head @23-4C252EDA
public class AD4_SERVIZIO_SELRow {
//End AD4_SERVIZIO_SELRow: class head

//AD4_SERVIZIO_SELRow: declare fiels @23-20920EA2
    private TextField DES_ACCESSO = new TextField("DES_ACCESSO", "DES_ACCESSO");
    private TextField DES_SERVIZIO = new TextField("DES_SERVIZIO", "DES_SERVIZIO");
//End AD4_SERVIZIO_SELRow: declare fiels

//AD4_SERVIZIO_SELRow: constructor @23-829A6975
    public AD4_SERVIZIO_SELRow() {
    }
//End AD4_SERVIZIO_SELRow: constructor

//AD4_SERVIZIO_SELRow: method(s) of DES_ACCESSO @28-BC13A282
    public TextField getDES_ACCESSOField() {
        return DES_ACCESSO;
    }

    public String getDES_ACCESSO() {
        return DES_ACCESSO.getValue();
    }

    public void setDES_ACCESSO(String value) {
        this.DES_ACCESSO.setValue(value);
    }
//End AD4_SERVIZIO_SELRow: method(s) of DES_ACCESSO

//AD4_SERVIZIO_SELRow: method(s) of DES_SERVIZIO @24-86A5B5EC
    public TextField getDES_SERVIZIOField() {
        return DES_SERVIZIO;
    }

    public String getDES_SERVIZIO() {
        return DES_SERVIZIO.getValue();
    }

    public void setDES_SERVIZIO(String value) {
        this.DES_SERVIZIO.setValue(value);
    }
//End AD4_SERVIZIO_SELRow: method(s) of DES_SERVIZIO

//AD4_SERVIZIO_SELRow: class tail @23-FCB6E20C
}
//End AD4_SERVIZIO_SELRow: class tail


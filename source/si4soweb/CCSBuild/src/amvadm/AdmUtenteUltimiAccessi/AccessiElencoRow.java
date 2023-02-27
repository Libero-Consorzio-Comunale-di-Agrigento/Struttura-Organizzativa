//AccessiElencoRow: import @6-DEFEAF47
package amvadm.AdmUtenteUltimiAccessi;

import java.util.*;
import com.codecharge.db.*;
//End AccessiElencoRow: import

//AccessiElencoRow: class head @6-15DF5D2B
public class AccessiElencoRow {
//End AccessiElencoRow: class head

//AccessiElencoRow: declare fiels @6-DC6D9D6C
    private TextField DES_ACCESSO = new TextField("DES_ACCESSO", "DES_ACCESSO");
    private TextField DES_SERVIZIO = new TextField("DES_SERVIZIO", "DES_SERVIZIO");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End AccessiElencoRow: declare fiels

//AccessiElencoRow: constructor @6-D9AFFEA5
    public AccessiElencoRow() {
    }
//End AccessiElencoRow: constructor

//AccessiElencoRow: method(s) of DES_ACCESSO @7-BC13A282
    public TextField getDES_ACCESSOField() {
        return DES_ACCESSO;
    }

    public String getDES_ACCESSO() {
        return DES_ACCESSO.getValue();
    }

    public void setDES_ACCESSO(String value) {
        this.DES_ACCESSO.setValue(value);
    }
//End AccessiElencoRow: method(s) of DES_ACCESSO

//AccessiElencoRow: method(s) of DES_SERVIZIO @8-86A5B5EC
    public TextField getDES_SERVIZIOField() {
        return DES_SERVIZIO;
    }

    public String getDES_SERVIZIO() {
        return DES_SERVIZIO.getValue();
    }

    public void setDES_SERVIZIO(String value) {
        this.DES_SERVIZIO.setValue(value);
    }
//End AccessiElencoRow: method(s) of DES_SERVIZIO

//AccessiElencoRow: method(s) of AFCNavigator @34-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AccessiElencoRow: method(s) of AFCNavigator

//AccessiElencoRow: class tail @6-FCB6E20C
}
//End AccessiElencoRow: class tail


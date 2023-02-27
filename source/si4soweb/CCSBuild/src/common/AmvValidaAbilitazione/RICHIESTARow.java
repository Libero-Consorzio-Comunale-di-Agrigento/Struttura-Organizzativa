//RICHIESTARow: import @22-57F6FA16
package common.AmvValidaAbilitazione;

import java.util.*;
import com.codecharge.db.*;
//End RICHIESTARow: import

//RICHIESTARow: class head @22-33A5EFEA
public class RICHIESTARow {
//End RICHIESTARow: class head

//RICHIESTARow: declare fiels @22-5A82CBC6
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
//End RICHIESTARow: declare fiels

//RICHIESTARow: constructor @22-BAFF8F03
    public RICHIESTARow() {
    }
//End RICHIESTARow: constructor

//RICHIESTARow: method(s) of NOMINATIVO @27-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End RICHIESTARow: method(s) of NOMINATIVO

//RICHIESTARow: method(s) of SERVIZIO @28-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End RICHIESTARow: method(s) of SERVIZIO

//RICHIESTARow: class tail @22-FCB6E20C
}
//End RICHIESTARow: class tail


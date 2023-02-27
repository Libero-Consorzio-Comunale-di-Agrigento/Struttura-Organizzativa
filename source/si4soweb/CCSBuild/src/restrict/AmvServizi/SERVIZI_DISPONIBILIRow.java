//SERVIZI_DISPONIBILIRow: import @17-BB438607
package restrict.AmvServizi;

import java.util.*;
import com.codecharge.db.*;
//End SERVIZI_DISPONIBILIRow: import

//SERVIZI_DISPONIBILIRow: class head @17-3AEA3A02
public class SERVIZI_DISPONIBILIRow {
//End SERVIZI_DISPONIBILIRow: class head

//SERVIZI_DISPONIBILIRow: declare fiels @17-152A701C
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField RICHIESTA = new TextField("RICHIESTA", "RICHIESTA");
//End SERVIZI_DISPONIBILIRow: declare fiels

//SERVIZI_DISPONIBILIRow: constructor @17-2B455B35
    public SERVIZI_DISPONIBILIRow() {
    }
//End SERVIZI_DISPONIBILIRow: constructor

//SERVIZI_DISPONIBILIRow: method(s) of SERVIZIO @-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of SERVIZIO

//SERVIZI_DISPONIBILIRow: method(s) of RICHIESTA @-8A5214D9
    public TextField getRICHIESTAField() {
        return RICHIESTA;
    }

    public String getRICHIESTA() {
        return RICHIESTA.getValue();
    }

    public void setRICHIESTA(String value) {
        this.RICHIESTA.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of RICHIESTA

//SERVIZI_DISPONIBILIRow: class tail @17-FCB6E20C
}
//End SERVIZI_DISPONIBILIRow: class tail


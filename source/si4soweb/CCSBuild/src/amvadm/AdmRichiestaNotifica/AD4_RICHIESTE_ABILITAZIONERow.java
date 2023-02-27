//AD4_RICHIESTE_ABILITAZIONERow: import @6-06A07F5D
package amvadm.AdmRichiestaNotifica;

import java.util.*;
import com.codecharge.db.*;
//End AD4_RICHIESTE_ABILITAZIONERow: import

//AD4_RICHIESTE_ABILITAZIONERow: class head @6-950869E7
public class AD4_RICHIESTE_ABILITAZIONERow {
//End AD4_RICHIESTE_ABILITAZIONERow: class head

//AD4_RICHIESTE_ABILITAZIONERow: declare fiels @6-22EC1920
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField TIPO_NOTIFICA = new TextField("TIPO_NOTIFICA", "TIPO_NOTIFICA");
    private TextField INDIRIZZO_NOTIFICA = new TextField("INDIRIZZO_NOTIFICA", "INDIRIZZO_NOTIFICA");
//End AD4_RICHIESTE_ABILITAZIONERow: declare fiels

//AD4_RICHIESTE_ABILITAZIONERow: constructor @6-56D91E9C
    public AD4_RICHIESTE_ABILITAZIONERow() {
    }
//End AD4_RICHIESTE_ABILITAZIONERow: constructor

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of SERVIZIO @7-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of SERVIZIO

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of TIPO_NOTIFICA @8-C59F1488
    public TextField getTIPO_NOTIFICAField() {
        return TIPO_NOTIFICA;
    }

    public String getTIPO_NOTIFICA() {
        return TIPO_NOTIFICA.getValue();
    }

    public void setTIPO_NOTIFICA(String value) {
        this.TIPO_NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of TIPO_NOTIFICA

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of INDIRIZZO_NOTIFICA @9-A4148738
    public TextField getINDIRIZZO_NOTIFICAField() {
        return INDIRIZZO_NOTIFICA;
    }

    public String getINDIRIZZO_NOTIFICA() {
        return INDIRIZZO_NOTIFICA.getValue();
    }

    public void setINDIRIZZO_NOTIFICA(String value) {
        this.INDIRIZZO_NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of INDIRIZZO_NOTIFICA

//AD4_RICHIESTE_ABILITAZIONERow: class tail @6-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONERow: class tail


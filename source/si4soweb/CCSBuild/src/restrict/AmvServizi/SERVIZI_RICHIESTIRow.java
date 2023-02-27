//SERVIZI_RICHIESTIRow: import @6-BB438607
package restrict.AmvServizi;

import java.util.*;
import com.codecharge.db.*;
//End SERVIZI_RICHIESTIRow: import

//SERVIZI_RICHIESTIRow: class head @6-C3B4554F
public class SERVIZI_RICHIESTIRow {
//End SERVIZI_RICHIESTIRow: class head

//SERVIZI_RICHIESTIRow: declare fiels @6-2B10131A
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private DateField DATA = new DateField("DATA", "DATA");
    private TextField NOTIFICA = new TextField("NOTIFICA", "NOTIFICA");
    private TextField AZIENDA = new TextField("AZIENDA", "AZIENDA");
//End SERVIZI_RICHIESTIRow: declare fiels

//SERVIZI_RICHIESTIRow: constructor @6-DCA8A892
    public SERVIZI_RICHIESTIRow() {
    }
//End SERVIZI_RICHIESTIRow: constructor

//SERVIZI_RICHIESTIRow: method(s) of SERVIZIO @-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of SERVIZIO

//SERVIZI_RICHIESTIRow: method(s) of DATA @-ABA0FD8B
    public DateField getDATAField() {
        return DATA;
    }

    public Date getDATA() {
        return DATA.getValue();
    }

    public void setDATA(Date value) {
        this.DATA.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of DATA

//SERVIZI_RICHIESTIRow: method(s) of NOTIFICA @-B4BB5F70
    public TextField getNOTIFICAField() {
        return NOTIFICA;
    }

    public String getNOTIFICA() {
        return NOTIFICA.getValue();
    }

    public void setNOTIFICA(String value) {
        this.NOTIFICA.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of NOTIFICA

//SERVIZI_RICHIESTIRow: method(s) of AZIENDA @-4D5AFBE6
    public TextField getAZIENDAField() {
        return AZIENDA;
    }

    public String getAZIENDA() {
        return AZIENDA.getValue();
    }

    public void setAZIENDA(String value) {
        this.AZIENDA.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of AZIENDA

//SERVIZI_RICHIESTIRow: class tail @6-FCB6E20C
}
//End SERVIZI_RICHIESTIRow: class tail


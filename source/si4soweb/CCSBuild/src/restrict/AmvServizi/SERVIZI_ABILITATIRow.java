//SERVIZI_ABILITATIRow: import @12-BB438607
package restrict.AmvServizi;

import java.util.*;
import com.codecharge.db.*;
//End SERVIZI_ABILITATIRow: import

//SERVIZI_ABILITATIRow: class head @12-10FF7FF9
public class SERVIZI_ABILITATIRow {
//End SERVIZI_ABILITATIRow: class head

//SERVIZI_ABILITATIRow: declare fiels @12-2B10131A
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private DateField DATA = new DateField("DATA", "DATA");
    private TextField NOTIFICA = new TextField("NOTIFICA", "NOTIFICA");
    private TextField AZIENDA = new TextField("AZIENDA", "AZIENDA");
//End SERVIZI_ABILITATIRow: declare fiels

//SERVIZI_ABILITATIRow: constructor @12-931E7ED3
    public SERVIZI_ABILITATIRow() {
    }
//End SERVIZI_ABILITATIRow: constructor

//SERVIZI_ABILITATIRow: method(s) of SERVIZIO @-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of SERVIZIO

//SERVIZI_ABILITATIRow: method(s) of DATA @-ABA0FD8B
    public DateField getDATAField() {
        return DATA;
    }

    public Date getDATA() {
        return DATA.getValue();
    }

    public void setDATA(Date value) {
        this.DATA.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of DATA

//SERVIZI_ABILITATIRow: method(s) of NOTIFICA @-B4BB5F70
    public TextField getNOTIFICAField() {
        return NOTIFICA;
    }

    public String getNOTIFICA() {
        return NOTIFICA.getValue();
    }

    public void setNOTIFICA(String value) {
        this.NOTIFICA.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of NOTIFICA

//SERVIZI_ABILITATIRow: method(s) of AZIENDA @-4D5AFBE6
    public TextField getAZIENDAField() {
        return AZIENDA;
    }

    public String getAZIENDA() {
        return AZIENDA.getValue();
    }

    public void setAZIENDA(String value) {
        this.AZIENDA.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of AZIENDA

//SERVIZI_ABILITATIRow: class tail @12-FCB6E20C
}
//End SERVIZI_ABILITATIRow: class tail


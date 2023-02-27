//copyrightRow: import @25-C8BF5C71
package restrict.AmvPreferenzeStile;

import java.util.*;
import com.codecharge.db.*;
//End copyrightRow: import

//copyrightRow: class head @25-6C173934
public class copyrightRow {
//End copyrightRow: class head

//copyrightRow: declare fiels @25-4710658A
    private TextField MESSAGGIO = new TextField("MESSAGGIO", "MESSAGGIO");
    private TextField STILE = new TextField("STILE", "STILE");
//End copyrightRow: declare fiels

//copyrightRow: constructor @25-CFE5275F
    public copyrightRow() {
    }
//End copyrightRow: constructor

//copyrightRow: method(s) of MESSAGGIO @26-11031E2E
    public TextField getMESSAGGIOField() {
        return MESSAGGIO;
    }

    public String getMESSAGGIO() {
        return MESSAGGIO.getValue();
    }

    public void setMESSAGGIO(String value) {
        this.MESSAGGIO.setValue(value);
    }
//End copyrightRow: method(s) of MESSAGGIO

//copyrightRow: method(s) of STILE @27-F6F780CF
    public TextField getSTILEField() {
        return STILE;
    }

    public String getSTILE() {
        return STILE.getValue();
    }

    public void setSTILE(String value) {
        this.STILE.setValue(value);
    }
//End copyrightRow: method(s) of STILE

//copyrightRow: class tail @25-FCB6E20C
}
//End copyrightRow: class tail


//copyrightRow: import @2-F72A04F0
package common.AmvFooter;

import java.util.*;
import com.codecharge.db.*;
//End copyrightRow: import

//copyrightRow: class head @2-6C173934
public class copyrightRow {
//End copyrightRow: class head

//copyrightRow: declare fiels @2-E33A6A07
    private TextField MESSAGGIO = new TextField("MESSAGGIO", "MESSAGGIO");
    private TextField MVDIRUPLOAD = new TextField("MVDIRUPLOAD", "MVDIRUPLOAD");
//End copyrightRow: declare fiels

//copyrightRow: constructor @2-CFE5275F
    public copyrightRow() {
    }
//End copyrightRow: constructor

//copyrightRow: method(s) of MESSAGGIO @3-11031E2E
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

//copyrightRow: method(s) of MVDIRUPLOAD @11-F2B923E5
    public TextField getMVDIRUPLOADField() {
        return MVDIRUPLOAD;
    }

    public String getMVDIRUPLOAD() {
        return MVDIRUPLOAD.getValue();
    }

    public void setMVDIRUPLOAD(String value) {
        this.MVDIRUPLOAD.setValue(value);
    }
//End copyrightRow: method(s) of MVDIRUPLOAD

//copyrightRow: class tail @2-FCB6E20C
}
//End copyrightRow: class tail


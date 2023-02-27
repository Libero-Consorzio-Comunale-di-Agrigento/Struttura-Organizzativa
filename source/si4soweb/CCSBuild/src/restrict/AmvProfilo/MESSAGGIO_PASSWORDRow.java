//MESSAGGIO_PASSWORDRow: import @42-EC145828
package restrict.AmvProfilo;

import java.util.*;
import com.codecharge.db.*;
//End MESSAGGIO_PASSWORDRow: import

//MESSAGGIO_PASSWORDRow: class head @42-6FADD34A
public class MESSAGGIO_PASSWORDRow {
//End MESSAGGIO_PASSWORDRow: class head

//MESSAGGIO_PASSWORDRow: declare fiels @42-18A6D74B
    private TextField MESSAGGIO = new TextField("MESSAGGIO", "MESSAGGIO");
//End MESSAGGIO_PASSWORDRow: declare fiels

//MESSAGGIO_PASSWORDRow: constructor @42-2A860B0F
    public MESSAGGIO_PASSWORDRow() {
    }
//End MESSAGGIO_PASSWORDRow: constructor

//MESSAGGIO_PASSWORDRow: method(s) of MESSAGGIO @43-11031E2E
    public TextField getMESSAGGIOField() {
        return MESSAGGIO;
    }

    public String getMESSAGGIO() {
        return MESSAGGIO.getValue();
    }

    public void setMESSAGGIO(String value) {
        this.MESSAGGIO.setValue(value);
    }
//End MESSAGGIO_PASSWORDRow: method(s) of MESSAGGIO

//MESSAGGIO_PASSWORDRow: class tail @42-FCB6E20C
}
//End MESSAGGIO_PASSWORDRow: class tail


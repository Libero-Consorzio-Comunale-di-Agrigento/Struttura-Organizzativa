//styleRow: import @2-7B29F11F
package common.AmvStyle;

import java.util.*;
import com.codecharge.db.*;
//End styleRow: import

//styleRow: class head @2-AB72F100
public class styleRow {
//End styleRow: class head

//styleRow: declare fiels @2-3BD53302
    private TextField STILE = new TextField("STILE", "STILE");
//End styleRow: declare fiels

//styleRow: constructor @2-95A1D564
    public styleRow() {
    }
//End styleRow: constructor

//styleRow: method(s) of STILE @4-F6F780CF
    public TextField getSTILEField() {
        return STILE;
    }

    public String getSTILE() {
        return STILE.getValue();
    }

    public void setSTILE(String value) {
        this.STILE.setValue(value);
    }
//End styleRow: method(s) of STILE

//styleRow: class tail @2-FCB6E20C
}
//End styleRow: class tail


//styleRow: import @3-8CD473A5
package restrict.AmvStili;

import java.util.*;
import com.codecharge.db.*;
//End styleRow: import

//styleRow: class head @3-AB72F100
public class styleRow {
//End styleRow: class head

//styleRow: declare fiels @3-3BD53302
    private TextField STILE = new TextField("STILE", "STILE");
//End styleRow: declare fiels

//styleRow: constructor @3-95A1D564
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

//styleRow: class tail @3-FCB6E20C
}
//End styleRow: class tail


//AGENTERow: import @3-020BAFC7
package common.Footer;

import java.util.*;
import com.codecharge.db.*;
//End AGENTERow: import

//AGENTERow: class head @3-45A3F77F
public class AGENTERow {
//End AGENTERow: class head

//AGENTERow: declare fiels @3-AF389804
    private TextField AGENTE_ID = new TextField("AGENTE_ID", "AGENTE_ID");
//End AGENTERow: declare fiels

//AGENTERow: constructor @3-892E9ADE
    public AGENTERow() {
    }
//End AGENTERow: constructor

//AGENTERow: method(s) of AGENTE_ID @4-3D820996
    public TextField getAGENTE_IDField() {
        return AGENTE_ID;
    }

    public String getAGENTE_ID() {
        return AGENTE_ID.getValue();
    }

    public void setAGENTE_ID(String value) {
        this.AGENTE_ID.setValue(value);
    }
//End AGENTERow: method(s) of AGENTE_ID

//AGENTERow: class tail @3-FCB6E20C
}
//End AGENTERow: class tail


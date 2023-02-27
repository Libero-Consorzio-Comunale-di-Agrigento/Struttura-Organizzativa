//AD4_UTENTIRow: import @59-42702442
package amvadm.AdmUtenteGruppi;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @59-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @59-A78B8B83
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField DATA_PASSWORD = new TextField("DATA_PASSWORD", "DATA_PASSWORD");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @59-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOMINATIVO @-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NOMINATIVO

//AD4_UTENTIRow: method(s) of DATA_PASSWORD @-0483A8D6
    public TextField getDATA_PASSWORDField() {
        return DATA_PASSWORD;
    }

    public String getDATA_PASSWORD() {
        return DATA_PASSWORD.getValue();
    }

    public void setDATA_PASSWORD(String value) {
        this.DATA_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DATA_PASSWORD

//AD4_UTENTIRow: class tail @59-FCB6E20C
}
//End AD4_UTENTIRow: class tail


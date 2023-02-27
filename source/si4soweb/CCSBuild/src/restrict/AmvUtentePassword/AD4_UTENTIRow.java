//AD4_UTENTIRow: import @6-D74211B1
package restrict.AmvUtentePassword;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @6-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @6-E7EFF2D6
    private TextField PASSWORD_ATTUALE = new TextField("PASSWORD_ATTUALE", "");
    private TextField NUOVA_PASSWORD = new TextField("NUOVA_PASSWORD", "");
    private TextField CONFERMA_PASSWORD = new TextField("CONFERMA_PASSWORD", "");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @6-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of PASSWORD_ATTUALE @22-E7517D4E
    public TextField getPASSWORD_ATTUALEField() {
        return PASSWORD_ATTUALE;
    }

    public String getPASSWORD_ATTUALE() {
        return PASSWORD_ATTUALE.getValue();
    }

    public void setPASSWORD_ATTUALE(String value) {
        this.PASSWORD_ATTUALE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of PASSWORD_ATTUALE

//AD4_UTENTIRow: method(s) of NUOVA_PASSWORD @23-B45767BC
    public TextField getNUOVA_PASSWORDField() {
        return NUOVA_PASSWORD;
    }

    public String getNUOVA_PASSWORD() {
        return NUOVA_PASSWORD.getValue();
    }

    public void setNUOVA_PASSWORD(String value) {
        this.NUOVA_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NUOVA_PASSWORD

//AD4_UTENTIRow: method(s) of CONFERMA_PASSWORD @24-31D97D57
    public TextField getCONFERMA_PASSWORDField() {
        return CONFERMA_PASSWORD;
    }

    public String getCONFERMA_PASSWORD() {
        return CONFERMA_PASSWORD.getValue();
    }

    public void setCONFERMA_PASSWORD(String value) {
        this.CONFERMA_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of CONFERMA_PASSWORD

//AD4_UTENTIRow: class tail @6-FCB6E20C
}
//End AD4_UTENTIRow: class tail


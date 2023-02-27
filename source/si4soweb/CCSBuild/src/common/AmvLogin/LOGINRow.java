//LOGINRow: import @2-FFA1893A
package common.AmvLogin;

import java.util.*;
import com.codecharge.db.*;
//End LOGINRow: import

//LOGINRow: class head @2-9B71E5B7
public class LOGINRow {
//End LOGINRow: class head

//LOGINRow: declare fiels @2-67E73052
    private TextField ERRORE = new TextField("ERRORE", "ERRORE");
    private TextField j_username = new TextField("j_username", "");
    private TextField j_password = new TextField("j_password", "");
    private TextField LOSTMSG = new TextField("LOSTMSG", "LOSTMSG");
//End LOGINRow: declare fiels

//LOGINRow: constructor @2-E217BB2E
    public LOGINRow() {
    }
//End LOGINRow: constructor

//LOGINRow: method(s) of ERRORE @3-F2CEF8C4
    public TextField getERROREField() {
        return ERRORE;
    }

    public String getERRORE() {
        return ERRORE.getValue();
    }

    public void setERRORE(String value) {
        this.ERRORE.setValue(value);
    }
//End LOGINRow: method(s) of ERRORE

//LOGINRow: method(s) of j_username @4-1F8AC4A2
    public TextField getJ_usernameField() {
        return j_username;
    }

    public String getJ_username() {
        return j_username.getValue();
    }

    public void setJ_username(String value) {
        this.j_username.setValue(value);
    }
//End LOGINRow: method(s) of j_username

//LOGINRow: method(s) of j_password @5-24A0A0C4
    public TextField getJ_passwordField() {
        return j_password;
    }

    public String getJ_password() {
        return j_password.getValue();
    }

    public void setJ_password(String value) {
        this.j_password.setValue(value);
    }
//End LOGINRow: method(s) of j_password

//LOGINRow: method(s) of LOSTMSG @12-F4C2C624
    public TextField getLOSTMSGField() {
        return LOSTMSG;
    }

    public String getLOSTMSG() {
        return LOSTMSG.getValue();
    }

    public void setLOSTMSG(String value) {
        this.LOSTMSG.setValue(value);
    }
//End LOGINRow: method(s) of LOSTMSG

//LOGINRow: class tail @2-FCB6E20C
}
//End LOGINRow: class tail


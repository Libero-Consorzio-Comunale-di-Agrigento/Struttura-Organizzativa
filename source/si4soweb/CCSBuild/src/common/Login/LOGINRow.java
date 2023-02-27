//LOGINRow: import @6-D1CEE96D
package common.Login;

import java.util.*;
import com.codecharge.db.*;
//End LOGINRow: import

//LOGINRow: class head @6-9B71E5B7
public class LOGINRow {
//End LOGINRow: class head

//LOGINRow: declare fiels @6-846D875B
    private TextField ERRORE = new TextField("ERRORE", "ERRORE");
    private TextField j_username = new TextField("j_username", "");
    private TextField j_password = new TextField("j_password", "");
//End LOGINRow: declare fiels

//LOGINRow: constructor @6-E217BB2E
    public LOGINRow() {
    }
//End LOGINRow: constructor

//LOGINRow: method(s) of ERRORE @-F2CEF8C4
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

//LOGINRow: method(s) of j_username @-1F8AC4A2
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

//LOGINRow: method(s) of j_password @-24A0A0C4
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

//LOGINRow: class tail @6-FCB6E20C
}
//End LOGINRow: class tail


//REDIRECT_TAGRow: import @2-BEEE808D
package common.AmvRedirect;

import java.util.*;
import com.codecharge.db.*;
//End REDIRECT_TAGRow: import

//REDIRECT_TAGRow: class head @2-2C9AC767
public class REDIRECT_TAGRow {
//End REDIRECT_TAGRow: class head

//REDIRECT_TAGRow: declare fiels @2-E430B702
    private TextField Redirection = new TextField("Redirection", "REDIRECT");
//End REDIRECT_TAGRow: declare fiels

//REDIRECT_TAGRow: constructor @2-933536D3
    public REDIRECT_TAGRow() {
    }
//End REDIRECT_TAGRow: constructor

//REDIRECT_TAGRow: method(s) of Redirection @3-D2FF4D3F
    public TextField getRedirectionField() {
        return Redirection;
    }

    public String getRedirection() {
        return Redirection.getValue();
    }

    public void setRedirection(String value) {
        this.Redirection.setValue(value);
    }
//End REDIRECT_TAGRow: method(s) of Redirection

//REDIRECT_TAGRow: class tail @2-FCB6E20C
}
//End REDIRECT_TAGRow: class tail


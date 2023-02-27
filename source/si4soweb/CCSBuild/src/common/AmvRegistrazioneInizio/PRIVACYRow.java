//PRIVACYRow: import @114-6FE36575
package common.AmvRegistrazioneInizio;

import java.util.*;
import com.codecharge.db.*;
//End PRIVACYRow: import

//PRIVACYRow: class head @114-1A11FC93
public class PRIVACYRow {
//End PRIVACYRow: class head

//PRIVACYRow: declare fiels @114-6F951316
    private TextField PRIVACY = new TextField("PRIVACY", "PRIVACY");
//End PRIVACYRow: declare fiels

//PRIVACYRow: constructor @114-2CA59AAA
    public PRIVACYRow() {
    }
//End PRIVACYRow: constructor

//PRIVACYRow: method(s) of PRIVACY @115-BB0AEF36
    public TextField getPRIVACYField() {
        return PRIVACY;
    }

    public String getPRIVACY() {
        return PRIVACY.getValue();
    }

    public void setPRIVACY(String value) {
        this.PRIVACY.setValue(value);
    }
//End PRIVACYRow: method(s) of PRIVACY

//PRIVACYRow: class tail @114-FCB6E20C
}
//End PRIVACYRow: class tail


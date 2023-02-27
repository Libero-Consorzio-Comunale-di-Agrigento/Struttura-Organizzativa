//ACCESSORow: import @3-DC84B7B5
package common.AmvAccessControl;

import java.util.*;
import com.codecharge.db.*;
//End ACCESSORow: import

//ACCESSORow: class head @3-C6285C46
public class ACCESSORow {
//End ACCESSORow: class head

//ACCESSORow: declare fiels @3-5B6082A0
    private TextField VOCE = new TextField("VOCE", "VOCE");
//End ACCESSORow: declare fiels

//ACCESSORow: constructor @3-56E5594C
    public ACCESSORow() {
    }
//End ACCESSORow: constructor

//ACCESSORow: method(s) of VOCE @4-202F88FE
    public TextField getVOCEField() {
        return VOCE;
    }

    public String getVOCE() {
        return VOCE.getValue();
    }

    public void setVOCE(String value) {
        this.VOCE.setValue(value);
    }
//End ACCESSORow: method(s) of VOCE

//ACCESSORow: class tail @3-FCB6E20C
}
//End ACCESSORow: class tail


//AD4_DIRITTI_ACCESSORow: import @22-5FBCA610
package restrict.AmvAccessi;

import java.util.*;
import com.codecharge.db.*;
//End AD4_DIRITTI_ACCESSORow: import

//AD4_DIRITTI_ACCESSORow: class head @22-A706698E
public class AD4_DIRITTI_ACCESSORow {
//End AD4_DIRITTI_ACCESSORow: class head

//AD4_DIRITTI_ACCESSORow: declare fiels @22-7A457FC2
    private TextField DES_SERVIZIO = new TextField("DES_SERVIZIO", "DES_SERVIZIO");
    private TextField DSP_ACCESSO = new TextField("DSP_ACCESSO", "DSP_ACCESSO");
    private TextField DSP_NOTE = new TextField("DSP_NOTE", "DSP_NOTE");
//End AD4_DIRITTI_ACCESSORow: declare fiels

//AD4_DIRITTI_ACCESSORow: constructor @22-FB401988
    public AD4_DIRITTI_ACCESSORow() {
    }
//End AD4_DIRITTI_ACCESSORow: constructor

//AD4_DIRITTI_ACCESSORow: method(s) of DES_SERVIZIO @24-86A5B5EC
    public TextField getDES_SERVIZIOField() {
        return DES_SERVIZIO;
    }

    public String getDES_SERVIZIO() {
        return DES_SERVIZIO.getValue();
    }

    public void setDES_SERVIZIO(String value) {
        this.DES_SERVIZIO.setValue(value);
    }
//End AD4_DIRITTI_ACCESSORow: method(s) of DES_SERVIZIO

//AD4_DIRITTI_ACCESSORow: method(s) of DSP_ACCESSO @29-A6A20C5F
    public TextField getDSP_ACCESSOField() {
        return DSP_ACCESSO;
    }

    public String getDSP_ACCESSO() {
        return DSP_ACCESSO.getValue();
    }

    public void setDSP_ACCESSO(String value) {
        this.DSP_ACCESSO.setValue(value);
    }
//End AD4_DIRITTI_ACCESSORow: method(s) of DSP_ACCESSO

//AD4_DIRITTI_ACCESSORow: method(s) of DSP_NOTE @34-083535B7
    public TextField getDSP_NOTEField() {
        return DSP_NOTE;
    }

    public String getDSP_NOTE() {
        return DSP_NOTE.getValue();
    }

    public void setDSP_NOTE(String value) {
        this.DSP_NOTE.setValue(value);
    }
//End AD4_DIRITTI_ACCESSORow: method(s) of DSP_NOTE

//AD4_DIRITTI_ACCESSORow: class tail @22-FCB6E20C
}
//End AD4_DIRITTI_ACCESSORow: class tail


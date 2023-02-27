//RuoloRow: import @6-09534DEE
package amvadm.AdmMenu;

import java.util.*;
import com.codecharge.db.*;
//End RuoloRow: import

//RuoloRow: class head @6-BCECD62B
public class RuoloRow {
//End RuoloRow: class head

//RuoloRow: declare fiels @6-BC30A94E
    private TextField SP = new TextField("SP", "PROGETTO_SEL");
    private TextField SM = new TextField("SM", "MODULO_SEL");
    private TextField SR = new TextField("SR", "RUOLO_SEL");
//End RuoloRow: declare fiels

//RuoloRow: constructor @6-6CCB7054
    public RuoloRow() {
    }
//End RuoloRow: constructor

//RuoloRow: method(s) of SP @150-EA591783
    public TextField getSPField() {
        return SP;
    }

    public String getSP() {
        return SP.getValue();
    }

    public void setSP(String value) {
        this.SP.setValue(value);
    }
//End RuoloRow: method(s) of SP

//RuoloRow: method(s) of SM @7-F0BA6F30
    public TextField getSMField() {
        return SM;
    }

    public String getSM() {
        return SM.getValue();
    }

    public void setSM(String value) {
        this.SM.setValue(value);
    }
//End RuoloRow: method(s) of SM

//RuoloRow: method(s) of SR @10-6F199125
    public TextField getSRField() {
        return SR;
    }

    public String getSR() {
        return SR.getValue();
    }

    public void setSR(String value) {
        this.SR.setValue(value);
    }
//End RuoloRow: method(s) of SR

//RuoloRow: class tail @6-FCB6E20C
}
//End RuoloRow: class tail


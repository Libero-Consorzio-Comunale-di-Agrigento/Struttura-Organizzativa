//welcomeRow: import @19-B1E9099D
package common.AmvHeader;

import java.util.*;
import com.codecharge.db.*;
//End welcomeRow: import

//welcomeRow: class head @19-FC271673
public class welcomeRow {
//End welcomeRow: class head

//welcomeRow: declare fiels @19-DC9B08C8
    private TextField INTESTAZIONE = new TextField("INTESTAZIONE", "INTESTAZIONE");
    private TextField MESSAGGIO = new TextField("MESSAGGIO", "MESSAGGIO");
    private TextField OGGI = new TextField("OGGI", "OGGI");
    private TextField NOTE = new TextField("NOTE", "NOTE");
    private TextField NEW_MSG = new TextField("NEW_MSG", "NUOVI_MSG");
//End welcomeRow: declare fiels

//welcomeRow: constructor @19-EE6CC413
    public welcomeRow() {
    }
//End welcomeRow: constructor

//welcomeRow: method(s) of INTESTAZIONE @61-FDC49E10
    public TextField getINTESTAZIONEField() {
        return INTESTAZIONE;
    }

    public String getINTESTAZIONE() {
        return INTESTAZIONE.getValue();
    }

    public void setINTESTAZIONE(String value) {
        this.INTESTAZIONE.setValue(value);
    }
//End welcomeRow: method(s) of INTESTAZIONE

//welcomeRow: method(s) of MESSAGGIO @20-11031E2E
    public TextField getMESSAGGIOField() {
        return MESSAGGIO;
    }

    public String getMESSAGGIO() {
        return MESSAGGIO.getValue();
    }

    public void setMESSAGGIO(String value) {
        this.MESSAGGIO.setValue(value);
    }
//End welcomeRow: method(s) of MESSAGGIO

//welcomeRow: method(s) of OGGI @21-B3E450ED
    public TextField getOGGIField() {
        return OGGI;
    }

    public String getOGGI() {
        return OGGI.getValue();
    }

    public void setOGGI(String value) {
        this.OGGI.setValue(value);
    }
//End welcomeRow: method(s) of OGGI

//welcomeRow: method(s) of NOTE @22-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End welcomeRow: method(s) of NOTE

//welcomeRow: method(s) of NEW_MSG @27-5737D5A1
    public TextField getNEW_MSGField() {
        return NEW_MSG;
    }

    public String getNEW_MSG() {
        return NEW_MSG.getValue();
    }

    public void setNEW_MSG(String value) {
        this.NEW_MSG.setValue(value);
    }
//End welcomeRow: method(s) of NEW_MSG

//welcomeRow: class tail @19-FCB6E20C
}
//End welcomeRow: class tail


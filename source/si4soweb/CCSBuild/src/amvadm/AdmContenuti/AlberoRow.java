//AlberoRow: import @6-D520F1F0
package amvadm.AdmContenuti;

import java.util.*;
import com.codecharge.db.*;
//End AlberoRow: import

//AlberoRow: class head @6-218A3CA6
public class AlberoRow {
//End AlberoRow: class head

//AlberoRow: declare fiels @6-EC77E6F9
    private TextField MENU = new TextField("MENU", "TABELLA");
//End AlberoRow: declare fiels

//AlberoRow: constructor @6-61CA02EC
    public AlberoRow() {
    }
//End AlberoRow: constructor

//AlberoRow: method(s) of MENU @7-C7B0370E
    public TextField getMENUField() {
        return MENU;
    }

    public String getMENU() {
        return MENU.getValue();
    }

    public void setMENU(String value) {
        this.MENU.setValue(value);
    }
//End AlberoRow: method(s) of MENU

//AlberoRow: class tail @6-FCB6E20C
}
//End AlberoRow: class tail


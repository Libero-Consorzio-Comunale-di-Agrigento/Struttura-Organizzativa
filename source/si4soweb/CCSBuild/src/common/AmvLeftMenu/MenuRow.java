//MenuRow: import @103-9DFF6BBC
package common.AmvLeftMenu;

import java.util.*;
import com.codecharge.db.*;
//End MenuRow: import

//MenuRow: class head @103-44895A3E
public class MenuRow {
//End MenuRow: class head

//MenuRow: declare fiels @103-EC77E6F9
    private TextField MENU = new TextField("MENU", "TABELLA");
//End MenuRow: declare fiels

//MenuRow: constructor @103-7E22A52B
    public MenuRow() {
    }
//End MenuRow: constructor

//MenuRow: method(s) of MENU @104-C7B0370E
    public TextField getMENUField() {
        return MENU;
    }

    public String getMENU() {
        return MENU.getValue();
    }

    public void setMENU(String value) {
        this.MENU.setValue(value);
    }
//End MenuRow: method(s) of MENU

//MenuRow: class tail @103-FCB6E20C
}
//End MenuRow: class tail


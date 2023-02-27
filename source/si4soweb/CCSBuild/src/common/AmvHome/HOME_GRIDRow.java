//HOME_GRIDRow: import @2-D0765539
package common.AmvHome;

import java.util.*;
import com.codecharge.db.*;
//End HOME_GRIDRow: import

//HOME_GRIDRow: class head @2-B9688347
public class HOME_GRIDRow {
//End HOME_GRIDRow: class head

//HOME_GRIDRow: declare fiels @2-C5C7B58F
    private TextField HOME = new TextField("HOME", "HOME");
//End HOME_GRIDRow: declare fiels

//HOME_GRIDRow: constructor @2-47C2DB1C
    public HOME_GRIDRow() {
    }
//End HOME_GRIDRow: constructor

//HOME_GRIDRow: method(s) of HOME @3-0C0F5036
    public TextField getHOMEField() {
        return HOME;
    }

    public String getHOME() {
        return HOME.getValue();
    }

    public void setHOME(String value) {
        this.HOME.setValue(value);
    }
//End HOME_GRIDRow: method(s) of HOME

//HOME_GRIDRow: class tail @2-FCB6E20C
}
//End HOME_GRIDRow: class tail


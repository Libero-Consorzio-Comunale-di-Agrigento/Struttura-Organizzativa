//LOGORow: import @41-B1E9099D
package common.AmvHeader;

import java.util.*;
import com.codecharge.db.*;
//End LOGORow: import

//LOGORow: class head @41-28DCC8AB
public class LOGORow {
//End LOGORow: class head

//LOGORow: declare fiels @41-6A1B9C09
    private TextField LOGO = new TextField("LOGO", "LOGO");
    private TextField LOGO_HREF = new TextField("LOGO_HREF", "LOGO_HREF");
//End LOGORow: declare fiels

//LOGORow: constructor @41-DD8C92BF
    public LOGORow() {
    }
//End LOGORow: constructor

//LOGORow: method(s) of LOGO @42-B1A9EC57
    public TextField getLOGOField() {
        return LOGO;
    }

    public String getLOGO() {
        return LOGO.getValue();
    }

    public void setLOGO(String value) {
        this.LOGO.setValue(value);
    }
//End LOGORow: method(s) of LOGO

//LOGORow: method(s) of LOGO_HREF @LOGO_HREF-C9BD762C
    public TextField getLOGO_HREFField() {
        return LOGO_HREF;
    }

    public String getLOGO_HREF() {
        return LOGO_HREF.getValue();
    }

    public void setLOGO_HREF(String value) {
        this.LOGO_HREF.setValue(value);
    }
//End LOGORow: method(s) of LOGO_HREF

//LOGORow: class tail @41-FCB6E20C
}
//End LOGORow: class tail


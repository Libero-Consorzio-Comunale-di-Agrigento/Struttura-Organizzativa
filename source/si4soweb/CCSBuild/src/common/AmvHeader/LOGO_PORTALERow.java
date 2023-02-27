//LOGO_PORTALERow: import @43-B1E9099D
package common.AmvHeader;

import java.util.*;
import com.codecharge.db.*;
//End LOGO_PORTALERow: import

//LOGO_PORTALERow: class head @43-D74E97A0
public class LOGO_PORTALERow {
//End LOGO_PORTALERow: class head

//LOGO_PORTALERow: declare fiels @43-B8A299E3
    private TextField LOGO_PORTALE = new TextField("LOGO_PORTALE", "LOGO_PORTALE");
    private TextField LOGO_PORTALE_HREF = new TextField("LOGO_PORTALE_HREF", "LOGO_PORTALE_HREF");
//End LOGO_PORTALERow: declare fiels

//LOGO_PORTALERow: constructor @43-3CD0FD74
    public LOGO_PORTALERow() {
    }
//End LOGO_PORTALERow: constructor

//LOGO_PORTALERow: method(s) of LOGO_PORTALE @44-D470D02D
    public TextField getLOGO_PORTALEField() {
        return LOGO_PORTALE;
    }

    public String getLOGO_PORTALE() {
        return LOGO_PORTALE.getValue();
    }

    public void setLOGO_PORTALE(String value) {
        this.LOGO_PORTALE.setValue(value);
    }
//End LOGO_PORTALERow: method(s) of LOGO_PORTALE

//LOGO_PORTALERow: method(s) of LOGO_PORTALE_HREF @LOGO_PORTALE_HREF-7D6546A4
    public TextField getLOGO_PORTALE_HREFField() {
        return LOGO_PORTALE_HREF;
    }

    public String getLOGO_PORTALE_HREF() {
        return LOGO_PORTALE_HREF.getValue();
    }

    public void setLOGO_PORTALE_HREF(String value) {
        this.LOGO_PORTALE_HREF.setValue(value);
    }
//End LOGO_PORTALERow: method(s) of LOGO_PORTALE_HREF

//LOGO_PORTALERow: class tail @43-FCB6E20C
}
//End LOGO_PORTALERow: class tail


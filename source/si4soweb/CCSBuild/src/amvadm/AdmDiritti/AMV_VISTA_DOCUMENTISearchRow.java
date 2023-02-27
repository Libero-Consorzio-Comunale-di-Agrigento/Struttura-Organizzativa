//AMV_VISTA_DOCUMENTISearchRow: import @31-0C73CB51
package amvadm.AdmDiritti;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTISearchRow: import

//AMV_VISTA_DOCUMENTISearchRow: class head @31-C6175280
public class AMV_VISTA_DOCUMENTISearchRow {
//End AMV_VISTA_DOCUMENTISearchRow: class head

//AMV_VISTA_DOCUMENTISearchRow: declare fiels @31-79AD3A02
    private LongField s_AREA = new LongField("s_AREA", "AREA");
    private TextField s_GRUPPO = new TextField("s_GRUPPO", "GRUPPO");
    private TextField s_DISPLAY = new TextField("s_DISPLAY", "");
//End AMV_VISTA_DOCUMENTISearchRow: declare fiels

//AMV_VISTA_DOCUMENTISearchRow: constructor @31-F5225B22
    public AMV_VISTA_DOCUMENTISearchRow() {
    }
//End AMV_VISTA_DOCUMENTISearchRow: constructor

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_AREA @47-C2FAE919
    public LongField getS_AREAField() {
        return s_AREA;
    }

    public Long getS_AREA() {
        return s_AREA.getValue();
    }

    public void setS_AREA(Long value) {
        this.s_AREA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_AREA

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_GRUPPO @45-CBB850D0
    public TextField getS_GRUPPOField() {
        return s_GRUPPO;
    }

    public String getS_GRUPPO() {
        return s_GRUPPO.getValue();
    }

    public void setS_GRUPPO(String value) {
        this.s_GRUPPO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_GRUPPO

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_DISPLAY @34-CC538B96
    public TextField getS_DISPLAYField() {
        return s_DISPLAY;
    }

    public String getS_DISPLAY() {
        return s_DISPLAY.getValue();
    }

    public void setS_DISPLAY(String value) {
        this.s_DISPLAY.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_DISPLAY

//AMV_VISTA_DOCUMENTISearchRow: class tail @31-FCB6E20C
}
//End AMV_VISTA_DOCUMENTISearchRow: class tail


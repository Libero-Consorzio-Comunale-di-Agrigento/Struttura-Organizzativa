//AMV_DIRITTI1Row: import @15-0C73CB51
package amvadm.AdmDiritti;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DIRITTI1Row: import

//AMV_DIRITTI1Row: class head @15-04B51E35
public class AMV_DIRITTI1Row {
//End AMV_DIRITTI1Row: class head

//AMV_DIRITTI1Row: declare fiels @15-5A86B825
    private LongField ID_AREA = new LongField("ID_AREA", "ID_AREA");
    private LongField ID_TIPOLOGIA = new LongField("ID_TIPOLOGIA", "ID_TIPOLOGIA");
    private TextField GRUPPO = new TextField("GRUPPO", "GRUPPO");
    private TextField ACCESSO = new TextField("ACCESSO", "ACCESSO");
    private LongField ID_DIRITTO = new LongField("ID_DIRITTO", "ID_DIRITTO");
//End AMV_DIRITTI1Row: declare fiels

//AMV_DIRITTI1Row: constructor @15-07268F2A
    public AMV_DIRITTI1Row() {
    }
//End AMV_DIRITTI1Row: constructor

//AMV_DIRITTI1Row: method(s) of ID_AREA @22-0DE84566
    public LongField getID_AREAField() {
        return ID_AREA;
    }

    public Long getID_AREA() {
        return ID_AREA.getValue();
    }

    public void setID_AREA(Long value) {
        this.ID_AREA.setValue(value);
    }
//End AMV_DIRITTI1Row: method(s) of ID_AREA

//AMV_DIRITTI1Row: method(s) of ID_TIPOLOGIA @25-1DBA51EF
    public LongField getID_TIPOLOGIAField() {
        return ID_TIPOLOGIA;
    }

    public Long getID_TIPOLOGIA() {
        return ID_TIPOLOGIA.getValue();
    }

    public void setID_TIPOLOGIA(Long value) {
        this.ID_TIPOLOGIA.setValue(value);
    }
//End AMV_DIRITTI1Row: method(s) of ID_TIPOLOGIA

//AMV_DIRITTI1Row: method(s) of GRUPPO @23-C886BC8A
    public TextField getGRUPPOField() {
        return GRUPPO;
    }

    public String getGRUPPO() {
        return GRUPPO.getValue();
    }

    public void setGRUPPO(String value) {
        this.GRUPPO.setValue(value);
    }
//End AMV_DIRITTI1Row: method(s) of GRUPPO

//AMV_DIRITTI1Row: method(s) of ACCESSO @24-EBD40B8B
    public TextField getACCESSOField() {
        return ACCESSO;
    }

    public String getACCESSO() {
        return ACCESSO.getValue();
    }

    public void setACCESSO(String value) {
        this.ACCESSO.setValue(value);
    }
//End AMV_DIRITTI1Row: method(s) of ACCESSO

//AMV_DIRITTI1Row: method(s) of ID_DIRITTO @21-156E6224
    public LongField getID_DIRITTOField() {
        return ID_DIRITTO;
    }

    public Long getID_DIRITTO() {
        return ID_DIRITTO.getValue();
    }

    public void setID_DIRITTO(Long value) {
        this.ID_DIRITTO.setValue(value);
    }
//End AMV_DIRITTI1Row: method(s) of ID_DIRITTO

//AMV_DIRITTI1Row: class tail @15-FCB6E20C
}
//End AMV_DIRITTI1Row: class tail


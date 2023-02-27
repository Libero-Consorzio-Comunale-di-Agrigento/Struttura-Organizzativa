//AMV_DIRITTIRow: import @6-59D94448
package restrict.AmvAccessiAreeDoc;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DIRITTIRow: import

//AMV_DIRITTIRow: class head @6-EFDFAA87
public class AMV_DIRITTIRow {
//End AMV_DIRITTIRow: class head

//AMV_DIRITTIRow: declare fiels @6-EB22CC4D
    private TextField AREA = new TextField("AREA", "AREA");
    private TextField TIPOLOGIA = new TextField("TIPOLOGIA", "TIPOLOGIA");
    private TextField DES_ACCESSO = new TextField("DES_ACCESSO", "DES_ACCESSO");
    private TextField GRUPPO = new TextField("GRUPPO", "GRUPPO");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End AMV_DIRITTIRow: declare fiels

//AMV_DIRITTIRow: constructor @6-E5493237
    public AMV_DIRITTIRow() {
    }
//End AMV_DIRITTIRow: constructor

//AMV_DIRITTIRow: method(s) of AREA @7-6BE433B2
    public TextField getAREAField() {
        return AREA;
    }

    public String getAREA() {
        return AREA.getValue();
    }

    public void setAREA(String value) {
        this.AREA.setValue(value);
    }
//End AMV_DIRITTIRow: method(s) of AREA

//AMV_DIRITTIRow: method(s) of TIPOLOGIA @10-6E0C9A0A
    public TextField getTIPOLOGIAField() {
        return TIPOLOGIA;
    }

    public String getTIPOLOGIA() {
        return TIPOLOGIA.getValue();
    }

    public void setTIPOLOGIA(String value) {
        this.TIPOLOGIA.setValue(value);
    }
//End AMV_DIRITTIRow: method(s) of TIPOLOGIA

//AMV_DIRITTIRow: method(s) of DES_ACCESSO @11-BC13A282
    public TextField getDES_ACCESSOField() {
        return DES_ACCESSO;
    }

    public String getDES_ACCESSO() {
        return DES_ACCESSO.getValue();
    }

    public void setDES_ACCESSO(String value) {
        this.DES_ACCESSO.setValue(value);
    }
//End AMV_DIRITTIRow: method(s) of DES_ACCESSO

//AMV_DIRITTIRow: method(s) of GRUPPO @8-C886BC8A
    public TextField getGRUPPOField() {
        return GRUPPO;
    }

    public String getGRUPPO() {
        return GRUPPO.getValue();
    }

    public void setGRUPPO(String value) {
        this.GRUPPO.setValue(value);
    }
//End AMV_DIRITTIRow: method(s) of GRUPPO

//AMV_DIRITTIRow: method(s) of AFCNavigator @12-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_DIRITTIRow: method(s) of AFCNavigator

//AMV_DIRITTIRow: class tail @6-FCB6E20C
}
//End AMV_DIRITTIRow: class tail


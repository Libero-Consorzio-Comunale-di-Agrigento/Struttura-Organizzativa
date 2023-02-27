//AD4_UTENTIRow: import @5-AEE82053
package amvadm.AdmGruppiElenco;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @5-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @5-AC106EA3
    private TextField NOME_GRUPPO = new TextField("NOME_GRUPPO", "NOME_GRUPPO");
    private TextField DIRITTI = new TextField("DIRITTI", "DIRITTI");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField IDUTE = new TextField("IDUTE", "GRUPPO");
    private TextField GRUPPO = new TextField("GRUPPO", "GRUPPO");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @5-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOME_GRUPPO @32-05B32D39
    public TextField getNOME_GRUPPOField() {
        return NOME_GRUPPO;
    }

    public String getNOME_GRUPPO() {
        return NOME_GRUPPO.getValue();
    }

    public void setNOME_GRUPPO(String value) {
        this.NOME_GRUPPO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NOME_GRUPPO

//AD4_UTENTIRow: method(s) of DIRITTI @69-546C156D
    public TextField getDIRITTIField() {
        return DIRITTI;
    }

    public String getDIRITTI() {
        return DIRITTI.getValue();
    }

    public void setDIRITTI(String value) {
        this.DIRITTI.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DIRITTI

//AD4_UTENTIRow: method(s) of AFCNavigator @72-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of AFCNavigator

//AD4_UTENTIRow: method(s) of IDUTE @47-76C50423
    public TextField getIDUTEField() {
        return IDUTE;
    }

    public String getIDUTE() {
        return IDUTE.getValue();
    }

    public void setIDUTE(String value) {
        this.IDUTE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of IDUTE

//AD4_UTENTIRow: method(s) of GRUPPO @47-C886BC8A
    public TextField getGRUPPOField() {
        return GRUPPO;
    }

    public String getGRUPPO() {
        return GRUPPO.getValue();
    }

    public void setGRUPPO(String value) {
        this.GRUPPO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of GRUPPO

//AD4_UTENTIRow: class tail @5-FCB6E20C
}
//End AD4_UTENTIRow: class tail


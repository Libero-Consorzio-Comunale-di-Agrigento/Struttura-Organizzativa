//AMV_AREERow: import @2-F2523B18
package amvadm.AdmAree;

import java.util.*;
import com.codecharge.db.*;
//End AMV_AREERow: import

//AMV_AREERow: class head @2-77C0EA2B
public class AMV_AREERow {
//End AMV_AREERow: class head

//AMV_AREERow: declare fiels @2-D3203589
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_AREA");
    private TextField ID_AREA = new TextField("ID_AREA", "ID_AREA");
//End AMV_AREERow: declare fiels

//AMV_AREERow: constructor @2-E0B2CDE1
    public AMV_AREERow() {
    }
//End AMV_AREERow: constructor

//AMV_AREERow: method(s) of NOME @6-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_AREERow: method(s) of NOME

//AMV_AREERow: method(s) of DESCRIZIONE @8-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_AREERow: method(s) of DESCRIZIONE

//AMV_AREERow: method(s) of AFCNavigator @26-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_AREERow: method(s) of AFCNavigator

//AMV_AREERow: method(s) of ID @7-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_AREERow: method(s) of ID

//AMV_AREERow: method(s) of ID_AREA @7-F032956E
    public TextField getID_AREAField() {
        return ID_AREA;
    }

    public String getID_AREA() {
        return ID_AREA.getValue();
    }

    public void setID_AREA(String value) {
        this.ID_AREA.setValue(value);
    }
//End AMV_AREERow: method(s) of ID_AREA

//AMV_AREERow: class tail @2-FCB6E20C
}
//End AMV_AREERow: class tail


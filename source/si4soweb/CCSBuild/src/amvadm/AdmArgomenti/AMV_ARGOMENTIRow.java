//AMV_ARGOMENTIRow: import @5-A20592D0
package amvadm.AdmArgomenti;

import java.util.*;
import com.codecharge.db.*;
//End AMV_ARGOMENTIRow: import

//AMV_ARGOMENTIRow: class head @5-77658AF8
public class AMV_ARGOMENTIRow {
//End AMV_ARGOMENTIRow: class head

//AMV_ARGOMENTIRow: declare fiels @5-D1FB0A7E
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_ARGOMENTO");
    private TextField ID_ARGOMENTO = new TextField("ID_ARGOMENTO", "ID_ARGOMENTO");
//End AMV_ARGOMENTIRow: declare fiels

//AMV_ARGOMENTIRow: constructor @5-B3AD7CE4
    public AMV_ARGOMENTIRow() {
    }
//End AMV_ARGOMENTIRow: constructor

//AMV_ARGOMENTIRow: method(s) of NOME @9-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_ARGOMENTIRow: method(s) of NOME

//AMV_ARGOMENTIRow: method(s) of DESCRIZIONE @25-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_ARGOMENTIRow: method(s) of DESCRIZIONE

//AMV_ARGOMENTIRow: method(s) of AFCNavigator @27-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_ARGOMENTIRow: method(s) of AFCNavigator

//AMV_ARGOMENTIRow: method(s) of ID @13-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_ARGOMENTIRow: method(s) of ID

//AMV_ARGOMENTIRow: method(s) of ID_ARGOMENTO @13-E5F9E8F2
    public TextField getID_ARGOMENTOField() {
        return ID_ARGOMENTO;
    }

    public String getID_ARGOMENTO() {
        return ID_ARGOMENTO.getValue();
    }

    public void setID_ARGOMENTO(String value) {
        this.ID_ARGOMENTO.setValue(value);
    }
//End AMV_ARGOMENTIRow: method(s) of ID_ARGOMENTO

//AMV_ARGOMENTIRow: class tail @5-FCB6E20C
}
//End AMV_ARGOMENTIRow: class tail


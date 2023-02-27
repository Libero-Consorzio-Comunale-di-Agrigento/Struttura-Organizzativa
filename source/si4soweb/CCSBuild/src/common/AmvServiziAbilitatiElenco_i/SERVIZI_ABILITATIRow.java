//SERVIZI_ABILITATIRow: import @10-657B316F
package common.AmvServiziAbilitatiElenco_i;

import java.util.*;
import com.codecharge.db.*;
//End SERVIZI_ABILITATIRow: import

//SERVIZI_ABILITATIRow: class head @10-10FF7FF9
public class SERVIZI_ABILITATIRow {
//End SERVIZI_ABILITATIRow: class head

//SERVIZI_ABILITATIRow: declare fiels @10-D72FE4E3
    private TextField Label1 = new TextField("Label1", "");
    private TextField DATA = new TextField("DATA", "DATA");
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField NOTIFICA = new TextField("NOTIFICA", "NOTIFICA");
    private TextField AZIENDA = new TextField("AZIENDA", "AZIENDA");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End SERVIZI_ABILITATIRow: declare fiels

//SERVIZI_ABILITATIRow: constructor @10-931E7ED3
    public SERVIZI_ABILITATIRow() {
    }
//End SERVIZI_ABILITATIRow: constructor

//SERVIZI_ABILITATIRow: method(s) of Label1 @40-6401A877
    public TextField getLabel1Field() {
        return Label1;
    }

    public String getLabel1() {
        return Label1.getValue();
    }

    public void setLabel1(String value) {
        this.Label1.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of Label1

//SERVIZI_ABILITATIRow: method(s) of DATA @12-28E61A6F
    public TextField getDATAField() {
        return DATA;
    }

    public String getDATA() {
        return DATA.getValue();
    }

    public void setDATA(String value) {
        this.DATA.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of DATA

//SERVIZI_ABILITATIRow: method(s) of SERVIZIO @11-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of SERVIZIO

//SERVIZI_ABILITATIRow: method(s) of NOTIFICA @13-B4BB5F70
    public TextField getNOTIFICAField() {
        return NOTIFICA;
    }

    public String getNOTIFICA() {
        return NOTIFICA.getValue();
    }

    public void setNOTIFICA(String value) {
        this.NOTIFICA.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of NOTIFICA

//SERVIZI_ABILITATIRow: method(s) of AZIENDA @14-4D5AFBE6
    public TextField getAZIENDAField() {
        return AZIENDA;
    }

    public String getAZIENDA() {
        return AZIENDA.getValue();
    }

    public void setAZIENDA(String value) {
        this.AZIENDA.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of AZIENDA

//SERVIZI_ABILITATIRow: method(s) of AFCNavigator @38-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End SERVIZI_ABILITATIRow: method(s) of AFCNavigator

//SERVIZI_ABILITATIRow: class tail @10-FCB6E20C
}
//End SERVIZI_ABILITATIRow: class tail


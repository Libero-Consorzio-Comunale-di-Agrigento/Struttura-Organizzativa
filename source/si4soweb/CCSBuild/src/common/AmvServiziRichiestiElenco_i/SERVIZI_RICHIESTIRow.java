//SERVIZI_RICHIESTIRow: import @2-A05A0C57
package common.AmvServiziRichiestiElenco_i;

import java.util.*;
import com.codecharge.db.*;
//End SERVIZI_RICHIESTIRow: import

//SERVIZI_RICHIESTIRow: class head @2-C3B4554F
public class SERVIZI_RICHIESTIRow {
//End SERVIZI_RICHIESTIRow: class head

//SERVIZI_RICHIESTIRow: declare fiels @2-34930E28
    private TextField DATA = new TextField("DATA", "DATA");
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField NOTIFICA = new TextField("NOTIFICA", "NOTIFICA");
    private TextField AZIENDA = new TextField("AZIENDA", "AZIENDA");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End SERVIZI_RICHIESTIRow: declare fiels

//SERVIZI_RICHIESTIRow: constructor @2-DCA8A892
    public SERVIZI_RICHIESTIRow() {
    }
//End SERVIZI_RICHIESTIRow: constructor

//SERVIZI_RICHIESTIRow: method(s) of DATA @4-28E61A6F
    public TextField getDATAField() {
        return DATA;
    }

    public String getDATA() {
        return DATA.getValue();
    }

    public void setDATA(String value) {
        this.DATA.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of DATA

//SERVIZI_RICHIESTIRow: method(s) of SERVIZIO @3-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of SERVIZIO

//SERVIZI_RICHIESTIRow: method(s) of NOTIFICA @5-B4BB5F70
    public TextField getNOTIFICAField() {
        return NOTIFICA;
    }

    public String getNOTIFICA() {
        return NOTIFICA.getValue();
    }

    public void setNOTIFICA(String value) {
        this.NOTIFICA.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of NOTIFICA

//SERVIZI_RICHIESTIRow: method(s) of AZIENDA @6-4D5AFBE6
    public TextField getAZIENDAField() {
        return AZIENDA;
    }

    public String getAZIENDA() {
        return AZIENDA.getValue();
    }

    public void setAZIENDA(String value) {
        this.AZIENDA.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of AZIENDA

//SERVIZI_RICHIESTIRow: method(s) of AFCNavigator @37-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End SERVIZI_RICHIESTIRow: method(s) of AFCNavigator

//SERVIZI_RICHIESTIRow: class tail @2-FCB6E20C
}
//End SERVIZI_RICHIESTIRow: class tail


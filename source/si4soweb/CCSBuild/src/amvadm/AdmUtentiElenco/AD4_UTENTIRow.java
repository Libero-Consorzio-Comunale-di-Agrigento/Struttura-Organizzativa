//AD4_UTENTIRow: import @5-FC0E138A
package amvadm.AdmUtentiElenco;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @5-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @5-1D4F9DCD
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField GRUPPI = new TextField("GRUPPI", "GRUPPI");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField IDUTE = new TextField("IDUTE", "UTENTE");
    private TextField UTENTE = new TextField("UTENTE", "UTENTE");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @5-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOMINATIVO @32-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NOMINATIVO

//AD4_UTENTIRow: method(s) of GRUPPI @69-781D3ACA
    public TextField getGRUPPIField() {
        return GRUPPI;
    }

    public String getGRUPPI() {
        return GRUPPI.getValue();
    }

    public void setGRUPPI(String value) {
        this.GRUPPI.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of GRUPPI

//AD4_UTENTIRow: method(s) of AFCNavigator @74-B6FE7CCE
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

//AD4_UTENTIRow: method(s) of UTENTE @47-95517C36
    public TextField getUTENTEField() {
        return UTENTE;
    }

    public String getUTENTE() {
        return UTENTE.getValue();
    }

    public void setUTENTE(String value) {
        this.UTENTE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of UTENTE

//AD4_UTENTIRow: class tail @5-FCB6E20C
}
//End AD4_UTENTIRow: class tail


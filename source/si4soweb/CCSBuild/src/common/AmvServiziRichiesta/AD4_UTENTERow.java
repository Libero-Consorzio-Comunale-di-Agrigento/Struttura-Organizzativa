//AD4_UTENTERow: import @2-26013C1D
package common.AmvServiziRichiesta;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTERow: import

//AD4_UTENTERow: class head @2-1D90A030
public class AD4_UTENTERow {
//End AD4_UTENTERow: class head

//AD4_UTENTERow: declare fiels @2-E2859190
    private TextField ISTANZA = new TextField("ISTANZA", "ISTANZA");
    private TextField MODULO = new TextField("MODULO", "MODULO");
    private TextField MVPAGES = new TextField("MVPAGES", "REDIRECTION");
//End AD4_UTENTERow: declare fiels

//AD4_UTENTERow: constructor @2-F4EC37D7
    public AD4_UTENTERow() {
    }
//End AD4_UTENTERow: constructor

//AD4_UTENTERow: method(s) of ISTANZA @52-CC23EEBF
    public TextField getISTANZAField() {
        return ISTANZA;
    }

    public String getISTANZA() {
        return ISTANZA.getValue();
    }

    public void setISTANZA(String value) {
        this.ISTANZA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of ISTANZA

//AD4_UTENTERow: method(s) of MODULO @51-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End AD4_UTENTERow: method(s) of MODULO

//AD4_UTENTERow: method(s) of MVPAGES @44-59C95F0B
    public TextField getMVPAGESField() {
        return MVPAGES;
    }

    public String getMVPAGES() {
        return MVPAGES.getValue();
    }

    public void setMVPAGES(String value) {
        this.MVPAGES.setValue(value);
    }
//End AD4_UTENTERow: method(s) of MVPAGES

//AD4_UTENTERow: class tail @2-FCB6E20C
}
//End AD4_UTENTERow: class tail


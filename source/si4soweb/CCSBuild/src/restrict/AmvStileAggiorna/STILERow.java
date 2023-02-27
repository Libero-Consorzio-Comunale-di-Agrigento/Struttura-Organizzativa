//STILERow: import @2-4D9BE2B2
package restrict.AmvStileAggiorna;

import java.util.*;
import com.codecharge.db.*;
//End STILERow: import

//STILERow: class head @2-BEFB9E95
public class STILERow {
//End STILERow: class head

//STILERow: declare fiels @2-0B53DCDC
    private TextField P_UTENTE = new TextField("P_UTENTE", "P_UTENTE");
    private TextField P_STRINGA = new TextField("P_STRINGA", "P_STRINGA");
    private TextField P_MODULO = new TextField("P_MODULO", "P_MODULO");
    private TextField P_STYLESHEET = new TextField("P_STYLESHEET", "P_STYLESHEET");
//End STILERow: declare fiels

//STILERow: constructor @2-1878E386
    public STILERow() {
    }
//End STILERow: constructor

//STILERow: method(s) of P_UTENTE @3-20BF9ECD
    public TextField getP_UTENTEField() {
        return P_UTENTE;
    }

    public String getP_UTENTE() {
        return P_UTENTE.getValue();
    }

    public void setP_UTENTE(String value) {
        this.P_UTENTE.setValue(value);
    }
//End STILERow: method(s) of P_UTENTE

//STILERow: method(s) of P_STRINGA @13-918F5946
    public TextField getP_STRINGAField() {
        return P_STRINGA;
    }

    public String getP_STRINGA() {
        return P_STRINGA.getValue();
    }

    public void setP_STRINGA(String value) {
        this.P_STRINGA.setValue(value);
    }
//End STILERow: method(s) of P_STRINGA

//STILERow: method(s) of P_MODULO @14-9CBF2AB0
    public TextField getP_MODULOField() {
        return P_MODULO;
    }

    public String getP_MODULO() {
        return P_MODULO.getValue();
    }

    public void setP_MODULO(String value) {
        this.P_MODULO.setValue(value);
    }
//End STILERow: method(s) of P_MODULO

//STILERow: method(s) of P_STYLESHEET @15-2797725C
    public TextField getP_STYLESHEETField() {
        return P_STYLESHEET;
    }

    public String getP_STYLESHEET() {
        return P_STYLESHEET.getValue();
    }

    public void setP_STYLESHEET(String value) {
        this.P_STYLESHEET.setValue(value);
    }
//End STILERow: method(s) of P_STYLESHEET

//STILERow: class tail @2-FCB6E20C
}
//End STILERow: class tail


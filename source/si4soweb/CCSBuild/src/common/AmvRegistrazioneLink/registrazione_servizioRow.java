//registrazione_servizioRow: import @2-E4E8BAAE
package common.AmvRegistrazioneLink;

import java.util.*;
import com.codecharge.db.*;
//End registrazione_servizioRow: import

//registrazione_servizioRow: class head @2-43D4CED1
public class registrazione_servizioRow {
//End registrazione_servizioRow: class head

//registrazione_servizioRow: declare fiels @2-98598431
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField REGISTRAZIONE = new TextField("REGISTRAZIONE", "RICHIESTA");
    private TextField MODULO = new TextField("MODULO", "MODULO");
    private TextField ISTANZA = new TextField("ISTANZA", "ISTANZA");
//End registrazione_servizioRow: declare fiels

//registrazione_servizioRow: constructor @2-8BE2BAD8
    public registrazione_servizioRow() {
    }
//End registrazione_servizioRow: constructor

//registrazione_servizioRow: method(s) of SERVIZIO @6-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End registrazione_servizioRow: method(s) of SERVIZIO

//registrazione_servizioRow: method(s) of NOMINATIVO @7-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End registrazione_servizioRow: method(s) of NOMINATIVO

//registrazione_servizioRow: method(s) of REGISTRAZIONE @3-84B470BB
    public TextField getREGISTRAZIONEField() {
        return REGISTRAZIONE;
    }

    public String getREGISTRAZIONE() {
        return REGISTRAZIONE.getValue();
    }

    public void setREGISTRAZIONE(String value) {
        this.REGISTRAZIONE.setValue(value);
    }
//End registrazione_servizioRow: method(s) of REGISTRAZIONE

//registrazione_servizioRow: method(s) of MODULO @9-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End registrazione_servizioRow: method(s) of MODULO

//registrazione_servizioRow: method(s) of ISTANZA @10-CC23EEBF
    public TextField getISTANZAField() {
        return ISTANZA;
    }

    public String getISTANZA() {
        return ISTANZA.getValue();
    }

    public void setISTANZA(String value) {
        this.ISTANZA.setValue(value);
    }
//End registrazione_servizioRow: method(s) of ISTANZA

//registrazione_servizioRow: class tail @2-FCB6E20C
}
//End registrazione_servizioRow: class tail


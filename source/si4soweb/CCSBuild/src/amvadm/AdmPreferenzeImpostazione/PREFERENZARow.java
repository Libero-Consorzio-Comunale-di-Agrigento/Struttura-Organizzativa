//PREFERENZARow: import @17-7693BFCE
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import com.codecharge.db.*;
//End PREFERENZARow: import

//PREFERENZARow: class head @17-03A50C2A
public class PREFERENZARow {
//End PREFERENZARow: class head

//PREFERENZARow: declare fiels @17-16CD06A3
    private TextField STRINGA_LABEL = new TextField("STRINGA_LABEL", "STRINGA");
    private TextField COMMENTO = new TextField("COMMENTO", "COMMENTO");
    private TextField VALORE = new TextField("VALORE", "VALORE");
    private TextField STRINGA = new TextField("STRINGA", "STRINGA");
    private TextField MODULO = new TextField("MODULO", "MODULO");
//End PREFERENZARow: declare fiels

//PREFERENZARow: constructor @17-B15C26A9
    public PREFERENZARow() {
    }
//End PREFERENZARow: constructor

//PREFERENZARow: method(s) of STRINGA_LABEL @18-9A500603
    public TextField getSTRINGA_LABELField() {
        return STRINGA_LABEL;
    }

    public String getSTRINGA_LABEL() {
        return STRINGA_LABEL.getValue();
    }

    public void setSTRINGA_LABEL(String value) {
        this.STRINGA_LABEL.setValue(value);
    }
//End PREFERENZARow: method(s) of STRINGA_LABEL

//PREFERENZARow: method(s) of COMMENTO @39-0F4C155C
    public TextField getCOMMENTOField() {
        return COMMENTO;
    }

    public String getCOMMENTO() {
        return COMMENTO.getValue();
    }

    public void setCOMMENTO(String value) {
        this.COMMENTO.setValue(value);
    }
//End PREFERENZARow: method(s) of COMMENTO

//PREFERENZARow: method(s) of VALORE @19-BC514AA0
    public TextField getVALOREField() {
        return VALORE;
    }

    public String getVALORE() {
        return VALORE.getValue();
    }

    public void setVALORE(String value) {
        this.VALORE.setValue(value);
    }
//End PREFERENZARow: method(s) of VALORE

//PREFERENZARow: method(s) of STRINGA @44-A3BF594E
    public TextField getSTRINGAField() {
        return STRINGA;
    }

    public String getSTRINGA() {
        return STRINGA.getValue();
    }

    public void setSTRINGA(String value) {
        this.STRINGA.setValue(value);
    }
//End PREFERENZARow: method(s) of STRINGA

//PREFERENZARow: method(s) of MODULO @24-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End PREFERENZARow: method(s) of MODULO

//PREFERENZARow: class tail @17-FCB6E20C
}
//End PREFERENZARow: class tail


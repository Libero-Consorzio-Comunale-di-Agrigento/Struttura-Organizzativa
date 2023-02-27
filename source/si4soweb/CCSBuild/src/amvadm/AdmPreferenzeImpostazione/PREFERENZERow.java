//PREFERENZERow: import @6-7693BFCE
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import com.codecharge.db.*;
//End PREFERENZERow: import

//PREFERENZERow: class head @6-F625AAEA
public class PREFERENZERow {
//End PREFERENZERow: class head

//PREFERENZERow: declare fiels @6-4B010482
    private TextField STRINGA = new TextField("STRINGA", "STRINGA");
    private TextField IMPOSTATA = new TextField("IMPOSTATA", "IMPOSTATA");
    private TextField VALORE = new TextField("VALORE", "VALORE");
    private TextField COMMENTO = new TextField("COMMENTO", "COMMENTO");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
//End PREFERENZERow: declare fiels

//PREFERENZERow: constructor @6-35162853
    public PREFERENZERow() {
    }
//End PREFERENZERow: constructor

//PREFERENZERow: method(s) of STRINGA @16-A3BF594E
    public TextField getSTRINGAField() {
        return STRINGA;
    }

    public String getSTRINGA() {
        return STRINGA.getValue();
    }

    public void setSTRINGA(String value) {
        this.STRINGA.setValue(value);
    }
//End PREFERENZERow: method(s) of STRINGA

//PREFERENZERow: method(s) of IMPOSTATA @41-04D89D32
    public TextField getIMPOSTATAField() {
        return IMPOSTATA;
    }

    public String getIMPOSTATA() {
        return IMPOSTATA.getValue();
    }

    public void setIMPOSTATA(String value) {
        this.IMPOSTATA.setValue(value);
    }
//End PREFERENZERow: method(s) of IMPOSTATA

//PREFERENZERow: method(s) of VALORE @7-BC514AA0
    public TextField getVALOREField() {
        return VALORE;
    }

    public String getVALORE() {
        return VALORE.getValue();
    }

    public void setVALORE(String value) {
        this.VALORE.setValue(value);
    }
//End PREFERENZERow: method(s) of VALORE

//PREFERENZERow: method(s) of COMMENTO @40-0F4C155C
    public TextField getCOMMENTOField() {
        return COMMENTO;
    }

    public String getCOMMENTO() {
        return COMMENTO.getValue();
    }

    public void setCOMMENTO(String value) {
        this.COMMENTO.setValue(value);
    }
//End PREFERENZERow: method(s) of COMMENTO

//PREFERENZERow: method(s) of AFCNavigator @43-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End PREFERENZERow: method(s) of AFCNavigator

//PREFERENZERow: class tail @6-FCB6E20C
}
//End PREFERENZERow: class tail


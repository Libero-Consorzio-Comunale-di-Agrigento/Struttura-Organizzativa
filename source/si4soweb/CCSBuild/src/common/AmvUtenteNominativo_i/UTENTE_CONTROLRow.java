//UTENTE_CONTROLRow: import @2-968802AB
package common.AmvUtenteNominativo_i;

import java.util.*;
import com.codecharge.db.*;
//End UTENTE_CONTROLRow: import

//UTENTE_CONTROLRow: class head @2-5176FAD1
public class UTENTE_CONTROLRow {
//End UTENTE_CONTROLRow: class head

//UTENTE_CONTROLRow: declare fiels @2-D33AA980
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
//End UTENTE_CONTROLRow: declare fiels

//UTENTE_CONTROLRow: constructor @2-65D19EAF
    public UTENTE_CONTROLRow() {
    }
//End UTENTE_CONTROLRow: constructor

//UTENTE_CONTROLRow: method(s) of NOMINATIVO @3-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End UTENTE_CONTROLRow: method(s) of NOMINATIVO

//UTENTE_CONTROLRow: class tail @2-FCB6E20C
}
//End UTENTE_CONTROLRow: class tail


//UTENTE_CONTROLRow: import @2-A1B37E3F
package common.AmvUtenteControl_i;

import java.util.*;
import com.codecharge.db.*;
//End UTENTE_CONTROLRow: import

//UTENTE_CONTROLRow: class head @2-5176FAD1
public class UTENTE_CONTROLRow {
//End UTENTE_CONTROLRow: class head

//UTENTE_CONTROLRow: declare fiels @2-64FCE8DB
    private TextField Utente = new TextField("Utente", "UTENTE");
//End UTENTE_CONTROLRow: declare fiels

//UTENTE_CONTROLRow: constructor @2-65D19EAF
    public UTENTE_CONTROLRow() {
    }
//End UTENTE_CONTROLRow: constructor

//UTENTE_CONTROLRow: method(s) of Utente @3-18FB6E6A
    public TextField getUtenteField() {
        return Utente;
    }

    public String getUtente() {
        return Utente.getValue();
    }

    public void setUtente(String value) {
        this.Utente.setValue(value);
    }
//End UTENTE_CONTROLRow: method(s) of Utente

//UTENTE_CONTROLRow: class tail @2-FCB6E20C
}
//End UTENTE_CONTROLRow: class tail


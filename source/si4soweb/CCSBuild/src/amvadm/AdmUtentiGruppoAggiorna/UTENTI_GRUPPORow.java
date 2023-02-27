//UTENTI_GRUPPORow: import @2-85B75FEE
package amvadm.AdmUtentiGruppoAggiorna;

import java.util.*;
import com.codecharge.db.*;
//End UTENTI_GRUPPORow: import

//UTENTI_GRUPPORow: class head @2-7970F9C9
public class UTENTI_GRUPPORow {
//End UTENTI_GRUPPORow: class head

//UTENTI_GRUPPORow: declare fiels @2-13388F64
    private TextField UTENTE = new TextField("UTENTE", "P_UTENTE");
    private TextField P_GRUPPO = new TextField("P_GRUPPO", "P_GRUPPO");
//End UTENTI_GRUPPORow: declare fiels

//UTENTI_GRUPPORow: constructor @2-FFCB3D93
    public UTENTI_GRUPPORow() {
    }
//End UTENTI_GRUPPORow: constructor

//UTENTI_GRUPPORow: method(s) of UTENTE @3-95517C36
    public TextField getUTENTEField() {
        return UTENTE;
    }

    public String getUTENTE() {
        return UTENTE.getValue();
    }

    public void setUTENTE(String value) {
        this.UTENTE.setValue(value);
    }
//End UTENTI_GRUPPORow: method(s) of UTENTE

//UTENTI_GRUPPORow: method(s) of P_GRUPPO @4-49DD45A7
    public TextField getP_GRUPPOField() {
        return P_GRUPPO;
    }

    public String getP_GRUPPO() {
        return P_GRUPPO.getValue();
    }

    public void setP_GRUPPO(String value) {
        this.P_GRUPPO.setValue(value);
    }
//End UTENTI_GRUPPORow: method(s) of P_GRUPPO

//UTENTI_GRUPPORow: class tail @2-FCB6E20C
}
//End UTENTI_GRUPPORow: class tail


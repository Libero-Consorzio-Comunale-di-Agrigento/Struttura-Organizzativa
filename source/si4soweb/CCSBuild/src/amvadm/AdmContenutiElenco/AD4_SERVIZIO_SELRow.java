//AD4_SERVIZIO_SELRow: import @10-1B3B1F4F
package amvadm.AdmDocumentiElenco;

import java.util.*;
import com.codecharge.db.*;
//End AD4_SERVIZIO_SELRow: import

//AD4_SERVIZIO_SELRow: class head @10-4C252EDA
public class AD4_SERVIZIO_SELRow {
//End AD4_SERVIZIO_SELRow: class head

//AD4_SERVIZIO_SELRow: declare fiels @10-4F1A0F54
    private TextField NOME_SEZIONE = new TextField("NOME_SEZIONE", "NOME");
    private TextField NUOVA_PAGINA = new TextField("NUOVA_PAGINA", "NEW_PAGE");
//End AD4_SERVIZIO_SELRow: declare fiels

//AD4_SERVIZIO_SELRow: constructor @10-829A6975
    public AD4_SERVIZIO_SELRow() {
    }
//End AD4_SERVIZIO_SELRow: constructor

//AD4_SERVIZIO_SELRow: method(s) of NOME_SEZIONE @11-DF48CFA4
    public TextField getNOME_SEZIONEField() {
        return NOME_SEZIONE;
    }

    public String getNOME_SEZIONE() {
        return NOME_SEZIONE.getValue();
    }

    public void setNOME_SEZIONE(String value) {
        this.NOME_SEZIONE.setValue(value);
    }
//End AD4_SERVIZIO_SELRow: method(s) of NOME_SEZIONE

//AD4_SERVIZIO_SELRow: method(s) of NUOVA_PAGINA @26-7EC837F0
    public TextField getNUOVA_PAGINAField() {
        return NUOVA_PAGINA;
    }

    public String getNUOVA_PAGINA() {
        return NUOVA_PAGINA.getValue();
    }

    public void setNUOVA_PAGINA(String value) {
        this.NUOVA_PAGINA.setValue(value);
    }
//End AD4_SERVIZIO_SELRow: method(s) of NUOVA_PAGINA

//AD4_SERVIZIO_SELRow: class tail @10-FCB6E20C
}
//End AD4_SERVIZIO_SELRow: class tail


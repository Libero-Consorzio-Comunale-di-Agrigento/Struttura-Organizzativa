//AD4_SEZIONE_SELRow: import @10-CF60D6C3
package amvadm.AdmContenutiElenco;

import java.util.*;
import com.codecharge.db.*;
//End AD4_SEZIONE_SELRow: import

//AD4_SEZIONE_SELRow: class head @10-334317EC
public class AD4_SEZIONE_SELRow {
//End AD4_SEZIONE_SELRow: class head

//AD4_SEZIONE_SELRow: declare fiels @10-94C63589
    private TextField NOME_SEZIONE = new TextField("NOME_SEZIONE", "NOME");
    private TextField RICERCA = new TextField("RICERCA", "RICERCA");
    private TextField NUOVA_PAGINA = new TextField("NUOVA_PAGINA", "NUOVA_PAGINA");
//End AD4_SEZIONE_SELRow: declare fiels

//AD4_SEZIONE_SELRow: constructor @10-2FF009FD
    public AD4_SEZIONE_SELRow() {
    }
//End AD4_SEZIONE_SELRow: constructor

//AD4_SEZIONE_SELRow: method(s) of NOME_SEZIONE @11-DF48CFA4
    public TextField getNOME_SEZIONEField() {
        return NOME_SEZIONE;
    }

    public String getNOME_SEZIONE() {
        return NOME_SEZIONE.getValue();
    }

    public void setNOME_SEZIONE(String value) {
        this.NOME_SEZIONE.setValue(value);
    }
//End AD4_SEZIONE_SELRow: method(s) of NOME_SEZIONE

//AD4_SEZIONE_SELRow: method(s) of RICERCA @32-548D848A
    public TextField getRICERCAField() {
        return RICERCA;
    }

    public String getRICERCA() {
        return RICERCA.getValue();
    }

    public void setRICERCA(String value) {
        this.RICERCA.setValue(value);
    }
//End AD4_SEZIONE_SELRow: method(s) of RICERCA

//AD4_SEZIONE_SELRow: method(s) of NUOVA_PAGINA @26-7EC837F0
    public TextField getNUOVA_PAGINAField() {
        return NUOVA_PAGINA;
    }

    public String getNUOVA_PAGINA() {
        return NUOVA_PAGINA.getValue();
    }

    public void setNUOVA_PAGINA(String value) {
        this.NUOVA_PAGINA.setValue(value);
    }
//End AD4_SEZIONE_SELRow: method(s) of NUOVA_PAGINA

//AD4_SEZIONE_SELRow: class tail @10-FCB6E20C
}
//End AD4_SEZIONE_SELRow: class tail


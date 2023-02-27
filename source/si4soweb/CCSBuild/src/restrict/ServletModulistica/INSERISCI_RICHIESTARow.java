//INSERISCI_RICHIESTARow: import @29-33AB40BF
package restrict.ServletModulistica;

import java.util.*;
import com.codecharge.db.*;
//End INSERISCI_RICHIESTARow: import

//INSERISCI_RICHIESTARow: class head @29-A012A08E
public class INSERISCI_RICHIESTARow {
//End INSERISCI_RICHIESTARow: class head

//INSERISCI_RICHIESTARow: declare fiels @29-832EF834
    private TextField MESSAGGIO = new TextField("MESSAGGIO", "MSG");
//End INSERISCI_RICHIESTARow: declare fiels

//INSERISCI_RICHIESTARow: constructor @29-FBA2A1F5
    public INSERISCI_RICHIESTARow() {
    }
//End INSERISCI_RICHIESTARow: constructor

//INSERISCI_RICHIESTARow: method(s) of MESSAGGIO @30-11031E2E
    public TextField getMESSAGGIOField() {
        return MESSAGGIO;
    }

    public String getMESSAGGIO() {
        return MESSAGGIO.getValue();
    }

    public void setMESSAGGIO(String value) {
        this.MESSAGGIO.setValue(value);
    }
//End INSERISCI_RICHIESTARow: method(s) of MESSAGGIO

//INSERISCI_RICHIESTARow: class tail @29-FCB6E20C
}
//End INSERISCI_RICHIESTARow: class tail


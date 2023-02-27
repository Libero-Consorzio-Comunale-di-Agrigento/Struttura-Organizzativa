//AMV_VISTA_DOCUMENTISearchRow: import @6-A5C988FD
package restrict.AmvRichiesteAutore;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTISearchRow: import

//AMV_VISTA_DOCUMENTISearchRow: class head @6-C6175280
public class AMV_VISTA_DOCUMENTISearchRow {
//End AMV_VISTA_DOCUMENTISearchRow: class head

//AMV_VISTA_DOCUMENTISearchRow: declare fiels @6-A104B781
    private TextField s_TESTO = new TextField("s_TESTO", "");
    private TextField s_MODELLO = new TextField("s_MODELLO", "");
//End AMV_VISTA_DOCUMENTISearchRow: declare fiels

//AMV_VISTA_DOCUMENTISearchRow: constructor @6-F5225B22
    public AMV_VISTA_DOCUMENTISearchRow() {
    }
//End AMV_VISTA_DOCUMENTISearchRow: constructor

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_TESTO @10-8A65CBD6
    public TextField getS_TESTOField() {
        return s_TESTO;
    }

    public String getS_TESTO() {
        return s_TESTO.getValue();
    }

    public void setS_TESTO(String value) {
        this.s_TESTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_TESTO

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_MODELLO @88-B3411951
    public TextField getS_MODELLOField() {
        return s_MODELLO;
    }

    public String getS_MODELLO() {
        return s_MODELLO.getValue();
    }

    public void setS_MODELLO(String value) {
        this.s_MODELLO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_MODELLO

//AMV_VISTA_DOCUMENTISearchRow: class tail @6-FCB6E20C
}
//End AMV_VISTA_DOCUMENTISearchRow: class tail


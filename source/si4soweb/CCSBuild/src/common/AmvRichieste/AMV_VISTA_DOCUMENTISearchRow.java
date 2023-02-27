//AMV_VISTA_DOCUMENTISearchRow: import @6-CA037FC9
package common.AmvRichieste;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTISearchRow: import

//AMV_VISTA_DOCUMENTISearchRow: class head @6-C6175280
public class AMV_VISTA_DOCUMENTISearchRow {
//End AMV_VISTA_DOCUMENTISearchRow: class head

//AMV_VISTA_DOCUMENTISearchRow: declare fiels @6-A26006C1
    private TextField NOME_TIPOLOGIA = new TextField("NOME_TIPOLOGIA", "NOME");
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField s_TESTO = new TextField("s_TESTO", "");
//End AMV_VISTA_DOCUMENTISearchRow: declare fiels

//AMV_VISTA_DOCUMENTISearchRow: constructor @6-F5225B22
    public AMV_VISTA_DOCUMENTISearchRow() {
    }
//End AMV_VISTA_DOCUMENTISearchRow: constructor

//AMV_VISTA_DOCUMENTISearchRow: method(s) of NOME_TIPOLOGIA @78-83892B33
    public TextField getNOME_TIPOLOGIAField() {
        return NOME_TIPOLOGIA;
    }

    public String getNOME_TIPOLOGIA() {
        return NOME_TIPOLOGIA.getValue();
    }

    public void setNOME_TIPOLOGIA(String value) {
        this.NOME_TIPOLOGIA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of NOME_TIPOLOGIA

//AMV_VISTA_DOCUMENTISearchRow: method(s) of TITOLO @77-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of TITOLO

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

//AMV_VISTA_DOCUMENTISearchRow: class tail @6-FCB6E20C
}
//End AMV_VISTA_DOCUMENTISearchRow: class tail


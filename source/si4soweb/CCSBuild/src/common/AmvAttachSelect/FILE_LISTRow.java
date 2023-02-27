//FILE_LISTRow: import @2-048A77A8
package common.AmvAttachSelect;

import java.util.*;
import com.codecharge.db.*;
//End FILE_LISTRow: import

//FILE_LISTRow: class head @2-972397CA
public class FILE_LISTRow {
//End FILE_LISTRow: class head

//FILE_LISTRow: declare fiels @2-12184DA2
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField DOCUMENTO = new TextField("DOCUMENTO", "VALORE");
    private TextField DATASOURCE = new TextField("DATASOURCE", "");
//End FILE_LISTRow: declare fiels

//FILE_LISTRow: constructor @2-618F1CAC
    public FILE_LISTRow() {
    }
//End FILE_LISTRow: constructor

//FILE_LISTRow: method(s) of TITOLO @10-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End FILE_LISTRow: method(s) of TITOLO

//FILE_LISTRow: method(s) of DOCUMENTO @27-6F813247
    public TextField getDOCUMENTOField() {
        return DOCUMENTO;
    }

    public String getDOCUMENTO() {
        return DOCUMENTO.getValue();
    }

    public void setDOCUMENTO(String value) {
        this.DOCUMENTO.setValue(value);
    }
//End FILE_LISTRow: method(s) of DOCUMENTO

//FILE_LISTRow: method(s) of DATASOURCE @37-43C15F0D
    public TextField getDATASOURCEField() {
        return DATASOURCE;
    }

    public String getDATASOURCE() {
        return DATASOURCE.getValue();
    }

    public void setDATASOURCE(String value) {
        this.DATASOURCE.setValue(value);
    }
//End FILE_LISTRow: method(s) of DATASOURCE

//FILE_LISTRow: class tail @2-FCB6E20C
}
//End FILE_LISTRow: class tail


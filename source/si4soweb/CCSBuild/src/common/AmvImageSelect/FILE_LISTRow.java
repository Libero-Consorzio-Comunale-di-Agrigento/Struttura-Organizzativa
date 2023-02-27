//FILE_LISTRow: import @2-9E847626
package common.AmvImageSelect;

import java.util.*;
import com.codecharge.db.*;
//End FILE_LISTRow: import

//FILE_LISTRow: class head @2-972397CA
public class FILE_LISTRow {
//End FILE_LISTRow: class head

//FILE_LISTRow: declare fiels @2-7CD540F7
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField MVIF = new TextField("MVIF", "MVIF");
    private TextField FILE_LIST_BOX = new TextField("FILE_LIST_BOX", "FILE_LIST_BOX");
    private TextField INPUT_FILE = new TextField("INPUT_FILE", "INPUT_FILE");
    private TextField MOSTRA = new TextField("MOSTRA", "MOSTRA");
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

//FILE_LISTRow: method(s) of MVIF @17-F542B257
    public TextField getMVIFField() {
        return MVIF;
    }

    public String getMVIF() {
        return MVIF.getValue();
    }

    public void setMVIF(String value) {
        this.MVIF.setValue(value);
    }
//End FILE_LISTRow: method(s) of MVIF

//FILE_LISTRow: method(s) of FILE_LIST_BOX @13-1A728701
    public TextField getFILE_LIST_BOXField() {
        return FILE_LIST_BOX;
    }

    public String getFILE_LIST_BOX() {
        return FILE_LIST_BOX.getValue();
    }

    public void setFILE_LIST_BOX(String value) {
        this.FILE_LIST_BOX.setValue(value);
    }
//End FILE_LISTRow: method(s) of FILE_LIST_BOX

//FILE_LISTRow: method(s) of INPUT_FILE @19-3DD795C7
    public TextField getINPUT_FILEField() {
        return INPUT_FILE;
    }

    public String getINPUT_FILE() {
        return INPUT_FILE.getValue();
    }

    public void setINPUT_FILE(String value) {
        this.INPUT_FILE.setValue(value);
    }
//End FILE_LISTRow: method(s) of INPUT_FILE

//FILE_LISTRow: method(s) of MOSTRA @20-10A00701
    public TextField getMOSTRAField() {
        return MOSTRA;
    }

    public String getMOSTRA() {
        return MOSTRA.getValue();
    }

    public void setMOSTRA(String value) {
        this.MOSTRA.setValue(value);
    }
//End FILE_LISTRow: method(s) of MOSTRA

//FILE_LISTRow: class tail @2-FCB6E20C
}
//End FILE_LISTRow: class tail


//SEZIONI_SRow: import @72-6D1D2178
package common.AmvLeftDoc;

import java.util.*;
import com.codecharge.db.*;
//End SEZIONI_SRow: import

//SEZIONI_SRow: class head @72-4C7978E3
public class SEZIONI_SRow {
//End SEZIONI_SRow: class head

//SEZIONI_SRow: declare fiels @72-21233637
    private TextField SEZ_S = new TextField("SEZ_S", "BLOCCO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End SEZIONI_SRow: declare fiels

//SEZIONI_SRow: constructor @72-044B36D1
    public SEZIONI_SRow() {
    }
//End SEZIONI_SRow: constructor

//SEZIONI_SRow: method(s) of SEZ_S @73-239C2FB8
    public TextField getSEZ_SField() {
        return SEZ_S;
    }

    public String getSEZ_S() {
        return SEZ_S.getValue();
    }

    public void setSEZ_S(String value) {
        this.SEZ_S.setValue(value);
    }
//End SEZIONI_SRow: method(s) of SEZ_S

//SEZIONI_SRow: method(s) of ID_ARTICOLO @74-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End SEZIONI_SRow: method(s) of ID_ARTICOLO

//SEZIONI_SRow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End SEZIONI_SRow: method(s) of VIS_LINK

//SEZIONI_SRow: class tail @72-FCB6E20C
}
//End SEZIONI_SRow: class tail


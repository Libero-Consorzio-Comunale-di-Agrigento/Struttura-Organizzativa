//Zona_SRow: import @34-6D1D2178
package common.AmvLeftDoc;

import java.util.*;
import com.codecharge.db.*;
//End Zona_SRow: import

//Zona_SRow: class head @34-BB4A084F
public class Zona_SRow {
//End Zona_SRow: class head

//Zona_SRow: declare fiels @34-920CFB0D
    private TextField ZONA_S = new TextField("ZONA_S", "BLOCCO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End Zona_SRow: declare fiels

//Zona_SRow: constructor @34-E7B7D81E
    public Zona_SRow() {
    }
//End Zona_SRow: constructor

//Zona_SRow: method(s) of ZONA_S @35-408B74AC
    public TextField getZONA_SField() {
        return ZONA_S;
    }

    public String getZONA_S() {
        return ZONA_S.getValue();
    }

    public void setZONA_S(String value) {
        this.ZONA_S.setValue(value);
    }
//End Zona_SRow: method(s) of ZONA_S

//Zona_SRow: method(s) of ID_ARTICOLO @36-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End Zona_SRow: method(s) of ID_ARTICOLO

//Zona_SRow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End Zona_SRow: method(s) of VIS_LINK

//Zona_SRow: class tail @34-FCB6E20C
}
//End Zona_SRow: class tail


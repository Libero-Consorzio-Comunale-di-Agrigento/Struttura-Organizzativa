//Zona_DRow: import @34-FEBF0954
package common.AmvRightDoc;

import java.util.*;
import com.codecharge.db.*;
//End Zona_DRow: import

//Zona_DRow: class head @34-698A43DD
public class Zona_DRow {
//End Zona_DRow: class head

//Zona_DRow: declare fiels @34-D8592998
    private TextField ZONA_D = new TextField("ZONA_D", "BLOCCO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End Zona_DRow: declare fiels

//Zona_DRow: constructor @34-91C9E02C
    public Zona_DRow() {
    }
//End Zona_DRow: constructor

//Zona_DRow: method(s) of ZONA_D @35-0D7DAE8E
    public TextField getZONA_DField() {
        return ZONA_D;
    }

    public String getZONA_D() {
        return ZONA_D.getValue();
    }

    public void setZONA_D(String value) {
        this.ZONA_D.setValue(value);
    }
//End Zona_DRow: method(s) of ZONA_D

//Zona_DRow: method(s) of ID_ARTICOLO @36-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End Zona_DRow: method(s) of ID_ARTICOLO

//Zona_DRow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End Zona_DRow: method(s) of VIS_LINK

//Zona_DRow: class tail @34-FCB6E20C
}
//End Zona_DRow: class tail


//SEZIONI_SRow: import @72-6FB92FF3
package common.AmvLeftSezione;

import java.util.*;
import com.codecharge.db.*;
//End SEZIONI_SRow: import

//SEZIONI_SRow: class head @72-4C7978E3
public class SEZIONI_SRow {
//End SEZIONI_SRow: class head

//SEZIONI_SRow: declare fiels @72-9896C5A8
    private TextField BLOCCO = new TextField("BLOCCO", "BLOCCO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End SEZIONI_SRow: declare fiels

//SEZIONI_SRow: constructor @72-044B36D1
    public SEZIONI_SRow() {
    }
//End SEZIONI_SRow: constructor

//SEZIONI_SRow: method(s) of BLOCCO @73-1E04C615
    public TextField getBLOCCOField() {
        return BLOCCO;
    }

    public String getBLOCCO() {
        return BLOCCO.getValue();
    }

    public void setBLOCCO(String value) {
        this.BLOCCO.setValue(value);
    }
//End SEZIONI_SRow: method(s) of BLOCCO

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


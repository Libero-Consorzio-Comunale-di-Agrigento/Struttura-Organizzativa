//NAVIGATORERow: import @2-25A96F4D
package common.AmvNavigatore;

import java.util.*;
import com.codecharge.db.*;
//End NAVIGATORERow: import

//NAVIGATORERow: class head @2-D132D43D
public class NAVIGATORERow {
//End NAVIGATORERow: class head

//NAVIGATORERow: declare fiels @2-18E6FF66
    private TextField NAVIGATORE_SEZIONI = new TextField("NAVIGATORE_SEZIONI", "NAVIGATORE_SEZIONI");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End NAVIGATORERow: declare fiels

//NAVIGATORERow: constructor @2-8FBFDA7E
    public NAVIGATORERow() {
    }
//End NAVIGATORERow: constructor

//NAVIGATORERow: method(s) of NAVIGATORE_SEZIONI @3-5D6B43E3
    public TextField getNAVIGATORE_SEZIONIField() {
        return NAVIGATORE_SEZIONI;
    }

    public String getNAVIGATORE_SEZIONI() {
        return NAVIGATORE_SEZIONI.getValue();
    }

    public void setNAVIGATORE_SEZIONI(String value) {
        this.NAVIGATORE_SEZIONI.setValue(value);
    }
//End NAVIGATORERow: method(s) of NAVIGATORE_SEZIONI

//NAVIGATORERow: method(s) of ID_ARTICOLO @4-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End NAVIGATORERow: method(s) of ID_ARTICOLO

//NAVIGATORERow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End NAVIGATORERow: method(s) of VIS_LINK

//NAVIGATORERow: class tail @2-FCB6E20C
}
//End NAVIGATORERow: class tail


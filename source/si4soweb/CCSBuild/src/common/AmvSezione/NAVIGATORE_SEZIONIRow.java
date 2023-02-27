//NAVIGATORE_SEZIONIRow: import @11-2FBB4EC1
package common.AmvSezione;

import java.util.*;
import com.codecharge.db.*;
//End NAVIGATORE_SEZIONIRow: import

//NAVIGATORE_SEZIONIRow: class head @11-FD14D3CF
public class NAVIGATORE_SEZIONIRow {
//End NAVIGATORE_SEZIONIRow: class head

//NAVIGATORE_SEZIONIRow: declare fiels @11-FCCF5C96
    private TextField NAVIGATORE = new TextField("NAVIGATORE", "BLOCCO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End NAVIGATORE_SEZIONIRow: declare fiels

//NAVIGATORE_SEZIONIRow: constructor @11-7FC5D9DE
    public NAVIGATORE_SEZIONIRow() {
    }
//End NAVIGATORE_SEZIONIRow: constructor

//NAVIGATORE_SEZIONIRow: method(s) of NAVIGATORE @12-C6836D03
    public TextField getNAVIGATOREField() {
        return NAVIGATORE;
    }

    public String getNAVIGATORE() {
        return NAVIGATORE.getValue();
    }

    public void setNAVIGATORE(String value) {
        this.NAVIGATORE.setValue(value);
    }
//End NAVIGATORE_SEZIONIRow: method(s) of NAVIGATORE

//NAVIGATORE_SEZIONIRow: method(s) of ID_ARTICOLO @13-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End NAVIGATORE_SEZIONIRow: method(s) of ID_ARTICOLO

//NAVIGATORE_SEZIONIRow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End NAVIGATORE_SEZIONIRow: method(s) of VIS_LINK

//NAVIGATORE_SEZIONIRow: class tail @11-FCB6E20C
}
//End NAVIGATORE_SEZIONIRow: class tail


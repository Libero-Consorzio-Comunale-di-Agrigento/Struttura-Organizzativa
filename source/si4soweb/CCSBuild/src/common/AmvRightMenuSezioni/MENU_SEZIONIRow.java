//MENU_SEZIONIRow: import @79-AA04262A
package common.AmvRightMenuSezioni;

import java.util.*;
import com.codecharge.db.*;
//End MENU_SEZIONIRow: import

//MENU_SEZIONIRow: class head @79-348603E6
public class MENU_SEZIONIRow {
//End MENU_SEZIONIRow: class head

//MENU_SEZIONIRow: declare fiels @79-8BCA910C
    private TextField MENU_SEZ = new TextField("MENU_SEZ", "BLOCCO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End MENU_SEZIONIRow: declare fiels

//MENU_SEZIONIRow: constructor @79-C8550979
    public MENU_SEZIONIRow() {
    }
//End MENU_SEZIONIRow: constructor

//MENU_SEZIONIRow: method(s) of MENU_SEZ @80-9FC1BF98
    public TextField getMENU_SEZField() {
        return MENU_SEZ;
    }

    public String getMENU_SEZ() {
        return MENU_SEZ.getValue();
    }

    public void setMENU_SEZ(String value) {
        this.MENU_SEZ.setValue(value);
    }
//End MENU_SEZIONIRow: method(s) of MENU_SEZ

//MENU_SEZIONIRow: method(s) of ID_ARTICOLO @81-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End MENU_SEZIONIRow: method(s) of ID_ARTICOLO

//MENU_SEZIONIRow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End MENU_SEZIONIRow: method(s) of VIS_LINK

//MENU_SEZIONIRow: class tail @79-FCB6E20C
}
//End MENU_SEZIONIRow: class tail


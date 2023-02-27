//AMV_VOCIRow: import @41-D505282F
package amvadm.AdmGuide;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VOCIRow: import

//AMV_VOCIRow: class head @41-141E210B
public class AMV_VOCIRow {
//End AMV_VOCIRow: class head

//AMV_VOCIRow: declare fiels @41-2853994B
    private TextField TITOLO_VOCE = new TextField("TITOLO_VOCE", "TITOLO");
    private TextField ID_ARTICOLO = new TextField("ID_ARTICOLO", "ID_ARTICOLO");
    private TextField VIS_LINK = new TextField("VIS_LINK", "VIS_LINK");
//End AMV_VOCIRow: declare fiels

//AMV_VOCIRow: constructor @41-919A7A34
    public AMV_VOCIRow() {
    }
//End AMV_VOCIRow: constructor

//AMV_VOCIRow: method(s) of TITOLO_VOCE @42-0B5EE3CE
    public TextField getTITOLO_VOCEField() {
        return TITOLO_VOCE;
    }

    public String getTITOLO_VOCE() {
        return TITOLO_VOCE.getValue();
    }

    public void setTITOLO_VOCE(String value) {
        this.TITOLO_VOCE.setValue(value);
    }
//End AMV_VOCIRow: method(s) of TITOLO_VOCE

//AMV_VOCIRow: method(s) of ID_ARTICOLO @43-24DA9907
    public TextField getID_ARTICOLOField() {
        return ID_ARTICOLO;
    }

    public String getID_ARTICOLO() {
        return ID_ARTICOLO.getValue();
    }

    public void setID_ARTICOLO(String value) {
        this.ID_ARTICOLO.setValue(value);
    }
//End AMV_VOCIRow: method(s) of ID_ARTICOLO

//AMV_VOCIRow: method(s) of VIS_LINK @VIS_LINK-327C15AC
    public TextField getVIS_LINKField() {
        return VIS_LINK;
    }

    public String getVIS_LINK() {
        return VIS_LINK.getValue();
    }

    public void setVIS_LINK(String value) {
        this.VIS_LINK.setValue(value);
    }
//End AMV_VOCIRow: method(s) of VIS_LINK

//AMV_VOCIRow: class tail @41-FCB6E20C
}
//End AMV_VOCIRow: class tail


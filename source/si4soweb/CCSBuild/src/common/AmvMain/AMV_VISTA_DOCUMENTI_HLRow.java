//AMV_VISTA_DOCUMENTI_HLRow: import @5-02E691B6
package common.AmvMain;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTI_HLRow: import

//AMV_VISTA_DOCUMENTI_HLRow: class head @5-CD21408B
public class AMV_VISTA_DOCUMENTI_HLRow {
//End AMV_VISTA_DOCUMENTI_HLRow: class head

//AMV_VISTA_DOCUMENTI_HLRow: declare fiels @5-3385B38D
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private DateField DATA = new DateField("DATA", "DATA_ULTIMA_MODIFICA");
    private TextField TESTO = new TextField("TESTO", "TESTO_TXT");
    private TextField TESTO_HTML = new TextField("TESTO_HTML", "TESTO_HTML");
    private TextField ID = new TextField("ID", "ID");
//End AMV_VISTA_DOCUMENTI_HLRow: declare fiels

//AMV_VISTA_DOCUMENTI_HLRow: constructor @5-821EA266
    public AMV_VISTA_DOCUMENTI_HLRow() {
    }
//End AMV_VISTA_DOCUMENTI_HLRow: constructor

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of TITOLO @23-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HLRow: method(s) of TITOLO

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of DATA @25-ABA0FD8B
    public DateField getDATAField() {
        return DATA;
    }

    public Date getDATA() {
        return DATA.getValue();
    }

    public void setDATA(Date value) {
        this.DATA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HLRow: method(s) of DATA

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of TESTO @24-BCA06F46
    public TextField getTESTOField() {
        return TESTO;
    }

    public String getTESTO() {
        return TESTO.getValue();
    }

    public void setTESTO(String value) {
        this.TESTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HLRow: method(s) of TESTO

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of TESTO_HTML @37-AB342311
    public TextField getTESTO_HTMLField() {
        return TESTO_HTML;
    }

    public String getTESTO_HTML() {
        return TESTO_HTML.getValue();
    }

    public void setTESTO_HTML(String value) {
        this.TESTO_HTML.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HLRow: method(s) of TESTO_HTML

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of ID @33-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HLRow: method(s) of ID

//AMV_VISTA_DOCUMENTI_HLRow: class tail @5-FCB6E20C
}
//End AMV_VISTA_DOCUMENTI_HLRow: class tail


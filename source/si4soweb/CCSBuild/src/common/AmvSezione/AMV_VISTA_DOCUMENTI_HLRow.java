//AMV_VISTA_DOCUMENTI_HLRow: import @20-2FBB4EC1
package common.AmvSezione;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTI_HLRow: import

//AMV_VISTA_DOCUMENTI_HLRow: class head @20-CD21408B
public class AMV_VISTA_DOCUMENTI_HLRow {
//End AMV_VISTA_DOCUMENTI_HLRow: class head

//AMV_VISTA_DOCUMENTI_HLRow: declare fiels @20-3385B38D
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private DateField DATA = new DateField("DATA", "DATA_ULTIMA_MODIFICA");
    private TextField TESTO = new TextField("TESTO", "TESTO_TXT");
    private TextField TESTO_HTML = new TextField("TESTO_HTML", "TESTO_HTML");
    private TextField ID = new TextField("ID", "ID");
//End AMV_VISTA_DOCUMENTI_HLRow: declare fiels

//AMV_VISTA_DOCUMENTI_HLRow: constructor @20-821EA266
    public AMV_VISTA_DOCUMENTI_HLRow() {
    }
//End AMV_VISTA_DOCUMENTI_HLRow: constructor

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of TITOLO @21-FB48796E
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

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of DATA @24-ABA0FD8B
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

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of TESTO @25-BCA06F46
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

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of TESTO_HTML @26-AB342311
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

//AMV_VISTA_DOCUMENTI_HLRow: method(s) of ID @22-2B895796
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

//AMV_VISTA_DOCUMENTI_HLRow: class tail @20-FCB6E20C
}
//End AMV_VISTA_DOCUMENTI_HLRow: class tail


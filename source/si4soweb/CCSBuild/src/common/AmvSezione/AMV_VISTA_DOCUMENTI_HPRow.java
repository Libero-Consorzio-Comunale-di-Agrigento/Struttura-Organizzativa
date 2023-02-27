//AMV_VISTA_DOCUMENTI_HPRow: import @30-2FBB4EC1
package common.AmvSezione;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTI_HPRow: import

//AMV_VISTA_DOCUMENTI_HPRow: class head @30-68313A08
public class AMV_VISTA_DOCUMENTI_HPRow {
//End AMV_VISTA_DOCUMENTI_HPRow: class head

//AMV_VISTA_DOCUMENTI_HPRow: declare fiels @30-A22D0326
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField TESTO = new TextField("TESTO", "TESTO_TXT");
    private TextField TESTO_HTML = new TextField("TESTO_HTML", "TESTO_HTML");
    private DateField DATA = new DateField("DATA", "DATA_ULTIMA_MODIFICA");
    private TextField ID = new TextField("ID", "ID");
//End AMV_VISTA_DOCUMENTI_HPRow: declare fiels

//AMV_VISTA_DOCUMENTI_HPRow: constructor @30-A90A8602
    public AMV_VISTA_DOCUMENTI_HPRow() {
    }
//End AMV_VISTA_DOCUMENTI_HPRow: constructor

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of TITOLO @31-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HPRow: method(s) of TITOLO

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of TESTO @34-BCA06F46
    public TextField getTESTOField() {
        return TESTO;
    }

    public String getTESTO() {
        return TESTO.getValue();
    }

    public void setTESTO(String value) {
        this.TESTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HPRow: method(s) of TESTO

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of TESTO_HTML @35-AB342311
    public TextField getTESTO_HTMLField() {
        return TESTO_HTML;
    }

    public String getTESTO_HTML() {
        return TESTO_HTML.getValue();
    }

    public void setTESTO_HTML(String value) {
        this.TESTO_HTML.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HPRow: method(s) of TESTO_HTML

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of DATA @36-ABA0FD8B
    public DateField getDATAField() {
        return DATA;
    }

    public Date getDATA() {
        return DATA.getValue();
    }

    public void setDATA(Date value) {
        this.DATA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HPRow: method(s) of DATA

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of ID @32-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_VISTA_DOCUMENTI_HPRow: method(s) of ID

//AMV_VISTA_DOCUMENTI_HPRow: class tail @30-FCB6E20C
}
//End AMV_VISTA_DOCUMENTI_HPRow: class tail


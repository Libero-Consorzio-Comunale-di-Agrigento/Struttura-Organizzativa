//AMV_VISTA_DOCUMENTI_HPRow: import @10-02E691B6
package common.AmvMain;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTI_HPRow: import

//AMV_VISTA_DOCUMENTI_HPRow: class head @10-68313A08
public class AMV_VISTA_DOCUMENTI_HPRow {
//End AMV_VISTA_DOCUMENTI_HPRow: class head

//AMV_VISTA_DOCUMENTI_HPRow: declare fiels @10-A22D0326
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField TESTO = new TextField("TESTO", "TESTO_TXT");
    private TextField TESTO_HTML = new TextField("TESTO_HTML", "TESTO_HTML");
    private DateField DATA = new DateField("DATA", "DATA_ULTIMA_MODIFICA");
    private TextField ID = new TextField("ID", "ID");
//End AMV_VISTA_DOCUMENTI_HPRow: declare fiels

//AMV_VISTA_DOCUMENTI_HPRow: constructor @10-A90A8602
    public AMV_VISTA_DOCUMENTI_HPRow() {
    }
//End AMV_VISTA_DOCUMENTI_HPRow: constructor

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of TITOLO @11-FB48796E
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

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of TESTO @28-BCA06F46
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

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of TESTO_HTML @38-AB342311
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

//AMV_VISTA_DOCUMENTI_HPRow: method(s) of DATA @29-ABA0FD8B
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

//AMV_VISTA_DOCUMENTI_HPRow: class tail @10-FCB6E20C
}
//End AMV_VISTA_DOCUMENTI_HPRow: class tail


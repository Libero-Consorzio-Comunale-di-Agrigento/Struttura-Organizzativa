//AD4_MODULIRow: import @28-B1E9099D
package common.AmvHeader;

import java.util.*;
import com.codecharge.db.*;
//End AD4_MODULIRow: import

//AD4_MODULIRow: class head @28-847A18DD
public class AD4_MODULIRow {
//End AD4_MODULIRow: class head

//AD4_MODULIRow: declare fiels @28-41131D10
    private TextField RETURN_PAGE = new TextField("RETURN_PAGE", "RETURN_PAGE");
    private TextField NAVIGATORE = new TextField("NAVIGATORE", "NAVIGATORE");
    private TextField MENUBAR = new TextField("MENUBAR", "MENUBAR");
    private TextField SECTIONBAR = new TextField("SECTIONBAR", "SECTIONBAR");
    private TextField HELP = new TextField("HELP", "HELP");
//End AD4_MODULIRow: declare fiels

//AD4_MODULIRow: constructor @28-39155B6B
    public AD4_MODULIRow() {
    }
//End AD4_MODULIRow: constructor

//AD4_MODULIRow: method(s) of RETURN_PAGE @48-BD409C84
    public TextField getRETURN_PAGEField() {
        return RETURN_PAGE;
    }

    public String getRETURN_PAGE() {
        return RETURN_PAGE.getValue();
    }

    public void setRETURN_PAGE(String value) {
        this.RETURN_PAGE.setValue(value);
    }
//End AD4_MODULIRow: method(s) of RETURN_PAGE

//AD4_MODULIRow: method(s) of NAVIGATORE @68-C6836D03
    public TextField getNAVIGATOREField() {
        return NAVIGATORE;
    }

    public String getNAVIGATORE() {
        return NAVIGATORE.getValue();
    }

    public void setNAVIGATORE(String value) {
        this.NAVIGATORE.setValue(value);
    }
//End AD4_MODULIRow: method(s) of NAVIGATORE

//AD4_MODULIRow: method(s) of MENUBAR @67-1ABEF871
    public TextField getMENUBARField() {
        return MENUBAR;
    }

    public String getMENUBAR() {
        return MENUBAR.getValue();
    }

    public void setMENUBAR(String value) {
        this.MENUBAR.setValue(value);
    }
//End AD4_MODULIRow: method(s) of MENUBAR

//AD4_MODULIRow: method(s) of SECTIONBAR @70-2E0A666D
    public TextField getSECTIONBARField() {
        return SECTIONBAR;
    }

    public String getSECTIONBAR() {
        return SECTIONBAR.getValue();
    }

    public void setSECTIONBAR(String value) {
        this.SECTIONBAR.setValue(value);
    }
//End AD4_MODULIRow: method(s) of SECTIONBAR

//AD4_MODULIRow: method(s) of HELP @50-8C31A0E3
    public TextField getHELPField() {
        return HELP;
    }

    public String getHELP() {
        return HELP.getValue();
    }

    public void setHELP(String value) {
        this.HELP.setValue(value);
    }
//End AD4_MODULIRow: method(s) of HELP

//AD4_MODULIRow: class tail @28-FCB6E20C
}
//End AD4_MODULIRow: class tail


//AMV_GUIDE1Row: import @19-D505282F
package amvadm.AdmGuide;

import java.util.*;
import com.codecharge.db.*;
//End AMV_GUIDE1Row: import

//AMV_GUIDE1Row: class head @19-5D4BC0E9
public class AMV_GUIDE1Row {
//End AMV_GUIDE1Row: class head

//AMV_GUIDE1Row: declare fiels @19-5CC64DF2
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField GUIDA = new TextField("GUIDA", "GUIDA");
    private TextField SEQUENZA = new TextField("SEQUENZA", "SEQUENZA");
    private TextField VOCE_MENU = new TextField("VOCE_MENU", "VOCE_MENU");
    private TextField ALIAS = new TextField("ALIAS", "ALIAS");
    private TextField VOCE_RIF = new TextField("VOCE_RIF", "VOCE_RIF");
//End AMV_GUIDE1Row: declare fiels

//AMV_GUIDE1Row: constructor @19-024859D3
    public AMV_GUIDE1Row() {
    }
//End AMV_GUIDE1Row: constructor

//AMV_GUIDE1Row: method(s) of TITOLO @20-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_GUIDE1Row: method(s) of TITOLO

//AMV_GUIDE1Row: method(s) of GUIDA @33-002FBA82
    public TextField getGUIDAField() {
        return GUIDA;
    }

    public String getGUIDA() {
        return GUIDA.getValue();
    }

    public void setGUIDA(String value) {
        this.GUIDA.setValue(value);
    }
//End AMV_GUIDE1Row: method(s) of GUIDA

//AMV_GUIDE1Row: method(s) of SEQUENZA @21-C6A59924
    public TextField getSEQUENZAField() {
        return SEQUENZA;
    }

    public String getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(String value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_GUIDE1Row: method(s) of SEQUENZA

//AMV_GUIDE1Row: method(s) of VOCE_MENU @22-1A2DD1B2
    public TextField getVOCE_MENUField() {
        return VOCE_MENU;
    }

    public String getVOCE_MENU() {
        return VOCE_MENU.getValue();
    }

    public void setVOCE_MENU(String value) {
        this.VOCE_MENU.setValue(value);
    }
//End AMV_GUIDE1Row: method(s) of VOCE_MENU

//AMV_GUIDE1Row: method(s) of ALIAS @49-B40FEC63
    public TextField getALIASField() {
        return ALIAS;
    }

    public String getALIAS() {
        return ALIAS.getValue();
    }

    public void setALIAS(String value) {
        this.ALIAS.setValue(value);
    }
//End AMV_GUIDE1Row: method(s) of ALIAS

//AMV_GUIDE1Row: method(s) of VOCE_RIF @47-F93454BE
    public TextField getVOCE_RIFField() {
        return VOCE_RIF;
    }

    public String getVOCE_RIF() {
        return VOCE_RIF.getValue();
    }

    public void setVOCE_RIF(String value) {
        this.VOCE_RIF.setValue(value);
    }
//End AMV_GUIDE1Row: method(s) of VOCE_RIF

//AMV_GUIDE1Row: class tail @19-FCB6E20C
}
//End AMV_GUIDE1Row: class tail


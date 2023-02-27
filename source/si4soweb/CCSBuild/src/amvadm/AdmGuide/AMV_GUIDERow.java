//AMV_GUIDERow: import @5-D505282F
package amvadm.AdmGuide;

import java.util.*;
import com.codecharge.db.*;
//End AMV_GUIDERow: import

//AMV_GUIDERow: class head @5-A23C61FB
public class AMV_GUIDERow {
//End AMV_GUIDERow: class head

//AMV_GUIDERow: declare fiels @5-3F175D08
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField SEQUENZA = new TextField("SEQUENZA", "SEQUENZA");
    private TextField VOCE_RIF = new TextField("VOCE_RIF", "VOCE_RIF");
    private TextField URL_RIF = new TextField("URL_RIF", "URL_RIF");
    private TextField Modifica = new TextField("Modifica", "MODIFICA");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField guida = new TextField("guida", "GUIDA");
    private TextField GUIDA = new TextField("GUIDA", "GUIDA");
    private TextField seq = new TextField("seq", "SEQUENZA");
//End AMV_GUIDERow: declare fiels

//AMV_GUIDERow: constructor @5-8BC8D8F0
    public AMV_GUIDERow() {
    }
//End AMV_GUIDERow: constructor

//AMV_GUIDERow: method(s) of TITOLO @10-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_GUIDERow: method(s) of TITOLO

//AMV_GUIDERow: method(s) of SEQUENZA @11-C6A59924
    public TextField getSEQUENZAField() {
        return SEQUENZA;
    }

    public String getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(String value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_GUIDERow: method(s) of SEQUENZA

//AMV_GUIDERow: method(s) of VOCE_RIF @12-F93454BE
    public TextField getVOCE_RIFField() {
        return VOCE_RIF;
    }

    public String getVOCE_RIF() {
        return VOCE_RIF.getValue();
    }

    public void setVOCE_RIF(String value) {
        this.VOCE_RIF.setValue(value);
    }
//End AMV_GUIDERow: method(s) of VOCE_RIF

//AMV_GUIDERow: method(s) of URL_RIF @13-A87CC907
    public TextField getURL_RIFField() {
        return URL_RIF;
    }

    public String getURL_RIF() {
        return URL_RIF.getValue();
    }

    public void setURL_RIF(String value) {
        this.URL_RIF.setValue(value);
    }
//End AMV_GUIDERow: method(s) of URL_RIF

//AMV_GUIDERow: method(s) of Modifica @14-D5541917
    public TextField getModificaField() {
        return Modifica;
    }

    public String getModifica() {
        return Modifica.getValue();
    }

    public void setModifica(String value) {
        this.Modifica.setValue(value);
    }
//End AMV_GUIDERow: method(s) of Modifica

//AMV_GUIDERow: method(s) of AFCNavigator @51-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_GUIDERow: method(s) of AFCNavigator

//AMV_GUIDERow: method(s) of guida @15-BA372172
    public TextField getGuidaField() {
        return guida;
    }

    public String getGuida() {
        return guida.getValue();
    }

    public void setGuida(String value) {
        this.guida.setValue(value);
    }
//End AMV_GUIDERow: method(s) of guida

//AMV_GUIDERow: method(s) of GUIDA @15-002FBA82
    public TextField getGUIDAField() {
        return GUIDA;
    }

    public String getGUIDA() {
        return GUIDA.getValue();
    }

    public void setGUIDA(String value) {
        this.GUIDA.setValue(value);
    }
//End AMV_GUIDERow: method(s) of GUIDA

//AMV_GUIDERow: method(s) of seq @18-21682A02
    public TextField getSeqField() {
        return seq;
    }

    public String getSeq() {
        return seq.getValue();
    }

    public void setSeq(String value) {
        this.seq.setValue(value);
    }
//End AMV_GUIDERow: method(s) of seq

//AMV_GUIDERow: class tail @5-FCB6E20C
}
//End AMV_GUIDERow: class tail


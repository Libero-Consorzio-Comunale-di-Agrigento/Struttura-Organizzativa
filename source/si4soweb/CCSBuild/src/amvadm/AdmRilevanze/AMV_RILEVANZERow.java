//AMV_RILEVANZERow: import @5-FDC91A5C
package amvadm.AdmRilevanze;

import java.util.*;
import com.codecharge.db.*;
//End AMV_RILEVANZERow: import

//AMV_RILEVANZERow: class head @5-620440B4
public class AMV_RILEVANZERow {
//End AMV_RILEVANZERow: class head

//AMV_RILEVANZERow: declare fiels @5-F3FADE6A
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField IMPORTANZA = new TextField("IMPORTANZA", "IMPORTANZA");
    private TextField ZONA = new TextField("ZONA", "ZONA_DES");
    private LongField SEQUENZA = new LongField("SEQUENZA", "SEQUENZA");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_RILEVANZA");
    private TextField ID_RILEVANZA = new TextField("ID_RILEVANZA", "ID_RILEVANZA");
//End AMV_RILEVANZERow: declare fiels

//AMV_RILEVANZERow: constructor @5-C18D665F
    public AMV_RILEVANZERow() {
    }
//End AMV_RILEVANZERow: constructor

//AMV_RILEVANZERow: method(s) of NOME @9-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of NOME

//AMV_RILEVANZERow: method(s) of IMPORTANZA @10-B2F8E335
    public TextField getIMPORTANZAField() {
        return IMPORTANZA;
    }

    public String getIMPORTANZA() {
        return IMPORTANZA.getValue();
    }

    public void setIMPORTANZA(String value) {
        this.IMPORTANZA.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of IMPORTANZA

//AMV_RILEVANZERow: method(s) of ZONA @33-EEFA4AA2
    public TextField getZONAField() {
        return ZONA;
    }

    public String getZONA() {
        return ZONA.getValue();
    }

    public void setZONA(String value) {
        this.ZONA.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of ZONA

//AMV_RILEVANZERow: method(s) of SEQUENZA @11-E6112114
    public LongField getSEQUENZAField() {
        return SEQUENZA;
    }

    public Long getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(Long value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of SEQUENZA

//AMV_RILEVANZERow: method(s) of AFCNavigator @25-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of AFCNavigator

//AMV_RILEVANZERow: method(s) of ID @13-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of ID

//AMV_RILEVANZERow: method(s) of ID_RILEVANZA @13-57BC322F
    public TextField getID_RILEVANZAField() {
        return ID_RILEVANZA;
    }

    public String getID_RILEVANZA() {
        return ID_RILEVANZA.getValue();
    }

    public void setID_RILEVANZA(String value) {
        this.ID_RILEVANZA.setValue(value);
    }
//End AMV_RILEVANZERow: method(s) of ID_RILEVANZA

//AMV_RILEVANZERow: class tail @5-FCB6E20C
}
//End AMV_RILEVANZERow: class tail


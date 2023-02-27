//AMV_TIPOLOGIERow: import @7-5C42AE99
package amvadm.AdmTipologie;

import java.util.*;
import com.codecharge.db.*;
//End AMV_TIPOLOGIERow: import

//AMV_TIPOLOGIERow: class head @7-4D91B697
public class AMV_TIPOLOGIERow {
//End AMV_TIPOLOGIERow: class head

//AMV_TIPOLOGIERow: declare fiels @7-2519865A
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField ZONA = new TextField("ZONA", "ZONA_DES");
    private LongField SEQUENZA = new LongField("SEQUENZA", "SEQUENZA");
    private TextField IMMAGINE = new TextField("IMMAGINE", "IMMAGINE");
    private TextField LINK = new TextField("LINK", "LINK");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_TIPOLOGIA");
    private TextField ID_TIPOLOGIA = new TextField("ID_TIPOLOGIA", "ID_TIPOLOGIA");
//End AMV_TIPOLOGIERow: declare fiels

//AMV_TIPOLOGIERow: constructor @7-3905BF39
    public AMV_TIPOLOGIERow() {
    }
//End AMV_TIPOLOGIERow: constructor

//AMV_TIPOLOGIERow: method(s) of NOME @14-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of NOME

//AMV_TIPOLOGIERow: method(s) of ZONA @17-EEFA4AA2
    public TextField getZONAField() {
        return ZONA;
    }

    public String getZONA() {
        return ZONA.getValue();
    }

    public void setZONA(String value) {
        this.ZONA.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of ZONA

//AMV_TIPOLOGIERow: method(s) of SEQUENZA @18-E6112114
    public LongField getSEQUENZAField() {
        return SEQUENZA;
    }

    public Long getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(Long value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of SEQUENZA

//AMV_TIPOLOGIERow: method(s) of IMMAGINE @19-D0029DDF
    public TextField getIMMAGINEField() {
        return IMMAGINE;
    }

    public String getIMMAGINE() {
        return IMMAGINE.getValue();
    }

    public void setIMMAGINE(String value) {
        this.IMMAGINE.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of IMMAGINE

//AMV_TIPOLOGIERow: method(s) of LINK @20-E8490594
    public TextField getLINKField() {
        return LINK;
    }

    public String getLINK() {
        return LINK.getValue();
    }

    public void setLINK(String value) {
        this.LINK.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of LINK

//AMV_TIPOLOGIERow: method(s) of AFCNavigator @38-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of AFCNavigator

//AMV_TIPOLOGIERow: method(s) of ID @15-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of ID

//AMV_TIPOLOGIERow: method(s) of ID_TIPOLOGIA @15-3DFA78BA
    public TextField getID_TIPOLOGIAField() {
        return ID_TIPOLOGIA;
    }

    public String getID_TIPOLOGIA() {
        return ID_TIPOLOGIA.getValue();
    }

    public void setID_TIPOLOGIA(String value) {
        this.ID_TIPOLOGIA.setValue(value);
    }
//End AMV_TIPOLOGIERow: method(s) of ID_TIPOLOGIA

//AMV_TIPOLOGIERow: class tail @7-FCB6E20C
}
//End AMV_TIPOLOGIERow: class tail


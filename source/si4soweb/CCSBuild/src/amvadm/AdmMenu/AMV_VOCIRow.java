//AMV_VOCIRow: import @35-09534DEE
package amvadm.AdmMenu;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VOCIRow: import

//AMV_VOCIRow: class head @35-141E210B
public class AMV_VOCIRow {
//End AMV_VOCIRow: class head

//AMV_VOCIRow: declare fiels @35-E1CDB5A4
    private TextField VOCE_NEW = new TextField("VOCE_NEW", "VOCE");
    private TextField VOCE_OLD = new TextField("VOCE_OLD", "VOCE");
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField TIPO = new TextField("TIPO", "TIPO_LIST");
    private TextField STRINGA = new TextField("STRINGA", "STRINGA");
    private TextField MODULO = new TextField("MODULO", "MODULO");
    private TextField NOTE = new TextField("NOTE", "NOTE");
    private TextField VOCE_GUIDA = new TextField("VOCE_GUIDA", "VOCE_GUIDA");
    private TextField SM = new TextField("SM", "MODULO_SEL");
    private TextField PD = new TextField("PD", "");
    private TextField PADRE_OLD = new TextField("PADRE_OLD", "PADRE_OLD");
    private TextField SQ = new TextField("SQ", "");
    private TextField RUOLO = new TextField("RUOLO", "RUOLO_SEL");
    private TextField MVDIRUPLOAD = new TextField("MVDIRUPLOAD", "MVDIRUPLOAD");
    private TextField AB = new TextField("AB", "STATO_ABIL");
    private TextField Nuovo = new TextField("Nuovo", "NUOVO");
//End AMV_VOCIRow: declare fiels

//AMV_VOCIRow: constructor @35-919A7A34
    public AMV_VOCIRow() {
    }
//End AMV_VOCIRow: constructor

//AMV_VOCIRow: method(s) of VOCE_NEW @36-8FDE9FAC
    public TextField getVOCE_NEWField() {
        return VOCE_NEW;
    }

    public String getVOCE_NEW() {
        return VOCE_NEW.getValue();
    }

    public void setVOCE_NEW(String value) {
        this.VOCE_NEW.setValue(value);
    }
//End AMV_VOCIRow: method(s) of VOCE_NEW

//AMV_VOCIRow: method(s) of VOCE_OLD @37-724E51DB
    public TextField getVOCE_OLDField() {
        return VOCE_OLD;
    }

    public String getVOCE_OLD() {
        return VOCE_OLD.getValue();
    }

    public void setVOCE_OLD(String value) {
        this.VOCE_OLD.setValue(value);
    }
//End AMV_VOCIRow: method(s) of VOCE_OLD

//AMV_VOCIRow: method(s) of TITOLO @38-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_VOCIRow: method(s) of TITOLO

//AMV_VOCIRow: method(s) of TIPO @39-07D1E38D
    public TextField getTIPOField() {
        return TIPO;
    }

    public String getTIPO() {
        return TIPO.getValue();
    }

    public void setTIPO(String value) {
        this.TIPO.setValue(value);
    }
//End AMV_VOCIRow: method(s) of TIPO

//AMV_VOCIRow: method(s) of STRINGA @40-A3BF594E
    public TextField getSTRINGAField() {
        return STRINGA;
    }

    public String getSTRINGA() {
        return STRINGA.getValue();
    }

    public void setSTRINGA(String value) {
        this.STRINGA.setValue(value);
    }
//End AMV_VOCIRow: method(s) of STRINGA

//AMV_VOCIRow: method(s) of MODULO @146-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End AMV_VOCIRow: method(s) of MODULO

//AMV_VOCIRow: method(s) of NOTE @41-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End AMV_VOCIRow: method(s) of NOTE

//AMV_VOCIRow: method(s) of VOCE_GUIDA @42-66B7F9AF
    public TextField getVOCE_GUIDAField() {
        return VOCE_GUIDA;
    }

    public String getVOCE_GUIDA() {
        return VOCE_GUIDA.getValue();
    }

    public void setVOCE_GUIDA(String value) {
        this.VOCE_GUIDA.setValue(value);
    }
//End AMV_VOCIRow: method(s) of VOCE_GUIDA

//AMV_VOCIRow: method(s) of SM @45-F0BA6F30
    public TextField getSMField() {
        return SM;
    }

    public String getSM() {
        return SM.getValue();
    }

    public void setSM(String value) {
        this.SM.setValue(value);
    }
//End AMV_VOCIRow: method(s) of SM

//AMV_VOCIRow: method(s) of PD @49-079BDA6E
    public TextField getPDField() {
        return PD;
    }

    public String getPD() {
        return PD.getValue();
    }

    public void setPD(String value) {
        this.PD.setValue(value);
    }
//End AMV_VOCIRow: method(s) of PD

//AMV_VOCIRow: method(s) of PADRE_OLD @52-56C66C18
    public TextField getPADRE_OLDField() {
        return PADRE_OLD;
    }

    public String getPADRE_OLD() {
        return PADRE_OLD.getValue();
    }

    public void setPADRE_OLD(String value) {
        this.PADRE_OLD.setValue(value);
    }
//End AMV_VOCIRow: method(s) of PADRE_OLD

//AMV_VOCIRow: method(s) of SQ @53-A8F954D0
    public TextField getSQField() {
        return SQ;
    }

    public String getSQ() {
        return SQ.getValue();
    }

    public void setSQ(String value) {
        this.SQ.setValue(value);
    }
//End AMV_VOCIRow: method(s) of SQ

//AMV_VOCIRow: method(s) of RUOLO @142-E9232889
    public TextField getRUOLOField() {
        return RUOLO;
    }

    public String getRUOLO() {
        return RUOLO.getValue();
    }

    public void setRUOLO(String value) {
        this.RUOLO.setValue(value);
    }
//End AMV_VOCIRow: method(s) of RUOLO

//AMV_VOCIRow: method(s) of MVDIRUPLOAD @165-F2B923E5
    public TextField getMVDIRUPLOADField() {
        return MVDIRUPLOAD;
    }

    public String getMVDIRUPLOAD() {
        return MVDIRUPLOAD.getValue();
    }

    public void setMVDIRUPLOAD(String value) {
        this.MVDIRUPLOAD.setValue(value);
    }
//End AMV_VOCIRow: method(s) of MVDIRUPLOAD

//AMV_VOCIRow: method(s) of AB @54-83F8C351
    public TextField getABField() {
        return AB;
    }

    public String getAB() {
        return AB.getValue();
    }

    public void setAB(String value) {
        this.AB.setValue(value);
    }
//End AMV_VOCIRow: method(s) of AB

//AMV_VOCIRow: method(s) of Nuovo @55-42611BD0
    public TextField getNuovoField() {
        return Nuovo;
    }

    public String getNuovo() {
        return Nuovo.getValue();
    }

    public void setNuovo(String value) {
        this.Nuovo.setValue(value);
    }
//End AMV_VOCIRow: method(s) of Nuovo

//AMV_VOCIRow: class tail @35-FCB6E20C
}
//End AMV_VOCIRow: class tail


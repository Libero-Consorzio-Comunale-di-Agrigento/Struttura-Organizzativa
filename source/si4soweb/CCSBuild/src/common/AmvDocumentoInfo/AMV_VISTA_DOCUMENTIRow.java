//AMV_VISTA_DOCUMENTIRow: import @5-3C465CD9
package common.AmvDocumentoInfo;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTIRow: import

//AMV_VISTA_DOCUMENTIRow: class head @5-DC06F424
public class AMV_VISTA_DOCUMENTIRow {
//End AMV_VISTA_DOCUMENTIRow: class head

//AMV_VISTA_DOCUMENTIRow: declare fiels @5-6B3135EC
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField IMG_LINK = new TextField("IMG_LINK", "IMG_LINK");
    private TextField STORICO = new TextField("STORICO", "STORICO_SRC");
    private TextField REVISIONA = new TextField("REVISIONA", "REV_SRC");
    private TextField MODIFICA = new TextField("MODIFICA", "MOD_SRC");
    private TextField STATO = new TextField("STATO", "STATO");
    private DateField INIZIO_PUBBLICAZIONE = new DateField("INIZIO_PUBBLICAZIONE", "INIZIO_PUBBLICAZIONE");
    private TextField DSP_FINE_PUBBLICAZIONE = new TextField("DSP_FINE_PUBBLICAZIONE", "DSP_FINE_PUBBLICAZIONE");
    private DateField DATA_ULTIMA_MODIFICA = new DateField("DATA_ULTIMA_MODIFICA", "DATA_AGGIORNAMENTO");
    private TextField TESTO = new TextField("TESTO", "TESTO");
    private TextField ID = new TextField("ID", "ID_DOCUMENTO");
    private TextField ID_DOCUMENTO = new TextField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private TextField REV = new TextField("REV", "REVISIONE");
    private TextField REVISIONE = new TextField("REVISIONE", "REVISIONE");
    private TextField REV_HREF = new TextField("REV_HREF", "REV_HREF");
    private TextField MOD_HREF = new TextField("MOD_HREF", "MOD_HREF");
//End AMV_VISTA_DOCUMENTIRow: declare fiels

//AMV_VISTA_DOCUMENTIRow: constructor @5-EB403512
    public AMV_VISTA_DOCUMENTIRow() {
    }
//End AMV_VISTA_DOCUMENTIRow: constructor

//AMV_VISTA_DOCUMENTIRow: method(s) of TITOLO @23-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of TITOLO

//AMV_VISTA_DOCUMENTIRow: method(s) of IMG_LINK @30-606F1B7A
    public TextField getIMG_LINKField() {
        return IMG_LINK;
    }

    public String getIMG_LINK() {
        return IMG_LINK.getValue();
    }

    public void setIMG_LINK(String value) {
        this.IMG_LINK.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of IMG_LINK

//AMV_VISTA_DOCUMENTIRow: method(s) of STORICO @46-778DF9CA
    public TextField getSTORICOField() {
        return STORICO;
    }

    public String getSTORICO() {
        return STORICO.getValue();
    }

    public void setSTORICO(String value) {
        this.STORICO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of STORICO

//AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONA @32-0A7125F6
    public TextField getREVISIONAField() {
        return REVISIONA;
    }

    public String getREVISIONA() {
        return REVISIONA.getValue();
    }

    public void setREVISIONA(String value) {
        this.REVISIONA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONA

//AMV_VISTA_DOCUMENTIRow: method(s) of MODIFICA @24-EF108664
    public TextField getMODIFICAField() {
        return MODIFICA;
    }

    public String getMODIFICA() {
        return MODIFICA.getValue();
    }

    public void setMODIFICA(String value) {
        this.MODIFICA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of MODIFICA

//AMV_VISTA_DOCUMENTIRow: method(s) of STATO @49-B34568E8
    public TextField getSTATOField() {
        return STATO;
    }

    public String getSTATO() {
        return STATO.getValue();
    }

    public void setSTATO(String value) {
        this.STATO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of STATO

//AMV_VISTA_DOCUMENTIRow: method(s) of INIZIO_PUBBLICAZIONE @7-EA180E25
    public DateField getINIZIO_PUBBLICAZIONEField() {
        return INIZIO_PUBBLICAZIONE;
    }

    public Date getINIZIO_PUBBLICAZIONE() {
        return INIZIO_PUBBLICAZIONE.getValue();
    }

    public void setINIZIO_PUBBLICAZIONE(Date value) {
        this.INIZIO_PUBBLICAZIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of INIZIO_PUBBLICAZIONE

//AMV_VISTA_DOCUMENTIRow: method(s) of DSP_FINE_PUBBLICAZIONE @18-9116F0FA
    public TextField getDSP_FINE_PUBBLICAZIONEField() {
        return DSP_FINE_PUBBLICAZIONE;
    }

    public String getDSP_FINE_PUBBLICAZIONE() {
        return DSP_FINE_PUBBLICAZIONE.getValue();
    }

    public void setDSP_FINE_PUBBLICAZIONE(String value) {
        this.DSP_FINE_PUBBLICAZIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of DSP_FINE_PUBBLICAZIONE

//AMV_VISTA_DOCUMENTIRow: method(s) of DATA_ULTIMA_MODIFICA @8-C2A731F8
    public DateField getDATA_ULTIMA_MODIFICAField() {
        return DATA_ULTIMA_MODIFICA;
    }

    public Date getDATA_ULTIMA_MODIFICA() {
        return DATA_ULTIMA_MODIFICA.getValue();
    }

    public void setDATA_ULTIMA_MODIFICA(Date value) {
        this.DATA_ULTIMA_MODIFICA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of DATA_ULTIMA_MODIFICA

//AMV_VISTA_DOCUMENTIRow: method(s) of TESTO @12-BCA06F46
    public TextField getTESTOField() {
        return TESTO;
    }

    public String getTESTO() {
        return TESTO.getValue();
    }

    public void setTESTO(String value) {
        this.TESTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of TESTO

//AMV_VISTA_DOCUMENTIRow: method(s) of ID @33-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ID

//AMV_VISTA_DOCUMENTIRow: method(s) of ID_DOCUMENTO @33-0839CD9A
    public TextField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public String getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(String value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ID_DOCUMENTO

//AMV_VISTA_DOCUMENTIRow: method(s) of REV @34-E7377A02
    public TextField getREVField() {
        return REV;
    }

    public String getREV() {
        return REV.getValue();
    }

    public void setREV(String value) {
        this.REV.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of REV

//AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONE @34-DF4C75B7
    public TextField getREVISIONEField() {
        return REVISIONE;
    }

    public String getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(String value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONE

//AMV_VISTA_DOCUMENTIRow: method(s) of REV_HREF @REV_HREF-C6BE5031
    public TextField getREV_HREFField() {
        return REV_HREF;
    }

    public String getREV_HREF() {
        return REV_HREF.getValue();
    }

    public void setREV_HREF(String value) {
        this.REV_HREF.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of REV_HREF

//AMV_VISTA_DOCUMENTIRow: method(s) of MOD_HREF @MOD_HREF-F05648A4
    public TextField getMOD_HREFField() {
        return MOD_HREF;
    }

    public String getMOD_HREF() {
        return MOD_HREF.getValue();
    }

    public void setMOD_HREF(String value) {
        this.MOD_HREF.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of MOD_HREF

//AMV_VISTA_DOCUMENTIRow: class tail @5-FCB6E20C
}
//End AMV_VISTA_DOCUMENTIRow: class tail


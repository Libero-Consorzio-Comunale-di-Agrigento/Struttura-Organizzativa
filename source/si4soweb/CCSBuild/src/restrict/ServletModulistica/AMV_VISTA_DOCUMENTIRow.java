//AMV_VISTA_DOCUMENTIRow: import @9-33AB40BF
package restrict.ServletModulistica;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTIRow: import

//AMV_VISTA_DOCUMENTIRow: class head @9-DC06F424
public class AMV_VISTA_DOCUMENTIRow {
//End AMV_VISTA_DOCUMENTIRow: class head

//AMV_VISTA_DOCUMENTIRow: declare fiels @9-4C06CACD
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField MODIFICA = new TextField("MODIFICA", "MOD_SRC");
    private TextField STATO = new TextField("STATO", "STATO");
    private TextField COD_STATO = new TextField("COD_STATO", "COD_STATO");
    private DateField DATA_ULTIMA_MODIFICA = new DateField("DATA_ULTIMA_MODIFICA", "DATA_AGGIORNAMENTO");
    private TextField TESTO = new TextField("TESTO", "TESTO");
    private TextField ALLEGATI = new TextField("ALLEGATI", "ALLEGATI");
    private TextField ID = new TextField("ID", "ID_DOCUMENTO");
    private TextField ID_DOCUMENTO = new TextField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private TextField REV = new TextField("REV", "REVISIONE");
    private TextField REVISIONE = new TextField("REVISIONE", "REVISIONE");
    private TextField MOD_HREF = new TextField("MOD_HREF", "MOD_HREF");
//End AMV_VISTA_DOCUMENTIRow: declare fiels

//AMV_VISTA_DOCUMENTIRow: constructor @9-EB403512
    public AMV_VISTA_DOCUMENTIRow() {
    }
//End AMV_VISTA_DOCUMENTIRow: constructor

//AMV_VISTA_DOCUMENTIRow: method(s) of TITOLO @10-FB48796E
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

//AMV_VISTA_DOCUMENTIRow: method(s) of MODIFICA @16-EF108664
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

//AMV_VISTA_DOCUMENTIRow: method(s) of STATO @53-B34568E8
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

//AMV_VISTA_DOCUMENTIRow: method(s) of COD_STATO @87-4DCDB9A9
    public TextField getCOD_STATOField() {
        return COD_STATO;
    }

    public String getCOD_STATO() {
        return COD_STATO.getValue();
    }

    public void setCOD_STATO(String value) {
        this.COD_STATO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of COD_STATO

//AMV_VISTA_DOCUMENTIRow: method(s) of DATA_ULTIMA_MODIFICA @21-C2A731F8
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

//AMV_VISTA_DOCUMENTIRow: method(s) of TESTO @22-BCA06F46
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

//AMV_VISTA_DOCUMENTIRow: method(s) of ALLEGATI @23-E07BBA0E
    public TextField getALLEGATIField() {
        return ALLEGATI;
    }

    public String getALLEGATI() {
        return ALLEGATI.getValue();
    }

    public void setALLEGATI(String value) {
        this.ALLEGATI.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of ALLEGATI

//AMV_VISTA_DOCUMENTIRow: method(s) of ID @17-2B895796
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

//AMV_VISTA_DOCUMENTIRow: method(s) of ID_DOCUMENTO @17-0839CD9A
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

//AMV_VISTA_DOCUMENTIRow: method(s) of REV @18-E7377A02
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

//AMV_VISTA_DOCUMENTIRow: method(s) of REVISIONE @18-DF4C75B7
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

//AMV_VISTA_DOCUMENTIRow: class tail @9-FCB6E20C
}
//End AMV_VISTA_DOCUMENTIRow: class tail


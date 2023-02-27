//AMV_VISTA_DOCUMENTIRow: import @5-CA037FC9
package common.AmvRichieste;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTIRow: import

//AMV_VISTA_DOCUMENTIRow: class head @5-DC06F424
public class AMV_VISTA_DOCUMENTIRow {
//End AMV_VISTA_DOCUMENTIRow: class head

//AMV_VISTA_DOCUMENTIRow: declare fiels @5-0AA8E938
    private TextField ID_DOCUMENTO = new TextField("ID_DOCUMENTO", "ID_DOCUMENTO");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private TextField STATO_DOCUMENTO = new TextField("STATO_DOCUMENTO", "STATO_DOCUMENTO");
    private TextField FLUSSO = new TextField("FLUSSO", "FLUSSO");
    private TextField AUTORE = new TextField("AUTORE", "NOME_AUTORE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField HREF = new TextField("HREF", "HREF");
//End AMV_VISTA_DOCUMENTIRow: declare fiels

//AMV_VISTA_DOCUMENTIRow: constructor @5-EB403512
    public AMV_VISTA_DOCUMENTIRow() {
    }
//End AMV_VISTA_DOCUMENTIRow: constructor

//AMV_VISTA_DOCUMENTIRow: method(s) of ID_DOCUMENTO @84-0839CD9A
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

//AMV_VISTA_DOCUMENTIRow: method(s) of DATA_INSERIMENTO @85-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of DATA_INSERIMENTO

//AMV_VISTA_DOCUMENTIRow: method(s) of STATO_DOCUMENTO @67-F8075FDA
    public TextField getSTATO_DOCUMENTOField() {
        return STATO_DOCUMENTO;
    }

    public String getSTATO_DOCUMENTO() {
        return STATO_DOCUMENTO.getValue();
    }

    public void setSTATO_DOCUMENTO(String value) {
        this.STATO_DOCUMENTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of STATO_DOCUMENTO

//AMV_VISTA_DOCUMENTIRow: method(s) of FLUSSO @74-0D1AFCA0
    public TextField getFLUSSOField() {
        return FLUSSO;
    }

    public String getFLUSSO() {
        return FLUSSO.getValue();
    }

    public void setFLUSSO(String value) {
        this.FLUSSO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of FLUSSO

//AMV_VISTA_DOCUMENTIRow: method(s) of AUTORE @68-583F757A
    public TextField getAUTOREField() {
        return AUTORE;
    }

    public String getAUTORE() {
        return AUTORE.getValue();
    }

    public void setAUTORE(String value) {
        this.AUTORE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of AUTORE

//AMV_VISTA_DOCUMENTIRow: method(s) of AFCNavigator @66-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of AFCNavigator

//AMV_VISTA_DOCUMENTIRow: method(s) of HREF @HREF-E995E63C
    public TextField getHREFField() {
        return HREF;
    }

    public String getHREF() {
        return HREF.getValue();
    }

    public void setHREF(String value) {
        this.HREF.setValue(value);
    }
//End AMV_VISTA_DOCUMENTIRow: method(s) of HREF

//AMV_VISTA_DOCUMENTIRow: class tail @5-FCB6E20C
}
//End AMV_VISTA_DOCUMENTIRow: class tail


//AccessiDettaglioRow: import @41-9FB163C0
package amvadm.AdmAccessi;

import java.util.*;
import com.codecharge.db.*;
//End AccessiDettaglioRow: import

//AccessiDettaglioRow: class head @41-77758C2A
public class AccessiDettaglioRow {
//End AccessiDettaglioRow: class head

//AccessiDettaglioRow: declare fiels @41-3D9E74B6
    private DateField DATA_ACCESSO = new DateField("DATA_ACCESSO", "DATA_ACCESSO");
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField SESSIONE = new TextField("SESSIONE", "SESSIONE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField IDUTE = new TextField("IDUTE", "UTENTE");
    private TextField UTENTE = new TextField("UTENTE", "UTENTE");
//End AccessiDettaglioRow: declare fiels

//AccessiDettaglioRow: constructor @41-C0049501
    public AccessiDettaglioRow() {
    }
//End AccessiDettaglioRow: constructor

//AccessiDettaglioRow: method(s) of DATA_ACCESSO @43-7DDBB39D
    public DateField getDATA_ACCESSOField() {
        return DATA_ACCESSO;
    }

    public Date getDATA_ACCESSO() {
        return DATA_ACCESSO.getValue();
    }

    public void setDATA_ACCESSO(Date value) {
        this.DATA_ACCESSO.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of DATA_ACCESSO

//AccessiDettaglioRow: method(s) of NOMINATIVO @55-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of NOMINATIVO

//AccessiDettaglioRow: method(s) of SESSIONE @44-ACFA3B94
    public TextField getSESSIONEField() {
        return SESSIONE;
    }

    public String getSESSIONE() {
        return SESSIONE.getValue();
    }

    public void setSESSIONE(String value) {
        this.SESSIONE.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of SESSIONE

//AccessiDettaglioRow: method(s) of AFCNavigator @45-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of AFCNavigator

//AccessiDettaglioRow: method(s) of IDUTE @56-76C50423
    public TextField getIDUTEField() {
        return IDUTE;
    }

    public String getIDUTE() {
        return IDUTE.getValue();
    }

    public void setIDUTE(String value) {
        this.IDUTE.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of IDUTE

//AccessiDettaglioRow: method(s) of UTENTE @56-95517C36
    public TextField getUTENTEField() {
        return UTENTE;
    }

    public String getUTENTE() {
        return UTENTE.getValue();
    }

    public void setUTENTE(String value) {
        this.UTENTE.setValue(value);
    }
//End AccessiDettaglioRow: method(s) of UTENTE

//AccessiDettaglioRow: class tail @41-FCB6E20C
}
//End AccessiDettaglioRow: class tail


//AD4_RICHIESTE_SERVIZIORow: import @123-1F03BD27
package amvadm.AdmRichieste;

import java.util.*;
import com.codecharge.db.*;
//End AD4_RICHIESTE_SERVIZIORow: import

//AD4_RICHIESTE_SERVIZIORow: class head @123-530C5388
public class AD4_RICHIESTE_SERVIZIORow {
//End AD4_RICHIESTE_SERVIZIORow: class head

//AD4_RICHIESTE_SERVIZIORow: declare fiels @123-37F0764B
    private TextField DATA = new TextField("DATA", "DATA");
    private TextField AUTORE = new TextField("AUTORE", "AUTORE");
    private TextField INDIRIZZO_WEB = new TextField("INDIRIZZO_WEB", "INDIRIZZO_WEB");
    private TextField INDIRIZZO_NOTIFICA = new TextField("INDIRIZZO_NOTIFICA", "INDIRIZZO_NOTIFICA");
    private TextField NOTIFICATA = new TextField("NOTIFICATA", "NOTIFICATA");
    private TextField AZIENDA = new TextField("AZIENDA", "AZIENDA");
    private TextField APPROVA = new TextField("APPROVA", "APPROVA");
    private TextField RESPINGI = new TextField("RESPINGI", "RESPINGI");
    private TextField NOTIFICA = new TextField("NOTIFICA", "NOTIFICA");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID");
    private TextField AB = new TextField("AB", "ABILITAZIONE");
    private TextField ABILITAZIONE = new TextField("ABILITAZIONE", "ABILITAZIONE");
//End AD4_RICHIESTE_SERVIZIORow: declare fiels

//AD4_RICHIESTE_SERVIZIORow: constructor @123-A4680146
    public AD4_RICHIESTE_SERVIZIORow() {
    }
//End AD4_RICHIESTE_SERVIZIORow: constructor

//AD4_RICHIESTE_SERVIZIORow: method(s) of DATA @124-28E61A6F
    public TextField getDATAField() {
        return DATA;
    }

    public String getDATA() {
        return DATA.getValue();
    }

    public void setDATA(String value) {
        this.DATA.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of DATA

//AD4_RICHIESTE_SERVIZIORow: method(s) of AUTORE @125-583F757A
    public TextField getAUTOREField() {
        return AUTORE;
    }

    public String getAUTORE() {
        return AUTORE.getValue();
    }

    public void setAUTORE(String value) {
        this.AUTORE.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of AUTORE

//AD4_RICHIESTE_SERVIZIORow: method(s) of INDIRIZZO_WEB @126-F718DE73
    public TextField getINDIRIZZO_WEBField() {
        return INDIRIZZO_WEB;
    }

    public String getINDIRIZZO_WEB() {
        return INDIRIZZO_WEB.getValue();
    }

    public void setINDIRIZZO_WEB(String value) {
        this.INDIRIZZO_WEB.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of INDIRIZZO_WEB

//AD4_RICHIESTE_SERVIZIORow: method(s) of INDIRIZZO_NOTIFICA @127-A4148738
    public TextField getINDIRIZZO_NOTIFICAField() {
        return INDIRIZZO_NOTIFICA;
    }

    public String getINDIRIZZO_NOTIFICA() {
        return INDIRIZZO_NOTIFICA.getValue();
    }

    public void setINDIRIZZO_NOTIFICA(String value) {
        this.INDIRIZZO_NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of INDIRIZZO_NOTIFICA

//AD4_RICHIESTE_SERVIZIORow: method(s) of NOTIFICATA @162-2314858D
    public TextField getNOTIFICATAField() {
        return NOTIFICATA;
    }

    public String getNOTIFICATA() {
        return NOTIFICATA.getValue();
    }

    public void setNOTIFICATA(String value) {
        this.NOTIFICATA.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of NOTIFICATA

//AD4_RICHIESTE_SERVIZIORow: method(s) of AZIENDA @128-4D5AFBE6
    public TextField getAZIENDAField() {
        return AZIENDA;
    }

    public String getAZIENDA() {
        return AZIENDA.getValue();
    }

    public void setAZIENDA(String value) {
        this.AZIENDA.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of AZIENDA

//AD4_RICHIESTE_SERVIZIORow: method(s) of APPROVA @131-2F8C9C77
    public TextField getAPPROVAField() {
        return APPROVA;
    }

    public String getAPPROVA() {
        return APPROVA.getValue();
    }

    public void setAPPROVA(String value) {
        this.APPROVA.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of APPROVA

//AD4_RICHIESTE_SERVIZIORow: method(s) of RESPINGI @133-444E0FFE
    public TextField getRESPINGIField() {
        return RESPINGI;
    }

    public String getRESPINGI() {
        return RESPINGI.getValue();
    }

    public void setRESPINGI(String value) {
        this.RESPINGI.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of RESPINGI

//AD4_RICHIESTE_SERVIZIORow: method(s) of NOTIFICA @169-B4BB5F70
    public TextField getNOTIFICAField() {
        return NOTIFICA;
    }

    public String getNOTIFICA() {
        return NOTIFICA.getValue();
    }

    public void setNOTIFICA(String value) {
        this.NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of NOTIFICA

//AD4_RICHIESTE_SERVIZIORow: method(s) of AFCNavigator @166-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of AFCNavigator

//AD4_RICHIESTE_SERVIZIORow: method(s) of ID @132-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of ID

//AD4_RICHIESTE_SERVIZIORow: method(s) of AB @163-83F8C351
    public TextField getABField() {
        return AB;
    }

    public String getAB() {
        return AB.getValue();
    }

    public void setAB(String value) {
        this.AB.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of AB

//AD4_RICHIESTE_SERVIZIORow: method(s) of ABILITAZIONE @163-6F33EA59
    public TextField getABILITAZIONEField() {
        return ABILITAZIONE;
    }

    public String getABILITAZIONE() {
        return ABILITAZIONE.getValue();
    }

    public void setABILITAZIONE(String value) {
        this.ABILITAZIONE.setValue(value);
    }
//End AD4_RICHIESTE_SERVIZIORow: method(s) of ABILITAZIONE

//AD4_RICHIESTE_SERVIZIORow: class tail @123-FCB6E20C
}
//End AD4_RICHIESTE_SERVIZIORow: class tail


//AD4_RICHIESTE_ABILITAZIONEGridRow: import @30-3B54D52A
package amvadm.AdmRichiesta;

import java.util.*;
import com.codecharge.db.*;
//End AD4_RICHIESTE_ABILITAZIONEGridRow: import

//AD4_RICHIESTE_ABILITAZIONEGridRow: class head @30-094E16B9
public class AD4_RICHIESTE_ABILITAZIONEGridRow {
//End AD4_RICHIESTE_ABILITAZIONEGridRow: class head

//AD4_RICHIESTE_ABILITAZIONEGridRow: declare fiels @30-48722B30
    private TextField DATA = new TextField("DATA", "DATA");
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField RICHIEDENTE = new TextField("RICHIEDENTE", "RICHIEDENTE");
    private TextField UTENTE = new TextField("UTENTE", "UTENTE");
    private TextField STATO = new TextField("STATO", "STATO");
    private TextField COD_STATO = new TextField("COD_STATO", "COD_STATO");
    private TextField NOTIFICATA = new TextField("NOTIFICATA", "NOTIFICATA");
    private TextField COD_NOTIFICATA = new TextField("COD_NOTIFICATA", "COD_NOTIFICATA");
    private TextField TIPO_NOTIFICA = new TextField("TIPO_NOTIFICA", "TIPO_NOTIFICA");
    private TextField INDIRIZZO_NOTIFICA = new TextField("INDIRIZZO_NOTIFICA", "INDIRIZZO_NOTIFICA");
    private TextField MODIFICA_NOTIFICA = new TextField("MODIFICA_NOTIFICA", "");
//End AD4_RICHIESTE_ABILITAZIONEGridRow: declare fiels

//AD4_RICHIESTE_ABILITAZIONEGridRow: constructor @30-89A42282
    public AD4_RICHIESTE_ABILITAZIONEGridRow() {
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: constructor

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of DATA @57-28E61A6F
    public TextField getDATAField() {
        return DATA;
    }

    public String getDATA() {
        return DATA.getValue();
    }

    public void setDATA(String value) {
        this.DATA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of DATA

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of SERVIZIO @34-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of SERVIZIO

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of RICHIEDENTE @35-EB0830FD
    public TextField getRICHIEDENTEField() {
        return RICHIEDENTE;
    }

    public String getRICHIEDENTE() {
        return RICHIEDENTE.getValue();
    }

    public void setRICHIEDENTE(String value) {
        this.RICHIEDENTE.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of RICHIEDENTE

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of UTENTE @55-95517C36
    public TextField getUTENTEField() {
        return UTENTE;
    }

    public String getUTENTE() {
        return UTENTE.getValue();
    }

    public void setUTENTE(String value) {
        this.UTENTE.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of UTENTE

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of STATO @37-B34568E8
    public TextField getSTATOField() {
        return STATO;
    }

    public String getSTATO() {
        return STATO.getValue();
    }

    public void setSTATO(String value) {
        this.STATO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of STATO

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of COD_STATO @63-4DCDB9A9
    public TextField getCOD_STATOField() {
        return COD_STATO;
    }

    public String getCOD_STATO() {
        return COD_STATO.getValue();
    }

    public void setCOD_STATO(String value) {
        this.COD_STATO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of COD_STATO

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of NOTIFICATA @58-2314858D
    public TextField getNOTIFICATAField() {
        return NOTIFICATA;
    }

    public String getNOTIFICATA() {
        return NOTIFICATA.getValue();
    }

    public void setNOTIFICATA(String value) {
        this.NOTIFICATA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of NOTIFICATA

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of COD_NOTIFICATA @66-363ACF22
    public TextField getCOD_NOTIFICATAField() {
        return COD_NOTIFICATA;
    }

    public String getCOD_NOTIFICATA() {
        return COD_NOTIFICATA.getValue();
    }

    public void setCOD_NOTIFICATA(String value) {
        this.COD_NOTIFICATA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of COD_NOTIFICATA

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of TIPO_NOTIFICA @38-C59F1488
    public TextField getTIPO_NOTIFICAField() {
        return TIPO_NOTIFICA;
    }

    public String getTIPO_NOTIFICA() {
        return TIPO_NOTIFICA.getValue();
    }

    public void setTIPO_NOTIFICA(String value) {
        this.TIPO_NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of TIPO_NOTIFICA

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of INDIRIZZO_NOTIFICA @39-A4148738
    public TextField getINDIRIZZO_NOTIFICAField() {
        return INDIRIZZO_NOTIFICA;
    }

    public String getINDIRIZZO_NOTIFICA() {
        return INDIRIZZO_NOTIFICA.getValue();
    }

    public void setINDIRIZZO_NOTIFICA(String value) {
        this.INDIRIZZO_NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of INDIRIZZO_NOTIFICA

//AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of MODIFICA_NOTIFICA @51-C865D50A
    public TextField getMODIFICA_NOTIFICAField() {
        return MODIFICA_NOTIFICA;
    }

    public String getMODIFICA_NOTIFICA() {
        return MODIFICA_NOTIFICA.getValue();
    }

    public void setMODIFICA_NOTIFICA(String value) {
        this.MODIFICA_NOTIFICA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONEGridRow: method(s) of MODIFICA_NOTIFICA

//AD4_RICHIESTE_ABILITAZIONEGridRow: class tail @30-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEGridRow: class tail


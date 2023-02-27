//AD4_RICHIESTE_ABILITAZIONERow: import @30-1F03BD27
package amvadm.AdmRichieste;

import java.util.*;
import com.codecharge.db.*;
//End AD4_RICHIESTE_ABILITAZIONERow: import

//AD4_RICHIESTE_ABILITAZIONERow: class head @30-950869E7
public class AD4_RICHIESTE_ABILITAZIONERow {
//End AD4_RICHIESTE_ABILITAZIONERow: class head

//AD4_RICHIESTE_ABILITAZIONERow: declare fiels @30-C24F006E
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField ABILITAZIONE = new TextField("ABILITAZIONE", "ABILITAZIONE");
    private TextField LIVELLO = new TextField("LIVELLO", "LIVELLO");
    private TextField TOTALE_RICHIESTE = new TextField("TOTALE_RICHIESTE", "TOTALE_RICHIESTE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField MOD = new TextField("MOD", "MODULO");
    private TextField MODULO = new TextField("MODULO", "MODULO");
    private TextField IST = new TextField("IST", "ISTANZA");
    private TextField ISTANZA = new TextField("ISTANZA", "ISTANZA");
    private TextField STATO = new TextField("STATO", "STATO");
//End AD4_RICHIESTE_ABILITAZIONERow: declare fiels

//AD4_RICHIESTE_ABILITAZIONERow: constructor @30-56D91E9C
    public AD4_RICHIESTE_ABILITAZIONERow() {
    }
//End AD4_RICHIESTE_ABILITAZIONERow: constructor

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of SERVIZIO @37-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of SERVIZIO

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of ABILITAZIONE @165-6F33EA59
    public TextField getABILITAZIONEField() {
        return ABILITAZIONE;
    }

    public String getABILITAZIONE() {
        return ABILITAZIONE.getValue();
    }

    public void setABILITAZIONE(String value) {
        this.ABILITAZIONE.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of ABILITAZIONE

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of LIVELLO @102-E164E905
    public TextField getLIVELLOField() {
        return LIVELLO;
    }

    public String getLIVELLO() {
        return LIVELLO.getValue();
    }

    public void setLIVELLO(String value) {
        this.LIVELLO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of LIVELLO

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of TOTALE_RICHIESTE @39-77EA3C70
    public TextField getTOTALE_RICHIESTEField() {
        return TOTALE_RICHIESTE;
    }

    public String getTOTALE_RICHIESTE() {
        return TOTALE_RICHIESTE.getValue();
    }

    public void setTOTALE_RICHIESTE(String value) {
        this.TOTALE_RICHIESTE.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of TOTALE_RICHIESTE

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of AFCNavigator @168-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of AFCNavigator

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of MOD @38-FFCF0C85
    public TextField getMODField() {
        return MOD;
    }

    public String getMOD() {
        return MOD.getValue();
    }

    public void setMOD(String value) {
        this.MOD.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of MOD

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of MODULO @38-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of MODULO

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of IST @97-E152FA17
    public TextField getISTField() {
        return IST;
    }

    public String getIST() {
        return IST.getValue();
    }

    public void setIST(String value) {
        this.IST.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of IST

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of ISTANZA @97-CC23EEBF
    public TextField getISTANZAField() {
        return ISTANZA;
    }

    public String getISTANZA() {
        return ISTANZA.getValue();
    }

    public void setISTANZA(String value) {
        this.ISTANZA.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of ISTANZA

//AD4_RICHIESTE_ABILITAZIONERow: method(s) of STATO @122-B34568E8
    public TextField getSTATOField() {
        return STATO;
    }

    public String getSTATO() {
        return STATO.getValue();
    }

    public void setSTATO(String value) {
        this.STATO.setValue(value);
    }
//End AD4_RICHIESTE_ABILITAZIONERow: method(s) of STATO

//AD4_RICHIESTE_ABILITAZIONERow: class tail @30-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONERow: class tail


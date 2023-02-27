//AD4_RICHIESTE_FALLITERow: import @106-1F03BD27
package amvadm.AdmRichieste;

import java.util.*;
import com.codecharge.db.*;
//End AD4_RICHIESTE_FALLITERow: import

//AD4_RICHIESTE_FALLITERow: class head @106-150E15DE
public class AD4_RICHIESTE_FALLITERow {
//End AD4_RICHIESTE_FALLITERow: class head

//AD4_RICHIESTE_FALLITERow: declare fiels @106-E3013DB3
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField LIVELLO = new TextField("LIVELLO", "LIVELLO");
    private TextField TOTALE_RICHIESTE = new TextField("TOTALE_RICHIESTE", "TOTALE_RICHIESTE");
    private TextField AmountRecords = new TextField("AmountRecords", "");
    private TextField MOD = new TextField("MOD", "MODULO");
    private TextField MODULO = new TextField("MODULO", "MODULO");
    private TextField IST = new TextField("IST", "ISTANZA");
    private TextField ISTANZA = new TextField("ISTANZA", "ISTANZA");
//End AD4_RICHIESTE_FALLITERow: declare fiels

//AD4_RICHIESTE_FALLITERow: constructor @106-BF25D5C4
    public AD4_RICHIESTE_FALLITERow() {
    }
//End AD4_RICHIESTE_FALLITERow: constructor

//AD4_RICHIESTE_FALLITERow: method(s) of SERVIZIO @-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of SERVIZIO

//AD4_RICHIESTE_FALLITERow: method(s) of LIVELLO @-E164E905
    public TextField getLIVELLOField() {
        return LIVELLO;
    }

    public String getLIVELLO() {
        return LIVELLO.getValue();
    }

    public void setLIVELLO(String value) {
        this.LIVELLO.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of LIVELLO

//AD4_RICHIESTE_FALLITERow: method(s) of TOTALE_RICHIESTE @-77EA3C70
    public TextField getTOTALE_RICHIESTEField() {
        return TOTALE_RICHIESTE;
    }

    public String getTOTALE_RICHIESTE() {
        return TOTALE_RICHIESTE.getValue();
    }

    public void setTOTALE_RICHIESTE(String value) {
        this.TOTALE_RICHIESTE.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of TOTALE_RICHIESTE

//AD4_RICHIESTE_FALLITERow: method(s) of AmountRecords @-2D61E1BB
    public TextField getAmountRecordsField() {
        return AmountRecords;
    }

    public String getAmountRecords() {
        return AmountRecords.getValue();
    }

    public void setAmountRecords(String value) {
        this.AmountRecords.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of AmountRecords

//AD4_RICHIESTE_FALLITERow: method(s) of MOD @-FFCF0C85
    public TextField getMODField() {
        return MOD;
    }

    public String getMOD() {
        return MOD.getValue();
    }

    public void setMOD(String value) {
        this.MOD.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of MOD

//AD4_RICHIESTE_FALLITERow: method(s) of MODULO @-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of MODULO

//AD4_RICHIESTE_FALLITERow: method(s) of IST @-E152FA17
    public TextField getISTField() {
        return IST;
    }

    public String getIST() {
        return IST.getValue();
    }

    public void setIST(String value) {
        this.IST.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of IST

//AD4_RICHIESTE_FALLITERow: method(s) of ISTANZA @-CC23EEBF
    public TextField getISTANZAField() {
        return ISTANZA;
    }

    public String getISTANZA() {
        return ISTANZA.getValue();
    }

    public void setISTANZA(String value) {
        this.ISTANZA.setValue(value);
    }
//End AD4_RICHIESTE_FALLITERow: method(s) of ISTANZA

//AD4_RICHIESTE_FALLITERow: class tail @106-FCB6E20C
}
//End AD4_RICHIESTE_FALLITERow: class tail


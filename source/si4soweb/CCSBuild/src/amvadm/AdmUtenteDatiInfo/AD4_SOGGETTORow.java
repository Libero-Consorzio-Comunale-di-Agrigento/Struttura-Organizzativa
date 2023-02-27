//AD4_SOGGETTORow: import @87-E30E135C
package amvadm.AdmUtenteDatiInfo;

import java.util.*;
import com.codecharge.db.*;
//End AD4_SOGGETTORow: import

//AD4_SOGGETTORow: class head @87-CFBF638E
public class AD4_SOGGETTORow {
//End AD4_SOGGETTORow: class head

//AD4_SOGGETTORow: declare fiels @87-63265FD1
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "");
    private TextField COGNOME = new TextField("COGNOME", "");
    private TextField NOME = new TextField("NOME", "");
    private TextField SESSO = new TextField("SESSO", "");
    private DateField DATA_NASCITA = new DateField("DATA_NASCITA", "");
    private LongField STATO_NASCITA = new LongField("STATO_NASCITA", "");
    private LongField PROVINCIA_NASCITA = new LongField("PROVINCIA_NASCITA", "");
    private LongField COMUNE_NASCITA = new LongField("COMUNE_NASCITA", "");
    private TextField CODICE_FISCALE = new TextField("CODICE_FISCALE", "");
    private TextField RR = new TextField("RR", "");
//End AD4_SOGGETTORow: declare fiels

//AD4_SOGGETTORow: constructor @87-B46970B5
    public AD4_SOGGETTORow() {
    }
//End AD4_SOGGETTORow: constructor

//AD4_SOGGETTORow: method(s) of NOMINATIVO @-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of NOMINATIVO

//AD4_SOGGETTORow: method(s) of COGNOME @-393F9325
    public TextField getCOGNOMEField() {
        return COGNOME;
    }

    public String getCOGNOME() {
        return COGNOME.getValue();
    }

    public void setCOGNOME(String value) {
        this.COGNOME.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of COGNOME

//AD4_SOGGETTORow: method(s) of NOME @-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of NOME

//AD4_SOGGETTORow: method(s) of SESSO @-A1140636
    public TextField getSESSOField() {
        return SESSO;
    }

    public String getSESSO() {
        return SESSO.getValue();
    }

    public void setSESSO(String value) {
        this.SESSO.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of SESSO

//AD4_SOGGETTORow: method(s) of DATA_NASCITA @-71A7627E
    public DateField getDATA_NASCITAField() {
        return DATA_NASCITA;
    }

    public Date getDATA_NASCITA() {
        return DATA_NASCITA.getValue();
    }

    public void setDATA_NASCITA(Date value) {
        this.DATA_NASCITA.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of DATA_NASCITA

//AD4_SOGGETTORow: method(s) of STATO_NASCITA @-0CE8703E
    public LongField getSTATO_NASCITAField() {
        return STATO_NASCITA;
    }

    public Long getSTATO_NASCITA() {
        return STATO_NASCITA.getValue();
    }

    public void setSTATO_NASCITA(Long value) {
        this.STATO_NASCITA.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of STATO_NASCITA

//AD4_SOGGETTORow: method(s) of PROVINCIA_NASCITA @-0DE43F33
    public LongField getPROVINCIA_NASCITAField() {
        return PROVINCIA_NASCITA;
    }

    public Long getPROVINCIA_NASCITA() {
        return PROVINCIA_NASCITA.getValue();
    }

    public void setPROVINCIA_NASCITA(Long value) {
        this.PROVINCIA_NASCITA.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of PROVINCIA_NASCITA

//AD4_SOGGETTORow: method(s) of COMUNE_NASCITA @-A19DA35E
    public LongField getCOMUNE_NASCITAField() {
        return COMUNE_NASCITA;
    }

    public Long getCOMUNE_NASCITA() {
        return COMUNE_NASCITA.getValue();
    }

    public void setCOMUNE_NASCITA(Long value) {
        this.COMUNE_NASCITA.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of COMUNE_NASCITA

//AD4_SOGGETTORow: method(s) of CODICE_FISCALE @-3FE2CCFC
    public TextField getCODICE_FISCALEField() {
        return CODICE_FISCALE;
    }

    public String getCODICE_FISCALE() {
        return CODICE_FISCALE.getValue();
    }

    public void setCODICE_FISCALE(String value) {
        this.CODICE_FISCALE.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of CODICE_FISCALE

//AD4_SOGGETTORow: method(s) of RR @-9D393128
    public TextField getRRField() {
        return RR;
    }

    public String getRR() {
        return RR.getValue();
    }

    public void setRR(String value) {
        this.RR.setValue(value);
    }
//End AD4_SOGGETTORow: method(s) of RR

//AD4_SOGGETTORow: class tail @87-FCB6E20C
}
//End AD4_SOGGETTORow: class tail


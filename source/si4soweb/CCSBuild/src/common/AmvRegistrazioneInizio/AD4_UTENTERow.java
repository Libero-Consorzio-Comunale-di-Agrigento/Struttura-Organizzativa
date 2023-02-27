//AD4_UTENTERow: import @50-6FE36575
package common.AmvRegistrazioneInizio;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTERow: import

//AD4_UTENTERow: class head @50-1D90A030
public class AD4_UTENTERow {
//End AD4_UTENTERow: class head

//AD4_UTENTERow: declare fiels @50-63265FD1
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
//End AD4_UTENTERow: declare fiels

//AD4_UTENTERow: constructor @50-F4EC37D7
    public AD4_UTENTERow() {
    }
//End AD4_UTENTERow: constructor

//AD4_UTENTERow: method(s) of NOMINATIVO @56-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AD4_UTENTERow: method(s) of NOMINATIVO

//AD4_UTENTERow: method(s) of COGNOME @57-393F9325
    public TextField getCOGNOMEField() {
        return COGNOME;
    }

    public String getCOGNOME() {
        return COGNOME.getValue();
    }

    public void setCOGNOME(String value) {
        this.COGNOME.setValue(value);
    }
//End AD4_UTENTERow: method(s) of COGNOME

//AD4_UTENTERow: method(s) of NOME @58-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AD4_UTENTERow: method(s) of NOME

//AD4_UTENTERow: method(s) of SESSO @59-A1140636
    public TextField getSESSOField() {
        return SESSO;
    }

    public String getSESSO() {
        return SESSO.getValue();
    }

    public void setSESSO(String value) {
        this.SESSO.setValue(value);
    }
//End AD4_UTENTERow: method(s) of SESSO

//AD4_UTENTERow: method(s) of DATA_NASCITA @60-71A7627E
    public DateField getDATA_NASCITAField() {
        return DATA_NASCITA;
    }

    public Date getDATA_NASCITA() {
        return DATA_NASCITA.getValue();
    }

    public void setDATA_NASCITA(Date value) {
        this.DATA_NASCITA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of DATA_NASCITA

//AD4_UTENTERow: method(s) of STATO_NASCITA @73-0CE8703E
    public LongField getSTATO_NASCITAField() {
        return STATO_NASCITA;
    }

    public Long getSTATO_NASCITA() {
        return STATO_NASCITA.getValue();
    }

    public void setSTATO_NASCITA(Long value) {
        this.STATO_NASCITA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of STATO_NASCITA

//AD4_UTENTERow: method(s) of PROVINCIA_NASCITA @61-0DE43F33
    public LongField getPROVINCIA_NASCITAField() {
        return PROVINCIA_NASCITA;
    }

    public Long getPROVINCIA_NASCITA() {
        return PROVINCIA_NASCITA.getValue();
    }

    public void setPROVINCIA_NASCITA(Long value) {
        this.PROVINCIA_NASCITA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of PROVINCIA_NASCITA

//AD4_UTENTERow: method(s) of COMUNE_NASCITA @62-A19DA35E
    public LongField getCOMUNE_NASCITAField() {
        return COMUNE_NASCITA;
    }

    public Long getCOMUNE_NASCITA() {
        return COMUNE_NASCITA.getValue();
    }

    public void setCOMUNE_NASCITA(Long value) {
        this.COMUNE_NASCITA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of COMUNE_NASCITA

//AD4_UTENTERow: method(s) of CODICE_FISCALE @63-3FE2CCFC
    public TextField getCODICE_FISCALEField() {
        return CODICE_FISCALE;
    }

    public String getCODICE_FISCALE() {
        return CODICE_FISCALE.getValue();
    }

    public void setCODICE_FISCALE(String value) {
        this.CODICE_FISCALE.setValue(value);
    }
//End AD4_UTENTERow: method(s) of CODICE_FISCALE

//AD4_UTENTERow: method(s) of RR @110-9D393128
    public TextField getRRField() {
        return RR;
    }

    public String getRR() {
        return RR.getValue();
    }

    public void setRR(String value) {
        this.RR.setValue(value);
    }
//End AD4_UTENTERow: method(s) of RR

//AD4_UTENTERow: class tail @50-FCB6E20C
}
//End AD4_UTENTERow: class tail


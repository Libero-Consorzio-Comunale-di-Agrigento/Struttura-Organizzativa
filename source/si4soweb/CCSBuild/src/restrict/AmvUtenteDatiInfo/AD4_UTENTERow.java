//AD4_UTENTERow: import @6-8735B5A9
package restrict.AmvUtenteDatiInfo;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTERow: import

//AD4_UTENTERow: class head @6-1D90A030
public class AD4_UTENTERow {
//End AD4_UTENTERow: class head

//AD4_UTENTERow: declare fiels @6-5037C8EA
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField SESSO = new TextField("SESSO", "SESSO");
    private TextField CODICE_FISCALE = new TextField("CODICE_FISCALE", "CODICE_FISCALE");
    private TextField DATA_NASCITA = new TextField("DATA_NASCITA", "DATA_NASCITA");
    private TextField DES_COMUNE_NAS = new TextField("DES_COMUNE_NAS", "DES_COMUNE_NAS");
    private TextField DES_PROVINCIA_NAS = new TextField("DES_PROVINCIA_NAS", "DES_PROVINCIA_NAS");
    private TextField INDIRIZZO_COMPLETO = new TextField("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO");
    private TextField MVPAGES = new TextField("MVPAGES", "MVPAGES");
//End AD4_UTENTERow: declare fiels

//AD4_UTENTERow: constructor @6-F4EC37D7
    public AD4_UTENTERow() {
    }
//End AD4_UTENTERow: constructor

//AD4_UTENTERow: method(s) of NOME @7-DBA8086C
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

//AD4_UTENTERow: method(s) of SESSO @8-A1140636
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

//AD4_UTENTERow: method(s) of CODICE_FISCALE @38-3FE2CCFC
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

//AD4_UTENTERow: method(s) of DATA_NASCITA @10-2B992BC2
    public TextField getDATA_NASCITAField() {
        return DATA_NASCITA;
    }

    public String getDATA_NASCITA() {
        return DATA_NASCITA.getValue();
    }

    public void setDATA_NASCITA(String value) {
        this.DATA_NASCITA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of DATA_NASCITA

//AD4_UTENTERow: method(s) of DES_COMUNE_NAS @11-3656702C
    public TextField getDES_COMUNE_NASField() {
        return DES_COMUNE_NAS;
    }

    public String getDES_COMUNE_NAS() {
        return DES_COMUNE_NAS.getValue();
    }

    public void setDES_COMUNE_NAS(String value) {
        this.DES_COMUNE_NAS.setValue(value);
    }
//End AD4_UTENTERow: method(s) of DES_COMUNE_NAS

//AD4_UTENTERow: method(s) of DES_PROVINCIA_NAS @12-33748940
    public TextField getDES_PROVINCIA_NASField() {
        return DES_PROVINCIA_NAS;
    }

    public String getDES_PROVINCIA_NAS() {
        return DES_PROVINCIA_NAS.getValue();
    }

    public void setDES_PROVINCIA_NAS(String value) {
        this.DES_PROVINCIA_NAS.setValue(value);
    }
//End AD4_UTENTERow: method(s) of DES_PROVINCIA_NAS

//AD4_UTENTERow: method(s) of INDIRIZZO_COMPLETO @50-92DA0D53
    public TextField getINDIRIZZO_COMPLETOField() {
        return INDIRIZZO_COMPLETO;
    }

    public String getINDIRIZZO_COMPLETO() {
        return INDIRIZZO_COMPLETO.getValue();
    }

    public void setINDIRIZZO_COMPLETO(String value) {
        this.INDIRIZZO_COMPLETO.setValue(value);
    }
//End AD4_UTENTERow: method(s) of INDIRIZZO_COMPLETO

//AD4_UTENTERow: method(s) of MVPAGES @51-59C95F0B
    public TextField getMVPAGESField() {
        return MVPAGES;
    }

    public String getMVPAGES() {
        return MVPAGES.getValue();
    }

    public void setMVPAGES(String value) {
        this.MVPAGES.setValue(value);
    }
//End AD4_UTENTERow: method(s) of MVPAGES

//AD4_UTENTERow: class tail @6-FCB6E20C
}
//End AD4_UTENTERow: class tail


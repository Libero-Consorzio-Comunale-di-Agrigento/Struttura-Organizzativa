//AD4_UTENTERow: import @14-794C3E24
package common.AmvRegistrazioneAzienda;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTERow: import

//AD4_UTENTERow: class head @14-1D90A030
public class AD4_UTENTERow {
//End AD4_UTENTERow: class head

//AD4_UTENTERow: declare fiels @14-9E413F18
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField RS_AZIENDA = new TextField("RS_AZIENDA", "");
    private TextField CF_AZIENDA = new TextField("CF_AZIENDA", "");
    private TextField MVPAGES = new TextField("MVPAGES", "REDIRECTION");
//End AD4_UTENTERow: declare fiels

//AD4_UTENTERow: constructor @14-F4EC37D7
    public AD4_UTENTERow() {
    }
//End AD4_UTENTERow: constructor

//AD4_UTENTERow: method(s) of NOMINATIVO @15-3BDE962A
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

//AD4_UTENTERow: method(s) of SERVIZIO @16-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End AD4_UTENTERow: method(s) of SERVIZIO

//AD4_UTENTERow: method(s) of RS_AZIENDA @51-CD6D724B
    public TextField getRS_AZIENDAField() {
        return RS_AZIENDA;
    }

    public String getRS_AZIENDA() {
        return RS_AZIENDA.getValue();
    }

    public void setRS_AZIENDA(String value) {
        this.RS_AZIENDA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of RS_AZIENDA

//AD4_UTENTERow: method(s) of CF_AZIENDA @18-70E477EB
    public TextField getCF_AZIENDAField() {
        return CF_AZIENDA;
    }

    public String getCF_AZIENDA() {
        return CF_AZIENDA.getValue();
    }

    public void setCF_AZIENDA(String value) {
        this.CF_AZIENDA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of CF_AZIENDA

//AD4_UTENTERow: method(s) of MVPAGES @27-59C95F0B
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

//AD4_UTENTERow: class tail @14-FCB6E20C
}
//End AD4_UTENTERow: class tail


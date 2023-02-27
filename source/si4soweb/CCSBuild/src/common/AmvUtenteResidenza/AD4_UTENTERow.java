//AD4_UTENTERow: import @6-E41E8C25
package common.AmvUtenteResidenza;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTERow: import

//AD4_UTENTERow: class head @6-1D90A030
public class AD4_UTENTERow {
//End AD4_UTENTERow: class head

//AD4_UTENTERow: declare fiels @6-23CEB8CD
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOME");
    private TextField INDIRIZZO_COMPLETO = new TextField("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO");
    private TextField VIA = new TextField("VIA", "");
    private TextField INDIRIZZO = new TextField("INDIRIZZO", "");
    private TextField NUM = new TextField("NUM", "");
    private LongField PROVINCIA = new LongField("PROVINCIA", "");
    private LongField COMUNE = new LongField("COMUNE", "");
    private TextField CAP = new TextField("CAP", "");
    private TextField MVPAGES = new TextField("MVPAGES", "MVPAGES");
//End AD4_UTENTERow: declare fiels

//AD4_UTENTERow: constructor @6-F4EC37D7
    public AD4_UTENTERow() {
    }
//End AD4_UTENTERow: constructor

//AD4_UTENTERow: method(s) of NOMINATIVO @47-3BDE962A
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

//AD4_UTENTERow: method(s) of INDIRIZZO_COMPLETO @48-92DA0D53
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

//AD4_UTENTERow: method(s) of VIA @14-09F721F0
    public TextField getVIAField() {
        return VIA;
    }

    public String getVIA() {
        return VIA.getValue();
    }

    public void setVIA(String value) {
        this.VIA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of VIA

//AD4_UTENTERow: method(s) of INDIRIZZO @15-79B8981C
    public TextField getINDIRIZZOField() {
        return INDIRIZZO;
    }

    public String getINDIRIZZO() {
        return INDIRIZZO.getValue();
    }

    public void setINDIRIZZO(String value) {
        this.INDIRIZZO.setValue(value);
    }
//End AD4_UTENTERow: method(s) of INDIRIZZO

//AD4_UTENTERow: method(s) of NUM @16-54D4C21D
    public TextField getNUMField() {
        return NUM;
    }

    public String getNUM() {
        return NUM.getValue();
    }

    public void setNUM(String value) {
        this.NUM.setValue(value);
    }
//End AD4_UTENTERow: method(s) of NUM

//AD4_UTENTERow: method(s) of PROVINCIA @17-A3592314
    public LongField getPROVINCIAField() {
        return PROVINCIA;
    }

    public Long getPROVINCIA() {
        return PROVINCIA.getValue();
    }

    public void setPROVINCIA(Long value) {
        this.PROVINCIA.setValue(value);
    }
//End AD4_UTENTERow: method(s) of PROVINCIA

//AD4_UTENTERow: method(s) of COMUNE @18-532A21D6
    public LongField getCOMUNEField() {
        return COMUNE;
    }

    public Long getCOMUNE() {
        return COMUNE.getValue();
    }

    public void setCOMUNE(Long value) {
        this.COMUNE.setValue(value);
    }
//End AD4_UTENTERow: method(s) of COMUNE

//AD4_UTENTERow: method(s) of CAP @21-CDFF7BC8
    public TextField getCAPField() {
        return CAP;
    }

    public String getCAP() {
        return CAP.getValue();
    }

    public void setCAP(String value) {
        this.CAP.setValue(value);
    }
//End AD4_UTENTERow: method(s) of CAP

//AD4_UTENTERow: method(s) of MVPAGES @52-59C95F0B
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


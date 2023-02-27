//AD4_UTENTIRow: import @6-9EF3235C
package common.AmvUtenteRecapito;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @6-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @6-0DC3E370
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOME");
    private TextField INDIRIZZO_WEB = new TextField("INDIRIZZO_WEB", "INDIRIZZO_WEB");
    private TextField TELEFONO = new TextField("TELEFONO", "TELEFONO");
    private TextField FAX = new TextField("FAX", "FAX");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @6-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOMINATIVO @35-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NOMINATIVO

//AD4_UTENTIRow: method(s) of INDIRIZZO_WEB @22-F718DE73
    public TextField getINDIRIZZO_WEBField() {
        return INDIRIZZO_WEB;
    }

    public String getINDIRIZZO_WEB() {
        return INDIRIZZO_WEB.getValue();
    }

    public void setINDIRIZZO_WEB(String value) {
        this.INDIRIZZO_WEB.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of INDIRIZZO_WEB

//AD4_UTENTIRow: method(s) of TELEFONO @23-E71ADE24
    public TextField getTELEFONOField() {
        return TELEFONO;
    }

    public String getTELEFONO() {
        return TELEFONO.getValue();
    }

    public void setTELEFONO(String value) {
        this.TELEFONO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of TELEFONO

//AD4_UTENTIRow: method(s) of FAX @24-AF87E71F
    public TextField getFAXField() {
        return FAX;
    }

    public String getFAX() {
        return FAX.getValue();
    }

    public void setFAX(String value) {
        this.FAX.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of FAX

//AD4_UTENTIRow: class tail @6-FCB6E20C
}
//End AD4_UTENTIRow: class tail


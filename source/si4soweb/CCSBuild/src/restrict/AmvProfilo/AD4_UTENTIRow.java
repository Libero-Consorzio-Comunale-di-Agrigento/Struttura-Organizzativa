//AD4_UTENTIRow: import @6-EC145828
package restrict.AmvProfilo;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @6-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @6-CA20DE05
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField RUOLO = new TextField("RUOLO", "RUOLO");
    private TextField DATA_PASSWORD = new TextField("DATA_PASSWORD", "DATA_PASSWORD");
    private TextField RINNOVO_PASSWORD_PORTALE = new TextField("RINNOVO_PASSWORD_PORTALE", "RINNOVO_PASSWORD_PORTALE");
    private TextField RINNOVO_PASSWORD = new TextField("RINNOVO_PASSWORD", "RINNOVO_PASSWORD");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @6-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOMINATIVO @7-3BDE962A
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

//AD4_UTENTIRow: method(s) of RUOLO @36-E9232889
    public TextField getRUOLOField() {
        return RUOLO;
    }

    public String getRUOLO() {
        return RUOLO.getValue();
    }

    public void setRUOLO(String value) {
        this.RUOLO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of RUOLO

//AD4_UTENTIRow: method(s) of DATA_PASSWORD @8-0483A8D6
    public TextField getDATA_PASSWORDField() {
        return DATA_PASSWORD;
    }

    public String getDATA_PASSWORD() {
        return DATA_PASSWORD.getValue();
    }

    public void setDATA_PASSWORD(String value) {
        this.DATA_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DATA_PASSWORD

//AD4_UTENTIRow: method(s) of RINNOVO_PASSWORD_PORTALE @40-F70DE2D2
    public TextField getRINNOVO_PASSWORD_PORTALEField() {
        return RINNOVO_PASSWORD_PORTALE;
    }

    public String getRINNOVO_PASSWORD_PORTALE() {
        return RINNOVO_PASSWORD_PORTALE.getValue();
    }

    public void setRINNOVO_PASSWORD_PORTALE(String value) {
        this.RINNOVO_PASSWORD_PORTALE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of RINNOVO_PASSWORD_PORTALE

//AD4_UTENTIRow: method(s) of RINNOVO_PASSWORD @38-280CE65F
    public TextField getRINNOVO_PASSWORDField() {
        return RINNOVO_PASSWORD;
    }

    public String getRINNOVO_PASSWORD() {
        return RINNOVO_PASSWORD.getValue();
    }

    public void setRINNOVO_PASSWORD(String value) {
        this.RINNOVO_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of RINNOVO_PASSWORD

//AD4_UTENTIRow: class tail @6-FCB6E20C
}
//End AD4_UTENTIRow: class tail


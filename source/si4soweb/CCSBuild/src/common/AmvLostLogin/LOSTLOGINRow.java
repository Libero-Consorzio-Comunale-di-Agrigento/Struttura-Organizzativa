//LOSTLOGINRow: import @6-1AEB91B0
package common.AmvLostLogin;

import java.util.*;
import com.codecharge.db.*;
//End LOSTLOGINRow: import

//LOSTLOGINRow: class head @6-74C32203
public class LOSTLOGINRow {
//End LOSTLOGINRow: class head

//LOSTLOGINRow: declare fiels @6-61C85323
    private TextField COGNOME = new TextField("COGNOME", "");
    private TextField NOME = new TextField("NOME", "");
    private TextField EMAIL = new TextField("EMAIL", "");
//End LOSTLOGINRow: declare fiels

//LOSTLOGINRow: constructor @6-C6490905
    public LOSTLOGINRow() {
    }
//End LOSTLOGINRow: constructor

//LOSTLOGINRow: method(s) of COGNOME @10-393F9325
    public TextField getCOGNOMEField() {
        return COGNOME;
    }

    public String getCOGNOME() {
        return COGNOME.getValue();
    }

    public void setCOGNOME(String value) {
        this.COGNOME.setValue(value);
    }
//End LOSTLOGINRow: method(s) of COGNOME

//LOSTLOGINRow: method(s) of NOME @11-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End LOSTLOGINRow: method(s) of NOME

//LOSTLOGINRow: method(s) of EMAIL @12-FE913298
    public TextField getEMAILField() {
        return EMAIL;
    }

    public String getEMAIL() {
        return EMAIL.getValue();
    }

    public void setEMAIL(String value) {
        this.EMAIL.setValue(value);
    }
//End LOSTLOGINRow: method(s) of EMAIL

//LOSTLOGINRow: class tail @6-FCB6E20C
}
//End LOSTLOGINRow: class tail


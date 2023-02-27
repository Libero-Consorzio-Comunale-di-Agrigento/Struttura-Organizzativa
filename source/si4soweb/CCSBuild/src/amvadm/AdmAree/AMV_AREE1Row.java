//AMV_AREE1Row: import @11-F2523B18
package amvadm.AdmAree;

import java.util.*;
import com.codecharge.db.*;
//End AMV_AREE1Row: import

//AMV_AREE1Row: class head @11-DB4DEEB6
public class AMV_AREE1Row {
//End AMV_AREE1Row: class head

//AMV_AREE1Row: declare fiels @11-241F0D17
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private LongField ID_AREA = new LongField("ID_AREA", "ID_AREA");
//End AMV_AREE1Row: declare fiels

//AMV_AREE1Row: constructor @11-68930334
    public AMV_AREE1Row() {
    }
//End AMV_AREE1Row: constructor

//AMV_AREE1Row: method(s) of NOME @13-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_AREE1Row: method(s) of NOME

//AMV_AREE1Row: method(s) of DESCRIZIONE @15-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_AREE1Row: method(s) of DESCRIZIONE

//AMV_AREE1Row: method(s) of ID_AREA @20-0DE84566
    public LongField getID_AREAField() {
        return ID_AREA;
    }

    public Long getID_AREA() {
        return ID_AREA.getValue();
    }

    public void setID_AREA(Long value) {
        this.ID_AREA.setValue(value);
    }
//End AMV_AREE1Row: method(s) of ID_AREA

//AMV_AREE1Row: class tail @11-FCB6E20C
}
//End AMV_AREE1Row: class tail


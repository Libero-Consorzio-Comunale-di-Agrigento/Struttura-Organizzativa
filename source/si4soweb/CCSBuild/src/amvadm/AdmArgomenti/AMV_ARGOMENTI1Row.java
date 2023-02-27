//AMV_ARGOMENTI1Row: import @14-A20592D0
package amvadm.AdmArgomenti;

import java.util.*;
import com.codecharge.db.*;
//End AMV_ARGOMENTI1Row: import

//AMV_ARGOMENTI1Row: class head @14-C497C8B8
public class AMV_ARGOMENTI1Row {
//End AMV_ARGOMENTI1Row: class head

//AMV_ARGOMENTI1Row: declare fiels @14-4CA6156C
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private LongField ID_ARGOMENTO = new LongField("ID_ARGOMENTO", "ID_ARGOMENTO");
//End AMV_ARGOMENTI1Row: declare fiels

//AMV_ARGOMENTI1Row: constructor @14-18AAE80A
    public AMV_ARGOMENTI1Row() {
    }
//End AMV_ARGOMENTI1Row: constructor

//AMV_ARGOMENTI1Row: method(s) of NOME @21-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_ARGOMENTI1Row: method(s) of NOME

//AMV_ARGOMENTI1Row: method(s) of DESCRIZIONE @23-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_ARGOMENTI1Row: method(s) of DESCRIZIONE

//AMV_ARGOMENTI1Row: method(s) of ID_ARGOMENTO @20-6544611D
    public LongField getID_ARGOMENTOField() {
        return ID_ARGOMENTO;
    }

    public Long getID_ARGOMENTO() {
        return ID_ARGOMENTO.getValue();
    }

    public void setID_ARGOMENTO(Long value) {
        this.ID_ARGOMENTO.setValue(value);
    }
//End AMV_ARGOMENTI1Row: method(s) of ID_ARGOMENTO

//AMV_ARGOMENTI1Row: class tail @14-FCB6E20C
}
//End AMV_ARGOMENTI1Row: class tail


//CONTROLLO_PASSWORDRow: import @9-77F1CB74
package common.AmvAccesso;

import java.util.*;
import com.codecharge.db.*;
//End CONTROLLO_PASSWORDRow: import

//CONTROLLO_PASSWORDRow: class head @9-32E9DAD0
public class CONTROLLO_PASSWORDRow {
//End CONTROLLO_PASSWORDRow: class head

//CONTROLLO_PASSWORDRow: declare fiels @9-13BE6455
    private TextField PWD = new TextField("PWD", "PWD");
//End CONTROLLO_PASSWORDRow: declare fiels

//CONTROLLO_PASSWORDRow: constructor @9-7A7108B4
    public CONTROLLO_PASSWORDRow() {
    }
//End CONTROLLO_PASSWORDRow: constructor

//CONTROLLO_PASSWORDRow: method(s) of PWD @10-BF21A2BD
    public TextField getPWDField() {
        return PWD;
    }

    public String getPWD() {
        return PWD.getValue();
    }

    public void setPWD(String value) {
        this.PWD.setValue(value);
    }
//End CONTROLLO_PASSWORDRow: method(s) of PWD

//CONTROLLO_PASSWORDRow: class tail @9-FCB6E20C
}
//End CONTROLLO_PASSWORDRow: class tail


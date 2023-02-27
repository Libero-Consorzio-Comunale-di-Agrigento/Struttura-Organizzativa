//AD4_RICHIESTARow: import @2-CD0CDAC0
package common.AmvRichiestaAbilitazione;

import java.util.*;
import com.codecharge.db.*;
//End AD4_RICHIESTARow: import

//AD4_RICHIESTARow: class head @2-0D717C8A
public class AD4_RICHIESTARow {
//End AD4_RICHIESTARow: class head

//AD4_RICHIESTARow: declare fiels @2-C7C50D4C
    private TextField TextBox1 = new TextField("TextBox1", "DUMMY");
//End AD4_RICHIESTARow: declare fiels

//AD4_RICHIESTARow: constructor @2-BCE452E6
    public AD4_RICHIESTARow() {
    }
//End AD4_RICHIESTARow: constructor

//AD4_RICHIESTARow: method(s) of TextBox1 @15-47306BE4
    public TextField getTextBox1Field() {
        return TextBox1;
    }

    public String getTextBox1() {
        return TextBox1.getValue();
    }

    public void setTextBox1(String value) {
        this.TextBox1.setValue(value);
    }
//End AD4_RICHIESTARow: method(s) of TextBox1

//AD4_RICHIESTARow: class tail @2-FCB6E20C
}
//End AD4_RICHIESTARow: class tail


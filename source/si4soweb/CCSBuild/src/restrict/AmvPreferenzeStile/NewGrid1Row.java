//NewGrid1Row: import @48-C8BF5C71
package restrict.AmvPreferenzeStile;

import java.util.*;
import com.codecharge.db.*;
//End NewGrid1Row: import

//NewGrid1Row: class head @48-EF08A6E5
public class NewGrid1Row {
//End NewGrid1Row: class head

//NewGrid1Row: declare fiels @48-13C2488E
    private TextField Link1 = new TextField("Link1", "TESTO1");
    private TextField Label2 = new TextField("Label2", "TESTO2");
//End NewGrid1Row: declare fiels

//NewGrid1Row: constructor @48-B2F03CB8
    public NewGrid1Row() {
    }
//End NewGrid1Row: constructor

//NewGrid1Row: method(s) of Link1 @53-07541A2B
    public TextField getLink1Field() {
        return Link1;
    }

    public String getLink1() {
        return Link1.getValue();
    }

    public void setLink1(String value) {
        this.Link1.setValue(value);
    }
//End NewGrid1Row: method(s) of Link1

//NewGrid1Row: method(s) of Label2 @50-3C4C6B57
    public TextField getLabel2Field() {
        return Label2;
    }

    public String getLabel2() {
        return Label2.getValue();
    }

    public void setLabel2(String value) {
        this.Label2.setValue(value);
    }
//End NewGrid1Row: method(s) of Label2

//NewGrid1Row: class tail @48-FCB6E20C
}
//End NewGrid1Row: class tail


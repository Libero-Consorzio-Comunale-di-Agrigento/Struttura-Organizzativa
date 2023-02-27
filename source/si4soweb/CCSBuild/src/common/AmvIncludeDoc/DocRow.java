//DocRow: import @3-06773686
package common.AmvIncludeDoc;

import java.util.*;
import com.codecharge.db.*;
//End DocRow: import

//DocRow: class head @3-D475AA03
public class DocRow {
//End DocRow: class head

//DocRow: declare fiels @3-98C11299
    private TextField LINK = new TextField("LINK", "LINK");
    private TextField DOC_LINK = new TextField("DOC_LINK", "DOC_LINK");
//End DocRow: declare fiels

//DocRow: constructor @3-7FA172D1
    public DocRow() {
    }
//End DocRow: constructor

//DocRow: method(s) of LINK @14-E8490594
    public TextField getLINKField() {
        return LINK;
    }

    public String getLINK() {
        return LINK.getValue();
    }

    public void setLINK(String value) {
        this.LINK.setValue(value);
    }
//End DocRow: method(s) of LINK

//DocRow: method(s) of DOC_LINK @4-1BEA6184
    public TextField getDOC_LINKField() {
        return DOC_LINK;
    }

    public String getDOC_LINK() {
        return DOC_LINK.getValue();
    }

    public void setDOC_LINK(String value) {
        this.DOC_LINK.setValue(value);
    }
//End DocRow: method(s) of DOC_LINK

//DocRow: class tail @3-FCB6E20C
}
//End DocRow: class tail


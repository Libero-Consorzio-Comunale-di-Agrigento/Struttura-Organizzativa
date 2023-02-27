//MenuRow: import @3-06773686
package common.AmvIncludeDoc;

import java.util.*;
import com.codecharge.db.*;
//End MenuRow: import

//MenuRow: class head @3-44895A3E
public class MenuRow {
//End MenuRow: class head

//MenuRow: declare fiels @3-698B2A58
    private TextField DOC_LINK = new TextField("DOC_LINK", "DOC");
//End MenuRow: declare fiels

//MenuRow: constructor @3-7E22A52B
    public MenuRow() {
    }
//End MenuRow: constructor

//MenuRow: method(s) of DOC_LINK @-1BEA6184
    public TextField getDOC_LINKField() {
        return DOC_LINK;
    }

    public String getDOC_LINK() {
        return DOC_LINK.getValue();
    }

    public void setDOC_LINK(String value) {
        this.DOC_LINK.setValue(value);
    }
//End MenuRow: method(s) of DOC_LINK

//MenuRow: class tail @3-FCB6E20C
}
//End MenuRow: class tail


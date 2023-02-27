//DOC_SEZIONERow: import @6-2FBB4EC1
package common.AmvSezione;

import java.util.*;
import com.codecharge.db.*;
//End DOC_SEZIONERow: import

//DOC_SEZIONERow: class head @6-B053527E
public class DOC_SEZIONERow {
//End DOC_SEZIONERow: class head

//DOC_SEZIONERow: declare fiels @6-524CA52B
    private TextField DOCS = new TextField("DOCS", "DOCS");
//End DOC_SEZIONERow: declare fiels

//DOC_SEZIONERow: constructor @6-6737DE89
    public DOC_SEZIONERow() {
    }
//End DOC_SEZIONERow: constructor

//DOC_SEZIONERow: method(s) of DOCS @7-E548B934
    public TextField getDOCSField() {
        return DOCS;
    }

    public String getDOCS() {
        return DOCS.getValue();
    }

    public void setDOCS(String value) {
        this.DOCS.setValue(value);
    }
//End DOC_SEZIONERow: method(s) of DOCS

//DOC_SEZIONERow: class tail @6-FCB6E20C
}
//End DOC_SEZIONERow: class tail


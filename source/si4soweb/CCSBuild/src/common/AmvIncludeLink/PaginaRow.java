//PaginaRow: import @3-8AC70D77
package common.AmvIncludeLink;

import java.util.*;
import com.codecharge.db.*;
//End PaginaRow: import

//PaginaRow: class head @3-5CCD29B6
public class PaginaRow {
//End PaginaRow: class head

//PaginaRow: declare fiels @3-7039244B
    private TextField PAGE_LINK = new TextField("PAGE_LINK", "PAGE_LINK");
//End PaginaRow: declare fiels

//PaginaRow: constructor @3-A2E193C6
    public PaginaRow() {
    }
//End PaginaRow: constructor

//PaginaRow: method(s) of PAGE_LINK @6-0F07FDC5
    public TextField getPAGE_LINKField() {
        return PAGE_LINK;
    }

    public String getPAGE_LINK() {
        return PAGE_LINK.getValue();
    }

    public void setPAGE_LINK(String value) {
        this.PAGE_LINK.setValue(value);
    }
//End PaginaRow: method(s) of PAGE_LINK

//PaginaRow: class tail @3-FCB6E20C
}
//End PaginaRow: class tail


//AmvDocSelectView imports @1-DF47F4FC
package common.AmvDocSelect;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvDocSelectView imports

//AmvDocSelectView class @1-DA26CB71
public class AmvDocSelectView extends View {
//End AmvDocSelectView class

//AmvDocSelectView: method show @1-05CF7A4D
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvDocSelectModel) req.getAttribute( "AmvDocSelectModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvDocSelect.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            common.AmvStyle.AmvStyleView AmvStyle = new common.AmvStyle.AmvStyleView();
            tmpl.setVar( "main/@AmvStyle", AmvStyle.show( req, resp, context ));
            page.setCookies();
        }
        FILE_LISTClass FILE_LIST = new FILE_LISTClass();
        FILE_LIST.show(page.getRecord("FILE_LIST"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvDocSelectView: method show

//FILE_LIST Record @2-8C7A1463
    final class FILE_LISTClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End FILE_LIST Record

//AmvDocSelectView Tail @1-FCB6E20C
}
//End AmvDocSelectView Tail

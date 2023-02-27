




//AmvIncludeDocView imports @1-51320048
package common.AmvIncludeDoc;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvIncludeDocView imports

//AmvIncludeDocView class @1-815AC2A9
public class AmvIncludeDocView extends View {
//End AmvIncludeDocView class

//AmvIncludeDocView: method show @1-F4A7649F
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvIncludeDocModel) req.getAttribute( "AmvIncludeDocModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvIncludeDoc.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        DocClass Doc = new DocClass();
        Doc.show(page.getGrid("Doc"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvIncludeDocView: method show

// //Doc Grid @3-F81417CB

//DocClass head @3-CF02A429
    final class DocClass {
//End DocClass head

// //Doc Grid: method show @3-F81417CB

//show head @3-22C204A7
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DOC_LINK");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("LINK");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Doc Grid Tail @3-FCB6E20C
    }
//End Doc Grid Tail
//AmvIncludeDocView Tail @1-FCB6E20C
}
//End AmvIncludeDocView Tail




//AmvAccessNoControlView imports @1-D182403A
package common.AmvAccessNoControl;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvAccessNoControlView imports

//AmvAccessNoControlView class @1-A6988CDC
public class AmvAccessNoControlView extends View {
//End AmvAccessNoControlView class

//AmvAccessNoControlView: method show @1-E78FF7FB
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvAccessNoControlModel) req.getAttribute( "AmvAccessNoControlModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvAccessNoControl.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvAccessNoControlView: method show

//AmvAccessNoControlView Tail @1-FCB6E20C
}
//End AmvAccessNoControlView Tail


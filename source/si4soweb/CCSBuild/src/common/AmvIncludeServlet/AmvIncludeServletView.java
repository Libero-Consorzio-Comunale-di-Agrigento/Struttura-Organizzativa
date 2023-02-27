//AmvIncludeServletView imports @1-73730695
package common.AmvIncludeServlet;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvIncludeServletView imports

//AmvIncludeServletView class @1-91B51868
public class AmvIncludeServletView extends View {
//End AmvIncludeServletView class

//AmvIncludeServletView: method show @1-84C2501C
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvIncludeServletModel) req.getAttribute( "AmvIncludeServletModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvIncludeServlet.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        view.show(page.getControl("Label1"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvIncludeServletView: method show

//AmvIncludeServletView Tail @1-FCB6E20C
}
//End AmvIncludeServletView Tail


//AmvLogoutView imports @1-3149A764
package common.AmvLogout;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvLogoutView imports

//AmvLogoutView class @1-C9C90FE0
public class AmvLogoutView extends View {
//End AmvLogoutView class

//AmvLogoutView: method show @1-2A53C5F2
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvLogoutModel) req.getAttribute( "AmvLogoutModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvLogout.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        view.show(page.getControl("cookies"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvLogoutView: method show

//AmvLogoutView Tail @1-FCB6E20C
}
//End AmvLogoutView Tail


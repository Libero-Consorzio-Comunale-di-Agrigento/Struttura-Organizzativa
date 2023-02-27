//LogoutView imports @1-6D1AC7CD
package common.Logout;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End LogoutView imports

//LogoutView class @1-EF70E77B
public class LogoutView extends View {
//End LogoutView class

//LogoutView: method show @1-3E2D468E
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (LogoutModel) req.getAttribute( "LogoutModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Logout.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End LogoutView: method show

//LogoutView Tail @1-FCB6E20C
}
//End LogoutView Tail


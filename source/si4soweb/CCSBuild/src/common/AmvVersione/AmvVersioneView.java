//AmvVersioneView imports @1-A1FAE6AC
package common.AmvVersione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvVersioneView imports

//AmvVersioneView class @1-EDD2886F
public class AmvVersioneView extends View {
//End AmvVersioneView class

//AmvVersioneView: method show @1-4AB56B07
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvVersioneModel) req.getAttribute( "AmvVersioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvVersione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvVersioneView: method show

//AmvVersioneView Tail @1-FCB6E20C
}
//End AmvVersioneView Tail


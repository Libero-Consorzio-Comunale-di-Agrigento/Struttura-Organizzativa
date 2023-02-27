//HelpView imports @1-EA611BB3
package common.Help;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End HelpView imports

//HelpView class @1-864F7851
public class HelpView extends View {
//End HelpView class

//HelpView: method show @1-5B4C007D
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (HelpModel) req.getAttribute( "HelpModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Help.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End HelpView: method show

//HelpView Tail @1-FCB6E20C
}
//End HelpView Tail


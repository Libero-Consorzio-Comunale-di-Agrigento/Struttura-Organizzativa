//IncludeView imports @1-C3B5DF04
package common.Include;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End IncludeView imports

//IncludeView class @1-A20DBDC4
public class IncludeView extends View {
//End IncludeView class

//IncludeView: method show @1-9A4CFA53
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (IncludeModel) req.getAttribute( "IncludeModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Include.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvInclude" ).isVisible() ) {
            common.AmvInclude.AmvIncludeView AmvInclude = new common.AmvInclude.AmvIncludeView();
            tmpl.setVar( "main/@AmvInclude", AmvInclude.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End IncludeView: method show

//IncludeView Tail @1-FCB6E20C
}
//End IncludeView Tail


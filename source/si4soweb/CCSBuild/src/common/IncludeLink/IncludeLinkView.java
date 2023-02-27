//IncludeLinkView imports @1-083CD401
package common.IncludeLink;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End IncludeLinkView imports

//IncludeLinkView class @1-DB8ECD46
public class IncludeLinkView extends View {
//End IncludeLinkView class

//IncludeLinkView: method show @1-4B3F1047
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (IncludeLinkModel) req.getAttribute( "IncludeLinkModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/IncludeLink.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvIncludeLink" ).isVisible() ) {
            common.AmvIncludeLink.AmvIncludeLinkView AmvIncludeLink = new common.AmvIncludeLink.AmvIncludeLinkView();
            tmpl.setVar( "main/@AmvIncludeLink", AmvIncludeLink.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End IncludeLinkView: method show

//IncludeLinkView Tail @1-FCB6E20C
}
//End IncludeLinkView Tail


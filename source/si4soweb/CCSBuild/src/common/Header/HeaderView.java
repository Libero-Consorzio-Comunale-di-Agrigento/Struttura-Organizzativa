//HeaderView imports @1-517FF1A6
package common.Header;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End HeaderView imports

//HeaderView class @1-D5A49199
public class HeaderView extends View {
//End HeaderView class

//HeaderView: method show @1-0276EE9B
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (HeaderModel) req.getAttribute( "HeaderModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Header.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvHeader" ).isVisible() ) {
            common.AmvHeader.AmvHeaderView AmvHeader = new common.AmvHeader.AmvHeaderView();
            tmpl.setVar( "main/@AmvHeader", AmvHeader.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End HeaderView: method show

//HeaderView Tail @1-FCB6E20C
}
//End HeaderView Tail


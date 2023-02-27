//FooterView imports @1-3E113027
package common.Footer;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End FooterView imports

//FooterView class @1-D59A957F
public class FooterView extends View {
//End FooterView class

//FooterView: method show @1-CE4B8204
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (FooterModel) req.getAttribute( "FooterModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Footer.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvFooter" ).isVisible() ) {
            common.AmvFooter.AmvFooterView AmvFooter = new common.AmvFooter.AmvFooterView();
            tmpl.setVar( "main/@AmvFooter", AmvFooter.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End FooterView: method show

//FooterView Tail @1-FCB6E20C
}
//End FooterView Tail


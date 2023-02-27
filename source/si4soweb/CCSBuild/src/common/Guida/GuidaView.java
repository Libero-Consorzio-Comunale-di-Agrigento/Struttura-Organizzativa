//GuidaView imports @1-2CB929F9
package common.Guida;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End GuidaView imports

//GuidaView class @1-A2717403
public class GuidaView extends View {
//End GuidaView class

//GuidaView: method show @1-FFB4E4EB
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (GuidaModel) req.getAttribute( "GuidaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Guida.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            common.AmvGuida.AmvGuidaView AmvGuida = new common.AmvGuida.AmvGuidaView();
            tmpl.setVar( "main/@AmvGuida", AmvGuida.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End GuidaView: method show

//GuidaView Tail @1-FCB6E20C
}
//End GuidaView Tail


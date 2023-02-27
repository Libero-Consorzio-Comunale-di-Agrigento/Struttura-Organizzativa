//AmvAccessiAreeDocView imports @1-03534667
package restrict.AmvAccessiAreeDoc;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvAccessiAreeDocView imports

//AmvAccessiAreeDocView class @1-CA2F09B4
public class AmvAccessiAreeDocView extends View {
//End AmvAccessiAreeDocView class

//AmvAccessiAreeDocView: method show @1-9AB87003
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvAccessiAreeDocModel) req.getAttribute( "AmvAccessiAreeDocModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvAccessiAreeDoc.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "Left" ).isVisible() ) {
            common.Left.LeftView Left = new common.Left.LeftView();
            tmpl.setVar( "main/@Left", Left.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            common.AmvGuida.AmvGuidaView AmvGuida = new common.AmvGuida.AmvGuidaView();
            tmpl.setVar( "main/@AmvGuida", AmvGuida.show( req, resp, context ));
            page.setCookies();
        }
        AMV_DIRITTIClass AMV_DIRITTI = new AMV_DIRITTIClass();
        AMV_DIRITTI.show(page.getGrid("AMV_DIRITTI"));
        if ( page.getChild( "Footer" ).isVisible() ) {
            common.Footer.FooterView Footer = new common.Footer.FooterView();
            tmpl.setVar( "main/@Footer", Footer.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvAccessiAreeDocView: method show

// //AMV_DIRITTI Grid @6-F81417CB

//AMV_DIRITTIClass head @6-90F65E1D
    final class AMV_DIRITTIClass {
//End AMV_DIRITTIClass head

// //AMV_DIRITTI Grid: method show @6-F81417CB

//show head @6-C0246A47
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("AREA");
            rowControls.add("TIPOLOGIA");
            rowControls.add("DES_ACCESSO");
            rowControls.add("GRUPPO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_DIRITTI Grid Tail @6-FCB6E20C
    }
//End AMV_DIRITTI Grid Tail

//AmvAccessiAreeDocView Tail @1-FCB6E20C
}
//End AmvAccessiAreeDocView Tail


//AmvAccessiView imports @1-1C8DEA88
package restrict.AmvAccessi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvAccessiView imports

//AmvAccessiView class @1-087004CC
public class AmvAccessiView extends View {
//End AmvAccessiView class

//AmvAccessiView: method show @1-9E52D1DC
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvAccessiModel) req.getAttribute( "AmvAccessiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvAccessi.html";
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
        AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
        AD4_UTENTI.show(page.getRecord("AD4_UTENTI"));
        AD4_DIRITTI_ACCESSOClass AD4_DIRITTI_ACCESSO = new AD4_DIRITTI_ACCESSOClass();
        AD4_DIRITTI_ACCESSO.show(page.getGrid("AD4_DIRITTI_ACCESSO"));
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
//End AmvAccessiView: method show

//AD4_UTENTI Record @6-3FE1AF3E
    final class AD4_UTENTIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTI Record

// //AD4_DIRITTI_ACCESSO Grid @22-F81417CB

//AD4_DIRITTI_ACCESSOClass head @22-C897A615
    final class AD4_DIRITTI_ACCESSOClass {
//End AD4_DIRITTI_ACCESSOClass head

// //AD4_DIRITTI_ACCESSO Grid: method show @22-F81417CB

//show head @22-7BC20F24
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DES_SERVIZIO");
            rowControls.add("DSP_ACCESSO");
            rowControls.add("DSP_NOTE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_DIRITTI_ACCESSO Grid Tail @22-FCB6E20C
    }
//End AD4_DIRITTI_ACCESSO Grid Tail

//AmvAccessiView Tail @1-FCB6E20C
}
//End AmvAccessiView Tail


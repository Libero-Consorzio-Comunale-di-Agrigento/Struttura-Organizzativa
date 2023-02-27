//AdmUtenteAccessiView imports @1-9FD7C1BC
package amvadm.AdmUtenteAccessi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmUtenteAccessiView imports

//AdmUtenteAccessiView class @1-07A1421F
public class AdmUtenteAccessiView extends View {
//End AdmUtenteAccessiView class

//AdmUtenteAccessiView: method show @1-23054813
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmUtenteAccessiModel) req.getAttribute( "AdmUtenteAccessiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmUtenteAccessi.html";
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
        if ( page.getChild( "AmvUtenteNominativo_i" ).isVisible() ) {
            common.AmvUtenteNominativo_i.AmvUtenteNominativo_iView AmvUtenteNominativo_i = new common.AmvUtenteNominativo_i.AmvUtenteNominativo_iView();
            tmpl.setVar( "main/@AmvUtenteNominativo_i", AmvUtenteNominativo_i.show( req, resp, context ));
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
//End AdmUtenteAccessiView: method show

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

//AdmUtenteAccessiView Tail @1-FCB6E20C
}
//End AdmUtenteAccessiView Tail



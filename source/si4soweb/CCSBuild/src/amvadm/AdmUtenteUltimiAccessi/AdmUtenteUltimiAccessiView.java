//AdmUtenteUltimiAccessiView imports @1-0C226701
package amvadm.AdmUtenteUltimiAccessi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmUtenteUltimiAccessiView imports

//AdmUtenteUltimiAccessiView class @1-30B8C5C8
public class AdmUtenteUltimiAccessiView extends View {
//End AdmUtenteUltimiAccessiView class

//AdmUtenteUltimiAccessiView: method show @1-606E60A4
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmUtenteUltimiAccessiModel) req.getAttribute( "AdmUtenteUltimiAccessiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmUtenteUltimiAccessi.html";
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
        AccessiElencoClass AccessiElenco = new AccessiElencoClass();
        AccessiElenco.show(page.getGrid("AccessiElenco"));
        AD4_SERVIZIO_SELClass AD4_SERVIZIO_SEL = new AD4_SERVIZIO_SELClass();
        AD4_SERVIZIO_SEL.show(page.getGrid("AD4_SERVIZIO_SEL"));
        AccessiDettaglioClass AccessiDettaglio = new AccessiDettaglioClass();
        AccessiDettaglio.show(page.getGrid("AccessiDettaglio"));
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
//End AdmUtenteUltimiAccessiView: method show

// //AccessiElenco Grid @6-F81417CB

//AccessiElencoClass head @6-D18393CF
    final class AccessiElencoClass {
//End AccessiElencoClass head

// //AccessiElenco Grid: method show @6-F81417CB

//show head @6-6BC4E12C
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DES_ACCESSO");
            rowControls.add("DES_SERVIZIO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AccessiElenco Grid Tail @6-FCB6E20C
    }
//End AccessiElenco Grid Tail

// //AD4_SERVIZIO_SEL Grid @23-F81417CB

//AD4_SERVIZIO_SELClass head @23-BD28604D
    final class AD4_SERVIZIO_SELClass {
//End AD4_SERVIZIO_SELClass head

// //AD4_SERVIZIO_SEL Grid: method show @23-F81417CB

//show head @23-2D9C5124
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DES_ACCESSO");
            rowControls.add("DES_SERVIZIO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_SERVIZIO_SEL Grid Tail @23-FCB6E20C
    }
//End AD4_SERVIZIO_SEL Grid Tail

// //AccessiDettaglio Grid @14-F81417CB

//AccessiDettaglioClass head @14-914C7864
    final class AccessiDettaglioClass {
//End AccessiDettaglioClass head

// //AccessiDettaglio Grid: method show @14-F81417CB

//show head @14-1335634F
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DES_ACCESSO");
            rowControls.add("DES_ORA");
            rowControls.add("DSP_SESSIONE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AccessiDettaglio Grid Tail @14-FCB6E20C
    }
//End AccessiDettaglio Grid Tail

//AdmUtenteUltimiAccessiView Tail @1-FCB6E20C
}
//End AdmUtenteUltimiAccessiView Tail



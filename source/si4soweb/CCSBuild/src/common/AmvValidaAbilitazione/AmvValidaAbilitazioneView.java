





//AmvValidaAbilitazioneView imports @1-C2FD5DC4
package common.AmvValidaAbilitazione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvValidaAbilitazioneView imports

//AmvValidaAbilitazioneView class @1-6C646565
public class AmvValidaAbilitazioneView extends View {
//End AmvValidaAbilitazioneView class

//AmvValidaAbilitazioneView: method show @1-16ADD296
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvValidaAbilitazioneModel) req.getAttribute( "AmvValidaAbilitazioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvValidaAbilitazione.html";
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
        if ( page.getChild( "Guida" ).isVisible() ) {
            common.Guida.GuidaView Guida = new common.Guida.GuidaView();
            tmpl.setVar( "main/@Guida", Guida.show( req, resp, context ));
            page.setCookies();
        }
        RICHIESTAClass RICHIESTA = new RICHIESTAClass();
        RICHIESTA.show(page.getGrid("RICHIESTA"));
        GESTISCI_RICHIESTAClass GESTISCI_RICHIESTA = new GESTISCI_RICHIESTAClass();
        GESTISCI_RICHIESTA.show(page.getRecord("GESTISCI_RICHIESTA"));
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
//End AmvValidaAbilitazioneView: method show

// //RICHIESTA Grid @22-F81417CB

//RICHIESTAClass head @22-BA24F77A
    final class RICHIESTAClass {
//End RICHIESTAClass head

// //RICHIESTA Grid: method show @22-F81417CB

//show head @22-F5AEEB23
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOMINATIVO");
            rowControls.add("SERVIZIO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//RICHIESTA Grid Tail @22-FCB6E20C
    }
//End RICHIESTA Grid Tail

//GESTISCI_RICHIESTA Record @7-FBCF3524
    final class GESTISCI_RICHIESTAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End GESTISCI_RICHIESTA Record

//AmvValidaAbilitazioneView Tail @1-FCB6E20C
}
//End AmvValidaAbilitazioneView Tail



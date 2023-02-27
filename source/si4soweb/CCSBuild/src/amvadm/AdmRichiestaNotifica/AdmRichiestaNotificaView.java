//AdmRichiestaNotificaView imports @1-D590C932
package amvadm.AdmRichiestaNotifica;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRichiestaNotificaView imports

//AdmRichiestaNotificaView class @1-3C75037D
public class AdmRichiestaNotificaView extends View {
//End AdmRichiestaNotificaView class

//AdmRichiestaNotificaView: method show @1-41BC7A42
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRichiestaNotificaModel) req.getAttribute( "AdmRichiestaNotificaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRichiestaNotifica.html";
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
        AD4_RICHIESTE_ABILITAZIONEClass AD4_RICHIESTE_ABILITAZIONE = new AD4_RICHIESTE_ABILITAZIONEClass();
        AD4_RICHIESTE_ABILITAZIONE.show(page.getRecord("AD4_RICHIESTE_ABILITAZIONE"));
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
//End AdmRichiestaNotificaView: method show

//AD4_RICHIESTE_ABILITAZIONE Record @6-5A3A4B75
    final class AD4_RICHIESTE_ABILITAZIONEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_RICHIESTE_ABILITAZIONE Record

//AdmRichiestaNotificaView Tail @1-FCB6E20C
}
//End AdmRichiestaNotificaView Tail



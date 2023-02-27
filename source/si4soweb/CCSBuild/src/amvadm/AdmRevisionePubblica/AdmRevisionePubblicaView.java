//AdmRevisionePubblicaView imports @1-2CABBBAA
package amvadm.AdmRevisionePubblica;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisionePubblicaView imports

//AdmRevisionePubblicaView class @1-632CB30D
public class AdmRevisionePubblicaView extends View {
//End AdmRevisionePubblicaView class

//AdmRevisionePubblicaView: method show @1-A4ED8036
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisionePubblicaModel) req.getAttribute( "AdmRevisionePubblicaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisionePubblica.html";
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
        AMV_DOCUMENTO_PUBBLICAClass AMV_DOCUMENTO_PUBBLICA = new AMV_DOCUMENTO_PUBBLICAClass();
        AMV_DOCUMENTO_PUBBLICA.show(page.getRecord("AMV_DOCUMENTO_PUBBLICA"));
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
//End AdmRevisionePubblicaView: method show

//AMV_DOCUMENTO_PUBBLICA Record @6-AD3F07B4
    final class AMV_DOCUMENTO_PUBBLICAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DOCUMENTO_PUBBLICA Record

//AdmRevisionePubblicaView Tail @1-FCB6E20C
}
//End AdmRevisionePubblicaView Tail

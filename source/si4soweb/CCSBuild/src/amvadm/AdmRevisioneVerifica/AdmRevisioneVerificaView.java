//AdmRevisioneVerificaView imports @1-741CF493
package amvadm.AdmRevisioneVerifica;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioneVerificaView imports

//AdmRevisioneVerificaView class @1-726D06FB
public class AdmRevisioneVerificaView extends View {
//End AdmRevisioneVerificaView class

//AdmRevisioneVerificaView: method show @1-0FD2EF22
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioneVerificaModel) req.getAttribute( "AdmRevisioneVerificaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioneVerifica.html";
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
        AMV_DOCUMENTO_VERIFICAClass AMV_DOCUMENTO_VERIFICA = new AMV_DOCUMENTO_VERIFICAClass();
        AMV_DOCUMENTO_VERIFICA.show(page.getRecord("AMV_DOCUMENTO_VERIFICA"));
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
//End AdmRevisioneVerificaView: method show

//AMV_DOCUMENTO_VERIFICA Record @6-DB5BA6BA
    final class AMV_DOCUMENTO_VERIFICAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DOCUMENTO_VERIFICA Record

//AdmRevisioneVerificaView Tail @1-FCB6E20C
}
//End AdmRevisioneVerificaView Tail

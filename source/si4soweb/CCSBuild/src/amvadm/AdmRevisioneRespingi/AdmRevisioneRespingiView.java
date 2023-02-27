//AdmRevisioneRespingiView imports @1-E25ED5BE
package amvadm.AdmRevisioneRespingi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioneRespingiView imports

//AdmRevisioneRespingiView class @1-26960792
public class AdmRevisioneRespingiView extends View {
//End AdmRevisioneRespingiView class

//AdmRevisioneRespingiView: method show @1-3A001FC9
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioneRespingiModel) req.getAttribute( "AdmRevisioneRespingiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioneRespingi.html";
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
        AMV_DOCUMENTO_RESPINGIClass AMV_DOCUMENTO_RESPINGI = new AMV_DOCUMENTO_RESPINGIClass();
        AMV_DOCUMENTO_RESPINGI.show(page.getRecord("AMV_DOCUMENTO_RESPINGI"));
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
//End AdmRevisioneRespingiView: method show

//AMV_DOCUMENTO_RESPINGI Record @6-C7BE5874
    final class AMV_DOCUMENTO_RESPINGIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DOCUMENTO_RESPINGI Record

//AdmRevisioneRespingiView Tail @1-FCB6E20C
}
//End AdmRevisioneRespingiView Tail

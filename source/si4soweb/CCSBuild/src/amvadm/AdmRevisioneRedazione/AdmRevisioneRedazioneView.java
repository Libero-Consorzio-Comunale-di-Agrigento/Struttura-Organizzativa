//AdmRevisioneRedazioneView imports @1-0D1F02BB
package amvadm.AdmRevisioneRedazione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioneRedazioneView imports

//AdmRevisioneRedazioneView class @1-94C32A08
public class AdmRevisioneRedazioneView extends View {
//End AdmRevisioneRedazioneView class

//AdmRevisioneRedazioneView: method show @1-0E4E3428
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioneRedazioneModel) req.getAttribute( "AdmRevisioneRedazioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioneRedazione.html";
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
        AMV_DOCUMENTO_REDAZIONEClass AMV_DOCUMENTO_REDAZIONE = new AMV_DOCUMENTO_REDAZIONEClass();
        AMV_DOCUMENTO_REDAZIONE.show(page.getRecord("AMV_DOCUMENTO_REDAZIONE"));
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
//End AdmRevisioneRedazioneView: method show

//AMV_DOCUMENTO_REDAZIONE Record @6-D37A1754
    final class AMV_DOCUMENTO_REDAZIONEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DOCUMENTO_REDAZIONE Record

//AdmRevisioneRedazioneView Tail @1-FCB6E20C
}
//End AdmRevisioneRedazioneView Tail

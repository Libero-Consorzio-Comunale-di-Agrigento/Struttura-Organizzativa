//AdmRevisioneApprovaView imports @1-CA1D1CD6
package amvadm.AdmRevisioneApprova;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioneApprovaView imports

//AdmRevisioneApprovaView class @1-643384E3
public class AdmRevisioneApprovaView extends View {
//End AdmRevisioneApprovaView class

//AdmRevisioneApprovaView: method show @1-EFD81411
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioneApprovaModel) req.getAttribute( "AdmRevisioneApprovaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioneApprova.html";
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
        AMV_DOCUMENTO_APPROVAClass AMV_DOCUMENTO_APPROVA = new AMV_DOCUMENTO_APPROVAClass();
        AMV_DOCUMENTO_APPROVA.show(page.getRecord("AMV_DOCUMENTO_APPROVA"));
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
//End AdmRevisioneApprovaView: method show

//AMV_DOCUMENTO_APPROVA Record @6-2DAC84B5
    final class AMV_DOCUMENTO_APPROVAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DOCUMENTO_APPROVA Record

//AdmRevisioneApprovaView Tail @1-FCB6E20C
}
//End AdmRevisioneApprovaView Tail

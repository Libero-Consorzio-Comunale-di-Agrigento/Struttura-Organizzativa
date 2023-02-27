//AdmRevisioneNuovaView imports @1-CCBEA969
package amvadm.AdmRevisioneNuova;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioneNuovaView imports

//AdmRevisioneNuovaView class @1-03DB39F3
public class AdmRevisioneNuovaView extends View {
//End AdmRevisioneNuovaView class

//AdmRevisioneNuovaView: method show @1-7814E75D
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioneNuovaModel) req.getAttribute( "AdmRevisioneNuovaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioneNuova.html";
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
        NUOVA_REVISIONEClass NUOVA_REVISIONE = new NUOVA_REVISIONEClass();
        NUOVA_REVISIONE.show(page.getRecord("NUOVA_REVISIONE"));
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
//End AdmRevisioneNuovaView: method show

//NUOVA_REVISIONE Record @6-A0FBD788
    final class NUOVA_REVISIONEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End NUOVA_REVISIONE Record

//AdmRevisioneNuovaView Tail @1-FCB6E20C
}
//End AdmRevisioneNuovaView Tail

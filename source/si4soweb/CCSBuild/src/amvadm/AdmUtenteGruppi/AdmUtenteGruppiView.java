//AdmUtenteGruppiView imports @1-A30F9049
package amvadm.AdmUtenteGruppi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmUtenteGruppiView imports

//AdmUtenteGruppiView class @1-E0B8D4B3
public class AdmUtenteGruppiView extends View {
//End AdmUtenteGruppiView class

//AdmUtenteGruppiView: method show @1-9CA73FC8
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmUtenteGruppiModel) req.getAttribute( "AdmUtenteGruppiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmUtenteGruppi.html";
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
        if ( page.getChild( "AmvUtenteNominativo_i" ).isVisible() ) {
            common.AmvUtenteNominativo_i.AmvUtenteNominativo_iView AmvUtenteNominativo_i = new common.AmvUtenteNominativo_i.AmvUtenteNominativo_iView();
            tmpl.setVar( "main/@AmvUtenteNominativo_i", AmvUtenteNominativo_i.show( req, resp, context ));
            page.setCookies();
        }
        DISPONIBILIClass DISPONIBILI = new DISPONIBILIClass();
        DISPONIBILI.show(page.getRecord("DISPONIBILI"));
        ASSEGNATIClass ASSEGNATI = new ASSEGNATIClass();
        ASSEGNATI.show(page.getRecord("ASSEGNATI"));
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
//End AdmUtenteGruppiView: method show

//DISPONIBILI Record @70-D9292E6E
    final class DISPONIBILIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End DISPONIBILI Record

//ASSEGNATI Record @76-5D1454D7
    final class ASSEGNATIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End ASSEGNATI Record

//AdmUtenteGruppiView Tail @1-FCB6E20C
}
//End AdmUtenteGruppiView Tail


//AdmGruppoUtentiView imports @1-014797C2
package amvadm.AdmGruppoUtenti;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmGruppoUtentiView imports

//AdmGruppoUtentiView class @1-68A2F8B1
public class AdmGruppoUtentiView extends View {
//End AdmGruppoUtentiView class

//AdmGruppoUtentiView: method show @1-071807C2
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmGruppoUtentiModel) req.getAttribute( "AdmGruppoUtentiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmGruppoUtenti.html";
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
        AD4_UTENTISearchClass AD4_UTENTISearch = new AD4_UTENTISearchClass();
        AD4_UTENTISearch.show(page.getRecord("AD4_UTENTISearch"));
        AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
        AD4_UTENTI.show(page.getGrid("AD4_UTENTI"));
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
//End AdmGruppoUtentiView: method show

//AD4_UTENTISearch Record @68-12A2D537
    final class AD4_UTENTISearchClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTISearch Record

// //AD4_UTENTI Grid @74-F81417CB

//AD4_UTENTIClass head @74-09343EF2
    final class AD4_UTENTIClass {
//End AD4_UTENTIClass head

// //AD4_UTENTI Grid: method show @74-F81417CB

//show head @74-95351403
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOMINATIVO");
            rowControls.add("GRUPPI");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_NOMINATIVO");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_UTENTI Grid Tail @74-FCB6E20C
    }
//End AD4_UTENTI Grid Tail

//AdmGruppoUtentiView Tail @1-FCB6E20C
}
//End AdmGruppoUtentiView Tail



//AdmGruppiElencoView imports @1-8C4A6700
package amvadm.AdmGruppiElenco;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmGruppiElencoView imports

//AdmGruppiElencoView class @1-2A303A64
public class AdmGruppiElencoView extends View {
//End AdmGruppiElencoView class

//AdmGruppiElencoView: method show @1-44346A72
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmGruppiElencoModel) req.getAttribute( "AdmGruppiElencoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmGruppiElenco.html";
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
//End AdmGruppiElencoView: method show

//AD4_UTENTISearch Record @6-12A2D537
    final class AD4_UTENTISearchClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTISearch Record

// //AD4_UTENTI Grid @5-F81417CB

//AD4_UTENTIClass head @5-09343EF2
    final class AD4_UTENTIClass {
//End AD4_UTENTIClass head

// //AD4_UTENTI Grid: method show @5-F81417CB

//show head @5-4D485185
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME_GRUPPO");
            rowControls.add("DIRITTI");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_NOMINATIVO");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_UTENTI Grid Tail @5-FCB6E20C
    }
//End AD4_UTENTI Grid Tail

//AdmGruppiElencoView Tail @1-FCB6E20C
}
//End AdmGruppiElencoView Tail




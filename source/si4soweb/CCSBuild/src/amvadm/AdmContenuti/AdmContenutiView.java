//AdmContenutiView imports @1-B64592F6
package amvadm.AdmContenuti;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmContenutiView imports

//AdmContenutiView class @1-D06AE459
public class AdmContenutiView extends View {
//End AdmContenutiView class

//AdmContenutiView: method show @1-B22220D0
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmContenutiModel) req.getAttribute( "AdmContenutiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmContenuti.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "Guida" ).isVisible() ) {
            common.Guida.GuidaView Guida = new common.Guida.GuidaView();
            tmpl.setVar( "main/@Guida", Guida.show( req, resp, context ));
            page.setCookies();
        }
        AlberoClass Albero = new AlberoClass();
        Albero.show(page.getGrid("Albero"));
        if ( page.getChild( "AdmContenutiElenco" ).isVisible() ) {
            amvadm.AdmContenutiElenco.AdmContenutiElencoView AdmContenutiElenco = new amvadm.AdmContenutiElenco.AdmContenutiElencoView();
            tmpl.setVar( "main/@AdmContenutiElenco", AdmContenutiElenco.show( req, resp, context ));
            page.setCookies();
        }
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
//End AdmContenutiView: method show

// //Albero Grid @6-F81417CB

//AlberoClass head @6-86C281BC
    final class AlberoClass {
//End AlberoClass head

// //Albero Grid: method show @6-F81417CB

//show head @6-1795A841
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MENU");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Albero Grid Tail @6-FCB6E20C
    }
//End Albero Grid Tail

//AdmContenutiView Tail @1-FCB6E20C
}
//End AdmContenutiView Tail

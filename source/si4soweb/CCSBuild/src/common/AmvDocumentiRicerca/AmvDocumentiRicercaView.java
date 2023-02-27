//AmvDocumentiRicercaView imports @1-6201CB20
package common.AmvDocumentiRicerca;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvDocumentiRicercaView imports

//AmvDocumentiRicercaView class @1-0AD85E32
public class AmvDocumentiRicercaView extends View {
//End AmvDocumentiRicercaView class

//AmvDocumentiRicercaView: method show @1-E13EB7B6
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvDocumentiRicercaModel) req.getAttribute( "AmvDocumentiRicercaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvDocumentiRicerca.html";
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
        AMV_VISTA_DOCUMENTISearchClass AMV_VISTA_DOCUMENTISearch = new AMV_VISTA_DOCUMENTISearchClass();
        AMV_VISTA_DOCUMENTISearch.show(page.getRecord("AMV_VISTA_DOCUMENTISearch"));
        AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
        AMV_VISTA_DOCUMENTI.show(page.getGrid("AMV_VISTA_DOCUMENTI"));
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
//End AmvDocumentiRicercaView: method show

//AMV_VISTA_DOCUMENTISearch Record @6-4D1B3B81
    final class AMV_VISTA_DOCUMENTISearchClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_VISTA_DOCUMENTISearch Record

// //AMV_VISTA_DOCUMENTI Grid @5-F81417CB

//AMV_VISTA_DOCUMENTIClass head @5-12C1668F
    final class AMV_VISTA_DOCUMENTIClass {
//End AMV_VISTA_DOCUMENTIClass head

// //AMV_VISTA_DOCUMENTI Grid: method show @5-F81417CB

//show head @5-CD3BEB4B
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("SEZIONE");
            rowControls.add("DATA_ULTIMA_MODIFICA");
            rowControls.add("MODIFICA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_TITOLO");
            staticControls.add("SorterMODIFICA");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_VISTA_DOCUMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

//AmvDocumentiRicercaView Tail @1-FCB6E20C
}
//End AmvDocumentiRicercaView Tail


//ServletModulisticaView imports @1-B3F45D21
package restrict.ServletModulistica;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End ServletModulisticaView imports

//ServletModulisticaView class @1-73BB65C8
public class ServletModulisticaView extends View {
//End ServletModulisticaView class

//ServletModulisticaView: method show @1-80F15949
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (ServletModulisticaModel) req.getAttribute( "ServletModulisticaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/ServletModulistica.html";
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
        AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
        AMV_VISTA_DOCUMENTI.show(page.getGrid("AMV_VISTA_DOCUMENTI"));
        INSERISCI_RICHIESTAClass INSERISCI_RICHIESTA = new INSERISCI_RICHIESTAClass();
        INSERISCI_RICHIESTA.show(page.getGrid("INSERISCI_RICHIESTA"));
        view.show(page.getControl("corpoHtml"));
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
//End ServletModulisticaView: method show

// //AMV_VISTA_DOCUMENTI Grid @9-F81417CB

//AMV_VISTA_DOCUMENTIClass head @9-12C1668F
    final class AMV_VISTA_DOCUMENTIClass {
//End AMV_VISTA_DOCUMENTIClass head

// //AMV_VISTA_DOCUMENTI Grid: method show @9-F81417CB

//show head @9-3B1A6070
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("MODIFICA");
            rowControls.add("STATO");
            rowControls.add("COD_STATO");
            rowControls.add("DATA_ULTIMA_MODIFICA");
            rowControls.add("TESTO");
            rowControls.add("ALLEGATI");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_VISTA_DOCUMENTI Grid Tail @9-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

// //INSERISCI_RICHIESTA Grid @29-F81417CB

//INSERISCI_RICHIESTAClass head @29-2A2FDB15
    final class INSERISCI_RICHIESTAClass {
//End INSERISCI_RICHIESTAClass head

// //INSERISCI_RICHIESTA Grid: method show @29-F81417CB

//show head @29-315A3F2B
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MESSAGGIO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//INSERISCI_RICHIESTA Grid Tail @29-FCB6E20C
    }
//End INSERISCI_RICHIESTA Grid Tail

//ServletModulisticaView Tail @1-FCB6E20C
}
//End ServletModulisticaView Tail

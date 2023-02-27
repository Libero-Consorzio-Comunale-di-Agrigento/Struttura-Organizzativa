//AmvDocumentoViewView imports @1-E591D766
package common.AmvDocumentoView;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvDocumentoViewView imports

//AmvDocumentoViewView class @1-21EFDA7F
public class AmvDocumentoViewView extends View {
//End AmvDocumentoViewView class

//AmvDocumentoViewView: method show @1-50F37C4F
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvDocumentoViewModel) req.getAttribute( "AmvDocumentoViewModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvDocumentoView.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
        AMV_VISTA_DOCUMENTI.show(page.getGrid("AMV_VISTA_DOCUMENTI"));
        if ( page.getChild( "AmvIncludeDoc" ).isVisible() ) {
            common.AmvIncludeDoc.AmvIncludeDocView AmvIncludeDoc = new common.AmvIncludeDoc.AmvIncludeDocView();
            tmpl.setVar( "main/@AmvIncludeDoc", AmvIncludeDoc.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvDocumentoViewView: method show

// //AMV_VISTA_DOCUMENTI Grid @5-F81417CB

//AMV_VISTA_DOCUMENTIClass head @5-12C1668F
    final class AMV_VISTA_DOCUMENTIClass {
//End AMV_VISTA_DOCUMENTIClass head

// //AMV_VISTA_DOCUMENTI Grid: method show @5-F81417CB

//show head @5-421E28E7
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("IMG_LINK");
            rowControls.add("STORICO");
            rowControls.add("REVISIONA");
            rowControls.add("MODIFICA");
            rowControls.add("STATO");
            rowControls.add("INIZIO_PUBBLICAZIONE");
            rowControls.add("DSP_FINE_PUBBLICAZIONE");
            rowControls.add("DATA_ULTIMA_MODIFICA");
            rowControls.add("TESTO");
            rowControls.add("ALLEGATI");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_VISTA_DOCUMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

//AmvDocumentoViewView Tail @1-FCB6E20C
}
//End AmvDocumentoViewView Tail

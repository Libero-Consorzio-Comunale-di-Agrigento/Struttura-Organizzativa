//AmvDocumentoInfoView imports @1-BC16208C
package common.AmvDocumentoInfo;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvDocumentoInfoView imports

//AmvDocumentoInfoView class @1-EC4F81B1
public class AmvDocumentoInfoView extends View {
//End AmvDocumentoInfoView class

//AmvDocumentoInfoView: method show @1-A7E2BA97
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvDocumentoInfoModel) req.getAttribute( "AmvDocumentoInfoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvDocumentoInfo.html";
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
        if ( page.getChild( "AmvNavigatore" ).isVisible() ) {
            common.AmvNavigatore.AmvNavigatoreView AmvNavigatore = new common.AmvNavigatore.AmvNavigatoreView();
            tmpl.setVar( "main/@AmvNavigatore", AmvNavigatore.show( req, resp, context ));
            page.setCookies();
        }
        AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
        AMV_VISTA_DOCUMENTI.show(page.getGrid("AMV_VISTA_DOCUMENTI"));
        if ( page.getChild( "Right" ).isVisible() ) {
            common.Right.RightView Right = new common.Right.RightView();
            tmpl.setVar( "main/@Right", Right.show( req, resp, context ));
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
//End AmvDocumentoInfoView: method show

// //AMV_VISTA_DOCUMENTI Grid @5-F81417CB

//AMV_VISTA_DOCUMENTIClass head @5-12C1668F
    final class AMV_VISTA_DOCUMENTIClass {
//End AMV_VISTA_DOCUMENTIClass head

// //AMV_VISTA_DOCUMENTI Grid: method show @5-F81417CB

//show head @5-31F6EA3A
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
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_VISTA_DOCUMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

//AmvDocumentoInfoView Tail @1-FCB6E20C
}
//End AmvDocumentoInfoView Tail


//AdmDirittiView imports @1-A2A4AB21
package amvadm.AdmDiritti;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmDirittiView imports

//AdmDirittiView class @1-D4AC64AF
public class AdmDirittiView extends View {
//End AdmDirittiView class

//AdmDirittiView: method show @1-D2F82C37
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmDirittiModel) req.getAttribute( "AdmDirittiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmDiritti.html";
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
        AMV_DIRITTIClass AMV_DIRITTI = new AMV_DIRITTIClass();
        AMV_DIRITTI.show(page.getGrid("AMV_DIRITTI"));
        AMV_DIRITTI1Class AMV_DIRITTI1 = new AMV_DIRITTI1Class();
        AMV_DIRITTI1.show(page.getRecord("AMV_DIRITTI1"));
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
//End AdmDirittiView: method show

//AMV_VISTA_DOCUMENTISearch Record @31-4D1B3B81
    final class AMV_VISTA_DOCUMENTISearchClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_VISTA_DOCUMENTISearch Record

// //AMV_DIRITTI Grid @5-F81417CB

//AMV_DIRITTIClass head @5-90F65E1D
    final class AMV_DIRITTIClass {
//End AMV_DIRITTIClass head

// //AMV_DIRITTI Grid: method show @5-F81417CB

//show head @5-CCEC7FF9
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("HEADER_AREA");
            rowControls.add("GRUPPO");
            rowControls.add("NOME_TIPOLOGIA");
            rowControls.add("ACCESSO");
            rowControls.add("Edit");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_DIRITTI Grid Tail @5-FCB6E20C
    }
//End AMV_DIRITTI Grid Tail

//AMV_DIRITTI1 Record @15-48859EE3
    final class AMV_DIRITTI1Class {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DIRITTI1 Record

//AdmDirittiView Tail @1-FCB6E20C
}
//End AdmDirittiView Tail


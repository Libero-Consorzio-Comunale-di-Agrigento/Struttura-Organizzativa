//AdmRevisioniElencoView imports @1-458B6BD2
package amvadm.AdmRevisioniElenco;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioniElencoView imports

//AdmRevisioniElencoView class @1-556AE47C
public class AdmRevisioniElencoView extends View {
//End AdmRevisioniElencoView class

//AdmRevisioniElencoView: method show @1-DCF1E30F
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioniElencoModel) req.getAttribute( "AdmRevisioniElencoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioniElenco.html";
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
        ELENCO_REVISIONIClass ELENCO_REVISIONI = new ELENCO_REVISIONIClass();
        ELENCO_REVISIONI.show(page.getGrid("ELENCO_REVISIONI"));
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
//End AdmRevisioniElencoView: method show

// //ELENCO_REVISIONI Grid @6-F81417CB

//ELENCO_REVISIONIClass head @6-4E72888D
    final class ELENCO_REVISIONIClass {
//End ELENCO_REVISIONIClass head

// //ELENCO_REVISIONI Grid: method show @6-F81417CB

//show head @6-F530C384
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("REVISIONE");
            rowControls.add("CRONOLOGIA");
            rowControls.add("STATO_DOCUMENTO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//ELENCO_REVISIONI Grid Tail @6-FCB6E20C
    }
//End ELENCO_REVISIONI Grid Tail

//AdmRevisioniElencoView Tail @1-FCB6E20C
}
//End AdmRevisioniElencoView Tail

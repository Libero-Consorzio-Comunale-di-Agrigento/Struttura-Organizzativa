//AdmSezioniView imports @1-2DED8104
package amvadm.AdmSezioni;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmSezioniView imports

//AdmSezioniView class @1-E6E4FF8A
public class AdmSezioniView extends View {
//End AdmSezioniView class

//AdmSezioniView: method show @1-165E4D99
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmSezioniModel) req.getAttribute( "AdmSezioniModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmSezioni.html";
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
        if ( page.getChild( "AdmSezione" ).isVisible() ) {
            amvadm.AdmSezione.AdmSezioneView AdmSezione = new amvadm.AdmSezione.AdmSezioneView();
            tmpl.setVar( "main/@AdmSezione", AdmSezione.show( req, resp, context ));
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
//End AdmSezioniView: method show

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

//AdmSezioniView Tail @1-FCB6E20C
}
//End AdmSezioniView Tail

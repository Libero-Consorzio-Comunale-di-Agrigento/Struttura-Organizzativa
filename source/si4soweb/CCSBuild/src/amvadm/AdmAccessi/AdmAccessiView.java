//AdmAccessiView imports @1-35C4BF38
package amvadm.AdmAccessi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmAccessiView imports

//AdmAccessiView class @1-7488EDDE
public class AdmAccessiView extends View {
//End AdmAccessiView class

//AdmAccessiView: method show @1-BC81D3B6
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmAccessiModel) req.getAttribute( "AdmAccessiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmAccessi.html";
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
        AD4_ACCESSISearchClass AD4_ACCESSISearch = new AD4_ACCESSISearchClass();
        AD4_ACCESSISearch.show(page.getRecord("AD4_ACCESSISearch"));
        AccessiDettaglioClass AccessiDettaglio = new AccessiDettaglioClass();
        AccessiDettaglio.show(page.getGrid("AccessiDettaglio"));
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
//End AdmAccessiView: method show

//AD4_ACCESSISearch Record @30-A25B2B17
    final class AD4_ACCESSISearchClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_ACCESSISearch Record

// //AccessiDettaglio Grid @41-F81417CB

//AccessiDettaglioClass head @41-914C7864
    final class AccessiDettaglioClass {
//End AccessiDettaglioClass head

// //AccessiDettaglio Grid: method show @41-F81417CB

//show head @41-ED3CD6DB
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DATA_ACCESSO");
            rowControls.add("NOMINATIVO");
            rowControls.add("SESSIONE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_ACCESSO");
            staticControls.add("Sorter_NOMINATIVO");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AccessiDettaglio Grid Tail @41-FCB6E20C
    }
//End AccessiDettaglio Grid Tail

//AdmAccessiView Tail @1-FCB6E20C
}
//End AdmAccessiView Tail



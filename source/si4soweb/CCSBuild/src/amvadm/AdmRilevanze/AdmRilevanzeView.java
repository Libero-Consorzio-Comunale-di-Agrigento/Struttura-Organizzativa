//AdmRilevanzeView imports @1-8358498D
package amvadm.AdmRilevanze;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRilevanzeView imports

//AdmRilevanzeView class @1-B767C6D1
public class AdmRilevanzeView extends View {
//End AdmRilevanzeView class

//AdmRilevanzeView: method show @1-2C3A4F3D
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRilevanzeModel) req.getAttribute( "AdmRilevanzeModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRilevanze.html";
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
        AMV_RILEVANZEClass AMV_RILEVANZE = new AMV_RILEVANZEClass();
        AMV_RILEVANZE.show(page.getGrid("AMV_RILEVANZE"));
        AMV_RILEVANZE_RECORDClass AMV_RILEVANZE_RECORD = new AMV_RILEVANZE_RECORDClass();
        AMV_RILEVANZE_RECORD.show(page.getRecord("AMV_RILEVANZE_RECORD"));
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
//End AdmRilevanzeView: method show

// //AMV_RILEVANZE Grid @5-F81417CB

//AMV_RILEVANZEClass head @5-445C1E18
    final class AMV_RILEVANZEClass {
//End AMV_RILEVANZEClass head

// //AMV_RILEVANZE Grid: method show @5-F81417CB

//show head @5-57D95C30
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME");
            rowControls.add("IMPORTANZA");
            rowControls.add("ZONA");
            rowControls.add("SEQUENZA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_NOME");
            staticControls.add("Sorter_IMPORTANZA");
            staticControls.add("Sorter_SEQUENZA");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_RILEVANZE Grid Tail @5-FCB6E20C
    }
//End AMV_RILEVANZE Grid Tail

//AMV_RILEVANZE_RECORD Record @14-55D176D0
    final class AMV_RILEVANZE_RECORDClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_RILEVANZE_RECORD Record

//AdmRilevanzeView Tail @1-FCB6E20C
}
//End AdmRilevanzeView Tail


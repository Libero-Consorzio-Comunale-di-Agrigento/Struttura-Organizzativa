//AdmTipologieView imports @1-7A32161D
package amvadm.AdmTipologie;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmTipologieView imports

//AdmTipologieView class @1-C3746C29
public class AdmTipologieView extends View {
//End AdmTipologieView class

//AdmTipologieView: method show @1-145A6A3F
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmTipologieModel) req.getAttribute( "AdmTipologieModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmTipologie.html";
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
        AMV_TIPOLOGIEClass AMV_TIPOLOGIE = new AMV_TIPOLOGIEClass();
        AMV_TIPOLOGIE.show(page.getGrid("AMV_TIPOLOGIE"));
        AMV_TIPOLOGIE_RECORDClass AMV_TIPOLOGIE_RECORD = new AMV_TIPOLOGIE_RECORDClass();
        AMV_TIPOLOGIE_RECORD.show(page.getRecord("AMV_TIPOLOGIE_RECORD"));
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
//End AdmTipologieView: method show

// //AMV_TIPOLOGIE Grid @7-F81417CB

//AMV_TIPOLOGIEClass head @7-AE2B11C5
    final class AMV_TIPOLOGIEClass {
//End AMV_TIPOLOGIEClass head

// //AMV_TIPOLOGIE Grid: method show @7-F81417CB

//show head @7-8D1CC01B
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME");
            rowControls.add("ZONA");
            rowControls.add("SEQUENZA");
            rowControls.add("IMMAGINE");
            rowControls.add("LINK");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_NOME");
            staticControls.add("Sorter_ZONA");
            staticControls.add("Sorter_SEQUENZA");
            staticControls.add("Sorter_IMMAGINE");
            staticControls.add("Sorter_LINK");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_TIPOLOGIE Grid Tail @7-FCB6E20C
    }
//End AMV_TIPOLOGIE Grid Tail

//AMV_TIPOLOGIE_RECORD Record @22-80A23501
    final class AMV_TIPOLOGIE_RECORDClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_TIPOLOGIE_RECORD Record

//AdmTipologieView Tail @1-FCB6E20C
}
//End AdmTipologieView Tail


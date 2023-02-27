//AdmGuideView imports @1-2731E129
package amvadm.AdmGuide;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmGuideView imports

//AdmGuideView class @1-03A70C0F
public class AdmGuideView extends View {
//End AdmGuideView class

//AdmGuideView: method show @1-58A242A3
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmGuideModel) req.getAttribute( "AdmGuideModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmGuide.html";
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
        AMV_VOCIClass AMV_VOCI = new AMV_VOCIClass();
        AMV_VOCI.show(page.getGrid("AMV_VOCI"));
        AMV_GUIDEClass AMV_GUIDE = new AMV_GUIDEClass();
        AMV_GUIDE.show(page.getGrid("AMV_GUIDE"));
        AMV_GUIDE1Class AMV_GUIDE1 = new AMV_GUIDE1Class();
        AMV_GUIDE1.show(page.getRecord("AMV_GUIDE1"));
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
//End AdmGuideView: method show

// //AMV_VOCI Grid @41-F81417CB

//AMV_VOCIClass head @41-E6C495DD
    final class AMV_VOCIClass {
//End AMV_VOCIClass head

// //AMV_VOCI Grid: method show @41-F81417CB

//show head @41-D07AA5EA
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO_VOCE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_VOCI Grid Tail @41-FCB6E20C
    }
//End AMV_VOCI Grid Tail

// //AMV_GUIDE Grid @5-F81417CB

//AMV_GUIDEClass head @5-E3FDEBD4
    final class AMV_GUIDEClass {
//End AMV_GUIDEClass head

// //AMV_GUIDE Grid: method show @5-F81417CB

//show head @5-961FF66C
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("SEQUENZA");
            rowControls.add("VOCE_RIF");
            rowControls.add("URL_RIF");
            rowControls.add("Modifica");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_TITOLO");
            staticControls.add("Sorter_SEQUENZA");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_GUIDE Grid Tail @5-FCB6E20C
    }
//End AMV_GUIDE Grid Tail

//AMV_GUIDE1 Record @19-88D9BED8
    final class AMV_GUIDE1Class {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_GUIDE1 Record

//AdmGuideView Tail @1-FCB6E20C
}
//End AdmGuideView Tail


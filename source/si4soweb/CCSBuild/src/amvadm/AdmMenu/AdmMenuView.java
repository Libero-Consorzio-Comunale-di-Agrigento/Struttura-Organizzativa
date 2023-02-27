//AdmMenuView imports @1-30CF66D2
package amvadm.AdmMenu;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmMenuView imports

//AdmMenuView class @1-8F651167
public class AdmMenuView extends View {
//End AdmMenuView class

//AdmMenuView: method show @1-4AFDB915
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmMenuModel) req.getAttribute( "AdmMenuModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmMenu.html";
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
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            common.AmvGuida.AmvGuidaView AmvGuida = new common.AmvGuida.AmvGuidaView();
            tmpl.setVar( "main/@AmvGuida", AmvGuida.show( req, resp, context ));
            page.setCookies();
        }
        RuoloClass Ruolo = new RuoloClass();
        Ruolo.show(page.getRecord("Ruolo"));
        AlberoClass Albero = new AlberoClass();
        Albero.show(page.getGrid("Albero"));
        AMV_VOCIClass AMV_VOCI = new AMV_VOCIClass();
        AMV_VOCI.show(page.getRecord("AMV_VOCI"));
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
//End AdmMenuView: method show

//Ruolo Record @6-BE56B7B7
    final class RuoloClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End Ruolo Record

// //Albero Grid @15-F81417CB

//AlberoClass head @15-86C281BC
    final class AlberoClass {
//End AlberoClass head

// //Albero Grid: method show @15-F81417CB

//show head @15-1795A841
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MENU");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Albero Grid Tail @15-FCB6E20C
    }
//End Albero Grid Tail

//AMV_VOCI Record @35-3996E4A1
    final class AMV_VOCIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_VOCI Record

//AdmMenuView Tail @1-FCB6E20C
}
//End AdmMenuView Tail


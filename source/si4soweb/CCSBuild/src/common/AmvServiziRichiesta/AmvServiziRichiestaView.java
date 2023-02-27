//AmvServiziRichiestaView imports @1-0AFD564B
package common.AmvServiziRichiesta;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvServiziRichiestaView imports

//AmvServiziRichiestaView class @1-31374D9C
public class AmvServiziRichiestaView extends View {
//End AmvServiziRichiestaView class

//AmvServiziRichiestaView: method show @1-7F15619B
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvServiziRichiestaModel) req.getAttribute( "AmvServiziRichiestaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvServiziRichiesta.html";
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
        AD4_UTENTEGridClass AD4_UTENTEGrid = new AD4_UTENTEGridClass();
        AD4_UTENTEGrid.show(page.getGrid("AD4_UTENTEGrid"));
        AD4_UTENTEClass AD4_UTENTE = new AD4_UTENTEClass();
        AD4_UTENTE.show(page.getRecord("AD4_UTENTE"));
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
//End AmvServiziRichiestaView: method show

// //AD4_UTENTEGrid Grid @67-F81417CB

//AD4_UTENTEGridClass head @67-37151883
    final class AD4_UTENTEGridClass {
//End AD4_UTENTEGridClass head

// //AD4_UTENTEGrid Grid: method show @67-F81417CB

//show head @67-BF7D0CD0
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOMINATIVO");
            rowControls.add("PASSWORD");
            rowControls.add("NOTIFICA");
            rowControls.add("INDIRIZZO_COMPLETO");
            rowControls.add("MODIFICA_RESIDENZA");
            rowControls.add("INDIRIZZO_WEB");
            rowControls.add("MODIFICA_RECAPITO");
            rowControls.add("TELEFONO");
            rowControls.add("FAX");
            rowControls.add("SERVIZIO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_UTENTEGrid Grid Tail @67-FCB6E20C
    }
//End AD4_UTENTEGrid Grid Tail

//AD4_UTENTE Record @2-4387350C
    final class AD4_UTENTEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTE Record

//AmvServiziRichiestaView Tail @1-FCB6E20C
}
//End AmvServiziRichiestaView Tail


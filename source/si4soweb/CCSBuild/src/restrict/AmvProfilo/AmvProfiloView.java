//AmvProfiloView imports @1-8BCBF283
package restrict.AmvProfilo;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvProfiloView imports

//AmvProfiloView class @1-A5B369D4
public class AmvProfiloView extends View {
//End AmvProfiloView class

//AmvProfiloView: method show @1-1CD697AD
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvProfiloModel) req.getAttribute( "AmvProfiloModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvProfilo.html";
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
        MESSAGGIO_PASSWORDClass MESSAGGIO_PASSWORD = new MESSAGGIO_PASSWORDClass();
        MESSAGGIO_PASSWORD.show(page.getGrid("MESSAGGIO_PASSWORD"));
        AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
        AD4_UTENTI.show(page.getRecord("AD4_UTENTI"));
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
//End AmvProfiloView: method show

// //MESSAGGIO_PASSWORD Grid @42-F81417CB

//MESSAGGIO_PASSWORDClass head @42-A268EF1B
    final class MESSAGGIO_PASSWORDClass {
//End MESSAGGIO_PASSWORDClass head

// //MESSAGGIO_PASSWORD Grid: method show @42-F81417CB

//show head @42-315A3F2B
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MESSAGGIO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//MESSAGGIO_PASSWORD Grid Tail @42-FCB6E20C
    }
//End MESSAGGIO_PASSWORD Grid Tail

//AD4_UTENTI Record @6-3FE1AF3E
    final class AD4_UTENTIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTI Record

//AmvProfiloView Tail @1-FCB6E20C
}
//End AmvProfiloView Tail


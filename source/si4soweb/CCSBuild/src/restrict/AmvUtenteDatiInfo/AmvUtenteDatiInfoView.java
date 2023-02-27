//AmvUtenteDatiInfoView imports @1-F74ACD67
package restrict.AmvUtenteDatiInfo;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvUtenteDatiInfoView imports

//AmvUtenteDatiInfoView class @1-DCECEA92
public class AmvUtenteDatiInfoView extends View {
//End AmvUtenteDatiInfoView class

//AmvUtenteDatiInfoView: method show @1-64E3632C
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvUtenteDatiInfoModel) req.getAttribute( "AmvUtenteDatiInfoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvUtenteDatiInfo.html";
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
        AD4_UTENTEClass AD4_UTENTE = new AD4_UTENTEClass();
        AD4_UTENTE.show(page.getRecord("AD4_UTENTE"));
        AD4_SOGGETTOClass AD4_SOGGETTO = new AD4_SOGGETTOClass();
        AD4_SOGGETTO.show(page.getRecord("AD4_SOGGETTO"));
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
//End AmvUtenteDatiInfoView: method show

//AD4_UTENTE Record @6-4387350C
    final class AD4_UTENTEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTE Record

//AD4_SOGGETTO Record @52-E0559E8A
    final class AD4_SOGGETTOClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_SOGGETTO Record

//AmvUtenteDatiInfoView Tail @1-FCB6E20C
}
//End AmvUtenteDatiInfoView Tail


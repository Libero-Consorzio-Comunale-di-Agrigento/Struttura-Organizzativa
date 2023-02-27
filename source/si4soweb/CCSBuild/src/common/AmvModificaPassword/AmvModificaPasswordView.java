//AmvModificaPasswordView imports @1-8256422D
package common.AmvModificaPassword;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvModificaPasswordView imports

//AmvModificaPasswordView class @1-09A4F21F
public class AmvModificaPasswordView extends View {
//End AmvModificaPasswordView class

//AmvModificaPasswordView: method show @1-1531B835
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvModificaPasswordModel) req.getAttribute( "AmvModificaPasswordModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvModificaPassword.html";
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
        AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
        AD4_UTENTI.show(page.getRecord("AD4_UTENTI"));
        view.show(page.getControl("MSG"));
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
//End AmvModificaPasswordView: method show

//AD4_UTENTI Record @6-3FE1AF3E
    final class AD4_UTENTIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTI Record

//AmvModificaPasswordView Tail @1-FCB6E20C
}
//End AmvModificaPasswordView Tail

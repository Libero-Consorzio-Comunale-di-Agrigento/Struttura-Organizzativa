//AmvLostLoginView imports @1-721801A1
package common.AmvLostLogin;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvLostLoginView imports

//AmvLostLoginView class @1-DB1C15A9
public class AmvLostLoginView extends View {
//End AmvLostLoginView class

//AmvLostLoginView: method show @1-4E5BDE48
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvLostLoginModel) req.getAttribute( "AmvLostLoginModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvLostLogin.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        LOSTLOGINClass LOSTLOGIN = new LOSTLOGINClass();
        LOSTLOGIN.show(page.getRecord("LOSTLOGIN"));
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
//End AmvLostLoginView: method show

//LOSTLOGIN Record @6-2C877A0E
    final class LOSTLOGINClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End LOSTLOGIN Record

//AmvLostLoginView Tail @1-FCB6E20C
}
//End AmvLostLoginView Tail

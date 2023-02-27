//LoginView imports @1-486A8B4A
package common.Login;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End LoginView imports

//LoginView class @1-EA1A1E25
public class LoginView extends View {
//End LoginView class

//LoginView: method show @1-7958CF19
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (LoginModel) req.getAttribute( "LoginModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Login.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvLogin" ).isVisible() ) {
            common.AmvLogin.AmvLoginView AmvLogin = new common.AmvLogin.AmvLoginView();
            tmpl.setVar( "main/@AmvLogin", AmvLogin.show( req, resp, context ));
            page.setCookies();
        }
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
//End LoginView: method show

//LoginView Tail @1-FCB6E20C
}
//End LoginView Tail




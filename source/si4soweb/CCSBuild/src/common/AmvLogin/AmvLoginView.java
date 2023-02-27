//AmvLoginView imports @1-A86026F1
package common.AmvLogin;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvLoginView imports

//AmvLoginView class @1-8AC22915
public class AmvLoginView extends View {
//End AmvLoginView class

//AmvLoginView: method show @1-5ED2EEAB
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvLoginModel) req.getAttribute( "AmvLoginModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvLogin.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        LOGINClass LOGIN = new LOGINClass();
        LOGIN.show(page.getRecord("LOGIN"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvLoginView: method show

//LOGIN Record @2-AF19329C
    final class LOGINClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End LOGIN Record

//AmvLoginView Tail @1-FCB6E20C
}
//End AmvLoginView Tail


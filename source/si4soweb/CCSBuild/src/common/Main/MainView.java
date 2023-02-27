//MainView imports @1-3FED476E
package common.Main;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End MainView imports

//MainView class @1-F622A5A0
public class MainView extends View {
//End MainView class

//MainView: method show @1-F7AD3C26
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (MainModel) req.getAttribute( "MainModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Main.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            common.AmvStyle.AmvStyleView AmvStyle = new common.AmvStyle.AmvStyleView();
            tmpl.setVar( "main/@AmvStyle", AmvStyle.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvHome" ).isVisible() ) {
            common.AmvHome.AmvHomeView AmvHome = new common.AmvHome.AmvHomeView();
            tmpl.setVar( "main/@AmvHome", AmvHome.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvMain" ).isVisible() ) {
            common.AmvMain.AmvMainView AmvMain = new common.AmvMain.AmvMainView();
            tmpl.setVar( "main/@AmvMain", AmvMain.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End MainView: method show

//MainView Tail @1-FCB6E20C
}
//End MainView Tail


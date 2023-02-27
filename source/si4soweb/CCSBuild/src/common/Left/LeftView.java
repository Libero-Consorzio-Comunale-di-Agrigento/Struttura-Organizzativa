//LeftView imports @1-47421AC2
package common.Left;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End LeftView imports

//LeftView class @1-A92F7148
public class LeftView extends View {
//End LeftView class

//LeftView: method show @1-1F74694F
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (LeftModel) req.getAttribute( "LeftModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Left.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvLeftMenu" ).isVisible() ) {
            common.AmvLeftMenu.AmvLeftMenuView AmvLeftMenu = new common.AmvLeftMenu.AmvLeftMenuView();
            tmpl.setVar( "main/@AmvLeftMenu", AmvLeftMenu.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvLeftMenuSezioni" ).isVisible() ) {
            common.AmvLeftMenuSezioni.AmvLeftMenuSezioniView AmvLeftMenuSezioni = new common.AmvLeftMenuSezioni.AmvLeftMenuSezioniView();
            tmpl.setVar( "main/@AmvLeftMenuSezioni", AmvLeftMenuSezioni.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvLeftDoc" ).isVisible() ) {
            common.AmvLeftDoc.AmvLeftDocView AmvLeftDoc = new common.AmvLeftDoc.AmvLeftDocView();
            tmpl.setVar( "main/@AmvLeftDoc", AmvLeftDoc.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End LeftView: method show

//LeftView Tail @1-FCB6E20C
}
//End LeftView Tail


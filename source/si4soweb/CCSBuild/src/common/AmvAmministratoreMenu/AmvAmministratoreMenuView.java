





//AmvAmministratoreMenuView imports @1-3D1A0934
package common.AmvAmministratoreMenu;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvAmministratoreMenuView imports

//AmvAmministratoreMenuView class @1-3634BADA
public class AmvAmministratoreMenuView extends View {
//End AmvAmministratoreMenuView class

//AmvAmministratoreMenuView: method show @1-23B669F8
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvAmministratoreMenuModel) req.getAttribute( "AmvAmministratoreMenuModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvAmministratoreMenu.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvAmministratoreMenuView: method show

//AmvAmministratoreMenuView Tail @1-FCB6E20C
}
//End AmvAmministratoreMenuView Tail



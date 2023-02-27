//AmvDocumentiMenuView imports @1-358D00C6
package common.AmvDocumentiMenu;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvDocumentiMenuView imports

//AmvDocumentiMenuView class @1-CC441C2A
public class AmvDocumentiMenuView extends View {
//End AmvDocumentiMenuView class

//AmvDocumentiMenuView: method show @1-3B7E6B50
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvDocumentiMenuModel) req.getAttribute( "AmvDocumentiMenuModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvDocumentiMenu.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvDocumentiMenuView: method show

//AmvDocumentiMenuView Tail @1-FCB6E20C
}
//End AmvDocumentiMenuView Tail


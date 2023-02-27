//AmvEditView imports @1-306953A1
package common.AmvEdit;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvEditView imports

//AmvEditView class @1-18B75D13
public class AmvEditView extends View {
//End AmvEditView class

//AmvEditView: method show @1-200EC436
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvEditModel) req.getAttribute( "AmvEditModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvEdit.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        NOTEClass NOTE = new NOTEClass();
        NOTE.show(page.getRecord("NOTE"));
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            common.AmvStyle.AmvStyleView AmvStyle = new common.AmvStyle.AmvStyleView();
            tmpl.setVar( "main/@AmvStyle", AmvStyle.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvEditView: method show

//NOTE Record @2-4733C36B
    final class NOTEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End NOTE Record

//AmvEditView Tail @1-FCB6E20C
}
//End AmvEditView Tail



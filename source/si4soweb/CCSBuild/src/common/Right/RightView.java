//RightView imports @1-8082E737
package common.Right;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End RightView imports

//RightView class @1-3C3D6D69
public class RightView extends View {
//End RightView class

//RightView: method show @1-73F02EE2
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (RightModel) req.getAttribute( "RightModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Right.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvRightMenuSezioni" ).isVisible() ) {
            common.AmvRightMenuSezioni.AmvRightMenuSezioniView AmvRightMenuSezioni = new common.AmvRightMenuSezioni.AmvRightMenuSezioniView();
            tmpl.setVar( "main/@AmvRightMenuSezioni", AmvRightMenuSezioni.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvRightDoc" ).isVisible() ) {
            common.AmvRightDoc.AmvRightDocView AmvRightDoc = new common.AmvRightDoc.AmvRightDocView();
            tmpl.setVar( "main/@AmvRightDoc", AmvRightDoc.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End RightView: method show

//RightView Tail @1-FCB6E20C
}
//End RightView Tail



//VersioneView imports @1-938DDC07
package common.Versione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End VersioneView imports

//VersioneView class @1-D1B6974D
public class VersioneView extends View {
//End VersioneView class

//VersioneView: method show @1-A385B34A
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (VersioneModel) req.getAttribute( "VersioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/Versione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        page.getControl("VERSIONE").setValue("1.1");
        view.show(page.getControl("VERSIONE"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End VersioneView: method show

//VersioneView Tail @1-FCB6E20C
}
//End VersioneView Tail


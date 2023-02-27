//AmvRightDocView imports @1-61B5F67A
package common.AmvRightDoc;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRightDocView imports

//AmvRightDocView class @1-E1C59124
public class AmvRightDocView extends View {
//End AmvRightDocView class

//AmvRightDocView: method show @1-08C2CB70
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRightDocModel) req.getAttribute( "AmvRightDocModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRightDoc.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        Zona_DClass Zona_D = new Zona_DClass();
        Zona_D.show(page.getGrid("Zona_D"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvRightDocView: method show

// //Zona_D Grid @34-F81417CB

//Zona_DClass head @34-8AB3052C
    final class Zona_DClass {
//End Zona_DClass head

// //Zona_D Grid: method show @34-F81417CB

//show head @34-77276139
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("ZONA_D");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Zona_D Grid Tail @34-FCB6E20C
    }
//End Zona_D Grid Tail

//AmvRightDocView Tail @1-FCB6E20C
}
//End AmvRightDocView Tail



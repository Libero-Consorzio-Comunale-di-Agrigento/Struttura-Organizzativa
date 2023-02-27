//AmvLeftDocView imports @1-75ED6841
package common.AmvLeftDoc;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvLeftDocView imports

//AmvLeftDocView class @1-961B7D75
public class AmvLeftDocView extends View {
//End AmvLeftDocView class

//AmvLeftDocView: method show @1-ADD1174C
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvLeftDocModel) req.getAttribute( "AmvLeftDocModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvLeftDoc.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        Zona_SClass Zona_S = new Zona_SClass();
        Zona_S.show(page.getGrid("Zona_S"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvLeftDocView: method show

// //Zona_S Grid @34-F81417CB

//Zona_SClass head @34-28CAA76C
    final class Zona_SClass {
//End Zona_SClass head

// //Zona_S Grid: method show @34-F81417CB

//show head @34-F16025E5
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("ZONA_S");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Zona_S Grid Tail @34-FCB6E20C
    }
//End Zona_S Grid Tail

//AmvLeftDocView Tail @1-FCB6E20C
}
//End AmvLeftDocView Tail


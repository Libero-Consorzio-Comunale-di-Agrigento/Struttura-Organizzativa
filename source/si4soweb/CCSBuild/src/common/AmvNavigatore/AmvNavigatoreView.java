//AmvNavigatoreView imports @1-995F9A2B
package common.AmvNavigatore;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvNavigatoreView imports

//AmvNavigatoreView class @1-CECF44D6
public class AmvNavigatoreView extends View {
//End AmvNavigatoreView class

//AmvNavigatoreView: method show @1-A9007EC7
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvNavigatoreModel) req.getAttribute( "AmvNavigatoreModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvNavigatore.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        NAVIGATOREClass NAVIGATORE = new NAVIGATOREClass();
        NAVIGATORE.show(page.getGrid("NAVIGATORE"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvNavigatoreView: method show

// //NAVIGATORE Grid @2-F81417CB

//NAVIGATOREClass head @2-2C52534C
    final class NAVIGATOREClass {
//End NAVIGATOREClass head

// //NAVIGATORE Grid: method show @2-F81417CB

//show head @2-24AE57AB
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NAVIGATORE_SEZIONI");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//NAVIGATORE Grid Tail @2-FCB6E20C
    }
//End NAVIGATORE Grid Tail

//AmvNavigatoreView Tail @1-FCB6E20C
}
//End AmvNavigatoreView Tail


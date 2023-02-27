//AmvAccessoView imports @1-D0D4CDF0
package common.AmvAccesso;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvAccessoView imports

//AmvAccessoView class @1-AF44B3C4
public class AmvAccessoView extends View {
//End AmvAccessoView class

//AmvAccessoView: method show @1-51B6A868
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvAccessoModel) req.getAttribute( "AmvAccessoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvAccesso.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        CONTROLLO_PASSWORDClass CONTROLLO_PASSWORD = new CONTROLLO_PASSWORDClass();
        CONTROLLO_PASSWORD.show(page.getGrid("CONTROLLO_PASSWORD"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvAccessoView: method show

// //CONTROLLO_PASSWORD Grid @9-F81417CB

//CONTROLLO_PASSWORDClass head @9-501A686B
    final class CONTROLLO_PASSWORDClass {
//End CONTROLLO_PASSWORDClass head

// //CONTROLLO_PASSWORD Grid: method show @9-F81417CB

//show head @9-926B4447
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("PWD");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//CONTROLLO_PASSWORD Grid Tail @9-FCB6E20C
    }
//End CONTROLLO_PASSWORD Grid Tail

//AmvAccessoView Tail @1-FCB6E20C
}
//End AmvAccessoView Tail


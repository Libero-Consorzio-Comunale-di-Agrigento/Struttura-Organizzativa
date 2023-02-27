//AmvRedirectView imports @1-BAE5D7C3
package common.AmvRedirect;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRedirectView imports

//AmvRedirectView class @1-19FDAAEA
public class AmvRedirectView extends View {
//End AmvRedirectView class

//AmvRedirectView: method show @1-BF2424E2
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRedirectModel) req.getAttribute( "AmvRedirectModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRedirect.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        REDIRECT_TAGClass REDIRECT_TAG = new REDIRECT_TAGClass();
        REDIRECT_TAG.show(page.getGrid("REDIRECT_TAG"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvRedirectView: method show

// //REDIRECT_TAG Grid @2-F81417CB

//REDIRECT_TAGClass head @2-4695077B
    final class REDIRECT_TAGClass {
//End REDIRECT_TAGClass head

// //REDIRECT_TAG Grid: method show @2-F81417CB

//show head @2-DACAE196
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("Redirection");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//REDIRECT_TAG Grid Tail @2-FCB6E20C
    }
//End REDIRECT_TAG Grid Tail

//AmvRedirectView Tail @1-FCB6E20C
}
//End AmvRedirectView Tail


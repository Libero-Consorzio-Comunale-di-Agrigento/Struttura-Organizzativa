//AmvAccessControlView imports @1-E940CA34
package common.AmvAccessControl;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvAccessControlView imports

//AmvAccessControlView class @1-92815B53
public class AmvAccessControlView extends View {
//End AmvAccessControlView class

//AmvAccessControlView: method show @1-AD35E593
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvAccessControlModel) req.getAttribute( "AmvAccessControlModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvAccessControl.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        ACCESSOClass ACCESSO = new ACCESSOClass();
        ACCESSO.show(page.getGrid("ACCESSO"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvAccessControlView: method show

// //ACCESSO Grid @3-F81417CB

//ACCESSOClass head @3-0985B1B9
    final class ACCESSOClass {
//End ACCESSOClass head

// //ACCESSO Grid: method show @3-F81417CB

//show head @3-63BB50F8
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("VOCE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//ACCESSO Grid Tail @3-FCB6E20C
    }
//End ACCESSO Grid Tail

//AmvAccessControlView Tail @1-FCB6E20C
}
//End AmvAccessControlView Tail


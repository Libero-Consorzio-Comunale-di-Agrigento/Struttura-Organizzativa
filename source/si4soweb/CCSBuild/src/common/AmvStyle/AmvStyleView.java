//AmvStyleView imports @1-777D4D23
package common.AmvStyle;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvStyleView imports

//AmvStyleView class @1-89C8DCEB
public class AmvStyleView extends View {
//End AmvStyleView class

//AmvStyleView: method show @1-5CB93385
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvStyleModel) req.getAttribute( "AmvStyleModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvStyle.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        styleClass style = new styleClass();
        style.show(page.getGrid("style"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvStyleView: method show

// //style Grid @2-F81417CB

//styleClass head @2-190914E2
    final class styleClass {
//End styleClass head

// //style Grid: method show @2-F81417CB

//show head @2-F90DF84E
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("STILE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//style Grid Tail @2-FCB6E20C
    }
//End style Grid Tail

//AmvStyleView Tail @1-FCB6E20C
}
//End AmvStyleView Tail


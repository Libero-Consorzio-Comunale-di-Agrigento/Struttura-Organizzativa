//AmvStiliView imports @1-6C9D699B
package restrict.AmvStili;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvStiliView imports

//AmvStiliView class @1-0F928FB0
public class AmvStiliView extends View {
//End AmvStiliView class

//AmvStiliView: method show @1-D51C0FF7
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvStiliModel) req.getAttribute( "AmvStiliModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvStili.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        styleClass style = new styleClass();
        style.show(page.getGrid("style"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvStiliView: method show

// //style Grid @3-F81417CB

//styleClass head @3-190914E2
    final class styleClass {
//End styleClass head

// //style Grid: method show @3-F81417CB

//show head @3-F90DF84E
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("STILE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//style Grid Tail @3-FCB6E20C
    }
//End style Grid Tail
//AmvStiliView Tail @1-FCB6E20C
}
//End AmvStiliView Tail


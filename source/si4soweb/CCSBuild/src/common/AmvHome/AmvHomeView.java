//AmvHomeView imports @1-AF8C4515
package common.AmvHome;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvHomeView imports

//AmvHomeView class @1-9F4E45AA
public class AmvHomeView extends View {
//End AmvHomeView class

//AmvHomeView: method show @1-8B5D9676
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvHomeModel) req.getAttribute( "AmvHomeModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvHome.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        HOME_GRIDClass HOME_GRID = new HOME_GRIDClass();
        HOME_GRID.show(page.getGrid("HOME_GRID"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvHomeView: method show

// //HOME_GRID Grid @2-F81417CB

//HOME_GRIDClass head @2-E5899260
    final class HOME_GRIDClass {
//End HOME_GRIDClass head

// //HOME_GRID Grid: method show @2-F81417CB

//show head @2-F9CF07C2
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("HOME");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//HOME_GRID Grid Tail @2-FCB6E20C
    }
//End HOME_GRID Grid Tail

//AmvHomeView Tail @1-FCB6E20C
}
//End AmvHomeView Tail


//AmvLeftMenuView imports @1-CBE6F319
package common.AmvLeftMenu;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvLeftMenuView imports

//AmvLeftMenuView class @1-3B6B61A1
public class AmvLeftMenuView extends View {
//End AmvLeftMenuView class

//AmvLeftMenuView: method show @1-364DC29F
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvLeftMenuModel) req.getAttribute( "AmvLeftMenuModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvLeftMenu.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        MenuClass Menu = new MenuClass();
        Menu.show(page.getGrid("Menu"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvLeftMenuView: method show

// //Menu Grid @103-F81417CB

//MenuClass head @103-52869F52
    final class MenuClass {
//End MenuClass head

// //Menu Grid: method show @103-F81417CB

//show head @103-1795A841
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MENU");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Menu Grid Tail @103-FCB6E20C
    }
//End Menu Grid Tail

//AmvLeftMenuView Tail @1-FCB6E20C
}
//End AmvLeftMenuView Tail


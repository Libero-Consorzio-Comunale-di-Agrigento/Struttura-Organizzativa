//AmvRightMenuSezioniView imports @1-683C428A
package common.AmvRightMenuSezioni;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRightMenuSezioniView imports

//AmvRightMenuSezioniView class @1-16933012
public class AmvRightMenuSezioniView extends View {
//End AmvRightMenuSezioniView class

//AmvRightMenuSezioniView: method show @1-45861264
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRightMenuSezioniModel) req.getAttribute( "AmvRightMenuSezioniModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRightMenuSezioni.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        MENU_SEZIONIClass MENU_SEZIONI = new MENU_SEZIONIClass();
        MENU_SEZIONI.show(page.getGrid("MENU_SEZIONI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvRightMenuSezioniView: method show

// //MENU_SEZIONI Grid @79-F81417CB

//MENU_SEZIONIClass head @79-F804B0C4
    final class MENU_SEZIONIClass {
//End MENU_SEZIONIClass head

// //MENU_SEZIONI Grid: method show @79-F81417CB

//show head @79-5328EFAF
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MENU_SEZ");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//MENU_SEZIONI Grid Tail @79-FCB6E20C
    }
//End MENU_SEZIONI Grid Tail

//AmvRightMenuSezioniView Tail @1-FCB6E20C
}
//End AmvRightMenuSezioniView Tail

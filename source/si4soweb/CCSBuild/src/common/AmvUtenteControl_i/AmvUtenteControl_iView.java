//AmvUtenteControl_iView imports @1-1570CB11
package common.AmvUtenteControl_i;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvUtenteControl_iView imports

//AmvUtenteControl_iView class @1-03534E55
public class AmvUtenteControl_iView extends View {
//End AmvUtenteControl_iView class

//AmvUtenteControl_iView: method show @1-9CCFFDDF
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvUtenteControl_iModel) req.getAttribute( "AmvUtenteControl_iModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvUtenteControl_i.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        UTENTE_CONTROLClass UTENTE_CONTROL = new UTENTE_CONTROLClass();
        UTENTE_CONTROL.show(page.getGrid("UTENTE_CONTROL"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvUtenteControl_iView: method show

// //UTENTE_CONTROL Grid @2-F81417CB

//UTENTE_CONTROLClass head @2-4F612A09
    final class UTENTE_CONTROLClass {
//End UTENTE_CONTROLClass head

// //UTENTE_CONTROL Grid: method show @2-F81417CB

//show head @2-CD81FDAD
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("Utente");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//UTENTE_CONTROL Grid Tail @2-FCB6E20C
    }
//End UTENTE_CONTROL Grid Tail

//AmvUtenteControl_iView Tail @1-FCB6E20C
}
//End AmvUtenteControl_iView Tail


//AmvServiziRichiestiElenco_iView imports @1-FB6E0624
package common.AmvServiziRichiestiElenco_i;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvServiziRichiestiElenco_iView imports

//AmvServiziRichiestiElenco_iView class @1-7A82162C
public class AmvServiziRichiestiElenco_iView extends View {
//End AmvServiziRichiestiElenco_iView class

//AmvServiziRichiestiElenco_iView: method show @1-F7F61946
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvServiziRichiestiElenco_iModel) req.getAttribute( "AmvServiziRichiestiElenco_iModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvServiziRichiestiElenco_i.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        SERVIZI_RICHIESTIClass SERVIZI_RICHIESTI = new SERVIZI_RICHIESTIClass();
        SERVIZI_RICHIESTI.show(page.getGrid("SERVIZI_RICHIESTI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvServiziRichiestiElenco_iView: method show

// //SERVIZI_RICHIESTI Grid @2-F81417CB

//SERVIZI_RICHIESTIClass head @2-086CC050
    final class SERVIZI_RICHIESTIClass {
//End SERVIZI_RICHIESTIClass head

// //SERVIZI_RICHIESTI Grid: method show @2-F81417CB

//show head @2-D3CF353D
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DATA");
            rowControls.add("SERVIZIO");
            rowControls.add("NOTIFICA");
            rowControls.add("AZIENDA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//SERVIZI_RICHIESTI Grid Tail @2-FCB6E20C
    }
//End SERVIZI_RICHIESTI Grid Tail

//AmvServiziRichiestiElenco_iView Tail @1-FCB6E20C
}
//End AmvServiziRichiestiElenco_iView Tail

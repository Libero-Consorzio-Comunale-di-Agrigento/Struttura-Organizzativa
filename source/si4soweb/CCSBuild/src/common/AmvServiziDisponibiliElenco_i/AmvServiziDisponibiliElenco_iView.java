

//AmvServiziDisponibiliElenco_iView imports @1-6F2BC8B6
package common.AmvServiziDisponibiliElenco_i;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvServiziDisponibiliElenco_iView imports

//AmvServiziDisponibiliElenco_iView class @1-4D4769B8
public class AmvServiziDisponibiliElenco_iView extends View {
//End AmvServiziDisponibiliElenco_iView class

//AmvServiziDisponibiliElenco_iView: method show @1-85C65C13
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvServiziDisponibiliElenco_iModel) req.getAttribute( "AmvServiziDisponibiliElenco_iModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvServiziDisponibiliElenco_i.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        SERVIZI_DISPONIBILIClass SERVIZI_DISPONIBILI = new SERVIZI_DISPONIBILIClass();
        SERVIZI_DISPONIBILI.show(page.getGrid("SERVIZI_DISPONIBILI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvServiziDisponibiliElenco_iView: method show

// //SERVIZI_DISPONIBILI Grid @16-F81417CB

//SERVIZI_DISPONIBILIClass head @16-ADC3ECF0
    final class SERVIZI_DISPONIBILIClass {
//End SERVIZI_DISPONIBILIClass head

// //SERVIZI_DISPONIBILI Grid: method show @16-F81417CB

//show head @16-FCA8C0A0
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("SERVIZIO");
            rowControls.add("RICHIESTA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//SERVIZI_DISPONIBILI Grid Tail @16-FCB6E20C
    }
//End SERVIZI_DISPONIBILI Grid Tail

//AmvServiziDisponibiliElenco_iView Tail @1-FCB6E20C
}
//End AmvServiziDisponibiliElenco_iView Tail






//AmvServiziAbilitatiElenco_iView imports @1-C4FE97E4
package common.AmvServiziAbilitatiElenco_i;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvServiziAbilitatiElenco_iView imports

//AmvServiziAbilitatiElenco_iView class @1-D0A03270
public class AmvServiziAbilitatiElenco_iView extends View {
//End AmvServiziAbilitatiElenco_iView class

//AmvServiziAbilitatiElenco_iView: method show @1-CCC9D220
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvServiziAbilitatiElenco_iModel) req.getAttribute( "AmvServiziAbilitatiElenco_iModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvServiziAbilitatiElenco_i.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        SERVIZI_ABILITATIClass SERVIZI_ABILITATI = new SERVIZI_ABILITATIClass();
        SERVIZI_ABILITATI.show(page.getGrid("SERVIZI_ABILITATI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvServiziAbilitatiElenco_iView: method show

// //SERVIZI_ABILITATI Grid @10-F81417CB

//SERVIZI_ABILITATIClass head @10-6148D3F3
    final class SERVIZI_ABILITATIClass {
//End SERVIZI_ABILITATIClass head

// //SERVIZI_ABILITATI Grid: method show @10-F81417CB

//show head @10-B8720652
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DATA");
            rowControls.add("SERVIZIO");
            rowControls.add("NOTIFICA");
            rowControls.add("AZIENDA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Label1");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//SERVIZI_ABILITATI Grid Tail @10-FCB6E20C
    }
//End SERVIZI_ABILITATI Grid Tail

//AmvServiziAbilitatiElenco_iView Tail @1-FCB6E20C
}
//End AmvServiziAbilitatiElenco_iView Tail




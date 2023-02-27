//AmvUtenteNominativo_iView imports @1-2BCD23D8
package common.AmvUtenteNominativo_i;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvUtenteNominativo_iView imports

//AmvUtenteNominativo_iView class @1-749674D8
public class AmvUtenteNominativo_iView extends View {
//End AmvUtenteNominativo_iView class

//AmvUtenteNominativo_iView: method show @1-5E7A294E
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvUtenteNominativo_iModel) req.getAttribute( "AmvUtenteNominativo_iModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvUtenteNominativo_i.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        UTENTE_CONTROLClass UTENTE_CONTROL = new UTENTE_CONTROLClass();
        UTENTE_CONTROL.show(page.getGrid("UTENTE_CONTROL"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvUtenteNominativo_iView: method show

// //UTENTE_CONTROL Grid @2-F81417CB

//UTENTE_CONTROLClass head @2-4F612A09
    final class UTENTE_CONTROLClass {
//End UTENTE_CONTROLClass head

// //UTENTE_CONTROL Grid: method show @2-F81417CB

//show head @2-0933EF3A
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOMINATIVO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//UTENTE_CONTROL Grid Tail @2-FCB6E20C
    }
//End UTENTE_CONTROL Grid Tail

//AmvUtenteNominativo_iView Tail @1-FCB6E20C
}
//End AmvUtenteNominativo_iView Tail


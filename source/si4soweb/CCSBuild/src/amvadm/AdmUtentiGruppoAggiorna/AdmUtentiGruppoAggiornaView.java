//AdmUtentiGruppoAggiornaView imports @1-B8D82CCB
package amvadm.AdmUtentiGruppoAggiorna;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmUtentiGruppoAggiornaView imports

//AdmUtentiGruppoAggiornaView class @1-A5929F15
public class AdmUtentiGruppoAggiornaView extends View {
//End AdmUtentiGruppoAggiornaView class

//AdmUtentiGruppoAggiornaView: method show @1-31F5F8A9
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmUtentiGruppoAggiornaModel) req.getAttribute( "AdmUtentiGruppoAggiornaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmUtentiGruppoAggiorna.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        UTENTI_GRUPPOClass UTENTI_GRUPPO = new UTENTI_GRUPPOClass();
        UTENTI_GRUPPO.show(page.getRecord("UTENTI_GRUPPO"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AdmUtentiGruppoAggiornaView: method show

//UTENTI_GRUPPO Record @2-A5EE0065
    final class UTENTI_GRUPPOClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End UTENTI_GRUPPO Record

//AdmUtentiGruppoAggiornaView Tail @1-FCB6E20C
}
//End AdmUtentiGruppoAggiornaView Tail


//AmvRichiestaAbilitazioneView imports @1-4A8393C1
package common.AmvRichiestaAbilitazione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRichiestaAbilitazioneView imports

//AmvRichiestaAbilitazioneView class @1-9B06808E
public class AmvRichiestaAbilitazioneView extends View {
//End AmvRichiestaAbilitazioneView class

//AmvRichiestaAbilitazioneView: method show @1-3A468EC7
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRichiestaAbilitazioneModel) req.getAttribute( "AmvRichiestaAbilitazioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRichiestaAbilitazione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        AD4_RICHIESTAClass AD4_RICHIESTA = new AD4_RICHIESTAClass();
        AD4_RICHIESTA.show(page.getRecord("AD4_RICHIESTA"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvRichiestaAbilitazioneView: method show

//AD4_RICHIESTA Record @2-EBAC6629
    final class AD4_RICHIESTAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_RICHIESTA Record

//AmvRichiestaAbilitazioneView Tail @1-FCB6E20C
}
//End AmvRichiestaAbilitazioneView Tail


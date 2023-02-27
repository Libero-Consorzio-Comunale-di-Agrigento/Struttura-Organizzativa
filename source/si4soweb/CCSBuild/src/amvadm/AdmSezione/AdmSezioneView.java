//AdmSezioneView imports @1-93D17C8E
package amvadm.AdmSezione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmSezioneView imports

//AdmSezioneView class @1-73FC97DB
public class AdmSezioneView extends View {
//End AdmSezioneView class

//AdmSezioneView: method show @1-7D216B2B
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmSezioneModel) req.getAttribute( "AdmSezioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmSezione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        AMV_SEZIONE_RECORDClass AMV_SEZIONE_RECORD = new AMV_SEZIONE_RECORDClass();
        AMV_SEZIONE_RECORD.show(page.getRecord("AMV_SEZIONE_RECORD"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AdmSezioneView: method show

//AMV_SEZIONE_RECORD Record @2-6C86C8BD
    final class AMV_SEZIONE_RECORDClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_SEZIONE_RECORD Record

//AdmSezioneView Tail @1-FCB6E20C
}
//End AdmSezioneView Tail


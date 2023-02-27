//AmvRegistrazioneLinkView imports @1-067206F1
package common.AmvRegistrazioneLink;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRegistrazioneLinkView imports

//AmvRegistrazioneLinkView class @1-ED849BD4
public class AmvRegistrazioneLinkView extends View {
//End AmvRegistrazioneLinkView class

//AmvRegistrazioneLinkView: method show @1-BC915F53
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRegistrazioneLinkModel) req.getAttribute( "AmvRegistrazioneLinkModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRegistrazioneLink.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        registrazione_servizioClass registrazione_servizio = new registrazione_servizioClass();
        registrazione_servizio.show(page.getGrid("registrazione_servizio"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvRegistrazioneLinkView: method show

// //registrazione_servizio Grid @2-F81417CB

//registrazione_servizioClass head @2-55064FAE
    final class registrazione_servizioClass {
//End registrazione_servizioClass head

// //registrazione_servizio Grid: method show @2-F81417CB

//show head @2-F315B1F8
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("SERVIZIO");
            rowControls.add("NOMINATIVO");
            rowControls.add("REGISTRAZIONE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//registrazione_servizio Grid Tail @2-FCB6E20C
    }
//End registrazione_servizio Grid Tail

//AmvRegistrazioneLinkView Tail @1-FCB6E20C
}
//End AmvRegistrazioneLinkView Tail


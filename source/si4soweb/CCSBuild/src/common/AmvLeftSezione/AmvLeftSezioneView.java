//AmvLeftSezioneView imports @1-40AFE3E7
package common.AmvLeftSezione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvLeftSezioneView imports

//AmvLeftSezioneView class @1-2E59296C
public class AmvLeftSezioneView extends View {
//End AmvLeftSezioneView class

//AmvLeftSezioneView: method show @1-4EB21D95
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvLeftSezioneModel) req.getAttribute( "AmvLeftSezioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvLeftSezione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        SEZIONI_SClass SEZIONI_S = new SEZIONI_SClass();
        SEZIONI_S.show(page.getGrid("SEZIONI_S"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvLeftSezioneView: method show

// //SEZIONI_S Grid @72-F81417CB

//SEZIONI_SClass head @72-058D3508
    final class SEZIONI_SClass {
//End SEZIONI_SClass head

// //SEZIONI_S Grid: method show @72-F81417CB

//show head @72-6F548C6B
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("BLOCCO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//SEZIONI_S Grid Tail @72-FCB6E20C
    }
//End SEZIONI_S Grid Tail

//AmvLeftSezioneView Tail @1-FCB6E20C
}
//End AmvLeftSezioneView Tail

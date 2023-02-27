//AmvGuidaView imports @1-CCB38442
package common.AmvGuida;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvGuidaView imports

//AmvGuidaView class @1-C2A94333
public class AmvGuidaView extends View {
//End AmvGuidaView class

//AmvGuidaView: method show @1-DD190191
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvGuidaModel) req.getAttribute( "AmvGuidaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvGuida.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        GuidaClass Guida = new GuidaClass();
        Guida.show(page.getGrid("Guida"));
        GuidaPropriaClass GuidaPropria = new GuidaPropriaClass();
        GuidaPropria.show(page.getGrid("GuidaPropria"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvGuidaView: method show

// //Guida Grid @2-F81417CB

//GuidaClass head @2-E5123A95
    final class GuidaClass {
//End GuidaClass head

// //Guida Grid: method show @2-F81417CB

//show head @2-747BF878
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("APERTURA");
            rowControls.add("GUIDA");
            rowControls.add("CHIUSURA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Guida Grid Tail @2-FCB6E20C
    }
//End Guida Grid Tail

// //GuidaPropria Grid @13-F81417CB

//GuidaPropriaClass head @13-EC9BF011
    final class GuidaPropriaClass {
//End GuidaPropriaClass head

// //GuidaPropria Grid: method show @13-F81417CB

//show head @13-747BF878
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("APERTURA");
            rowControls.add("GUIDA");
            rowControls.add("CHIUSURA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//GuidaPropria Grid Tail @13-FCB6E20C
    }
//End GuidaPropria Grid Tail

//AmvGuidaView Tail @1-FCB6E20C
}
//End AmvGuidaView Tail


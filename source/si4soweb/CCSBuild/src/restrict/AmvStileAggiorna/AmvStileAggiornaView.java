//AmvStileAggiornaView imports @1-3056A20A
package restrict.AmvStileAggiorna;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvStileAggiornaView imports

//AmvStileAggiornaView class @1-F6B103C3
public class AmvStileAggiornaView extends View {
//End AmvStileAggiornaView class

//AmvStileAggiornaView: method show @1-166A6F44
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvStileAggiornaModel) req.getAttribute( "AmvStileAggiornaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvStileAggiorna.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        STILEClass STILE = new STILEClass();
        STILE.show(page.getRecord("STILE"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvStileAggiornaView: method show

//STILE Record @2-C415B86B
    final class STILEClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End STILE Record

//AmvStileAggiornaView Tail @1-FCB6E20C
}
//End AmvStileAggiornaView Tail


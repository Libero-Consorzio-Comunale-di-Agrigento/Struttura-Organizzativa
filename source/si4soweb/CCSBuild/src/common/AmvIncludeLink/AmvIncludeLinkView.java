

//AmvIncludeLinkView imports @1-36D95C54
package common.AmvIncludeLink;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvIncludeLinkView imports

//AmvIncludeLinkView class @1-67C2F42B
public class AmvIncludeLinkView extends View {
//End AmvIncludeLinkView class

//AmvIncludeLinkView: method show @1-EBB7FE16
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvIncludeLinkModel) req.getAttribute( "AmvIncludeLinkModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvIncludeLink.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        PaginaClass Pagina = new PaginaClass();
        Pagina.show(page.getGrid("Pagina"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvIncludeLinkView: method show

// //Pagina Grid @3-F81417CB

//PaginaClass head @3-A1DD0A41
    final class PaginaClass {
//End PaginaClass head

// //Pagina Grid: method show @3-F81417CB

//show head @3-1857A2AB
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("PAGE_LINK");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//Pagina Grid Tail @3-FCB6E20C
    }
//End Pagina Grid Tail

//AmvIncludeLinkView Tail @1-FCB6E20C
}
//End AmvIncludeLinkView Tail



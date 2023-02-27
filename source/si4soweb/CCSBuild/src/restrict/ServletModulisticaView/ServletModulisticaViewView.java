//ServletModulisticaViewView imports @1-A0B47C6E
package restrict.ServletModulisticaView;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End ServletModulisticaViewView imports

//ServletModulisticaViewView class @1-99C47453
public class ServletModulisticaViewView extends View {
//End ServletModulisticaViewView class

//ServletModulisticaViewView: method show @1-93BC7999
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (ServletModulisticaViewModel) req.getAttribute( "ServletModulisticaViewModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/ServletModulisticaView.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        view.show(page.getControl("corpoHtml"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End ServletModulisticaViewView: method show

//ServletModulisticaViewView Tail @1-FCB6E20C
}
//End ServletModulisticaViewView Tail

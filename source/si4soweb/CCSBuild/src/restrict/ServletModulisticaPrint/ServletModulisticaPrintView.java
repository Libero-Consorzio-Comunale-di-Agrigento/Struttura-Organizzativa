//ServletModulisticaPrintView imports @1-CB4549A4
package restrict.ServletModulisticaPrint;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End ServletModulisticaPrintView imports

//ServletModulisticaPrintView class @1-0A2DA874
public class ServletModulisticaPrintView extends View {
//End ServletModulisticaPrintView class

//ServletModulisticaPrintView: method show @1-18F8F0BC
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (ServletModulisticaPrintModel) req.getAttribute( "ServletModulisticaPrintModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/ServletModulisticaPrint.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        view.show(page.getControl("corpoHtml"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End ServletModulisticaPrintView: method show

//ServletModulisticaPrintView Tail @1-FCB6E20C
}
//End ServletModulisticaPrintView Tail

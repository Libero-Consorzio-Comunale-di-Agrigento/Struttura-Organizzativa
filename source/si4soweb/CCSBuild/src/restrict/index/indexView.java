//indexView imports @1-3048AD03
package restrict.index;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End indexView imports

//indexView class @1-9A5C5648
public class indexView extends View {
//End indexView class

//indexView: method show @1-58B4420A
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (indexModel) req.getAttribute( "indexModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/index.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End indexView: method show

//indexView Tail @1-FCB6E20C
}
//End indexView Tail


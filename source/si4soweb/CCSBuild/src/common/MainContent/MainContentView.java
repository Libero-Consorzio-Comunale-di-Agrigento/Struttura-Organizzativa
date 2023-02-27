//MainContentView imports @1-E7580D0C
package common.MainContent;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End MainContentView imports

//MainContentView class @1-3402E654
public class MainContentView extends View {
//End MainContentView class

//MainContentView: method show @1-99AEFFB5
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (MainContentModel) req.getAttribute( "MainContentModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/MainContent.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End MainContentView: method show

//MainContentView Tail @1-FCB6E20C
}
//End MainContentView Tail


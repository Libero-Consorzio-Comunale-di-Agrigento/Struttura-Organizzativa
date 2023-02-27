//AmvIncludeView imports @1-6CE39728
package common.AmvInclude;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvIncludeView imports

//AmvIncludeView class @1-C5F64EE0
public class AmvIncludeView extends View {
//End AmvIncludeView class

//AmvIncludeView: method show @1-67DC1818
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvIncludeModel) req.getAttribute( "AmvIncludeModel" );
        this.tmplPath = "/common/AmvInclude.html";
        init(req, resp, context, page);
		String pageToBeIncluded = req.getParameter("MVPG");
        if ( page.getChild( "Pagina" ).isVisible() ) {
            // Codice modificato per includere la pagina specificata nel paramentro "includePage"
            try {
		        View PaginaInclusa = (com.codecharge.View)
			    Class.forName(req.getServletPath().substring(1, req.getServletPath().indexOf('/',1)) + "." + pageToBeIncluded + "." + pageToBeIncluded + "View").newInstance();
   		        tmpl.setVar( "main/@Pagina", PaginaInclusa.show( req, resp, context ));
                        page.setCookies();
				System.out.println("Nessuna exception in inclusione");
	        } catch (Exception e) {
		        System.out.println(e.toString() + " no ok " + req.getServletPath().substring(1, req.getServletPath().indexOf('/',1)) + "." + pageToBeIncluded + "." + pageToBeIncluded + "View");
                e.printStackTrace();
			}
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvIncludeView: method show

//AmvIncludeView Tail @1-FCB6E20C
}
//End AmvIncludeView Tail


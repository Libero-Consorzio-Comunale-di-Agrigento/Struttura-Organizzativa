

//AmvServiziElenco_iView imports @1-089F02D9
package common.AmvServiziElenco_i;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvServiziElenco_iView imports

//AmvServiziElenco_iView class @1-1937F2F6
public class AmvServiziElenco_iView extends View {
//End AmvServiziElenco_iView class

//AmvServiziElenco_iView: method show @1-D974C425
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvServiziElenco_iModel) req.getAttribute( "AmvServiziElenco_iModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvServiziElenco_i.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvServiziRichiestiElenco_i" ).isVisible() ) {
            common.AmvServiziRichiestiElenco_i.AmvServiziRichiestiElenco_iView AmvServiziRichiestiElenco_i = new common.AmvServiziRichiestiElenco_i.AmvServiziRichiestiElenco_iView();
            tmpl.setVar( "main/@AmvServiziRichiestiElenco_i", AmvServiziRichiestiElenco_i.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvServiziAbilitatiElenco_i" ).isVisible() ) {
            common.AmvServiziAbilitatiElenco_i.AmvServiziAbilitatiElenco_iView AmvServiziAbilitatiElenco_i = new common.AmvServiziAbilitatiElenco_i.AmvServiziAbilitatiElenco_iView();
            tmpl.setVar( "main/@AmvServiziAbilitatiElenco_i", AmvServiziAbilitatiElenco_i.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvServiziDisponibiliElenco_i" ).isVisible() ) {
            common.AmvServiziDisponibiliElenco_i.AmvServiziDisponibiliElenco_iView AmvServiziDisponibiliElenco_i = new common.AmvServiziDisponibiliElenco_i.AmvServiziDisponibiliElenco_iView();
            tmpl.setVar( "main/@AmvServiziDisponibiliElenco_i", AmvServiziDisponibiliElenco_i.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvServiziElenco_iView: method show

//AmvServiziElenco_iView Tail @1-FCB6E20C
}
//End AmvServiziElenco_iView Tail



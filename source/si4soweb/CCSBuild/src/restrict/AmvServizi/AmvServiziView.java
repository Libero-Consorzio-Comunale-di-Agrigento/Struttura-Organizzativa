//AmvServiziView imports @1-34A5A373
package restrict.AmvServizi;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvServiziView imports

//AmvServiziView class @1-9B6044E7
public class AmvServiziView extends View {
//End AmvServiziView class

//AmvServiziView: method show @1-9093BA79
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvServiziModel) req.getAttribute( "AmvServiziModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvServizi.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "Left" ).isVisible() ) {
            common.Left.LeftView Left = new common.Left.LeftView();
            tmpl.setVar( "main/@Left", Left.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            common.AmvGuida.AmvGuidaView AmvGuida = new common.AmvGuida.AmvGuidaView();
            tmpl.setVar( "main/@AmvGuida", AmvGuida.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvServiziElenco_i" ).isVisible() ) {
            common.AmvServiziElenco_i.AmvServiziElenco_iView AmvServiziElenco_i = new common.AmvServiziElenco_i.AmvServiziElenco_iView();
            tmpl.setVar( "main/@AmvServiziElenco_i", AmvServiziElenco_i.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "Footer" ).isVisible() ) {
            common.Footer.FooterView Footer = new common.Footer.FooterView();
            tmpl.setVar( "main/@Footer", Footer.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvServiziView: method show

//AmvServiziView Tail @1-FCB6E20C
}
//End AmvServiziView Tail


//AmvRichiestaInoltraView imports @1-A95A74B7
package common.AmvRichiestaInoltra;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRichiestaInoltraView imports

//AmvRichiestaInoltraView class @1-03A6EBD3
public class AmvRichiestaInoltraView extends View {
//End AmvRichiestaInoltraView class

//AmvRichiestaInoltraView: method show @1-28DA848D
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRichiestaInoltraModel) req.getAttribute( "AmvRichiestaInoltraModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRichiestaInoltra.html";
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
        if ( page.getChild( "Guida" ).isVisible() ) {
            common.Guida.GuidaView Guida = new common.Guida.GuidaView();
            tmpl.setVar( "main/@Guida", Guida.show( req, resp, context ));
            page.setCookies();
        }
        RICHIESTA_INOLTRAClass RICHIESTA_INOLTRA = new RICHIESTA_INOLTRAClass();
        RICHIESTA_INOLTRA.show(page.getRecord("RICHIESTA_INOLTRA"));
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
//End AmvRichiestaInoltraView: method show

//RICHIESTA_INOLTRA Record @6-BC0C9A23
    final class RICHIESTA_INOLTRAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End RICHIESTA_INOLTRA Record

//AmvRichiestaInoltraView Tail @1-FCB6E20C
}
//End AmvRichiestaInoltraView Tail

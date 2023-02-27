//AdmRevisioniStoricoView imports @1-65955DBE
package amvadm.AdmRevisioniStorico;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRevisioniStoricoView imports

//AdmRevisioniStoricoView class @1-7E2DB31F
public class AdmRevisioniStoricoView extends View {
//End AdmRevisioniStoricoView class

//AdmRevisioniStoricoView: method show @1-920FDF10
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRevisioniStoricoModel) req.getAttribute( "AdmRevisioniStoricoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRevisioniStorico.html";
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
        if ( page.getChild( "AdmDocumentoRevisioni" ).isVisible() ) {
            amvadm.AdmDocumentoRevisioni.AdmDocumentoRevisioniView AdmDocumentoRevisioni = new amvadm.AdmDocumentoRevisioni.AdmDocumentoRevisioniView();
            tmpl.setVar( "main/@AdmDocumentoRevisioni", AdmDocumentoRevisioni.show( req, resp, context ));
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
//End AdmRevisioniStoricoView: method show

//AdmRevisioniStoricoView Tail @1-FCB6E20C
}
//End AdmRevisioniStoricoView Tail

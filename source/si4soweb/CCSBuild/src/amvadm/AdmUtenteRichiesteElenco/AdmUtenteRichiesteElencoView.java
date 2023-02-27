//AdmUtenteRichiesteElencoView imports @1-55898919
package amvadm.AdmUtenteRichiesteElenco;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmUtenteRichiesteElencoView imports

//AdmUtenteRichiesteElencoView class @1-73FFF45B
public class AdmUtenteRichiesteElencoView extends View {
//End AdmUtenteRichiesteElencoView class

//AdmUtenteRichiesteElencoView: method show @1-914DCD99
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmUtenteRichiesteElencoModel) req.getAttribute( "AdmUtenteRichiesteElencoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmUtenteRichiesteElenco.html";
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
        if ( page.getChild( "AmvUtenteNominativo_i" ).isVisible() ) {
            common.AmvUtenteNominativo_i.AmvUtenteNominativo_iView AmvUtenteNominativo_i = new common.AmvUtenteNominativo_i.AmvUtenteNominativo_iView();
            tmpl.setVar( "main/@AmvUtenteNominativo_i", AmvUtenteNominativo_i.show( req, resp, context ));
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
//End AdmUtenteRichiesteElencoView: method show

//AdmUtenteRichiesteElencoView Tail @1-FCB6E20C
}
//End AdmUtenteRichiesteElencoView Tail



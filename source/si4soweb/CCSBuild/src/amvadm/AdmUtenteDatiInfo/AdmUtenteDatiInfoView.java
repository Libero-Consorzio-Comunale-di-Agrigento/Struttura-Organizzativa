//AdmUtenteDatiInfoView imports @1-03A5C10F
package amvadm.AdmUtenteDatiInfo;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmUtenteDatiInfoView imports

//AdmUtenteDatiInfoView class @1-444B2987
public class AdmUtenteDatiInfoView extends View {
//End AdmUtenteDatiInfoView class

//AdmUtenteDatiInfoView: method show @1-D8BF0A02
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmUtenteDatiInfoModel) req.getAttribute( "AdmUtenteDatiInfoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmUtenteDatiInfo.html";
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
        AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
        AD4_UTENTI.show(page.getRecord("AD4_UTENTI"));
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
//End AdmUtenteDatiInfoView: method show

//AD4_UTENTI Record @59-3FE1AF3E
    final class AD4_UTENTIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_UTENTI Record

//AdmUtenteDatiInfoView Tail @1-FCB6E20C
}
//End AdmUtenteDatiInfoView Tail





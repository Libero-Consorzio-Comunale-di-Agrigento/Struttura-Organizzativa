//AmvSezioneView imports @1-29DF7083
package common.AmvSezione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvSezioneView imports

//AmvSezioneView class @1-0F047EC9
public class AmvSezioneView extends View {
//End AmvSezioneView class

//AmvSezioneView: method show @1-E31E8EF8
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvSezioneModel) req.getAttribute( "AmvSezioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvSezione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "LeftSezione" ).isVisible() ) {
            common.LeftSezione.LeftSezioneView LeftSezione = new common.LeftSezione.LeftSezioneView();
            tmpl.setVar( "main/@LeftSezione", LeftSezione.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvNavigatore" ).isVisible() ) {
            common.AmvNavigatore.AmvNavigatoreView AmvNavigatore = new common.AmvNavigatore.AmvNavigatoreView();
            tmpl.setVar( "main/@AmvNavigatore", AmvNavigatore.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvCenterMenuSezioni" ).isVisible() ) {
            common.AmvCenterMenuSezioni.AmvCenterMenuSezioniView AmvCenterMenuSezioni = new common.AmvCenterMenuSezioni.AmvCenterMenuSezioniView();
            tmpl.setVar( "main/@AmvCenterMenuSezioni", AmvCenterMenuSezioni.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "RightSezione" ).isVisible() ) {
            common.RightSezione.RightSezioneView RightSezione = new common.RightSezione.RightSezioneView();
            tmpl.setVar( "main/@RightSezione", RightSezione.show( req, resp, context ));
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
//End AmvSezioneView: method show

//AmvSezioneView Tail @1-FCB6E20C
}
//End AmvSezioneView Tail

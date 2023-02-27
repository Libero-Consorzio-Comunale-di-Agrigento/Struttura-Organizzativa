//AmvMainView imports @1-E0A9E264
package common.AmvMain;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvMainView imports

//AmvMainView class @1-9E9B403F
public class AmvMainView extends View {
//End AmvMainView class

//AmvMainView: method show @1-378499C6
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvMainModel) req.getAttribute( "AmvMainModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvMain.html";
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
        if ( page.getChild( "AmvNavigatore" ).isVisible() ) {
            common.AmvNavigatore.AmvNavigatoreView AmvNavigatore = new common.AmvNavigatore.AmvNavigatoreView();
            tmpl.setVar( "main/@AmvNavigatore", AmvNavigatore.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvRegistrazioneLink" ).isVisible() ) {
            common.AmvRegistrazioneLink.AmvRegistrazioneLinkView AmvRegistrazioneLink = new common.AmvRegistrazioneLink.AmvRegistrazioneLinkView();
            tmpl.setVar( "main/@AmvRegistrazioneLink", AmvRegistrazioneLink.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "MainContent" ).isVisible() ) {
            common.MainContent.MainContentView MainContent = new common.MainContent.MainContentView();
            tmpl.setVar( "main/@MainContent", MainContent.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvCenterMenuSezioni" ).isVisible() ) {
            common.AmvCenterMenuSezioni.AmvCenterMenuSezioniView AmvCenterMenuSezioni = new common.AmvCenterMenuSezioni.AmvCenterMenuSezioniView();
            tmpl.setVar( "main/@AmvCenterMenuSezioni", AmvCenterMenuSezioni.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "Right" ).isVisible() ) {
            common.Right.RightView Right = new common.Right.RightView();
            tmpl.setVar( "main/@Right", Right.show( req, resp, context ));
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
//End AmvMainView: method show

//AmvMainView Tail @1-FCB6E20C
}
//End AmvMainView Tail

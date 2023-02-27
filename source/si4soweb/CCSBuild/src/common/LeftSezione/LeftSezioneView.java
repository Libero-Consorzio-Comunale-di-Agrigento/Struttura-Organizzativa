//LeftSezioneView imports @1-7E4A6BB2
package common.LeftSezione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End LeftSezioneView imports

//LeftSezioneView class @1-92151001
public class LeftSezioneView extends View {
//End LeftSezioneView class

//LeftSezioneView: method show @1-E307114D
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (LeftSezioneModel) req.getAttribute( "LeftSezioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/LeftSezione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvLeftMenu" ).isVisible() ) {
            common.AmvLeftMenu.AmvLeftMenuView AmvLeftMenu = new common.AmvLeftMenu.AmvLeftMenuView();
            tmpl.setVar( "main/@AmvLeftMenu", AmvLeftMenu.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvLeftMenuSezioni" ).isVisible() ) {
            common.AmvLeftMenuSezioni.AmvLeftMenuSezioniView AmvLeftMenuSezioni = new common.AmvLeftMenuSezioni.AmvLeftMenuSezioniView();
            tmpl.setVar( "main/@AmvLeftMenuSezioni", AmvLeftMenuSezioni.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvLeftDoc" ).isVisible() ) {
            common.AmvLeftDoc.AmvLeftDocView AmvLeftDoc = new common.AmvLeftDoc.AmvLeftDocView();
            tmpl.setVar( "main/@AmvLeftDoc", AmvLeftDoc.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End LeftSezioneView: method show

//LeftSezioneView Tail @1-FCB6E20C
}
//End LeftSezioneView Tail

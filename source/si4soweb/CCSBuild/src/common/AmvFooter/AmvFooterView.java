//AmvFooterView imports @1-6242508E
package common.AmvFooter;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvFooterView imports

//AmvFooterView class @1-F3237DE4
public class AmvFooterView extends View {
//End AmvFooterView class

//AmvFooterView: method show @1-3E95503A
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvFooterModel) req.getAttribute( "AmvFooterModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvFooter.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        copyrightClass copyright = new copyrightClass();
        copyright.show(page.getGrid("copyright"));
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            common.AmvStyle.AmvStyleView AmvStyle = new common.AmvStyle.AmvStyleView();
            tmpl.setVar( "main/@AmvStyle", AmvStyle.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "Versione" ).isVisible() ) {
            common.Versione.VersioneView Versione = new common.Versione.VersioneView();
            tmpl.setVar( "main/@Versione", Versione.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvVersione" ).isVisible() ) {
            common.AmvVersione.AmvVersioneView AmvVersione = new common.AmvVersione.AmvVersioneView();
            tmpl.setVar( "main/@AmvVersione", AmvVersione.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvFooterView: method show

// //copyright Grid @2-F81417CB

//copyrightClass head @2-CA2F37B8
    final class copyrightClass {
//End copyrightClass head

// //copyright Grid: method show @2-F81417CB

//show head @2-BA42602D
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MESSAGGIO");
            rowControls.add("MVDIRUPLOAD");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//copyright Grid Tail @2-FCB6E20C
    }
//End copyright Grid Tail

//AmvFooterView Tail @1-FCB6E20C
}
//End AmvFooterView Tail


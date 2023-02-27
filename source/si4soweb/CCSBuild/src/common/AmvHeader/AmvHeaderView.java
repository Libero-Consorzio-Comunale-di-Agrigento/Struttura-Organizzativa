//AmvHeaderView imports @1-0D2C910F
package common.AmvHeader;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvHeaderView imports

//AmvHeaderView class @1-F31D7902
public class AmvHeaderView extends View {
//End AmvHeaderView class

//AmvHeaderView: method show @1-FA0ABB78
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvHeaderModel) req.getAttribute( "AmvHeaderModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvHeader.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvControl" ).isVisible() ) {
            common.AmvControl.AmvControlView AmvControl = new common.AmvControl.AmvControlView();
            tmpl.setVar( "main/@AmvControl", AmvControl.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvAccessControl" ).isVisible() ) {
            common.AmvAccessControl.AmvAccessControlView AmvAccessControl = new common.AmvAccessControl.AmvAccessControlView();
            tmpl.setVar( "main/@AmvAccessControl", AmvAccessControl.show( req, resp, context ));
            page.setCookies();
        }
        LOGOClass LOGO = new LOGOClass();
        LOGO.show(page.getGrid("LOGO"));
        welcomeClass welcome = new welcomeClass();
        welcome.show(page.getGrid("welcome"));
        LOGO_PORTALEClass LOGO_PORTALE = new LOGO_PORTALEClass();
        LOGO_PORTALE.show(page.getGrid("LOGO_PORTALE"));
        AD4_MODULIClass AD4_MODULI = new AD4_MODULIClass();
        AD4_MODULI.show(page.getGrid("AD4_MODULI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvHeaderView: method show

// //LOGO Grid @41-F81417CB

//LOGOClass head @41-40B17F30
    final class LOGOClass {
//End LOGOClass head

// //LOGO Grid: method show @41-F81417CB

//show head @41-9C022052
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("LOGO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//LOGO Grid Tail @41-FCB6E20C
    }
//End LOGO Grid Tail

// //welcome Grid @19-F81417CB

//welcomeClass head @19-3DBDE18E
    final class welcomeClass {
//End welcomeClass head

// //welcome Grid: method show @19-F81417CB

//show head @19-1A7FCDEA
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("INTESTAZIONE");
            rowControls.add("MESSAGGIO");
            rowControls.add("OGGI");
            rowControls.add("NOTE");
            rowControls.add("NEW_MSG");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//welcome Grid Tail @19-FCB6E20C
    }
//End welcome Grid Tail

// //LOGO_PORTALE Grid @43-F81417CB

//LOGO_PORTALEClass head @43-A945ECD2
    final class LOGO_PORTALEClass {
//End LOGO_PORTALEClass head

// //LOGO_PORTALE Grid: method show @43-F81417CB

//show head @43-F7782806
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("LOGO_PORTALE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//LOGO_PORTALE Grid Tail @43-FCB6E20C
    }
//End LOGO_PORTALE Grid Tail

// //AD4_MODULI Grid @28-F81417CB

//AD4_MODULIClass head @28-E0FE7B73
    final class AD4_MODULIClass {
//End AD4_MODULIClass head

// //AD4_MODULI Grid: method show @28-F81417CB

//show head @28-9159799A
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("RETURN_PAGE");
            rowControls.add("NAVIGATORE");
            rowControls.add("MENUBAR");
            rowControls.add("SECTIONBAR");
            rowControls.add("HELP");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_MODULI Grid Tail @28-FCB6E20C
    }
//End AD4_MODULI Grid Tail

//AmvHeaderView Tail @1-FCB6E20C
}
//End AmvHeaderView Tail


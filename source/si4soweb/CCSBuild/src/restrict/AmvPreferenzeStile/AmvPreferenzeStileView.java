

//AmvPreferenzeStileView imports @1-52633F93
package restrict.AmvPreferenzeStile;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvPreferenzeStileView imports

//AmvPreferenzeStileView class @1-FDD933EB
public class AmvPreferenzeStileView extends View {
//End AmvPreferenzeStileView class

//AmvPreferenzeStileView: method show @1-EDCD6AE0
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvPreferenzeStileModel) req.getAttribute( "AmvPreferenzeStileModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/restrict/AmvPreferenzeStile.html";
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
        STILE_ATTUALEClass STILE_ATTUALE = new STILE_ATTUALEClass();
        STILE_ATTUALE.show(page.getGrid("STILE_ATTUALE"));
        if ( page.getChild( "AmvStili" ).isVisible() ) {
            restrict.AmvStili.AmvStiliView AmvStili = new restrict.AmvStili.AmvStiliView();
            tmpl.setVar( "main/@AmvStili", AmvStili.show( req, resp, context ));
            page.setCookies();
        }
        NewRecord1Class NewRecord1 = new NewRecord1Class();
        NewRecord1.show(page.getRecord("NewRecord1"));
        NewGrid1Class NewGrid1 = new NewGrid1Class();
        NewGrid1.show(page.getGrid("NewGrid1"));
        copyrightClass copyright = new copyrightClass();
        copyright.show(page.getGrid("copyright"));
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
//End AmvPreferenzeStileView: method show

// //STILE_ATTUALE Grid @7-F81417CB

//STILE_ATTUALEClass head @7-69F00E9E
    final class STILE_ATTUALEClass {
//End STILE_ATTUALEClass head

// //STILE_ATTUALE Grid: method show @7-F81417CB

//show head @7-2F33C9CC
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("STILE_SCELTO");
            rowControls.add("STILE");
            rowControls.add("CONFERMA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//STILE_ATTUALE Grid Tail @7-FCB6E20C
    }
//End STILE_ATTUALE Grid Tail

//NewRecord1 Record @42-B7619456
    final class NewRecord1Class {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End NewRecord1 Record

// //NewGrid1 Grid @48-F81417CB

//NewGrid1Class head @48-55E5A62A
    final class NewGrid1Class {
//End NewGrid1Class head

// //NewGrid1 Grid: method show @48-F81417CB

//show head @48-F9FCDC31
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("Link1");
            rowControls.add("Label2");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter1");
            staticControls.add("Navigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//NewGrid1 Grid Tail @48-FCB6E20C
    }
//End NewGrid1 Grid Tail

// //copyright Grid @25-F81417CB

//copyrightClass head @25-CA2F37B8
    final class copyrightClass {
//End copyrightClass head

// //copyright Grid: method show @25-F81417CB

//show head @25-C36C386B
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("MESSAGGIO");
            rowControls.add("STILE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//copyright Grid Tail @25-FCB6E20C
    }
//End copyright Grid Tail

//AmvPreferenzeStileView Tail @1-FCB6E20C
}
//End AmvPreferenzeStileView Tail



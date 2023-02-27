//AdmArgomentiView imports @1-980C0C65
package amvadm.AdmArgomenti;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmArgomentiView imports

//AdmArgomentiView class @1-197A2024
public class AdmArgomentiView extends View {
//End AdmArgomentiView class

//AdmArgomentiView: method show @1-E3058AAF
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmArgomentiModel) req.getAttribute( "AdmArgomentiModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmArgomenti.html";
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
        AMV_ARGOMENTIClass AMV_ARGOMENTI = new AMV_ARGOMENTIClass();
        AMV_ARGOMENTI.show(page.getGrid("AMV_ARGOMENTI"));
        AMV_ARGOMENTI1Class AMV_ARGOMENTI1 = new AMV_ARGOMENTI1Class();
        AMV_ARGOMENTI1.show(page.getRecord("AMV_ARGOMENTI1"));
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
//End AdmArgomentiView: method show

// //AMV_ARGOMENTI Grid @5-F81417CB

//AMV_ARGOMENTIClass head @5-632120DE
    final class AMV_ARGOMENTIClass {
//End AMV_ARGOMENTIClass head

// //AMV_ARGOMENTI Grid: method show @5-F81417CB

//show head @5-842B0CF2
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME");
            rowControls.add("DESCRIZIONE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_NOME");
            staticControls.add("Descrizione");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_ARGOMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_ARGOMENTI Grid Tail

//AMV_ARGOMENTI1 Record @14-DC049DC9
    final class AMV_ARGOMENTI1Class {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_ARGOMENTI1 Record

//AdmArgomentiView Tail @1-FCB6E20C
}
//End AdmArgomentiView Tail


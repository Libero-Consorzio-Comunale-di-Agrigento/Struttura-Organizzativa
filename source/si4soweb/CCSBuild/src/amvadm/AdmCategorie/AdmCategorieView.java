//AdmCategorieView imports @1-683A9D7B
package amvadm.AdmCategorie;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmCategorieView imports

//AdmCategorieView class @1-6355F867
public class AdmCategorieView extends View {
//End AdmCategorieView class

//AdmCategorieView: method show @1-9FD314D2
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmCategorieModel) req.getAttribute( "AdmCategorieModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmCategorie.html";
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
        AMV_CATEGORIEClass AMV_CATEGORIE = new AMV_CATEGORIEClass();
        AMV_CATEGORIE.show(page.getGrid("AMV_CATEGORIE"));
        AMV_CATEGORIE1Class AMV_CATEGORIE1 = new AMV_CATEGORIE1Class();
        AMV_CATEGORIE1.show(page.getRecord("AMV_CATEGORIE1"));
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
//End AdmCategorieView: method show

// //AMV_CATEGORIE Grid @2-F81417CB

//AMV_CATEGORIEClass head @2-ADE99D2B
    final class AMV_CATEGORIEClass {
//End AMV_CATEGORIEClass head

// //AMV_CATEGORIE Grid: method show @2-F81417CB

//show head @2-3A77DD16
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME");
            rowControls.add("DESCRIZIONE");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Sorter_NOME");
            staticControls.add("Sorter_DESCRIZIONE");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AMV_CATEGORIE Grid Tail @2-FCB6E20C
    }
//End AMV_CATEGORIE Grid Tail

//AMV_CATEGORIE1 Record @11-E2DFC85C
    final class AMV_CATEGORIE1Class {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_CATEGORIE1 Record

//AdmCategorieView Tail @1-FCB6E20C
}
//End AdmCategorieView Tail


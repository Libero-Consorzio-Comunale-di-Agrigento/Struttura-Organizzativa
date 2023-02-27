//AdmRichiestaView imports @1-CED65971
package amvadm.AdmRichiesta;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmRichiestaView imports

//AdmRichiestaView class @1-34FD2471
public class AdmRichiestaView extends View {
//End AdmRichiestaView class

//AdmRichiestaView: method show @1-E097BF86
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmRichiestaModel) req.getAttribute( "AdmRichiestaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmRichiesta.html";
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
        AD4_RICHIESTE_ABILITAZIONEGridClass AD4_RICHIESTE_ABILITAZIONEGrid = new AD4_RICHIESTE_ABILITAZIONEGridClass();
        AD4_RICHIESTE_ABILITAZIONEGrid.show(page.getGrid("AD4_RICHIESTE_ABILITAZIONEGrid"));
        AD4_RICHIESTE_ABILITAZIONERecordClass AD4_RICHIESTE_ABILITAZIONERecord = new AD4_RICHIESTE_ABILITAZIONERecordClass();
        AD4_RICHIESTE_ABILITAZIONERecord.show(page.getRecord("AD4_RICHIESTE_ABILITAZIONERecord"));
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
//End AdmRichiestaView: method show

// //AD4_RICHIESTE_ABILITAZIONEGrid Grid @30-F81417CB

//AD4_RICHIESTE_ABILITAZIONEGridClass head @30-5D797FA3
    final class AD4_RICHIESTE_ABILITAZIONEGridClass {
//End AD4_RICHIESTE_ABILITAZIONEGridClass head

// //AD4_RICHIESTE_ABILITAZIONEGrid Grid: method show @30-F81417CB

//show head @30-D5CA3DE1
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("DATA");
            rowControls.add("SERVIZIO");
            rowControls.add("RICHIEDENTE");
            rowControls.add("UTENTE");
            rowControls.add("STATO");
            rowControls.add("COD_STATO");
            rowControls.add("NOTIFICATA");
            rowControls.add("COD_NOTIFICATA");
            rowControls.add("TIPO_NOTIFICA");
            rowControls.add("INDIRIZZO_NOTIFICA");
            rowControls.add("MODIFICA_NOTIFICA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_RICHIESTE_ABILITAZIONEGrid Grid Tail @30-FCB6E20C
    }
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid Tail

//AD4_RICHIESTE_ABILITAZIONERecord Record @7-B9A57B18
    final class AD4_RICHIESTE_ABILITAZIONERecordClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AD4_RICHIESTE_ABILITAZIONERecord Record

//AdmRichiestaView Tail @1-FCB6E20C
}
//End AdmRichiestaView Tail


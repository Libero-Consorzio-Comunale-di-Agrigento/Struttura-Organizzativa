//AdmPreferenzeImpostazioneView imports @1-9167CB38
package amvadm.AdmPreferenzeImpostazione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmPreferenzeImpostazioneView imports

//AdmPreferenzeImpostazioneView class @1-24DD5184
public class AdmPreferenzeImpostazioneView extends View {
//End AdmPreferenzeImpostazioneView class

//AdmPreferenzeImpostazioneView: method show @1-EB9A4984
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmPreferenzeImpostazioneModel) req.getAttribute( "AdmPreferenzeImpostazioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmPreferenzeImpostazione.html";
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
        TITLEGridClass TITLEGrid = new TITLEGridClass();
        TITLEGrid.show(page.getGrid("TITLEGrid"));
        PREFERENZEClass PREFERENZE = new PREFERENZEClass();
        PREFERENZE.show(page.getGrid("PREFERENZE"));
        PREFERENZAClass PREFERENZA = new PREFERENZAClass();
        PREFERENZA.show(page.getRecord("PREFERENZA"));
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
//End AdmPreferenzeImpostazioneView: method show

// //TITLEGrid Grid @31-F81417CB

//TITLEGridClass head @31-4A843CF8
    final class TITLEGridClass {
//End TITLEGridClass head

// //TITLEGrid Grid: method show @31-F81417CB

//show head @31-ACF1DCF8
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("LIVELLO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//TITLEGrid Grid Tail @31-FCB6E20C
    }
//End TITLEGrid Grid Tail

// //PREFERENZE Grid @6-F81417CB

//PREFERENZEClass head @6-55967BB8
    final class PREFERENZEClass {
//End PREFERENZEClass head

// //PREFERENZE Grid: method show @6-F81417CB

//show head @6-8010CD8C
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("STRINGA");
            rowControls.add("IMPOSTATA");
            rowControls.add("VALORE");
            rowControls.add("COMMENTO");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//PREFERENZE Grid Tail @6-FCB6E20C
    }
//End PREFERENZE Grid Tail

//PREFERENZA Record @17-5B792505
    final class PREFERENZAClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End PREFERENZA Record

//AdmPreferenzeImpostazioneView Tail @1-FCB6E20C
}
//End AdmPreferenzeImpostazioneView Tail





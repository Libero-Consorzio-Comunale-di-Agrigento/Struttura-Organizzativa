//AmvRegistrazioneParametriView imports @1-BB6104B1
package common.AmvRegistrazioneParametri;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRegistrazioneParametriView imports

//AmvRegistrazioneParametriView class @1-A4FAFF26
public class AmvRegistrazioneParametriView extends View {
//End AmvRegistrazioneParametriView class

//AmvRegistrazioneParametriView: method show @1-14DB3297
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRegistrazioneParametriModel) req.getAttribute( "AmvRegistrazioneParametriModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRegistrazioneParametri.html";
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
        PARAMETRIClass PARAMETRI = new PARAMETRIClass();
        PARAMETRI.show(page.getEditableGrid("PARAMETRI"));
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
//End AmvRegistrazioneParametriView: method show

// //PARAMETRI EditGrid @6-F81417CB

//PARAMETRIClass head @6-F4FB44B8
    final class PARAMETRIClass {
//End PARAMETRIClass head

// //PARAMETRI EditGrid: method show @6-F81417CB

//show head @6-69226DCB
        void show(com.codecharge.components.EditableGrid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME");
            rowControls.add("VALORE");
            rowControls.add("NOME_PAR");
            rowControls.add("ID_RIC");
            rowControls.add("CheckBox_Delete");
            ArrayList staticControls = new ArrayList();
            staticControls.add("Button_Submit");
            if (!(model.isAllowInsert() || model.isAllowUpdate() || model.isAllowDelete())) {
                model.getButton("Button_Submit").setVisible(false);
            }
            
            view.show(model,staticControls,rowControls,false,false);
        }
//End show head

//PARAMETRI EditGrid Tail @6-FCB6E20C
    }
//End PARAMETRI EditGrid Tail

//AmvRegistrazioneParametriView Tail @1-FCB6E20C
}
//End AmvRegistrazioneParametriView Tail

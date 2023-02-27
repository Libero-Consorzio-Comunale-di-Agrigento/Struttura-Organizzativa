//AdmDocumentoView imports @1-ED8DB1FF
package amvadm.AdmDocumento;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmDocumentoView imports

//AdmDocumentoView class @1-9B85F170
public class AdmDocumentoView extends View {
//End AdmDocumentoView class

//AdmDocumentoView: method show @1-FA444408
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmDocumentoModel) req.getAttribute( "AdmDocumentoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmDocumento.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "Header" ).isVisible() ) {
            common.Header.HeaderView Header = new common.Header.HeaderView();
            tmpl.setVar( "main/@Header", Header.show( req, resp, context ));
            page.setCookies();
        }
        AMV_DOCUMENTIClass AMV_DOCUMENTI = new AMV_DOCUMENTIClass();
        AMV_DOCUMENTI.show(page.getRecord("AMV_DOCUMENTI"));
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
//End AdmDocumentoView: method show

//AMV_DOCUMENTI Record @5-36205B3E
    final class AMV_DOCUMENTIClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End AMV_DOCUMENTI Record

//AdmDocumentoView Tail @1-FCB6E20C
}
//End AdmDocumentoView Tail

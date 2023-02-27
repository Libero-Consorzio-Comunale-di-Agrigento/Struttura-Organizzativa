//AmvRichiestaConfermaView imports @1-6D051751
package common.AmvRichiestaConferma;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvRichiestaConfermaView imports

//AmvRichiestaConfermaView class @1-C913C2F4
public class AmvRichiestaConfermaView extends View {
//End AmvRichiestaConfermaView class

//AmvRichiestaConfermaView: method show @1-A9E280C3
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvRichiestaConfermaModel) req.getAttribute( "AmvRichiestaConfermaModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvRichiestaConferma.html";
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
        RICHIESTA_GRIDClass RICHIESTA_GRID = new RICHIESTA_GRIDClass();
        RICHIESTA_GRID.show(page.getGrid("RICHIESTA_GRID"));
        if ( page.getChild( "Right" ).isVisible() ) {
            common.Right.RightView Right = new common.Right.RightView();
            tmpl.setVar( "main/@Right", Right.show( req, resp, context ));
            page.setCookies();
        }
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
//End AmvRichiestaConfermaView: method show

// //RICHIESTA_GRID Grid @39-F81417CB

//RICHIESTA_GRIDClass head @39-90B8D454
    final class RICHIESTA_GRIDClass {
//End RICHIESTA_GRIDClass head

// //RICHIESTA_GRID Grid: method show @39-F81417CB

//show head @39-3CBB31B1
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO");
            rowControls.add("STATO_FUTURO");
            rowControls.add("ID_RICHIESTA");
            rowControls.add("ELENCO_RICHIESTE_LINK");
            rowControls.add("STAMPA_RICHIESTA");
            rowControls.add("MODIFICA_RICHIESTA_LINK");
            rowControls.add("CONFERMA_RICHIESTA_LINK");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//RICHIESTA_GRID Grid Tail @39-FCB6E20C
    }
//End RICHIESTA_GRID Grid Tail

//AmvRichiestaConfermaView Tail @1-FCB6E20C
}
//End AmvRichiestaConfermaView Tail

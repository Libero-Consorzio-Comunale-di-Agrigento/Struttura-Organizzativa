//RightSezioneView imports @1-E38F4A6F
package common.RightSezione;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End RightSezioneView imports

//RightSezioneView class @1-1F7535BD
public class RightSezioneView extends View {
//End RightSezioneView class

//RightSezioneView: method show @1-CC7ECC51
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (RightSezioneModel) req.getAttribute( "RightSezioneModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/RightSezione.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        if ( page.getChild( "AmvRightMenuSezioni" ).isVisible() ) {
            common.AmvRightMenuSezioni.AmvRightMenuSezioniView AmvRightMenuSezioni = new common.AmvRightMenuSezioni.AmvRightMenuSezioniView();
            tmpl.setVar( "main/@AmvRightMenuSezioni", AmvRightMenuSezioni.show( req, resp, context ));
            page.setCookies();
        }
        if ( page.getChild( "AmvRightDoc" ).isVisible() ) {
            common.AmvRightDoc.AmvRightDocView AmvRightDoc = new common.AmvRightDoc.AmvRightDocView();
            tmpl.setVar( "main/@AmvRightDoc", AmvRightDoc.show( req, resp, context ));
            page.setCookies();
        }
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End RightSezioneView: method show

//RightSezioneView Tail @1-FCB6E20C
}
//End RightSezioneView Tail

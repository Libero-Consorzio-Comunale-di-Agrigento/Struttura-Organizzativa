//AmvImagesView imports @1-6810E058
package common.AmvImages;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AmvImagesView imports

//AmvImagesView class @1-E537595E
public class AmvImagesView extends View {
//End AmvImagesView class

//AmvImagesView: method show @1-084378D6
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AmvImagesModel) req.getAttribute( "AmvImagesModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/common/AmvImages.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        RecordImageClass RecordImage = new RecordImageClass();
        RecordImage.show(page.getRecord("RecordImage"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AmvImagesView: method show

//RecordImage Record @2-0FADC2CD
    final class RecordImageClass {
        void show(com.codecharge.components.Record model) {
            view.show(model);
        }
    }
//End RecordImage Record

//AmvImagesView Tail @1-FCB6E20C
}
//End AmvImagesView Tail


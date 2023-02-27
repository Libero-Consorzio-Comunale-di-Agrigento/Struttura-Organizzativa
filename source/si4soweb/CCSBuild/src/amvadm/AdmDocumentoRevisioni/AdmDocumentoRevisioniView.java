//AdmDocumentoRevisioniView imports @1-64458909
package amvadm.AdmDocumentoRevisioni;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmDocumentoRevisioniView imports

//AdmDocumentoRevisioniView class @1-166AE25A
public class AdmDocumentoRevisioniView extends View {
//End AdmDocumentoRevisioniView class

//AdmDocumentoRevisioniView: method show @1-42D25425
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmDocumentoRevisioniModel) req.getAttribute( "AdmDocumentoRevisioniModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmDocumentoRevisioni.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        AD4_DOCUMENTO_SELClass AD4_DOCUMENTO_SEL = new AD4_DOCUMENTO_SELClass();
        AD4_DOCUMENTO_SEL.show(page.getGrid("AD4_DOCUMENTO_SEL"));
        ELENCO_REVISIONIClass ELENCO_REVISIONI = new ELENCO_REVISIONIClass();
        ELENCO_REVISIONI.show(page.getGrid("ELENCO_REVISIONI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AdmDocumentoRevisioniView: method show

// //AD4_DOCUMENTO_SEL Grid @10-F81417CB

//AD4_DOCUMENTO_SELClass head @10-EBD47117
    final class AD4_DOCUMENTO_SELClass {
//End AD4_DOCUMENTO_SELClass head

// //AD4_DOCUMENTO_SEL Grid: method show @10-F81417CB

//show head @10-03041DB7
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME_DOCUMENTO");
            rowControls.add("NUOVA_REV");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_DOCUMENTO_SEL Grid Tail @10-FCB6E20C
    }
//End AD4_DOCUMENTO_SEL Grid Tail

// //ELENCO_REVISIONI Grid @2-F81417CB

//ELENCO_REVISIONIClass head @2-4E72888D
    final class ELENCO_REVISIONIClass {
//End ELENCO_REVISIONIClass head

// //ELENCO_REVISIONI Grid: method show @2-F81417CB

//show head @2-B0271CE4
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("REVISIONE");
            rowControls.add("STATO_DOCUMENTO");
            rowControls.add("TITOLO_DOC");
            rowControls.add("MODIFICA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//ELENCO_REVISIONI Grid Tail @2-FCB6E20C
    }
//End ELENCO_REVISIONI Grid Tail

//AdmDocumentoRevisioniView Tail @1-FCB6E20C
}
//End AdmDocumentoRevisioniView Tail

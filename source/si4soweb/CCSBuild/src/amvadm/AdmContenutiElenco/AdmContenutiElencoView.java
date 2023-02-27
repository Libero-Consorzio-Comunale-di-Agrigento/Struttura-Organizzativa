//AdmContenutiElencoView imports @1-765CC4B5
package amvadm.AdmContenutiElenco;

import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.util.*;

//End AdmContenutiElencoView imports

//AdmContenutiElencoView class @1-660BB1E6
public class AdmContenutiElencoView extends View {
//End AdmContenutiElencoView class

//AdmContenutiElencoView: method show @1-9072B1C0
    public String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        this.page = (AdmContenutiElencoModel) req.getAttribute( "AdmContenutiElencoModel" );
        if (this.page == null) return "";
        String enc = (req.getAttribute(page.getName()+"Parent")!=null) ? ((com.codecharge.components.Page) req.getAttribute(page.getName()+"Parent")).getCharacterEncoding() : null;
        page.setCharacterEncoding("windows-1252");
        this.tmplPath = "/amvadm/AdmContenutiElenco.html";
        init(req, resp, context, page);
        if (req.getAttribute(page.getName()+"Parent")!=null) page.setCharacterEncoding(enc);
        AD4_SEZIONE_SELClass AD4_SEZIONE_SEL = new AD4_SEZIONE_SELClass();
        AD4_SEZIONE_SEL.show(page.getGrid("AD4_SEZIONE_SEL"));
        ELENCO_REVISIONIClass ELENCO_REVISIONI = new ELENCO_REVISIONIClass();
        ELENCO_REVISIONI.show(page.getGrid("ELENCO_REVISIONI"));
        String result = tmpl.render("main");
        page.fireBeforeUnloadEvent();
        if (!page.isVisible()) result="";
        return result;
    }
//End AdmContenutiElencoView: method show

// //AD4_SEZIONE_SEL Grid @10-F81417CB

//AD4_SEZIONE_SELClass head @10-7FB4DC5B
    final class AD4_SEZIONE_SELClass {
//End AD4_SEZIONE_SELClass head

// //AD4_SEZIONE_SEL Grid: method show @10-F81417CB

//show head @10-5E648E97
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("NOME_SEZIONE");
            rowControls.add("RICERCA");
            rowControls.add("NUOVA_PAGINA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//AD4_SEZIONE_SEL Grid Tail @10-FCB6E20C
    }
//End AD4_SEZIONE_SEL Grid Tail

// //ELENCO_REVISIONI Grid @2-F81417CB

//ELENCO_REVISIONIClass head @2-4E72888D
    final class ELENCO_REVISIONIClass {
//End ELENCO_REVISIONIClass head

// //ELENCO_REVISIONI Grid: method show @2-F81417CB

//show head @2-CF310BAF
        void show(com.codecharge.components.Grid model) {
            ArrayList rowControls = new ArrayList();
            rowControls.add("TITOLO_DOC");
            rowControls.add("DATA_RIFERIMENTO");
            rowControls.add("ID_DOCUMENTO");
            rowControls.add("REVISIONE");
            rowControls.add("STATO_DOCUMENTO");
            rowControls.add("STORICO");
            rowControls.add("REVISIONA");
            rowControls.add("MODIFICA");
            ArrayList altRowControls = new ArrayList();
            ArrayList staticControls = new ArrayList();
            staticControls.add("Titolo");
            staticControls.add("Riferimento");
            staticControls.add("AFCNavigator");
            view.show(model,staticControls,rowControls,altRowControls,false,false);
        }
//End show head

//ELENCO_REVISIONI Grid Tail @2-FCB6E20C
    }
//End ELENCO_REVISIONI Grid Tail

//AdmContenutiElencoView Tail @1-FCB6E20C
}
//End AdmContenutiElencoView Tail

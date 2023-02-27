//AMV_VISTA_DOCUMENTICOD_STATOHandler Head @87-E0DA9EB9
package restrict.ServletModulistica;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AMV_VISTA_DOCUMENTICOD_STATOHandler implements ControlListener {
//End AMV_VISTA_DOCUMENTICOD_STATOHandler Head

//BeforeShow Head @87-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @93-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 	String path = "/";
    String realPath = e.getPage().getRequest().getRealPath(path);
	String parametri = "";
    it.finmatica.modulistica.Modulistica modello = new it.finmatica.modulistica.Modulistica(realPath);
	boolean inoltri = modello.esistonoInoltri(e.getPage().getParameter("area"), e.getPage().getParameter("cm"), e.getPage().getParameter("cr"));
	boolean inoltro_modello = modello.esistonoInoltri(e.getPage().getParameter("area"), e.getPage().getParameter("cm"),"");
	//boolean inoltri = "true".equals((String) e.getPage().getRequest().getAttribute("INOLTRI"));
	//boolean inoltro_modello = "true".equals((String) e.getPage().getRequest().getAttribute("INOLTRO_MODELLO"));
	boolean erroriControlli = "true".equals((String) e.getPage().getRequest().getAttribute("ERRORI_CONTROLLI"));
	//System.out.println("Inoltri=" + inoltri + " Inoltro modello=" + inoltro_modello + " Errori controlli=" + erroriControlli );
	if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVIDRIC") != null) {
	    if (!SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVIDRIC").toString().equals("0")) {
			if ((((!inoltri)&&(inoltro_modello))||(!inoltro_modello))&&(!erroriControlli))  {
				parametri = "ID=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVIDRIC");		
				parametri = parametri + "&REV=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVREVRIC");		
				if (e.getPage().getHttpGetParameter("cr") != null) {
					parametri = parametri + "&cr=" + e.getPage().getHttpGetParameter("cr");
					parametri = parametri + "&area=" + e.getPage().getHttpGetParameter("area");
					parametri = parametri + "&cm=" + e.getPage().getHttpGetParameter("cm");
				} else {
					parametri = parametri + "&cr=" + e.getPage().getHttpPostParams().getParameter("cr");
					parametri = parametri + "&area=" + e.getPage().getHttpPostParams().getParameter("area");
					parametri = parametri + "&cm=" + e.getPage().getHttpPostParams().getParameter("cm");
				}
				try {
					if ((e.getControl().getValue().toString().equals("V"))&&(e.getPage().getHttpPostParameter("reload") == null)) {
		 				e.getPage().getResponse().sendRedirect("../amvadm/AdmRevisioneApprova.do?" + parametri); 
					}
					if ((e.getControl().getValue().toString().equals("B"))&&(e.getPage().getHttpGetParameter("cr") == null)&&(e.getPage().getHttpPostParameter("reload") == null)){
		 				e.getPage().getResponse().sendRedirect("../common/AmvRichiestaConferma.do?" + parametri); 
					}
		} catch (Exception ex)  {
					ex.printStackTrace();
		 		}
			}	
		}
	}
	e.getControl().setVisible(false);

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @87-FCB6E20C
    }
//End BeforeShow Tail

//AMV_VISTA_DOCUMENTICOD_STATOHandler Tail @87-FCB6E20C
}
//End AMV_VISTA_DOCUMENTICOD_STATOHandler Tail


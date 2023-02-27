//INSERISCI_RICHIESTAMESSAGGIOHandler Head @30-95D2B181
package restrict.ServletModulistica;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class INSERISCI_RICHIESTAMESSAGGIOHandler implements ControlListener {
//End INSERISCI_RICHIESTAMESSAGGIOHandler Head

//BeforeShow Head @30-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @84-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
if (e.getControl().getValue().toString().substring(0,3).equals("ID=")) {
   String id = e.getControl().getValue().toString().substring(3);
   SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVIDRIC",id);
}

 	String parametri = "";
	boolean inoltri = "true".equals((String) e.getPage().getRequest().getAttribute("INOLTRI"));
	boolean inoltro_modello = "true".equals((String) e.getPage().getRequest().getAttribute("INOLTRO_MODELLO"));
	boolean erroriControlli = "true".equals((String) e.getPage().getRequest().getAttribute("ERRORI_CONTROLLI"));

    if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVIDRIC") != null) {
	    if (!SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVIDRIC").toString().equals("0")) {
			// Se il modello non ha inoltri e non ha errori sui controlli 
			//if (e.getPage().getRequest().getAttribute("INOLTRI").equals("false") && e.getPage().getRequest().getAttribute("ERRORI_CONTROLLI").equals("false")) {
			if ((((!inoltri)&&(inoltro_modello))||(!inoltro_modello))&&(!erroriControlli))  {
				parametri = "ID=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVIDRIC");		
				parametri = parametri + "&REV=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVREVRIC");		
				parametri = parametri + "&cr=" + e.getPage().getHttpPostParams().getParameter("cr");
				parametri = parametri + "&area=" + e.getPage().getHttpPostParams().getParameter("area");
				parametri = parametri + "&cm=" + e.getPage().getHttpPostParams().getParameter("cm");
				try {
	 				e.getPage().getResponse().sendRedirect("../common/AmvRichiestaConferma.do?" + parametri); 
		 		} catch (Exception ex)  {
					ex.printStackTrace();
		 		}
			}	
		}
	}
 
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @30-FCB6E20C
    }
//End BeforeShow Tail

//INSERISCI_RICHIESTAMESSAGGIOHandler Tail @30-FCB6E20C
}
//End INSERISCI_RICHIESTAMESSAGGIOHandler Tail


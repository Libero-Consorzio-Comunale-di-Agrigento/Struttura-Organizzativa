//ACCESSOGridHandler @3-EECE29B4
package common.AmvAccessControl;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ACCESSOGridHandler implements GridListener {
//End ACCESSOGridHandler

// //beforeShow @3-F81417CB

//BeforeShow Head @3-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @6-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
String Utente = "GUEST";
if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Utente") != null) {
	Utente = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Utente").toString();
}
 if ((SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVABILITAZIONI")== null) && (!Utente.equals("GUEST"))) {
	try {
		String url = "../common/AmvAccesso.do?MVURL=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVURL");
		e.getPage().getResponse().sendRedirect(url);
	} catch (Exception ex)  {
		ex.printStackTrace();
	}
}
if ((e.getGrid().getAmountOfRows() < 1)&&(e.getPage().getRequest().getAttribute("ACCESSO").toString().equals("NO"))) {
 	try {
		if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Utente") != null) {
			e.getPage().getResponse().sendRedirect("../common/Denied.do");
		}
	} catch (Exception ex)  {
		ex.printStackTrace();
	}
}
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @3-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @3-F81417CB

//beforeShowRow Head @3-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @3-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @3-F81417CB

//BeforeSelect Head @3-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @3-FCB6E20C
    }
//End BeforeSelect Tail

//ACCESSOHandler Tail @3-FCB6E20C
}
//End ACCESSOHandler Tail

